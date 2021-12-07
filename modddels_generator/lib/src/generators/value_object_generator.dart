import 'package:analyzer/dart/element/element.dart';
import 'package:modddels_generator/src/utils.dart';
import 'package:source_gen/source_gen.dart';

class ValueObjectGenerator {
  ValueObjectGenerator(
      {required this.className, required this.factoryConstructor});

  final String className;
  final ConstructorElement factoryConstructor;

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

    return classBuffer.toString();
  }

  void makeMixin(StringBuffer classBuffer, ValueObjectClassInfo classInfo) {
    classBuffer.writeln('''
    mixin \$$className {
    ''');

    ///create method
    classBuffer.writeln('''
    static $className _create(${classInfo.valueType} input) {
      return _verifyValue(input).match(
        (l) => ${classInfo.invalidValueObject}._(failure: l),
        (r) => ${classInfo.validValueObject}._(value: r),
      );
    }
    
    ''');

    ///_verifyValue method
    classBuffer.writeln('''
    static Either<${classInfo.valueFailure}, ${classInfo.valueType}> _verifyValue(${classInfo.valueType} input) {
      final valueVerification = const $className._().validateValue(input);
      return valueVerification.toEither(() => input).swap();
    }

    ''');

    ///toBroadEitherNullable method
    classBuffer.writeln('''
    static Either<Failure, ${classInfo.validValueObject}?> toBroadEitherNullable(
      $className? nullableValueObject) =>
        optionOf(nullableValueObject)
          .match((t) => t.toBroadEither, () => right(null));

    ''');

    ///map method
    classBuffer.writeln('''
    TResult map<TResult extends Object?>({
      required TResult Function(${classInfo.validValueObject} valid) valid,
      required TResult Function(${classInfo.invalidValueObject} invalid) invalid,
    }) {
      throw UnimplementedError();
    }
    
    ''');

    ///mapValidity method
    classBuffer.writeln('''
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

    //End
    classBuffer.writeln('}');
  }

  void makeValidValueObject(
      StringBuffer classBuffer, ValueObjectClassInfo classInfo) {
    classBuffer.writeln('''
    class ${classInfo.validValueObject} extends $className implements ValidValueObject<${classInfo.valueType}> {
    ''');

    ///private constructor
    classBuffer.writeln('''
    const ${classInfo.validValueObject}._({required this.value}) : super._();
    
    ''');

    ///class members
    classBuffer.writeln('''
    @override
    final ${classInfo.valueType} value;

    ''');

    ///map method
    classBuffer.writeln('''
    @override
    TResult map<TResult extends Object?>(
      {required TResult Function(${classInfo.validValueObject} valid) valid,
      required TResult Function(${classInfo.invalidValueObject} invalid) invalid}) {
        return valid(this);
    }

    ''');

    ///allProps method
    classBuffer.writeln('''
    @override
    List<Object?> get allProps => [value];

    ''');

    ///end
    classBuffer.writeln('}');
  }

  void makeInvalidValueObject(
      StringBuffer classBuffer, ValueObjectClassInfo classInfo) {
    classBuffer.writeln('''
    class ${classInfo.invalidValueObject} extends $className
      implements InvalidValueObject<${classInfo.valueType}, ${classInfo.valueFailure}> {
    ''');

    ///private constructor
    classBuffer.writeln('''
    const ${classInfo.invalidValueObject}._({
      required this.failure,
    }) : super._();
    ''');

    ///class members
    classBuffer.writeln('''
    @override
    final ${classInfo.valueFailure} failure;
    ''');

    ///map method
    classBuffer.writeln('''
    @override
    TResult map<TResult extends Object?>(
      {required TResult Function(${classInfo.validValueObject} valid) valid,
      required TResult Function(${classInfo.invalidValueObject} invalid) invalid}) {
        return invalid(this);
    }
    ''');

    ///allProps method
    classBuffer.writeln('''
    @override
    List<Object?> get allProps => [failure];
    ''');

    ///end
    classBuffer.writeln('}');
  }
}
