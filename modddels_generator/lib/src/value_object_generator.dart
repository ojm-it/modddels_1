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
    classBuffer.writeln('mixin \$$className {');

    ///create method
    classBuffer
        .writeln('static $className _create(${classInfo.valueType} input) {');

    classBuffer.writeln('return const $className._()');
    classBuffer.writeln('.validateWithResult(input).match(');
    classBuffer
        .writeln('(l) => ${classInfo.invalidValueObject}._(failure: l),');
    classBuffer.writeln('(r) => ${classInfo.validValueObject}._(value: r),');
    classBuffer.writeln(');');

    classBuffer.writeln('}');

    ///toBroadEitherNullable method
    classBuffer.writeln(
        'static Either<Failure, ${classInfo.validValueObject}?> toBroadEitherNullable(');
    classBuffer.writeln(' $className? nullableValueObject) =>');
    classBuffer.writeln('optionOf(nullableValueObject)');
    classBuffer.writeln('.match((t) => t.toBroadEither, () => right(null));');

    ///match method
    classBuffer.writeln('TResult match<TResult extends Object?>(');
    classBuffer.writeln(
        '{required TResult Function(${classInfo.validValueObject} valid) valid,');
    classBuffer.writeln(
        'required TResult Function(${classInfo.invalidValueObject} invalid) invalid}) {');
    classBuffer.writeln('throw UnimplementedError();');
    classBuffer.writeln('}');

    //End
    classBuffer.writeln('}');
  }

  void makeValidValueObject(
      StringBuffer classBuffer, ValueObjectClassInfo classInfo) {
    classBuffer.writeln(
        'class ${classInfo.validValueObject} extends $className implements ValidValueObject<${classInfo.valueType}> {');
    classBuffer.writeln(
        'const ${classInfo.validValueObject}._({required this.value}) : super._();');

    classBuffer.writeln('@override');
    classBuffer.writeln('final ${classInfo.valueType} value;');

    classBuffer.writeln('@override');
    classBuffer.writeln('TResult match<TResult extends Object?>(');
    classBuffer.writeln(
        '{required TResult Function(${classInfo.validValueObject} valid) valid,');
    classBuffer.writeln(
        'required TResult Function(${classInfo.invalidValueObject} invalid) invalid}) {');
    classBuffer.writeln('return valid(this);');
    classBuffer.writeln('}');

    classBuffer.writeln('@override');
    classBuffer.writeln('List<Object?> get allProps => [value];');

    classBuffer.writeln('}');
  }

  void makeInvalidValueObject(
      StringBuffer classBuffer, ValueObjectClassInfo classInfo) {
    classBuffer
        .writeln('class ${classInfo.invalidValueObject} extends $className');
    classBuffer.writeln(
        'implements InvalidValueObject<${classInfo.valueType}, ${classInfo.valueFailure}> {');
    classBuffer.writeln('const ${classInfo.invalidValueObject}._({');
    classBuffer.writeln('required this.failure,');
    classBuffer.writeln('}) : super._();');

    classBuffer.writeln('@override');
    classBuffer.writeln('final ${classInfo.valueFailure} failure;');

    ///match method
    classBuffer.writeln('@override');
    classBuffer.writeln('TResult match<TResult extends Object?>(');
    classBuffer.writeln(
        '{required TResult Function(${classInfo.validValueObject} valid) valid,');
    classBuffer.writeln(
        'required TResult Function(${classInfo.invalidValueObject} invalid) invalid}) {');
    classBuffer.writeln('return invalid(this);');
    classBuffer.writeln('}');

    ///allProps method
    classBuffer.writeln('@override');
    classBuffer.writeln('List<Object?> get allProps => [failure];');

    classBuffer.writeln('}');
  }
}
