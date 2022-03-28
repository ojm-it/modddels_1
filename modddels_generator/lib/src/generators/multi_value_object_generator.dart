import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:modddels_annotations/modddels.dart';
import 'package:modddels_generator/src/core/class_info/class_info.dart';
import 'package:modddels_generator/src/core/templates/parameter.dart';
import 'package:modddels_generator/src/core/templates/parameters_template.dart';

class MultiValueObjectGenerator {
  MultiValueObjectGenerator._({
    required this.classInfo,
    required this.generateTester,
    required this.maxSutDescriptionLength,
    required this.stringifyMode,
  });

  static Future<MultiValueObjectGenerator> create({
    required BuildStep buildStep,
    required String className,
    required ConstructorElement factoryConstructor,
    required bool generateTester,
    required int maxSutDescriptionLength,
    required StringifyMode stringifyMode,
  }) async {
    final classInfo = await MultiValueObjectClassInfo.create(
      buildStep: buildStep,
      className: className,
      factoryConstructor: factoryConstructor,
    );

    return MultiValueObjectGenerator._(
      classInfo: classInfo,
      generateTester: generateTester,
      maxSutDescriptionLength: maxSutDescriptionLength,
      stringifyMode: stringifyMode,
    );
  }

  final MultiValueObjectClassInfo classInfo;

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
    $makeHolder
    $makeValidValueObject
    $makeInvalidValueObject
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
      /// 1. **Value Validation**
      return _verifyValue(${classInfo.holder}._(
        ${parametersTemplate.allParameters.map((param) => '${param.name} : ${param.name},').join()}
      )).match(
        (valueFailure) => ${classInfo.invalid}._(
          valueFailure: valueFailure,
          ${parametersTemplate.allParameters.map((param) => '${param.name} : ${param.name},').join()}
        ),

        /// 2. **→ Validations passed**
        (validValueObject) => validValueObject,
      );
    }

    ''');

    /// _verifyValue method
    buffer.writeln('''
    /// If the value is invalid, this holds the [ValueFailure] on the Left.
    /// Otherwise, holds the [ValidValueObject] on the Right.
    static Either<${classInfo.valueFailure}, ${classInfo.valid}> _verifyValue(
      ${classInfo.holder} valueObject) {
      final nullablesVerification = valueObject.verifyNullables();

      final valueVerification = nullablesVerification.flatMap(
          (validValueObject) => const $className._()
              .validateValue(validValueObject)
              .toEither(() => validValueObject)
              .swap());

      return valueVerification;
    }

    ''');

    /// toBroadEitherNullable method
    buffer.writeln('''
    /// If [nullableValueObject] is null, returns `right(null)`.
    /// Otherwise, returns `nullableValueObject.toBroadEither`.
    static Either<Failure, ${classInfo.valid}?> toBroadEitherNullable(
      $className? nullableValueObject) =>
        optionOf(nullableValueObject)
          .match((t) => t.toBroadEither, () => right(null));

    ''');

    buffer.writeln('''
    
    ''');

    /// map method
    buffer.writeln('''
    /// Same as [mapValidity] (because there is only one invalid union-case)
    TResult map<TResult extends Object?>({
      required TResult Function(${classInfo.valid} valid) valid,
      required TResult Function(${classInfo.invalid} invalid) invalid,
    }) {
      throw UnimplementedError();
    }
    
    ''');

    /// mapValidity method
    buffer.writeln('''
    /// Pattern matching for the two different union-cases of this ValueObject :
    /// valid and invalid.
    TResult mapValidity<TResult extends Object?>({
      required TResult Function(${classInfo.valid} valid) valid,
      required TResult Function(${classInfo.invalid} invalid) invalid,
    }) {
      return map(
        valid: valid,
        invalid: invalid,
      );
    }
    
    ''');

    /// copyWith method
    buffer.writeln('''
    /// Creates a clone of this MultiValueObject with the new specified values.
    ///
    /// The resulting MultiValueObject is totally independent from this 
    /// MultiValueObject. It is validated upon creation, and can be either valid
    /// or invalid.
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

  String get makeHolder {
    final buffer = StringBuffer();

    buffer.writeln('''
    class ${classInfo.holder} {
      
    ''');

    /// private constructor
    buffer.writeln('''
    const ${classInfo.holder}._(
      ${parametersTemplate.asNamed(optionality: Optionality.makeAllRequired).asLocal()}
      );

    ''');

    /// class members
    for (final param in parametersTemplate.allParameters) {
      buffer.writeln('final ${param.type} ${param.name};');
    }
    buffer.writeln('');

    /// verifyNullables method
    buffer.writeln('''
    /// If one of the nullable fields marked with `@NullFailure` is null, this
    /// holds a [ValueFailure] on the Left. Otherwise, holds the
    /// [ValidValueObject] on the Right.
    Either<${classInfo.valueFailure}, ${classInfo.valid}> verifyNullables() {

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

  String get makeValidValueObject {
    final buffer = StringBuffer();

    buffer.writeln('''
    class ${classInfo.valid} extends $className implements ValidValueObject {
    ''');

    /// private constructor
    buffer.writeln('''
    const ${classInfo.valid}._(
      ${parametersTemplate.asNamed(optionality: Optionality.makeAllRequired).asLocal()}
      ) : super._();

    ''');

    /// class members
    for (final param in parametersTemplate.allParameters) {
      final paramType =
          param.hasNullFailureAnnotation ? param.nonNullableType : param.type;

      buffer.writeln('''
      ${param.doc}
      final $paramType ${param.name};
      ''');
    }
    buffer.writeln('');

    /// map method
    buffer.writeln('''
    @override
    TResult map<TResult extends Object?>(
      {required TResult Function(${classInfo.valid} valid) valid,
      required TResult Function(${classInfo.invalid} invalid) invalid}) {
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

  String get makeInvalidValueObject {
    final buffer = StringBuffer();

    final invalidValueObjectParams = parametersTemplate.copyWith(
      namedParameters: [
        ...parametersTemplate.namedParameters,
        ExpandedParameter.empty(
            name: 'valueFailure', type: classInfo.valueFailure),
      ],
    );

    buffer.writeln('''
    class ${classInfo.invalid} extends $className implements InvalidValueObject<${classInfo.valueFailure}> {
    
    ''');

    /// private constructor
    final constructorParams = invalidValueObjectParams
        .asNamed(optionality: Optionality.makeAllRequired)
        .asLocal();

    buffer.writeln('''
    const ${classInfo.invalid}._($constructorParams) : super._();
    ''');

    /// class members
    buffer.writeln('''
    ${parametersTemplate.allParameters.map((param) => '''
    ${param.doc}
    final ${param.type} ${param.name};
    ''').join()}

    @override
    final ${classInfo.valueFailure} valueFailure;
    ''');

    /// failure getter
    buffer.writeln('''
    @override
    ${classInfo.valueFailure} get failure => valueFailure; 
    ''');

    /// map method
    buffer.writeln('''
    @override
    TResult map<TResult extends Object?>(
      {required TResult Function(${classInfo.valid} valid) valid,
      required TResult Function(${classInfo.invalid} invalid) invalid}) {
        return invalid(this);
    }
    ''');

    /// props getter
    buffer.writeln('''
    @override
    List<Object?> get props => [
         ${invalidValueObjectParams.allParameters.map((param) => '${param.name},').join()}
      ];
    ''');

    /// end
    buffer.writeln('}');

    return buffer.toString();
  }

  String get makeTester {
    final buffer = StringBuffer();

    buffer.writeln('''
    class ${className}Tester extends ValueObjectTester<${classInfo.valueFailure}, ${classInfo.invalid},
    ${classInfo.valid}, $className, ${classInfo.modddelInput}> {
    ''');

    /// constructor
    buffer.writeln('''
    const ${className}Tester({
      int maxSutDescriptionLength = $maxSutDescriptionLength,
      String isSanitizedGroupDescription = 'Should be sanitized',
      String isNotSanitizedGroupDescription = 'Should not be sanitized',
      String isValidGroupDescription = 'Should be a ${classInfo.valid}',
      String isInvalidValueGroupDescription =
          'Should be an ${classInfo.invalid} and hold the ${classInfo.valueFailure}',
    }) : super(
            maxSutDescriptionLength: maxSutDescriptionLength,
            isSanitizedGroupDescription: isSanitizedGroupDescription,
            isNotSanitizedGroupDescription: isNotSanitizedGroupDescription,
            isValidGroupDescription: isValidGroupDescription,
            isInvalidValueGroupDescription: isInvalidValueGroupDescription,
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
    String mapValidityParam(Parameter param, bool isNamed) {
      final paramName = param.name;
      final result = 'modddel.mapValidity('
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
