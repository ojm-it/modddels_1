import 'package:analyzer/dart/element/element.dart';
import 'package:modddels_annotations/modddels.dart';
import 'package:modddels_generator/src/core/class_info.dart';
import 'package:modddels_generator/src/core/modddel_parameter.dart';
import 'package:source_gen/source_gen.dart';

class SimpleEntityGenerator {
  SimpleEntityGenerator({
    required this.className,
    required this.factoryConstructor,
    required this.generateTester,
    required this.maxSutDescriptionLength,
    required this.stringifyMode,
  });

  final String className;
  final ConstructorElement factoryConstructor;

  /// See [ModddelAnnotation.generateTester]
  final bool generateTester;

  /// See [ModddelAnnotation.maxSutDescriptionLength]
  final int maxSutDescriptionLength;

  /// See [ModddelAnnotation.stringifyMode]
  final StringifyMode stringifyMode;

  String generate() {
    final parameters = factoryConstructor.parameters;

    final namedParameterElements =
        parameters.where((element) => element.isNamed).toList();

    if (namedParameterElements.isEmpty) {
      throw InvalidGenerationSourceError(
        'The factory constructor should contain at least one name parameter',
        element: factoryConstructor,
      );
    }

    final classInfo = SimpleEntityClassInfo(
      className: className,
      namedParameterElements: namedParameterElements,
    );

    for (final param in classInfo.namedParameters) {
      if (param.type == 'dynamic') {
        throw InvalidGenerationSourceError(
          'The named parameters of the factory constructor should have valid types, and should not be dynamic.'
          'Consider using the @TypeName annotation to manually provide the type.',
          element: param.parameterElement,
        );
      }
    }

    if (classInfo.namedParameters.every((param) => param.hasValidAnnotation)) {
      throw InvalidGenerationSourceError(
        'A SimpleEntity can\'t have all its fields marked with @valid.',
        element: factoryConstructor,
      );
    }

    for (final param in classInfo.namedParameters) {
      if (param.hasValidAnnotation && param.hasInvalidAnnotation) {
        throw InvalidGenerationSourceError(
          'The @valid and @invalid annotations can\'t be used together on the same parameter.',
          element: param.parameterElement,
        );
      }
    }

    for (final param in classInfo.namedParameters) {
      if (param.hasInvalidAnnotation && !param.isNullable) {
        throw InvalidGenerationSourceError(
          'The @invalid annotation can only be used on nullable parameters.',
          element: param.parameterElement,
        );
      }
    }

    for (final param in classInfo.namedParameters) {
      if (param.hasWithGetterAnnotation) {
        throw InvalidGenerationSourceError(
          'The @withGetter annotation is reserved for General Entities, and is useless for Simple Entities.',
          element: param.parameterElement,
        );
      }
    }

    for (final param in classInfo.namedParameters) {
      if (param.hasNullFailureAnnotation) {
        throw InvalidGenerationSourceError(
          'The @NullFailure annotation can\'t be used with a SimpleEntity',
          element: param.parameterElement,
        );
      }
    }

    final classBuffer = StringBuffer();

    makeMixin(classBuffer, classInfo);

    makeCopyWithClasses(classBuffer, classInfo);

    makeValidEntity(classBuffer, classInfo);

    makeInvalidEntityContent(classBuffer, classInfo);

    if (generateTester) {
      makeTester(classBuffer, classInfo);

      makeModddelInput(classBuffer, classInfo);
    }

    return classBuffer.toString();
  }

