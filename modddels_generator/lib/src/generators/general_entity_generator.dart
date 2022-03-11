import 'package:analyzer/dart/element/element.dart';
import 'package:modddels_annotations/modddels.dart';
import 'package:modddels_generator/src/utils.dart';
import 'package:source_gen/source_gen.dart';

class GeneralEntityGenerator {
  GeneralEntityGenerator({
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

    final namedParameters =
        parameters.where((element) => element.isNamed).toList();

    if (namedParameters.isEmpty) {
      throw InvalidGenerationSourceError(
        'The factory constructor should contain at least one name parameter',
        element: factoryConstructor,
      );
    }

    final classInfo = GeneralEntityClassInfo(className, namedParameters);

    for (final param in classInfo.namedParameters) {
      if (param.type == 'dynamic') {
        throw InvalidGenerationSourceError(
          'The named parameters of the factory constructor should have valid types, and should not be dynamic.'
          'Consider using the @TypeName annotation to manually provide the type.',
          element: param.parameter,
        );
      }
    }

    if (classInfo.namedParameters.every((param) => param.hasValidAnnotation)) {
      throw InvalidGenerationSourceError(
        'A GeneralEntity can\'t have all its fields marked with @valid.',
        element: factoryConstructor,
      );
    }

    for (final param in classInfo.namedParameters) {
      if (param.hasValidAnnotation && param.hasInvalidAnnotation) {
        throw InvalidGenerationSourceError(
          'The @valid and @invalid annotations can\'t be used together on the same parameter.',
          element: param.parameter,
        );
      }
    }

    for (final param in classInfo.namedParameters) {
      if (param.hasInvalidAnnotation && !param.isNullable) {
        throw InvalidGenerationSourceError(
          'The @invalid annotation can only be used on nullable parameters.',
          element: param.parameter,
        );
      }
    }

    for (final param in classInfo.namedParameters) {
      if (param.hasInvalidAnnotation && param.hasNullFailureAnnotation) {
        throw InvalidGenerationSourceError(
          'The @invalid and @NullFailure annotations can\'t be used together on the same parameter.',
          element: param.parameter,
        );
      }
    }

    for (final param in classInfo.namedParameters) {
      if (param.hasNullFailureAnnotation) {
        if (!param.isNullable) {
          throw InvalidGenerationSourceError(
            'The @NullFailure annotation can only be used with nullable parameters.',
            element: param.parameter,
          );
        }
      }
    }

    final classBuffer = StringBuffer();

    makeHeader(classBuffer);

    makeMixin(classBuffer, classInfo);

    makeValidEntityContent(classBuffer, classInfo);

    makeValidEntity(classBuffer, classInfo);

    makeInvalidEntity(classBuffer, classInfo);

    makeInvalidEntityContent(classBuffer, classInfo);

    makeInvalidEntityGeneral(classBuffer, classInfo);

    if (generateTester) {
      makeTester(classBuffer, classInfo);
    }

    return classBuffer.toString();
  }

  void makeHeader(StringBuffer classBuffer) {
    classBuffer.writeln('''
    // ignore_for_file: prefer_void_to_null
    
    ''');
  }

  void makeMixin(StringBuffer classBuffer, GeneralEntityClassInfo classInfo) {
    classBuffer.writeln('''
    mixin \$$className {
    
    ''');

    /// create method
    classBuffer.writeln('''
    static $className _create({
      ${classInfo.namedParameters.map((param) => 'required ${param.type} ${param.name},').join()}
    }) {
      /// 1. **Content validation**
      return _verifyContent(
        ${classInfo.namedParameters.map((param) => '${param.name} : ${param.name},').join()}
      ).match(
        (contentFailure) => ${classInfo.invalidEntityContent}._(
          contentFailure: contentFailure,
          ${classInfo.namedParameters.map((param) => '${param.name} : ${param.name},').join()}
        ),
        
        /// 2. **General validation**
        (validContent) => _verifyGeneral(validContent).match(
          (generalFailure) => ${classInfo.invalidEntityGeneral}._(
            generalFailure: generalFailure,
            ${classInfo.namedParameters.map((param) => '${param.name} : validContent.${param.name},').join()}
          ),

          /// 3. **→ Validations passed**
          (validGeneral) => validGeneral,
        ),
      );
    }

    ''');

    /// verifyContent function
    classBuffer.writeln('''
    /// If any of the modddels is invalid, this holds its failure on the Left (the
    /// failure of the first invalid modddel encountered)
    ///
    /// Otherwise, holds all the modddels as valid modddels, wrapped inside a
    /// _ValidEntityContent, on the Right.
    static Either<Failure, ${classInfo.validEntityContent}> _verifyContent({
      ${classInfo.namedParameters.map((param) => 'required ${param.type} ${param.name},').join()}
    }) {
      ${generateContentVerification(classInfo.namedParameters, classInfo)}
      return contentVerification;
    }

    ''');

    /// verifyGeneral function
    classBuffer.writeln('''
    /// This holds a [GeneralFailure] on the Left if :
    ///  - One of the nullable fields marked with `@NullFailure` is null
    ///  - The validateGeneral method returns a [GeneralFailure]
    /// Otherwise, holds the ValidEntity on the Right.
    static Either<${classInfo.generalFailure}, ${classInfo.validEntity}> _verifyGeneral(
      ${classInfo.validEntityContent} validEntityContent) {
      final nullablesVerification = validEntityContent.verifyNullables();

      final generalVerification = nullablesVerification.flatMap((validEntity) =>
        const $className._()
            .validateGeneral(validEntity)
            .toEither(() => validEntity)
            .swap());

      return generalVerification;
    }

    ''');

    /// Getters for fields marked with '@withGetter' (or '@validWithGetter' or
    /// '@invalidWithGetter')

    final getterParameters =
        classInfo.namedParameters.where((e) => e.hasWithGetterAnnotation);

    for (final param in getterParameters) {
      classBuffer.writeln('''
      ${param.type} get ${param.name} => throw UnimplementedError();
    
      ''');
    }

    /// toBroadEitherNullable method
    classBuffer.writeln('''
    /// If [nullableEntity] is null, returns `right(null)`.
    /// Otherwise, returns `nullableEntity.toBroadEither`.
    static Either<Failure, ${classInfo.validEntity}?> toBroadEitherNullable(
      $className? nullableEntity) =>
      optionOf(nullableEntity).match((t) => t.toBroadEither, () => right(null));

    ''');

    /// map method
    classBuffer.writeln('''
    /// Similar to [mapValidity], but the "base" invalid union-case is replaced by
    /// the "specific" invalid union-cases of this entity :
    /// - [InvalidEntityContent]
    /// - [InvalidEntityGeneral]
    TResult map<TResult extends Object?>({
      required TResult Function(${classInfo.validEntity} valid) valid,
      required TResult Function(${classInfo.invalidEntityContent} invalidContent)
          invalidContent,
      required TResult Function(${classInfo.invalidEntityGeneral} invalidGeneral)
          invalidGeneral,
    }) {
      return maybeMap(
        valid: valid,
        invalidContent: invalidContent,
        invalidGeneral: invalidGeneral,
        orElse: (invalid) => throw UnreachableError(),
      );
    }

    ''');

    /// maybe map method
    classBuffer.writeln('''
    /// Equivalent to [map], but only the [valid] callback is required. It also
    /// adds an extra orElse required parameter, for fallback behavior.
    TResult maybeMap<TResult extends Object?>({
      required TResult Function(${classInfo.validEntity} valid) valid,
      TResult Function(${classInfo.invalidEntityContent} invalidContent)? invalidContent,
      TResult Function(${classInfo.invalidEntityGeneral} invalidGeneral)? invalidGeneral,
      required TResult Function(${classInfo.invalidEntity} invalid) orElse,
    }) {
      throw UnimplementedError();
    }

    ''');

    /// mapValidity method
    classBuffer.writeln('''
    /// Pattern matching for the two different union-cases of this entity : valid
    /// and invalid.
    TResult mapValidity<TResult extends Object?>({
      required TResult Function(${classInfo.validEntity} valid) valid,
      required TResult Function(${classInfo.invalidEntity} invalid) invalid,
    }) {
      return maybeMap(
        valid: valid,
        orElse: invalid,
      );
    }

    ''');

    /// copyWith method
    classBuffer.writeln('''
    /// Creates a clone of this entity with the new specified values.
    ///
    /// The resulting entity is totally independent from this entity. It is
    /// validated upon creation, and can be either valid or invalid.
    $className copyWith({
      ${classInfo.namedParameters.map((param) => '${param.optionalType} ${param.name},').join()}
    }) {
      return mapValidity(
        valid: (valid) => _create(
          ${classInfo.namedParameters.map((param) => '${param.name}: ${param.name} ?? valid.${param.name},').join()}
        ),
        invalid: (invalid) => _create(
          ${classInfo.namedParameters.map((param) => '${param.name}: ${param.name} ?? invalid.${param.name},').join()}
        ),
      );
    }

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
      List<EntityParameter> params, GeneralEntityClassInfo classInfo) {
    final paramsToVerify = params.where((p) => !p.hasValidAnnotation).toList();
    return '''final contentVerification = 
      ${_makeContentVerificationRecursive(paramsToVerify.length, paramsToVerify, classInfo)}
    ''';
  }

  String _makeContentVerificationRecursive(int totalParamsToVerify,
      List<EntityParameter> paramsToVerify, GeneralEntityClassInfo classInfo) {
    final comma = paramsToVerify.length == totalParamsToVerify ? ';' : ',';

    if (paramsToVerify.isNotEmpty) {
      final param = paramsToVerify.first;

      final either = param.hasInvalidAnnotation
          ? 'Either<Null, Failure>.fromNullable(${param.name}?.failure, (r) => null).swap()'
          : param.isNullable
              ? '\$${param.typeWithoutNullabilitySuffix}.toBroadEitherNullable(${param.name})'
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

    return '''right<Failure, ${classInfo.validEntityContent}>(${classInfo.validEntityContent}._(
        ${constructorParams.join('')}
      ))$comma
      ''';
  }

  void makeValidEntityContent(
      StringBuffer classBuffer, GeneralEntityClassInfo classInfo) {
    classBuffer.writeln('''
    class ${classInfo.validEntityContent} {
      
    ''');

    /// private constructor
    classBuffer.writeln('''
    const ${classInfo.validEntityContent}._({
      ${classInfo.namedParameters.map((param) => 'required this.${param.name},').join()}
      });

    ''');

    /// class members
    for (final param in classInfo.namedParameters) {
      final paramType = param.hasInvalidAnnotation
          ? 'Null'
          : param.hasValidAnnotation
              ? param.type
              : 'Valid${param.type}';
      classBuffer.writeln('final $paramType ${param.name};');
    }
    classBuffer.writeln('');

    /// verifyNullables method
    classBuffer.writeln('''
    /// If one of the nullable fields marked with `@NullFailure` is null, this
    /// holds a [GeneralFailure] on the Left. Otherwise, holds the ValidEntity on
    /// the Right.
    Either<${classInfo.generalFailure}, ${classInfo.validEntity}> verifyNullables() {

      ${classInfo.namedParameters.where((p) => p.hasNullFailureAnnotation).map((param) => '''
      final ${param.name} = this.${param.name};
      if(${param.name} == null) {
        return left(${param.nullFailureString});
      }
      
      ''').join()}

      return right(${classInfo.validEntity}._(
        ${classInfo.namedParameters.map((param) => '${param.name} : ${param.name},').join()}
      ));
    }
    ''');

    /// end
    classBuffer.writeln('}');
  }

  void makeValidEntity(
      StringBuffer classBuffer, GeneralEntityClassInfo classInfo) {
    classBuffer.writeln('''
    class ${classInfo.validEntity} extends $className implements ValidEntity {
      
    ''');

    /// private constructor
    classBuffer.writeln('''
    const ${classInfo.validEntity}._({
      ${classInfo.namedParameters.map((param) => 'required this.${param.name},').join()}
      }) : super._();

    ''');

    /// class members
    for (final param in classInfo.namedParameters) {
      if (param.hasWithGetterAnnotation) {
        classBuffer.writeln('@override');
      }
      final paramType = param.hasNullFailureAnnotation
          ? param.typeWithoutNullabilitySuffix
          : param.type;

      final validParamType = param.hasInvalidAnnotation
          ? 'Null'
          : param.hasValidAnnotation
              ? paramType
              : 'Valid$paramType';
      classBuffer.writeln('final $validParamType ${param.name};');
    }
    classBuffer.writeln('');

    /// maybeMap method
    classBuffer.writeln('''
    @override
    TResult maybeMap<TResult extends Object?>({
      required TResult Function(${classInfo.validEntity} valid) valid,
      TResult Function(${classInfo.invalidEntityContent} invalidContent)? invalidContent,
      TResult Function(${classInfo.invalidEntityGeneral} invalidGeneral)? invalidGeneral,
      required TResult Function(${classInfo.invalidEntity} invalid) orElse,
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

  void makeInvalidEntity(
      StringBuffer classBuffer, GeneralEntityClassInfo classInfo) {
    classBuffer.writeln('''
    abstract class ${classInfo.invalidEntity} extends $className
      implements InvalidEntity {
    ''');

    /// private constructor
    classBuffer.writeln('''
    const ${classInfo.invalidEntity}._() : super._();

    ''');

    /// Fields Getters
    for (final param in classInfo.namedParameters) {
      if (param.hasWithGetterAnnotation) {
        classBuffer.writeln('@override');
      }
      classBuffer.writeln('${param.type} get ${param.name};');
    }
    classBuffer.writeln('');

    /// Failure getter
    classBuffer.writeln('''
    @override
    Failure get failure => whenInvalid(
          contentFailure: (contentFailure) => contentFailure,
          generalFailure: (generalFailure) => generalFailure,
        );

    ''');

    /// mapInvalid method
    classBuffer.writeln('''
    /// Pattern matching for the "specific" invalid union-cases of this "base"
    /// invalid union-case, which are :
    /// - [InvalidEntityContent]
    /// - [InvalidEntityGeneral]
    TResult mapInvalid<TResult extends Object?>({
      required TResult Function(${classInfo.invalidEntityContent} invalidContent)
          invalidContent,
      required TResult Function(${classInfo.invalidEntityGeneral} invalidGeneral)
          invalidGeneral,
    }) {
      return maybeMap(
        valid: (valid) => throw UnreachableError(),
        invalidContent: invalidContent,
        invalidGeneral: invalidGeneral,
        orElse: (invalid) => throw UnreachableError(),
      );
    }
    ''');

    /// whenInvalid method
    classBuffer.writeln('''
    /// Similar to [mapInvalid], but the union-cases are replaced by the failures
    /// they hold.
    TResult whenInvalid<TResult extends Object?>({
      required TResult Function(Failure contentFailure) contentFailure,
      required TResult Function(${classInfo.generalFailure} generalFailure)
          generalFailure,
    }) {
      return maybeMap(
        valid: (valid) => throw UnreachableError(),
        invalidContent: (invalidContent) =>
            contentFailure(invalidContent.contentFailure),
        invalidGeneral: (invalidGeneral) =>
            generalFailure(invalidGeneral.generalFailure),
        orElse: (invalid) => throw UnreachableError(),
      );
    }
    ''');

    /// End
    classBuffer.writeln('}');
  }

  void makeInvalidEntityContent(
      StringBuffer classBuffer, GeneralEntityClassInfo classInfo) {
    classBuffer.writeln('''
    class ${classInfo.invalidEntityContent} extends ${classInfo.invalidEntity}
      implements InvalidEntityContent {        
    ''');

    /// private constructor
    classBuffer.writeln('''
    const ${classInfo.invalidEntityContent}._({
      required this.contentFailure,
      ${classInfo.namedParameters.map((param) => 'required this.${param.name},').join()}
    }) : super._();
    ''');

    /// Getters
    classBuffer.writeln('''
    @override
    final Failure contentFailure;

    ${classInfo.namedParameters.map((param) => '''
    @override
    final ${param.type} ${param.name};
    ''').join()}

    ''');

    /// maybeMap method
    classBuffer.writeln('''
    @override
    TResult maybeMap<TResult extends Object?>({
      required TResult Function(${classInfo.validEntity} valid) valid,
      TResult Function(${classInfo.invalidEntityContent} invalidContent)? invalidContent,
      TResult Function(${classInfo.invalidEntityGeneral} invalidGeneral)? invalidGeneral,
      required TResult Function(${classInfo.invalidEntity} invalid) orElse,
    }) {
      if (invalidContent != null) {
        return invalidContent(this);
      }
      return orElse(this);
    }
    ''');

    /// props getter
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

  void makeInvalidEntityGeneral(
      StringBuffer classBuffer, GeneralEntityClassInfo classInfo) {
    classBuffer.writeln('''
    class ${classInfo.invalidEntityGeneral} extends ${classInfo.invalidEntity}
      implements InvalidEntityGeneral<${classInfo.generalFailure}> {
    ''');

    /// private constructor
    classBuffer.writeln('''
    const ${classInfo.invalidEntityGeneral}._({
      required this.generalFailure,
      ${classInfo.namedParameters.map((param) => 'required this.${param.name},').join()}
    }) : super._();

    ''');

    /// Getters
    classBuffer.writeln('''
    @override
    final ${classInfo.generalFailure} generalFailure;

    ${classInfo.namedParameters.map((param) => '''
    @override
    final ${param.hasInvalidAnnotation ? 'Null' : param.hasValidAnnotation ? param.type : 'Valid${param.type}'} ${param.name};
    ''').join()}

    ''');

    /// maybeMap method
    classBuffer.writeln('''
    @override
    TResult maybeMap<TResult extends Object?>({
      required TResult Function(${classInfo.validEntity} valid) valid,
      TResult Function(${classInfo.invalidEntityContent} invalidContent)? invalidContent,
      TResult Function(${classInfo.invalidEntityGeneral} invalidGeneral)? invalidGeneral,
      required TResult Function(${classInfo.invalidEntity} invalid) orElse,
    }) {
      if (invalidGeneral != null) {
        return invalidGeneral(this);
      }
      return orElse(this);
    }
    ''');

    /// props getter
    classBuffer.writeln('''
    @override
    List<Object?> get props => [
      generalFailure,
      ${classInfo.namedParameters.map((param) => '${param.name},').join()}
    ];
    ''');

    /// End
    classBuffer.writeln('}');
  }

  void makeTester(StringBuffer classBuffer, GeneralEntityClassInfo classInfo) {
    classBuffer.writeln('''
    class ${className}Tester extends GeneralEntityTester<
      ${classInfo.generalFailure},
      ${classInfo.invalidEntityContent},
      ${classInfo.invalidEntityGeneral},
      ${classInfo.invalidEntity},
      ${classInfo.validEntity},
      $className> {
    ''');

    /// constructor
    classBuffer.writeln('''
    const ${className}Tester({
      int maxSutDescriptionLength = $maxSutDescriptionLength,
      String isValidGroupDescription = 'Should be a ${classInfo.validEntity}',
      String isInvalidContentGroupDescription =
          'Should be an ${classInfo.invalidEntityContent} and hold the proper contentFailure',
      String isInvalidGeneralGroupDescription =
          'Should be an ${classInfo.invalidEntityGeneral} and hold the ${classInfo.generalFailure}',
    }) : super(
            maxSutDescriptionLength: maxSutDescriptionLength,
            isValidGroupDescription: isValidGroupDescription,
            isInvalidContentGroupDescription: isInvalidContentGroupDescription,
            isInvalidGeneralGroupDescription: isInvalidGeneralGroupDescription,
          );
    ''');

    /// end
    classBuffer.writeln('}');
  }
}
