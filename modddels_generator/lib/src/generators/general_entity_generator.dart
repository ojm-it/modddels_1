import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:modddels_annotations/modddels.dart';
import 'package:modddels_generator/src/core/class_info/class_info.dart';
import 'package:modddels_generator/src/core/templates/parameter.dart';
import 'package:modddels_generator/src/core/templates/parameters_template.dart';

class GeneralEntityGenerator {
  GeneralEntityGenerator._({
    required this.classInfo,
    required this.generateTester,
    required this.maxSutDescriptionLength,
    required this.stringifyMode,
  });

  static Future<GeneralEntityGenerator> create({
    required BuildStep buildStep,
    required String className,
    required ConstructorElement factoryConstructor,
    required bool generateTester,
    required int maxSutDescriptionLength,
    required StringifyMode stringifyMode,
  }) async {
    final classInfo = await GeneralEntityClassInfo.create(
      buildStep: buildStep,
      className: className,
      factoryConstructor: factoryConstructor,
    );

    return GeneralEntityGenerator._(
      classInfo: classInfo,
      generateTester: generateTester,
      maxSutDescriptionLength: maxSutDescriptionLength,
      stringifyMode: stringifyMode,
    );
  }

  final GeneralEntityClassInfo classInfo;

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
    $makeValidEntityContent
    $makeValidEntity
    $makeInvalidEntity
    $makeInvalidEntityContent
    $makeInvalidEntityGeneral
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
      /// 1. **Content validation**
      return _verifyContent(
        ${parametersTemplate.allParameters.map((param) => '${param.name} : ${param.name},').join()}
      ).match(
        (contentFailure) => ${classInfo.invalidContent}._(
          contentFailure: contentFailure,
          ${parametersTemplate.allParameters.map((param) => '${param.name} : ${param.name},').join()}
        ),
        
        /// 2. **General validation**
        (validContent) => _verifyGeneral(validContent).match(
          (generalFailure) => ${classInfo.invalidGeneral}._(
            generalFailure: generalFailure,
            ${parametersTemplate.allParameters.map((param) => '${param.name} : validContent.${param.name},').join()}
          ),

          /// 3. **→ Validations passed**
          (validGeneral) => validGeneral,
        ),
      );
    }

    ''');

    /// verifyContent function
    buffer.writeln('''
    /// If any of the modddels is invalid, this holds its failure on the Left (the
    /// failure of the first invalid modddel encountered)
    ///
    /// Otherwise, holds all the modddels as valid modddels, wrapped inside a
    /// _ValidEntityContent, on the Right.
    static Either<Failure, ${classInfo.validContent}> _verifyContent(
       ${parametersTemplate.asNamed(optionality: Optionality.makeAllRequired)}
    ) {
      ${generateContentVerification()}
      return contentVerification;
    }

    ''');

    /// verifyGeneral function
    buffer.writeln('''
    /// This holds a [GeneralFailure] on the Left if :
    ///  - One of the nullable fields marked with `@NullFailure` is null
    ///  - The validateGeneral method returns a [GeneralFailure]
    /// Otherwise, holds the ValidEntity on the Right.
    static Either<${classInfo.generalFailure}, ${classInfo.valid}> _verifyGeneral(
      ${classInfo.validContent} validEntityContent) {
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

    final getterParameters = parametersTemplate.allParameters
        .where((e) => e.hasWithGetterAnnotation);

    for (final param in getterParameters) {
      buffer.writeln('''
      ${param.doc}
      ${param.type} get ${param.name} => throw UnimplementedError();
    
      ''');
    }

    /// toBroadEitherNullable method
    buffer.writeln('''
    /// If [nullableEntity] is null, returns `right(null)`.
    /// Otherwise, returns `nullableEntity.toBroadEither`.
    static Either<Failure, ${classInfo.valid}?> toBroadEitherNullable(
      $className? nullableEntity) =>
      optionOf(nullableEntity).match((t) => t.toBroadEither, () => right(null));

    ''');

    /// map method
    buffer.writeln('''
    /// Similar to [mapValidity], but the "base" invalid union-case is replaced by
    /// the "specific" invalid union-cases of this entity :
    /// - [InvalidEntityContent]
    /// - [InvalidEntityGeneral]
    TResult map<TResult extends Object?>({
      required TResult Function(${classInfo.valid} valid) valid,
      required TResult Function(${classInfo.invalidContent} invalidContent)
          invalidContent,
      required TResult Function(${classInfo.invalidGeneral} invalidGeneral)
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
    buffer.writeln('''
    /// Equivalent to [map], but only the [valid] callback is required. It also
    /// adds an extra orElse required parameter, for fallback behavior.
    TResult maybeMap<TResult extends Object?>({
      required TResult Function(${classInfo.valid} valid) valid,
      TResult Function(${classInfo.invalidContent} invalidContent)? invalidContent,
      TResult Function(${classInfo.invalidGeneral} invalidGeneral)? invalidGeneral,
      required TResult Function(${classInfo.invalid} invalid) orElse,
    }) {
      throw UnimplementedError();
    }

    ''');

    /// mapValidity method
    buffer.writeln('''
    /// Pattern matching for the two different union-cases of this entity : valid
    /// and invalid.
    TResult mapValidity<TResult extends Object?>({
      required TResult Function(${classInfo.valid} valid) valid,
      required TResult Function(${classInfo.invalid} invalid) invalid,
    }) {
      return maybeMap(
        valid: valid,
        orElse: invalid,
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
      List<Parameter> paramsToVerify, GeneralEntityClassInfo classInfo) {
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

    final constructorParams = parametersTemplate.allParameters.map((p) =>
        '${p.name}: ${p.hasInvalidAnnotation ? 'null' : p.hasValidAnnotation ? p.name : p.validName},');

    return '''right<Failure, ${classInfo.validContent}>(${classInfo.validContent}._(
        ${constructorParams.join('')}
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

  String get makeValidEntityContent {
    final buffer = StringBuffer();

    buffer.writeln('''
    class ${classInfo.validContent} {
      
    ''');

    /// private constructor
    buffer.writeln('''
    const ${classInfo.validContent}._(
      ${parametersTemplate.asNamed(optionality: Optionality.makeAllRequired).asLocal()}
    );

    ''');

    /// class members
    for (final param in parametersTemplate.allParameters) {
      final paramType = param.hasInvalidAnnotation
          ? 'Null'
          : param.hasValidAnnotation
              ? param.type
              : 'Valid${param.type}';
      buffer.writeln('final $paramType ${param.name};');
    }
    buffer.writeln('');

    /// verifyNullables method
    buffer.writeln('''
    /// If one of the nullable fields marked with `@NullFailure` is null, this
    /// holds a [GeneralFailure] on the Left. Otherwise, holds the ValidEntity on
    /// the Right.
    Either<${classInfo.generalFailure}, ${classInfo.valid}> verifyNullables() {

      ${parametersTemplate.allParameters.where((p) => p.hasNullFailureAnnotation).map((param) => '''
      final ${param.name} = this.${param.name};
      if(${param.name} == null) {
        return left(${param.nullFailureString});
      }
      
      ''').join()}

      return right(${classInfo.valid}._(
        ${parametersTemplate.allParameters.map((param) => '${param.name} : ${param.name},').join()}
      ));
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
      if (param.hasWithGetterAnnotation) {
        buffer.writeln('@override');
      } else {
        buffer.writeln(param.doc);
      }
      final paramType =
          param.hasNullFailureAnnotation ? param.nonNullableType : param.type;

      final validParamType = param.hasInvalidAnnotation
          ? 'Null'
          : param.hasValidAnnotation
              ? paramType
              : 'Valid$paramType';
      buffer.writeln('final $validParamType ${param.name};');
    }
    buffer.writeln('');

    /// maybeMap method
    buffer.writeln('''
    @override
    TResult maybeMap<TResult extends Object?>({
      required TResult Function(${classInfo.valid} valid) valid,
      TResult Function(${classInfo.invalidContent} invalidContent)? invalidContent,
      TResult Function(${classInfo.invalidGeneral} invalidGeneral)? invalidGeneral,
      required TResult Function(${classInfo.invalid} invalid) orElse,
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

  String get makeInvalidEntity {
    final buffer = StringBuffer();

    buffer.writeln('''
    abstract class ${classInfo.invalid} extends $className
      implements InvalidEntity {
    ''');

    /// private constructor
    buffer.writeln('''
    const ${classInfo.invalid}._() : super._();

    ''');

    /// Fields Getters
    for (final param in parametersTemplate.allParameters) {
      if (param.hasWithGetterAnnotation) {
        buffer.writeln('@override');
      } else {
        buffer.writeln(param.doc);
      }
      buffer.writeln('${param.type} get ${param.name};');
    }
    buffer.writeln('');

    /// Failure getter
    buffer.writeln('''
    @override
    Failure get failure => whenInvalid(
          contentFailure: (contentFailure) => contentFailure,
          generalFailure: (generalFailure) => generalFailure,
        );

    ''');

    /// mapInvalid method
    buffer.writeln('''
    /// Pattern matching for the "specific" invalid union-cases of this "base"
    /// invalid union-case, which are :
    /// - [InvalidEntityContent]
    /// - [InvalidEntityGeneral]
    TResult mapInvalid<TResult extends Object?>({
      required TResult Function(${classInfo.invalidContent} invalidContent)
          invalidContent,
      required TResult Function(${classInfo.invalidGeneral} invalidGeneral)
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
    buffer.writeln('''
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
    class ${classInfo.invalidContent} extends ${classInfo.invalid}
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

    /// maybeMap method
    buffer.writeln('''
    @override
    TResult maybeMap<TResult extends Object?>({
      required TResult Function(${classInfo.valid} valid) valid,
      TResult Function(${classInfo.invalidContent} invalidContent)? invalidContent,
      TResult Function(${classInfo.invalidGeneral} invalidGeneral)? invalidGeneral,
      required TResult Function(${classInfo.invalid} invalid) orElse,
    }) {
      if (invalidContent != null) {
        return invalidContent(this);
      }
      return orElse(this);
    }
    ''');

    /// props getter
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

  String get makeInvalidEntityGeneral {
    final buffer = StringBuffer();

    final invalidEntityGeneralParams = parametersTemplate.copyWith(
      namedParameters: [
        ...parametersTemplate.namedParameters,
        ExpandedParameter.empty(
            name: 'generalFailure', type: classInfo.generalFailure),
      ],
    );

    buffer.writeln('''
    class ${classInfo.invalidGeneral} extends ${classInfo.invalid}
      implements InvalidEntityGeneral<${classInfo.generalFailure}> {
    ''');

    /// private constructor
    final constructorParams = invalidEntityGeneralParams
        .asNamed(optionality: Optionality.makeAllRequired)
        .asLocal();

    buffer.writeln('''
    const ${classInfo.invalidGeneral}._($constructorParams) : super._();

    ''');

    /// class members
    buffer.writeln('''
    ${parametersTemplate.allParameters.map((param) => '''
    @override
    final ${param.hasInvalidAnnotation ? 'Null' : param.hasValidAnnotation ? param.type : 'Valid${param.type}'} ${param.name};
    ''').join()}

    @override
    final ${classInfo.generalFailure} generalFailure;
    ''');

    /// maybeMap method
    buffer.writeln('''
    @override
    TResult maybeMap<TResult extends Object?>({
      required TResult Function(${classInfo.valid} valid) valid,
      TResult Function(${classInfo.invalidContent} invalidContent)? invalidContent,
      TResult Function(${classInfo.invalidGeneral} invalidGeneral)? invalidGeneral,
      required TResult Function(${classInfo.invalid} invalid) orElse,
    }) {
      if (invalidGeneral != null) {
        return invalidGeneral(this);
      }
      return orElse(this);
    }
    ''');

    /// props getter
    buffer.writeln('''
    @override
    List<Object?> get props => [
     ${invalidEntityGeneralParams.allParameters.map((param) => '${param.name},').join()}
    ];
    ''');

    /// End
    buffer.writeln('}');

    return buffer.toString();
  }

  String get makeTester {
    final buffer = StringBuffer();

    buffer.writeln('''
    class ${className}Tester extends GeneralEntityTester<
      ${classInfo.generalFailure},
      ${classInfo.invalidContent},
      ${classInfo.invalidGeneral},
      ${classInfo.invalid},
      ${classInfo.valid},
      $className,
      ${classInfo.modddelInput}
      > {
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
      String isInvalidGeneralGroupDescription =
          'Should be an ${classInfo.invalidGeneral} and hold the ${classInfo.generalFailure}',
    }) : super(
            maxSutDescriptionLength: maxSutDescriptionLength,
            isSanitizedGroupDescription: isSanitizedGroupDescription,
            isNotSanitizedGroupDescription: isNotSanitizedGroupDescription,
            isValidGroupDescription: isValidGroupDescription,
            isInvalidContentGroupDescription: isInvalidContentGroupDescription,
            isInvalidGeneralGroupDescription: isInvalidGeneralGroupDescription,
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
    for (final parameter in parametersTemplate.allParameters) {
      buffer.writeln('final ${parameter.type} ${parameter.name};');
    }

    /// props method
    buffer.writeln('''
    @override
    List<Object?> get props => [
          ${parametersTemplate.allParameters.map((p) => '${p.name},').join()}
        ];
    ''');

    /// sanitizedInput method
    String mapValidityParam(Parameter param, bool isNamed) {
      final paramName = param.name;
      final result = param.hasWithGetterAnnotation
          ? 'modddel.$paramName,'
          : 'modddel.mapValidity('
              'valid: (v) => v.$paramName, invalid: (i) => i.$paramName),';
      return isNamed ? '$paramName: $result' : result;
    }

    buffer.writeln('''
    @override
    ${classInfo.modddelInput} get sanitizedInput {
      final modddel = $className(
                 ${parametersTemplate.allPositionalParameters.map((p) => '${p.name},').join()}
        ${parametersTemplate.namedParameters.map((p) => '${p.name}: ${p.name},').join()}
      );

      return ${classInfo.modddelInput}(
         ${parametersTemplate.allPositionalParameters.map((p) => mapValidityParam(p, false)).join()}
        ${parametersTemplate.namedParameters.map((p) => mapValidityParam(p, true)).join()}
      );
    }
    ''');

    /// end
    buffer.writeln('}');

    return buffer.toString();
  }
}