  void makeMixin(StringBuffer classBuffer, SimpleEntityClassInfo classInfo) {
    classBuffer.writeln('''
    mixin \$$className {
    
    ''');

    /// create method
    classBuffer.writeln('''
    static $className _create({
      ${classInfo.namedParameters.map((param) => 'required ${param.type} ${param.name},').join()}
    }) {
      /// 1. **Content Validation**
      return _verifyContent(
        ${classInfo.namedParameters.map((param) => '${param.name} : ${param.name},').join()}
      ).match(
        (contentFailure) => ${classInfo.invalidContent}._(
          contentFailure: contentFailure,
           ${classInfo.namedParameters.map((param) => '${param.name} : ${param.name},').join()}
        ),

        /// 2. **→ Validations passed**
        (validContent) => validContent,
      );
    }
    ''');

    /// verifyContent function
    classBuffer.writeln('''
    /// If any of the modddels is invalid, this holds its failure on the Left (the
    /// failure of the first invalid modddel encountered)
    ///
    /// Otherwise, holds all the modddels as valid modddels, wrapped inside a
    /// ValidEntity, on the Right.
    static Either<Failure, ${classInfo.valid}> _verifyContent({
     ${classInfo.namedParameters.map((param) => 'required ${param.type} ${param.name},').join()}
    }) {
      ${generateContentVerification(classInfo.namedParameters, classInfo)}
      return contentVerification;
    }
    ''');

    /// Getters for all the fields

    for (final param in classInfo.namedParameters) {
      classBuffer.writeln('''
      ${param.type} get ${param.name} => map(
        valid: (valid) => valid.${param.name},
        invalidContent: (invalidContent) => invalidContent.${param.name},
      );
    
      ''');
    }

    /// toBroadEitherNullable method
    classBuffer.writeln('''
    /// If [nullableEntity] is null, returns `right(null)`.
    /// Otherwise, returns `nullableEntity.toBroadEither`
    static Either<Failure, ${classInfo.valid}?> toBroadEitherNullable(
      $className? nullableEntity) =>
      optionOf(nullableEntity).match((t) => t.toBroadEither, () => right(null));

    ''');

    /// map method
    classBuffer.writeln('''
    /// Same as [mapValidity] (because there is only one invalid union-case)
    TResult map<TResult extends Object?>({
      required TResult Function(${classInfo.valid} valid) valid,
      required TResult Function(${classInfo.invalidContent} invalidContent)
          invalidContent,
    }) {
      throw UnimplementedError();
    }

    ''');

    /// map validity method
    classBuffer.writeln('''
    /// Pattern matching for the two different union-cases of this entity : valid
    /// and invalid.
    TResult mapValidity<TResult extends Object?>({
      required TResult Function(${classInfo.valid} valid) valid,
      required TResult Function(${classInfo.invalidContent} invalidContent) invalid,
    }) {
      return map(
        valid: valid,
        invalidContent: invalid,
      );
    }

    ''');

    /// copyWith method
    classBuffer.writeln('''
    /// Creates a clone of this entity with the new specified values.
    ///
    /// The resulting entity is totally independent from this entity. It is
    /// validated upon creation, and can be either valid or invalid.
    ${classInfo.copyWith} get copyWith => ${classInfo.copyWithImpl}(
      mapValidity(valid: (valid) => valid, invalid: (invalid) => invalid));

    ''');

    /// props and stringifyMode getters
    classBuffer.writeln('''
    List<Object?> get props => throw UnimplementedError();

    StringifyMode get stringifyMode => ${stringifyMode.toString()};
    ''');

    /// End
    classBuffer.writeln('}');
  }

  String generateContentVerification(
      List<ModddelParameter> params, SimpleEntityClassInfo classInfo) {
    final paramsToVerify = params.where((p) => !p.hasValidAnnotation).toList();
    return '''final contentVerification = 
      ${_makeContentVerificationRecursive(paramsToVerify.length, paramsToVerify, classInfo)}
    ''';
  }

