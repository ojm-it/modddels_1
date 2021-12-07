import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:modddels_annotations/modddels_annotations.dart';
import 'package:modddels_generator/src/generators/simple_entity_generator.dart';
import 'package:modddels_generator/src/generators/general_entity_generator.dart';
import 'package:modddels_generator/src/generators/list_entity_generator.dart';
import 'package:modddels_generator/src/generators/list_general_entity_generator.dart';
import 'package:modddels_generator/src/generators/sized_list_general_entity_generator.dart';
import 'package:modddels_generator/src/generators/value_object_generator.dart';
import 'package:source_gen/source_gen.dart';

import 'generators/sized_list_entity_generator.dart';

enum Model {
  valueObject,
  simpleEntity,
  listEntity,
  sizedListEntity,
  generalEntity,
  listGeneralEntity,
  sizedListGeneralEntity,
}

class ModddelGenerator extends GeneratorForAnnotation<ModddelAnnotation> {
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

    final constructors = classElement.constructors;

    if (constructors.length < 2) {
      throw InvalidGenerationSourceError(
        'Missing constructors',
        element: classElement,
      );
    }

    final factoryConstructor = constructors.firstWhere(
      (element) => element.isFactory,
      orElse: () => throw InvalidGenerationSourceError(
        'Missing factory constructor',
        element: classElement,
      ),
    );

    // ignore: unused_local_variable
    final privateConstructor = constructors.firstWhere(
      (element) => !element.isFactory && element.isPrivate,
      orElse: () => throw InvalidGenerationSourceError(
        'Missing private constructor',
        element: classElement,
      ),
    );

    Model modelType;

    final superClassNameFullName =
        classElement.supertype?.getDisplayString(withNullability: false);

    final regex = RegExp(r"^([^\s<>]*)(<.*>)?$");

    final superClassName = superClassNameFullName == null
        ? null
        : regex.firstMatch(superClassNameFullName)?.group(1);

    if (superClassName == null) {
      throw InvalidGenerationSourceError(
        'Should extend a Modddel',
        element: classElement,
      );
    }
    if (superClassName == 'ValueObject') {
      modelType = Model.valueObject;
    } else if (superClassName == 'ListGeneralEntity') {
      modelType = Model.listGeneralEntity;
    } else if (superClassName == 'SizedListGeneralEntity') {
      modelType = Model.sizedListGeneralEntity;
    } else if (superClassName == 'GeneralEntity') {
      modelType = Model.generalEntity;
    } else if (superClassName == 'ListEntity') {
      modelType = Model.listEntity;
    } else if (superClassName == 'SizedListEntity') {
      modelType = Model.sizedListEntity;
    } else if (superClassName == 'SimpleEntity') {
      modelType = Model.simpleEntity;
    } else {
      throw InvalidGenerationSourceError(
        'Should extend a Modddel',
        element: classElement,
      );
    }

    switch (modelType) {
      case Model.valueObject:
        return ValueObjectGenerator(
                className: className, factoryConstructor: factoryConstructor)
            .generate();
      case Model.listGeneralEntity:
        return ListGeneralEntityGenerator(
                className: className, factoryConstructor: factoryConstructor)
            .generate();
      case Model.sizedListGeneralEntity:
        return SizedListGeneralEntityGenerator(
                className: className, factoryConstructor: factoryConstructor)
            .generate();
      case Model.generalEntity:
        return GeneralEntityGenerator(
                className: className, factoryConstructor: factoryConstructor)
            .generate();
      case Model.simpleEntity:
        return SimpleEntityGenerator(
                className: className, factoryConstructor: factoryConstructor)
            .generate();
      case Model.listEntity:
        return ListEntityGenerator(
                className: className, factoryConstructor: factoryConstructor)
            .generate();
      case Model.sizedListEntity:
        return SizedListEntityGenerator(
                className: className, factoryConstructor: factoryConstructor)
            .generate();
    }
  }
}
