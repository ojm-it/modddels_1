import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:modddels_annotations/modddels_annotations.dart';
import 'package:modddels_generator/src/value_object_generator.dart';
import 'package:source_gen/source_gen.dart';

import 'model_visitor.dart';

enum Model {
  valueObject,
  entity,
}

class ModddelGenerator extends GeneratorForAnnotation<ModddelAnnotation> {
// 1

  @override
  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        '@modddel can only be applied on classes. Failing element: ${element.name}',
        element: element,
      );
    }

    final ClassElement classElement = element;

    final className = classElement.name;

    print(className);

    // final visitor = ModelVisitor();
    // element.visitChildren(
    //     visitor); // Visits all the children of element in no particular order.

    final constructors = classElement.constructors;

    print(constructors.map((e) =>
        '${e.displayName} - ${e.isDefaultConstructor} - ${e.isPrivate}'));

    if (constructors.length < 2) {
      throw InvalidGenerationSourceError(
        'Missing constructors',
        element: element,
      );
    }

    final factoryConstructor = constructors.firstWhere(
      (element) => element.isFactory,
      orElse: () => throw InvalidGenerationSourceError(
        'Missing factory constructor',
        element: element,
      ),
    );

    print(factoryConstructor.displayName);

    final privateConstructor = constructors.firstWhere(
      (element) => !element.isFactory && element.isPrivate,
      orElse: () => throw InvalidGenerationSourceError(
        'Missing private constructor',
        element: element,
      ),
    );

    print(privateConstructor.displayName);

    Model modelType;

    final superClass = classElement.allSupertypes;

    if (superClass.any((element) => element
        .getDisplayString(withNullability: false)
        .startsWith('ValueObject'))) {
      modelType = Model.valueObject;
    } else if (superClass.any((element) => element
        .getDisplayString(withNullability: false)
        .startsWith('Entity'))) {
      modelType = Model.entity;
    } else {
      throw InvalidGenerationSourceError(
        'Should either extend Entity or ValueObject',
        element: element,
      );
    }

    switch (modelType) {
      case Model.valueObject:
        return ValueObjectGenerator(
                className: className, factoryConstructor: factoryConstructor)
            .generate();
      case Model.entity:
        //TODO replace with entityGenerator
        return ValueObjectGenerator(
                className: className, factoryConstructor: factoryConstructor)
            .generate();
    }
  }

  void generateGettersAndSetters(
      ModelVisitor visitor, StringBuffer classBuffer) {
// 1
    for (final field in visitor.fields.keys) {
      // 2
      final variable =
          field.startsWith('_') ? field.replaceFirst('_', '') : field;

      // 3
      classBuffer.writeln(
          "${visitor.fields[field]} get $variable => variables['$variable'];");
      // EX: String get name => variables['name'];

      // 4
      classBuffer
          .writeln('set $variable(${visitor.fields[field]} $variable) {');
      classBuffer.writeln('super.$field = $variable;');
      classBuffer.writeln("variables['$variable'] = $variable;");
      classBuffer.writeln('}');

      // EX: set name(String name) {
      //       super._name = name;
      //       variables['name'] = name;
      //     }
    }
  }
}