  String _makeContentVerificationRecursive(int totalParamsToVerify,
      List<ModddelParameter> paramsToVerify, SimpleEntityClassInfo classInfo) {
    final comma = paramsToVerify.length == totalParamsToVerify ? ';' : ',';

    if (paramsToVerify.isNotEmpty) {
      final param = paramsToVerify.first;

      final either = param.hasInvalidAnnotation
          ? 'Either<Null, Failure>.fromNullable(${param.name}?.failure, (r) => null).swap()'
          : param.isNullable
              ? '\$${param.nonNullableType}.toBroadEitherNullable(${param.name})'
              : '${param.name}.toBroadEither';

      return '''$either.flatMap(
      (${param.hasInvalidAnnotation ? '_' : param.validName}) => ${_makeContentVerificationRecursive(totalParamsToVerify, [
                ...paramsToVerify
              ]..removeAt(0), classInfo)}
      )$comma
      ''';
    }

    final constructorParams = classInfo.namedParameters.map((p) =>
        '${p.name}: ${p.hasInvalidAnnotation ? 'null' : p.hasValidAnnotation ? p.name : p.validName},');

    return '''right<Failure, ${classInfo.valid}>(${classInfo.valid}._(
        ${constructorParams.join('')}
      ))$comma
      ''';
  }

  void makeCopyWithClasses(
      StringBuffer classBuffer, SimpleEntityClassInfo classInfo) {
    /// COPYWITH ABSTRACT CLASS
    classBuffer.writeln('''
    abstract class ${classInfo.copyWith} {
    ''');

    /// call method
    classBuffer.writeln('''
    $className call({
      ${classInfo.namedParameters.map((param) => '${param.type} ${param.name},').join()} 
    });
    ''');

    /// end
    classBuffer.writeln('}');

    /// COPYWITH IMPLEMENTATION CLASS
    classBuffer.writeln('''
    class ${classInfo.copyWithImpl} implements ${classInfo.copyWith} {
      ${classInfo.copyWithImpl}(this._value);

      final $className _value;

    ''');

    /// call method
    classBuffer.writeln('''
    @override
    $className call({
      ${classInfo.namedParameters.map((param) => 'Object? ${param.name} = modddel,').join()} 
    }) {
      return _value.mapValidity(
        valid: (valid) => \$$className._create(
          ${classInfo.namedParameters.map((param) => '''${param.name}: ${param.name} == modddel
          ? valid.${param.name}
          : ${param.name} as ${param.type}, // ignore: cast_nullable_to_non_nullable
          ''').join()}
        ),
        invalid: (invalid) => \$$className._create(
          ${classInfo.namedParameters.map((param) => '''${param.name}: ${param.name} == modddel
          ? invalid.${param.name}
          : ${param.name} as ${param.type}, // ignore: cast_nullable_to_non_nullable
          ''').join()}
        ),
      );
    }
    ''');

    /// end
    classBuffer.writeln('}');
  }

  void makeValidEntity(
      StringBuffer classBuffer, SimpleEntityClassInfo classInfo) {
    classBuffer.writeln('''
    class ${classInfo.valid} extends $className implements ValidEntity {
      
    ''');

    /// private constructor
    classBuffer.writeln('''
    const ${classInfo.valid}._({
      ${classInfo.namedParameters.map((param) => 'required this.${param.name},').join()}
      }) : super._();

    ''');

    /// class members
    for (final param in classInfo.namedParameters) {
      classBuffer.writeln('@override');
      final paramType = param.hasInvalidAnnotation
          ? 'Null'
          : param.hasValidAnnotation
              ? param.type
              : 'Valid${param.type}';
      classBuffer.writeln('final $paramType ${param.name};');
    }
    classBuffer.writeln('');

    /// map method
    classBuffer.writeln('''
    @override
    TResult map<TResult extends Object?>({
      required TResult Function(${classInfo.valid} valid) valid,
      required TResult Function(${classInfo.invalidContent} invalidContent)
          invalidContent,
    }) {
      return valid(this);
    }

    ''');

    /// props getter
    classBuffer.writeln('''
    @override
    List<Object?> get props => [
        ${classInfo.namedParameters.map((param) => '${param.name},').join()}
      ];
    ''');

    /// end
    classBuffer.writeln('}');
  }

