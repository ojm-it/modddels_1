import 'package:analyzer/dart/element/element.dart';
import 'package:modddels_annotations/modddels.dart';
import 'package:modddels_generator/src/utils.dart';
import 'package:source_gen/source_gen.dart';

class ValueObjectGenerator {
  ValueObjectGenerator({
    required this.className,
    required this.factoryConstructor,
    required this.generateTester,
    required this.maxSutDescriptionLength,
  });

  final String className;
  final ConstructorElement factoryConstructor;

  /// See [ModddelAnnotation.generateTester]
  final bool generateTester;

  /// See [ModddelAnnotation.maxSutDescriptionLength]
  final int maxSutDescriptionLength;

  String generate() {
    final parameters = factoryConstructor.parameters;

    final inputParameter = parameters.firstWhere(
      (element) => element.isPositional && element.name == 'input',
      orElse: () => throw InvalidGenerationSourceError(
        'The factory constructor should have a positional argument named "input"',
        element: factoryConstructor,
      ),
    );

    final valueTypeName = inputParameter.type.toString();

    final classInfo = ValueObjectClassInfo(valueTypeName, className);

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
    static $className _create(${classInfo.valueType} input) {
      /// 1. **Value Validation**
      return _verifyValue(input).match(
        (valueFailure) => ${classInfo.invalidValueObject}._(valueFailure: valueFailure),

        /// 2. **→ Validations passed**
        (validValue) => ${classInfo.validValueObject}._(value: validValue),
      );
    }
    
    ''');

    /// _verifyValue method
    classBuffer.writeln('''
    /// If the value is invalid, this holds the [ValueFailure] on the Left.
    /// Otherwise, holds the value on the Right.
    static Either<${classInfo.valueFailure}, ${classInfo.valueType}> _verifyValue(${classInfo.valueType} input) {
      final valueVerification = const $className._().validateValue(input);
      return valueVerification.toEither(() => input).swap();
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
    /// Pattern matching for the two different union-cases of this ValueObject :
    /// valid and invalid.
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

    /// allProps method
    classBuffer.writeln('''
    @override
    List<Object?> get allProps => [value];

    ''');

    /// end
    classBuffer.writeln('}');
  }

  void makeInvalidValueObject(
      StringBuffer classBuffer, ValueObjectClassInfo classInfo) {
    classBuffer.writeln('''
    class ${classInfo.invalidValueObject} extends $className
      implements InvalidValueObject<${classInfo.valueType}, ${classInfo.valueFailure}> {
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

    /// allProps method
    classBuffer.writeln('''
    @override
    List<Object?> get allProps => [failure];
    ''');

    /// end
    classBuffer.writeln('}');
  }

  void makeTester(StringBuffer classBuffer, ValueObjectClassInfo classInfo) {
    classBuffer.writeln('''
    class ${className}Tester extends ValueObjectTester<${classInfo.valueType}, ${classInfo.valueFailure},
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
