import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:modddels_annotations/modddels.dart';
import 'package:modddels_generator/src/core/class_info/class_info.dart';
import 'package:modddels_generator/src/core/templates/parameters_template.dart';

class SingleValueObjectGenerator {
  SingleValueObjectGenerator._({
    required this.classInfo,
    required this.generateTester,
    required this.maxSutDescriptionLength,
    required this.stringifyMode,
  });

  static Future<SingleValueObjectGenerator> create({
    required BuildStep buildStep,
    required String className,
    required ConstructorElement factoryConstructor,
    required bool generateTester,
    required int maxSutDescriptionLength,
    required StringifyMode stringifyMode,
  }) async {
    final classInfo = await SingleValueObjectClassInfo.create(
      buildStep: buildStep,
      className: className,
      factoryConstructor: factoryConstructor,
    );

    return SingleValueObjectGenerator._(
      classInfo: classInfo,
      generateTester: generateTester,
      maxSutDescriptionLength: maxSutDescriptionLength,
      stringifyMode: stringifyMode,
    );
  }

  final SingleValueObjectClassInfo classInfo;

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
    static $className _create(${classInfo.inputParameter.type} input) {
      /// 1. **Value Validation**
      return _verifyValue(input).match(
        (valueFailure) => ${classInfo.invalid}._(
          valueFailure: valueFailure,
          failedValue: input,
        ),

        /// 2. **→ Validations passed**
        (validValue) => ${classInfo.valid}._(value: validValue),
      );
    }
    
    ''');

    /// _verifyValue method

    final paramType = classInfo.inputParameter.hasNullFailureAnnotation
        ? classInfo.inputParameter.nonNullableType
        : classInfo.inputParameter.type;

    buffer.writeln('''
    /// If the value is invalid, this holds the [ValueFailure] on the Left.
    /// Otherwise, holds the value on the Right.
    static Either<${classInfo.valueFailure}, $paramType> _verifyValue(${classInfo.inputParameter.type} input) {
      final nullableVerification = _verifyNullable(input);

      final valueVerification = nullableVerification.flatMap((nonNullableInput) =>
        const $className._()
            .validateValue(${classInfo.valid}._(value: nonNullableInput))
            .toEither(() => nonNullableInput)
            .swap());

      return valueVerification;
    }

    ''');

    /// _verifyNullable method
    buffer.writeln('''
    /// If the value is marked with `@NullFailure` and it's null, this holds a
    /// [ValueFailure] on the Left. Otherwise, holds the non-nullable value on the
    /// Right.
    static Either<${classInfo.valueFailure}, $paramType> _verifyNullable(${classInfo.inputParameter.type} input) {
    ''');

    if (classInfo.inputParameter.hasNullFailureAnnotation) {
      buffer.writeln('''
      if (input == null) {
        return left(${classInfo.inputParameter.nullFailureString});
      }
      ''');
    }

    buffer.writeln('''
      return right(input);
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

    /// props and stringifyMode getters
    buffer.writeln('''
    List<Object?> get props => throw UnimplementedError();

    StringifyMode get stringifyMode => ${stringifyMode.toString()};
    ''');

    /// End
    buffer.writeln('}');

    return buffer.toString();
  }

  String get makeValidValueObject {
    final buffer = StringBuffer();

    buffer.writeln('''
    class ${classInfo.valid} extends $className implements ValidSingleValueObject<${classInfo.inputParameter.type}> {
    ''');

    /// private constructor
    buffer.writeln('''
    const ${classInfo.valid}._({required this.value}) : super._();
    
    ''');

    /// class members
    final paramType = classInfo.inputParameter.hasNullFailureAnnotation
        ? classInfo.inputParameter.nonNullableType
        : classInfo.inputParameter.type;

    buffer.writeln('''
    @override
    final $paramType value;

    ''');

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
    List<Object?> get props => [value];

    ''');

    /// end
    buffer.writeln('}');

    return buffer.toString();
  }

  String get makeInvalidValueObject {
    final buffer = StringBuffer();

    buffer.writeln('''
    class ${classInfo.invalid} extends $className
      implements InvalidSingleValueObject<${classInfo.inputParameter.type}, ${classInfo.valueFailure}> {
    ''');

    /// private constructor
    buffer.writeln('''
    const ${classInfo.invalid}._({
      required this.valueFailure,
      required this.failedValue,
    }) : super._();
    ''');

    /// class members
    buffer.writeln('''
    @override
    final ${classInfo.valueFailure} valueFailure;

    @override
    final ${classInfo.inputParameter.type} failedValue;

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
    List<Object?> get props => [valueFailure, failedValue];
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
    const ${classInfo.modddelInput}(this.input);
    ''');

    /// class members
    buffer.writeln('''
    final ${classInfo.inputParameter.type} input;
    ''');

    /// props method
    buffer.writeln('''
    @override
    List<Object?> get props => [input];
    ''');

    /// sanitizedInput method
    buffer.writeln('''
    @override
    ${classInfo.modddelInput} get sanitizedInput {
      final modddel = $className(input);
      final modddelValue = modddel.mapValidity(
          valid: (v) => v.value, invalid: (i) => i.failedValue);

      return ${classInfo.modddelInput}(modddelValue);
    }
    ''');

    /// end
    buffer.writeln('}');

    return buffer.toString();
  }
}
