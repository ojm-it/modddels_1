import 'package:analyzer/dart/element/element.dart';
import 'package:modddels_generator/src/utils.dart';
import 'package:source_gen/source_gen.dart';

class ValueObjectGenerator {
  ValueObjectGenerator(
      {required this.className, required this.factoryConstructor});

  final String className;
  ConstructorElement factoryConstructor;

  String generate() {
    final parameters = factoryConstructor.parameters;

    print(parameters.map((e) => e.name));

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

    // 8
    // for (final field in visitor.fields.keys) {
    //   // remove '_' from private variables
    //   final variable =
    //       field.startsWith('_') ? field.replaceFirst('_', '') : field;

    //   classBuffer.writeln("variables['${variable}'] = super.$field;");
    //   // EX: variables['name'] = super._name;
    // }

    // 9

    // 10
    // generateGettersAndSetters(visitor, classBuffer);

    // 11

    // 12
    return classBuffer.toString();
  }

  void makeMixin(StringBuffer classBuffer, ValueObjectClassInfo classInfo) {
    classBuffer.writeln('mixin _\$$className {');

    ///Create method
    classBuffer.writeln(
        'static $className create(${classInfo.valueTypeName} input) {');

    classBuffer.writeln('return const $className._()');
    classBuffer.writeln('.validateWithResult(input).match(');
    classBuffer
        .writeln('(l) => ${classInfo.invalidValueObjectName}._(failure: l),');
    classBuffer
        .writeln('(r) => ${classInfo.validValueObjectName}._(value: r),');
    classBuffer.writeln(');');

    classBuffer.writeln('}');

    ///Match method
    classBuffer.writeln('TResult match<TResult extends Object?>(');
    classBuffer.writeln(
        '{required TResult Function(${classInfo.validValueObjectName} value) valid,');
    classBuffer.writeln(
        'required TResult Function(${classInfo.invalidValueObjectName} value) invalid}) {');
    classBuffer.writeln('throw UnimplementedError();');
    classBuffer.writeln('}');

    classBuffer.writeln('}');
  }
}
