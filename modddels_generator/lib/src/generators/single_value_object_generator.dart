import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:modddels_annotations/modddels.dart';
import 'package:modddels_generator/src/core/class_info.dart';
import 'package:source_gen/source_gen.dart';

class SingleValueObjectGenerator {
  SingleValueObjectGenerator({
    required this.buildStep,
    required this.className,
    required this.factoryConstructor,
    required this.generateTester,
    required this.maxSutDescriptionLength,
    required this.stringifyMode,
  });

  final BuildStep buildStep;

  final String className;

  final ConstructorElement factoryConstructor;

  /// See [ModddelAnnotation.generateTester]
  final bool generateTester;

  /// See [ModddelAnnotation.maxSutDescriptionLength]
  final int maxSutDescriptionLength;

  /// See [ModddelAnnotation.stringifyMode]
  final StringifyMode stringifyMode;

  Future<String> generate() async {
    final parameters = factoryConstructor.parameters;

    final inputParameterElement = parameters.firstWhere(
      (element) => element.isPositional && element.name == 'input',
      orElse: () => throw InvalidGenerationSourceError(
        'The factory constructor should have a positional argument named "input"',
        element: factoryConstructor,
      ),
    );

    final classInfo = await SingleValueObjectClassInfo.create(
      buildStep: buildStep,
      className: className,
      inputParameterElement: inputParameterElement,
    );

    if (classInfo.inputParameter.type == 'dynamic') {
      throw InvalidGenerationSourceError(
        'The "input" parameter should have a valid type, and should not be dynamic. '
        'Consider using the @TypeName annotation to manually provide the type.',
        element: classInfo.inputParameter.parameterElement,
      );
    }

    if (classInfo.inputParameter.hasValidAnnotation ||
        classInfo.inputParameter.hasInvalidAnnotation ||
        classInfo.inputParameter.hasWithGetterAnnotation) {
      throw InvalidGenerationSourceError(
        'The @valid, @invalid and @withGetter annotations can\'t be used with '
        'a SingleValueObject.',
        element: classInfo.inputParameter.parameterElement,
      );
    }

    if (classInfo.inputParameter.hasNullFailureAnnotation &&
        !classInfo.inputParameter.isNullable) {
      throw InvalidGenerationSourceError(
        'The @NullFailure annotation can only be used with a nullable parameter.',
        element: classInfo.inputParameter.parameterElement,
      );
    }

    final classBuffer = StringBuffer();

    makeMixin(classBuffer, classInfo);

    makeValidValueObject(classBuffer, classInfo);

    makeInvalidValueObject(classBuffer, classInfo);

    if (generateTester) {
      makeTester(classBuffer, classInfo);

      makeModddelInput(classBuffer, classInfo);
    }

    return classBuffer.toString();
  }

