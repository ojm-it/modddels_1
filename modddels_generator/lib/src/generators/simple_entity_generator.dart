import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:modddels_annotations/modddels.dart';
import 'package:modddels_generator/src/core/class_info/class_info.dart';
import 'package:modddels_generator/src/core/templates/parameter.dart';
import 'package:modddels_generator/src/core/templates/parameters_template.dart';

class SimpleEntityGenerator {
  SimpleEntityGenerator._({
    required this.classInfo,
    required this.generateTester,
    required this.maxSutDescriptionLength,
    required this.stringifyMode,
  });

  static Future<SimpleEntityGenerator> create({
    required BuildStep buildStep,
    required String className,
    required ConstructorElement factoryConstructor,
    required bool generateTester,
    required int maxSutDescriptionLength,
    required StringifyMode stringifyMode,
  }) async {
    final classInfo = await SimpleEntityClassInfo.create(
      buildStep: buildStep,
      className: className,
      factoryConstructor: factoryConstructor,
    );

    return SimpleEntityGenerator._(
      classInfo: classInfo,
      generateTester: generateTester,
      maxSutDescriptionLength: maxSutDescriptionLength,
      stringifyMode: stringifyMode,
    );
  }

  final SimpleEntityClassInfo classInfo;

  /// See [ModddelAnnotation.generateTester]
  final bool generateTester;

  /// See [ModddelAnnotation.maxSutDescriptionLength]
  final int maxSutDescriptionLength;

  /// See [ModddelAnnotation.stringifyMode]
  final StringifyMode stringifyMode;

  String get className => classInfo.className;

  ParametersTemplate get parametersTemplate => classInfo.parametersTemplate;

  @override
  String toString() {
    final tester = generateTester
        ? '''
          $makeTester
          $makeModddelInput
          '''
        : '';

    return '''
    $makeMixin
    $makeCopyWithClasses
    $makeValidEntity
    $makeInvalidEntityContent
    $tester
    ''';
  }

