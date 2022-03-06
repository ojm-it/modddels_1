import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:modddels_annotations/modddels.dart';
import 'package:modddels_generator/src/utils.dart';
import 'package:source_gen/source_gen.dart';

class NullableValueObjectGenerator {
  NullableValueObjectGenerator({
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

    final inputParameter = parameters.firstWhere(
      (element) => element.isPositional && element.name == 'input',
      orElse: () => throw InvalidGenerationSourceError(
        'The factory constructor should have a positional argument named "input"',
        element: factoryConstructor,
      ),
    );

    if (inputParameter.type.nullabilitySuffix != NullabilitySuffix.question) {
      throw InvalidGenerationSourceError(
        'The positional argument "input" should be nullable',
        element: inputParameter,
      );
    }

    final valueTypeName = inputParameter.type.toString();
    final nonNullValueTypeName =
        valueTypeName.substring(0, valueTypeName.length - 1);

    final classInfo = ValueObjectClassInfo(nonNullValueTypeName, className);

    final classBuffer = StringBuffer();

    makeMixin(classBuffer, classInfo);

    makeValidValueObject(classBuffer, classInfo);

    makeInvalidValueObject(classBuffer, classInfo);

    if (generateTester) {
      makeTester(classBuffer, classInfo);
    }

    return classBuffer.toString();
  }

  void makeMixin(StringBuffer classBuffer, ValueObjectClassInfo classInfo) {
    classBuffer.writeln('''
    mixin \$$className {
    ''');

    /// create method
    classBuffer.writeln('''
    static $className _create(${classInfo.valueType}? input) {
      /// 1. **Value Validation**
      return _verifyValue(input).match(
        (valueFailure) => ${classInfo.invalidValueObject}._(valueFailure: valueFailure),

        /// 2. **→ Validations passed**
        (validValue) => ${classInfo.validValueObject}._(value: validValue),
      );
    }
    
    ''');

    /// _verifyNullable method
    classBuffer.writeln('''
    /// If the value is null, this holds a [ValueFailure] on the Left returned by
    /// [NullableValueObject.nullFailure]. Otherwise, holds the non-null value on
    /// the right.
    static Either<${classInfo.valueFailure}, ${classInfo.valueType}> _verifyNullable(${classInfo.valueType}? input) {
      if (input == null) {
        return left(const $className._().nullFailure());
      }
      return right(input);
    }

    ''');

    /// _verifyValue method
    classBuffer.writeln('''
    /// If the value is invalid, this holds the [ValueFailure] on the Left.
    /// Otherwise, holds the value on the Right.
    static Either<${classInfo.valueFailure}, ${classInfo.valueType}> _verifyValue(${classInfo.valueType}? input) {
      final nullablesVerification = _verifyNullable(input);

      final valueVerification = nullablesVerification.flatMap((nonNullValue) =>
        const $className._()
            .validateValue(nonNullValue)
            .toEither(() => nonNullValue)
            .swap());

      return valueVerification;
    }

    ''');

    /// toBroadEitherNullable method
    classBuffer.writeln('''
    /// If [nullableValueObject] is null, returns `right(null)`.
    /// Otherwise, returns `nullableValueObject.toBroadEither`.
    static Either<Failure, ${classInfo.validValueObject}?> toBroadEitherNullable(
      $className? nullableValueObject) =>
        optionOf(nullableValueObject)
          .match((t) => t.toBroadEither, () => right(null));

    ''');

    /// map method
    classBuffer.writeln('''
    /// Same as [mapValidity] (because there is only one invalid union-case)
    TResult map<TResult extends Object?>({
      required TResult Function(${classInfo.validValueObject} valid) valid,
      required TResult Function(${classInfo.invalidValueObject} invalid) invalid,
    }) {
      throw UnimplementedError();
    }
    
    ''');

    /// mapValidity method
    classBuffer.writeln('''
    /// Pattern matching for the two different union-cases of this
    /// NullableValueObject : valid and invalid.
    TResult mapValidity<TResult extends Object?>({
      required TResult Function(${classInfo.validValueObject} valid) valid,
      required TResult Function(${classInfo.invalidValueObject} invalid) invalid,
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
      StringBuffer classBuffer, ValueObjectClassInfo classInfo) {
    classBuffer.writeln('''
    class ${classInfo.validValueObject} extends $className implements ValidValueObject<${classInfo.valueType}> {
    ''');

    /// private constructor
    classBuffer.writeln('''
    const ${classInfo.validValueObject}._({required this.value}) : super._();
    
    ''');

    /// class members
    classBuffer.writeln('''
    @override
    final ${classInfo.valueType} value;

    ''');

    /// map method
    classBuffer.writeln('''
    @override
    TResult map<TResult extends Object?>(
      {required TResult Function(${classInfo.validValueObject} valid) valid,
      required TResult Function(${classInfo.invalidValueObject} invalid) invalid}) {
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
      StringBuffer classBuffer, ValueObjectClassInfo classInfo) {
    classBuffer.writeln('''
    class ${classInfo.invalidValueObject} extends $className
      implements InvalidValueObject<${classInfo.valueType}?, ${classInfo.valueFailure}> {
    ''');

    /// private constructor
    classBuffer.writeln('''
    const ${classInfo.invalidValueObject}._({
      required this.valueFailure,
    }) : super._();
    ''');

    /// class members
    classBuffer.writeln('''
    @override
    final ${classInfo.valueFailure} valueFailure;

    @override
    ${classInfo.valueFailure} get failure => valueFailure; 
    ''');

    /// map method
    classBuffer.writeln('''
    @override
    TResult map<TResult extends Object?>(
      {required TResult Function(${classInfo.validValueObject} valid) valid,
      required TResult Function(${classInfo.invalidValueObject} invalid) invalid}) {
        return invalid(this);
    }
    ''');

    /// props getter
    classBuffer.writeln('''
    @override
    List<Object?> get props => [failure];
    ''');

    /// end
    classBuffer.writeln('}');
  }

  void makeTester(StringBuffer classBuffer, ValueObjectClassInfo classInfo) {
    classBuffer.writeln('''
    class ${className}Tester extends NullableValueObjectTester<${classInfo.valueType}, ${classInfo.valueFailure},
      ${classInfo.invalidValueObject}, ${classInfo.validValueObject}, $className> {
    ''');

    /// constructor
    classBuffer.writeln('''
    ${className}Tester({
      int maxSutDescriptionLength = $maxSutDescriptionLength,
      String isNotSanitizedGroupDescription = 'Should not be sanitized',
      String isInvalidGroupDescription =
          'Should be an ${classInfo.invalidValueObject} and hold the ${classInfo.valueFailure}',
      String isSanitizedGroupDescription = 'Should be sanitized',
      String isValidGroupDescription = 'Should be a ${classInfo.validValueObject}',
    }) : super(
            (input) =>  $className(input),
            maxSutDescriptionLength: maxSutDescriptionLength,
            isNotSanitizedGroupDescription: isNotSanitizedGroupDescription,
            isInvalidGroupDescription: isInvalidGroupDescription,
            isSanitizedGroupDescription: isSanitizedGroupDescription,
            isValidGroupDescription: isValidGroupDescription,
          );
    ''');

    /// end
    classBuffer.writeln('}');
  }
}