  void makeMixin(
      StringBuffer classBuffer, SingleValueObjectClassInfo classInfo) {
    classBuffer.writeln('''
    mixin \$$className {
    ''');

    /// create method
    classBuffer.writeln('''
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

    classBuffer.writeln('''
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
    classBuffer.writeln('''
    /// If the value is marked with `@NullFailure` and it's null, this holds a
    /// [ValueFailure] on the Left. Otherwise, holds the non-nullable value on the
    /// Right.
    static Either<${classInfo.valueFailure}, $paramType> _verifyNullable(${classInfo.inputParameter.type} input) {
    ''');

    if (classInfo.inputParameter.hasNullFailureAnnotation) {
      classBuffer.writeln('''
      if (input == null) {
        return left(${classInfo.inputParameter.nullFailureString});
      }
      ''');
    }

    classBuffer.writeln('''
      return right(input);
    }
    ''');

    /// toBroadEitherNullable method
    classBuffer.writeln('''
    /// If [nullableValueObject] is null, returns `right(null)`.
    /// Otherwise, returns `nullableValueObject.toBroadEither`.
    static Either<Failure, ${classInfo.valid}?> toBroadEitherNullable(
      $className? nullableValueObject) =>
        optionOf(nullableValueObject)
          .match((t) => t.toBroadEither, () => right(null));

    ''');

    /// map method
    classBuffer.writeln('''
    /// Same as [mapValidity] (because there is only one invalid union-case)
    TResult map<TResult extends Object?>({
      required TResult Function(${classInfo.valid} valid) valid,
      required TResult Function(${classInfo.invalid} invalid) invalid,
    }) {
      throw UnimplementedError();
    }
    
    ''');

    /// mapValidity method
    classBuffer.writeln('''
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
    classBuffer.writeln('''
    List<Object?> get props => throw UnimplementedError();

    StringifyMode get stringifyMode => ${stringifyMode.toString()};
    ''');

    /// End
    classBuffer.writeln('}');
  }

  void makeValidValueObject(
      StringBuffer classBuffer, SingleValueObjectClassInfo classInfo) {
    classBuffer.writeln('''
    class ${classInfo.valid} extends $className implements ValidSingleValueObject<${classInfo.inputParameter.type}> {
    ''');

    /// private constructor
    classBuffer.writeln('''
    const ${classInfo.valid}._({required this.value}) : super._();
    
    ''');

    /// class members
    final paramType = classInfo.inputParameter.hasNullFailureAnnotation
        ? classInfo.inputParameter.nonNullableType
        : classInfo.inputParameter.type;

    classBuffer.writeln('''
    @override
    final $paramType value;

    ''');

    /// map method
    classBuffer.writeln('''
    @override
    TResult map<TResult extends Object?>(
      {required TResult Function(${classInfo.valid} valid) valid,
      required TResult Function(${classInfo.invalid} invalid) invalid}) {
        return valid(this);
    }

    ''');

    /// props getter
    classBuffer.writeln('''
    @override
    List<Object?> get props => [value];

    ''');

    /// end
    classBuffer.writeln('}');
  }

  void makeInvalidValueObject(
      StringBuffer classBuffer, SingleValueObjectClassInfo classInfo) {
    classBuffer.writeln('''
    class ${classInfo.invalid} extends $className
      implements InvalidSingleValueObject<${classInfo.inputParameter.type}, ${classInfo.valueFailure}> {
    ''');

    /// private constructor
    classBuffer.writeln('''
    const ${classInfo.invalid}._({
      required this.valueFailure,
      required this.failedValue,
    }) : super._();
    ''');

    /// class members
    classBuffer.writeln('''
    @override
    final ${classInfo.valueFailure} valueFailure;

    @override
    final ${classInfo.inputParameter.type} failedValue;

    @override
    ${classInfo.valueFailure} get failure => valueFailure; 
    ''');

    /// map method
    classBuffer.writeln('''
    @override
    TResult map<TResult extends Object?>(
      {required TResult Function(${classInfo.valid} valid) valid,
      required TResult Function(${classInfo.invalid} invalid) invalid}) {
        return invalid(this);
    }
    ''');

    /// props getter
    classBuffer.writeln('''
    @override
    List<Object?> get props => [valueFailure, failedValue];
    ''');

    /// end
    classBuffer.writeln('}');
  }

  void makeTester(
      StringBuffer classBuffer, SingleValueObjectClassInfo classInfo) {
    classBuffer.writeln('''
    class ${className}Tester extends ValueObjectTester<${classInfo.valueFailure}, ${classInfo.invalid},
    ${classInfo.valid}, $className, ${classInfo.modddelInput}> {
    ''');

    /// constructor
    classBuffer.writeln('''
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
    classBuffer.writeln('''
    final makeInput = ${classInfo.modddelInput}.new;
    ''');

    /// end
    classBuffer.writeln('}');
  }

  void makeModddelInput(
      StringBuffer classBuffer, SingleValueObjectClassInfo classInfo) {
    classBuffer.writeln('''
    class ${classInfo.modddelInput} extends ModddelInput<$className> {
    ''');

    /// constructor
    classBuffer.writeln('''
    const ${classInfo.modddelInput}(this.input);
    ''');

    /// class members
    classBuffer.writeln('''
    final ${classInfo.inputParameter.type} input;
    ''');

    /// props method
    classBuffer.writeln('''
    @override
    List<Object?> get props => [input];
    ''');

    /// sanitizedInput method
    classBuffer.writeln('''
    @override
    ${classInfo.modddelInput} get sanitizedInput {
      final modddel = $className(input);
      final modddelValue = modddel.mapValidity(
          valid: (v) => v.value, invalid: (i) => i.failedValue);

      return ${classInfo.modddelInput}(modddelValue);
    }
    ''');

    /// end
    classBuffer.writeln('}');
  }
}