  String get makeMixin {
    final buffer = StringBuffer();

    buffer.writeln('''
    mixin \$$className {
    
    ''');

    /// create method
    buffer.writeln('''
    static $className _create(
      ${parametersTemplate.asNamed(optionality: Optionality.makeAllRequired)}
    ) {
      /// 1. **Content Validation**
      return _verifyContent(
        ${parametersTemplate.allParameters.map((param) => '${param.name} : ${param.name},').join()}
      ).match(
        (contentFailure) => ${classInfo.invalidContent}._(
          contentFailure: contentFailure,
           ${parametersTemplate.allParameters.map((param) => '${param.name} : ${param.name},').join()}
        ),

        /// 2. **→ Validations passed**
        (validContent) => validContent,
      );
    }
    ''');

    /// verifyContent function
    buffer.writeln('''
    /// If any of the modddels is invalid, this holds its failure on the Left (the
    /// failure of the first invalid modddel encountered)
    ///
    /// Otherwise, holds all the modddels as valid modddels, wrapped inside a
    /// ValidEntity, on the Right.
    static Either<Failure, ${classInfo.valid}> _verifyContent(
     ${parametersTemplate.asNamed(optionality: Optionality.makeAllRequired)}
    ) {
      ${generateContentVerification()}
      return contentVerification;
    }
    ''');

    /// Getters for all the fields

    for (final param in parametersTemplate.allParameters) {
      buffer.writeln('''
      ${param.doc}
      ${param.type} get ${param.name} => map(
        valid: (valid) => valid.${param.name},
        invalidContent: (invalidContent) => invalidContent.${param.name},
      );
    
      ''');
    }

    /// toBroadEitherNullable method
    buffer.writeln('''
    /// If [nullableEntity] is null, returns `right(null)`.
    /// Otherwise, returns `nullableEntity.toBroadEither`
    static Either<Failure, ${classInfo.valid}?> toBroadEitherNullable(
      $className? nullableEntity) =>
      optionOf(nullableEntity).match((t) => t.toBroadEither, () => right(null));

    ''');

    /// map method
    buffer.writeln('''
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
    buffer.writeln('''
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
    buffer.writeln('''
    /// Creates a clone of this entity with the new specified values.
    ///
    /// The resulting entity is totally independent from this entity. It is
    /// validated upon creation, and can be either valid or invalid.
    ${classInfo.copyWith} get copyWith => ${classInfo.copyWithImpl}(
      mapValidity(valid: (valid) => valid, invalid: (invalid) => invalid));

    ''');

    /// props and stringifyMode getters
    buffer.writeln('''
    List<Object?> get props => throw UnimplementedError();

    StringifyMode get stringifyMode => ${stringifyMode.toString()};
    ''');

    /// End
    buffer.writeln('}');

    return buffer.toString();
  }

  String generateContentVerification() {
    final paramsToVerify = parametersTemplate.allParameters
        .where((p) => !p.hasValidAnnotation)
        .toList();
    return '''final contentVerification = 
      ${_makeContentVerificationRecursive(paramsToVerify.length, paramsToVerify, classInfo)}
    ''';
  }

  String _makeContentVerificationRecursive(int totalParamsToVerify,
      List<Parameter> paramsToVerify, SimpleEntityClassInfo classInfo) {
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

    final validConstructorParams = parametersTemplate.allParameters.map((p) =>
        '${p.name}: ${p.hasInvalidAnnotation ? 'null' : p.hasValidAnnotation ? p.name : p.validName},');

    return '''right<Failure, ${classInfo.valid}>(${classInfo.valid}._(
        ${validConstructorParams.join('')}
      ))$comma
      ''';
  }

  String get makeCopyWithClasses {
    final buffer = StringBuffer();

    /// COPYWITH ABSTRACT CLASS
    buffer.writeln('''
    abstract class ${classInfo.copyWith} {
    ''');

    /// call method
    buffer.writeln('''
    $className call(
      ${parametersTemplate.asNamed(optionality: Optionality.makeAllOptional)} 
    );
    ''');

    /// end
    buffer.writeln('}');

    /// COPYWITH IMPLEMENTATION CLASS
    buffer.writeln('''
    class ${classInfo.copyWithImpl} implements ${classInfo.copyWith} {
      ${classInfo.copyWithImpl}(this._value);

      final $className _value;

    ''');

    /// call method
    final callParameters = parametersTemplate
        .asNamed(optionality: Optionality.makeAllOptional)
        .asExpanded(showDefaultValue: true)
        .transformParameters((parameter) => parameter.copyWith(
              type: 'Object?',
              defaultValue: 'modddel',
            ));

    buffer.writeln('''
    @override
    $className call($callParameters) {
      return _value.mapValidity(
        valid: (valid) => \$$className._create(
          ${parametersTemplate.allParameters.map((param) => '''${param.name}: ${param.name} == modddel
          ? valid.${param.name}
          : ${param.name} as ${param.type}, // ignore: cast_nullable_to_non_nullable
          ''').join()}
        ),
        invalid: (invalid) => \$$className._create(
          ${parametersTemplate.allParameters.map((param) => '''${param.name}: ${param.name} == modddel
          ? invalid.${param.name}
          : ${param.name} as ${param.type}, // ignore: cast_nullable_to_non_nullable
          ''').join()}
        ),
      );
    }
    ''');

    /// end
    buffer.writeln('}');

    return buffer.toString();
  }

  String get makeValidEntity {
    final buffer = StringBuffer();

    buffer.writeln('''
    class ${classInfo.valid} extends $className implements ValidEntity {
      
    ''');

    /// private constructor

    buffer.writeln('''
    const ${classInfo.valid}._(
      ${parametersTemplate.asNamed(optionality: Optionality.makeAllRequired).asLocal()}
      ) : super._();

    ''');

    /// class members
    for (final param in parametersTemplate.allParameters) {
      buffer.writeln('@override');
      final paramType = param.hasInvalidAnnotation
          ? 'Null'
          : param.hasValidAnnotation
              ? param.type
              : 'Valid${param.type}';
      buffer.writeln('final $paramType ${param.name};');
    }
    buffer.writeln('');

    /// map method
    buffer.writeln('''
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
    buffer.writeln('''
    @override
    List<Object?> get props => [
        ${parametersTemplate.allParameters.map((param) => '${param.name},').join()}
      ];
    ''');

    /// end
    buffer.writeln('}');

    return buffer.toString();
  }

  String get makeInvalidEntityContent {
    final buffer = StringBuffer();

    final invalidEntityContentParams = parametersTemplate.copyWith(
      namedParameters: [
        ...parametersTemplate.namedParameters,
        ExpandedParameter.empty(name: 'contentFailure', type: 'Failure'),
      ],
    );

    buffer.writeln('''
    class ${classInfo.invalidContent} extends $className
      implements InvalidEntityContent {        
    ''');

    /// private constructor
    final constructorParams = invalidEntityContentParams
        .asNamed(optionality: Optionality.makeAllRequired)
        .asLocal();

    buffer.writeln('''
    const ${classInfo.invalidContent}._($constructorParams) : super._();
    ''');

    /// class members
    for (final param in invalidEntityContentParams.allParameters) {
      buffer.writeln('''
      @override
      final ${param.type} ${param.name};
      ''');
    }

    /// failure getter
    buffer.writeln('''
    @override
    Failure get failure => contentFailure;
    ''');

    /// map method
    buffer.writeln('''
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
    buffer.writeln('''
    @override
    List<Object?> get props => [
      ${invalidEntityContentParams.allParameters.map((param) => '${param.name},').join()}
    ];

    ''');

    /// End
    buffer.writeln('}');

    return buffer.toString();
  }

  String get makeTester {
    final buffer = StringBuffer();

    buffer.writeln('''
    class ${className}Tester extends SimpleEntityTester<${classInfo.invalidContent},
      ${classInfo.valid}, $className, ${classInfo.modddelInput}> {
    ''');

    /// constructor
    buffer.writeln('''
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
    buffer.writeln('''
    final makeInput = ${classInfo.modddelInput}.new;
    ''');

    /// end
    buffer.writeln('}');

    return buffer.toString();
  }

  String get makeModddelInput {
    final buffer = StringBuffer();

    buffer.writeln('''
    class ${classInfo.modddelInput} extends ModddelInput<$className> {
    ''');

    /// constructor
    buffer.writeln('''
    const ${classInfo.modddelInput}(${parametersTemplate.asLocal()});
    ''');

    /// class members
    for (final param in parametersTemplate.allParameters) {
      buffer.writeln('final ${param.type} ${param.name};');
    }

    /// props method
    buffer.writeln('''
    @override
    List<Object?> get props => [
          ${parametersTemplate.allParameters.map((p) => '${p.name},').join()}
        ];
    ''');

    /// sanitizedInput method
    buffer.writeln('''
    @override
    ${classInfo.modddelInput} get sanitizedInput {
      final modddel = $className(
        ${parametersTemplate.allPositionalParameters.map((p) => '${p.name},').join()}
        ${parametersTemplate.namedParameters.map((p) => '${p.name}: ${p.name},').join()}
      );

      return ${classInfo.modddelInput}(
        ${parametersTemplate.allPositionalParameters.map((p) => 'modddel.${p.name},').join()}
        ${parametersTemplate.namedParameters.map((p) => '${p.name}: modddel.${p.name},').join()}
      );
    }
    ''');

    /// end
    buffer.writeln('}');

    return buffer.toString();
  }
}