  void makeInvalidEntityContent(
      StringBuffer classBuffer, SimpleEntityClassInfo classInfo) {
    classBuffer.writeln('''
    class ${classInfo.invalidContent} extends $className
      implements InvalidEntityContent {        
    ''');

    /// private constructor
    classBuffer.writeln('''
    const ${classInfo.invalidContent}._({
      required this.contentFailure,
      ${classInfo.namedParameters.map((param) => 'required this.${param.name},').join()}
    }) : super._();
    ''');

    /// class members
    classBuffer.writeln('''
    @override
    final Failure contentFailure;

    @override
    Failure get failure => contentFailure;

    ${classInfo.namedParameters.map((param) => '''
    @override
    final ${param.type} ${param.name};
    ''').join()}

    ''');

    /// map method
    classBuffer.writeln('''
    @override
    TResult map<TResult extends Object?>({
      required TResult Function(${classInfo.valid} valid) valid,
      required TResult Function(${classInfo.invalidContent} invalidContent)
          invalidContent,
    }) {
      return invalidContent(this);
    }

    ''');

    /// props method
    classBuffer.writeln('''
    @override
    List<Object?> get props => [
      contentFailure,
      ${classInfo.namedParameters.map((param) => '${param.name},').join()}
    ];

    ''');

    /// End
    classBuffer.writeln('}');
  }

  void makeTester(StringBuffer classBuffer, SimpleEntityClassInfo classInfo) {
    classBuffer.writeln('''
    class ${className}Tester extends SimpleEntityTester<${classInfo.invalidContent},
      ${classInfo.valid}, $className, ${classInfo.modddelInput}> {
    ''');

    /// constructor
    classBuffer.writeln('''
    const ${className}Tester({
      int maxSutDescriptionLength = $maxSutDescriptionLength,
      String isSanitizedGroupDescription = 'Should be sanitized',
      String isNotSanitizedGroupDescription = 'Should not be sanitized',
      String isValidGroupDescription = 'Should be a ${classInfo.valid}',
      String isInvalidContentGroupDescription =
          'Should be an ${classInfo.invalidContent} and hold the proper contentFailure',
    }) : super(
            maxSutDescriptionLength: maxSutDescriptionLength,
            isSanitizedGroupDescription: isSanitizedGroupDescription,
            isNotSanitizedGroupDescription: isNotSanitizedGroupDescription,
            isValidGroupDescription: isValidGroupDescription,
            isInvalidContentGroupDescription: isInvalidContentGroupDescription,
          );
    ''');

    /// makeInput field
    classBuffer.writeln('''
    final makeInput = ${classInfo.modddelInput}.new;
    ''');

    /// end
    classBuffer.writeln('}');
  }

  void makeModddelInput(
      StringBuffer classBuffer, SimpleEntityClassInfo classInfo) {
    classBuffer.writeln('''
    class ${classInfo.modddelInput} extends ModddelInput<$className> {
    ''');

    /// constructor
    final constructorParams = classInfo.namedParameters.map(
      (parameter) {
        final declaration = 'this.${parameter.name}';
        return parameter.isRequired
            ? 'required $declaration,'
            : parameter.hasDefaultValue
                ? '$declaration = ${parameter.defaultValue},'
                : '$declaration,';
      },
    );

    classBuffer.writeln('''
    const ${classInfo.modddelInput}({
      ${constructorParams.join()}
    });
    ''');

    /// class members
    for (final parameter in classInfo.namedParameters) {
      classBuffer.writeln('final ${parameter.type} ${parameter.name};');
    }

    /// props method
    classBuffer.writeln('''
    @override
    List<Object?> get props => [
          ${classInfo.namedParameters.map((p) => '${p.name},').join()}
        ];
    ''');

    /// sanitizedInput method
    classBuffer.writeln('''
    @override
    ${classInfo.modddelInput} get sanitizedInput {
      final modddel = $className(
        ${classInfo.namedParameters.map((p) => '${p.name}: ${p.name},').join()}
      );

      return ${classInfo.modddelInput}(
        ${classInfo.namedParameters.map((p) => '${p.name}: modddel.${p.name},').join()}
      );
    }
    ''');

    /// end
    classBuffer.writeln('}');
  }
}
