import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:modddels_annotations/modddels_annotations.dart';
import 'package:modddels_generator/src/value_object_generator.dart';
import 'package:source_gen/source_gen.dart';

import 'entity_generator.dart';
import 'ktlist_entity_generator.dart';

enum Model {
  valueObject,
  entity,
  ktListEntity,
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

    // ignore: unused_local_variable
    final privateConstructor = constructors.firstWhere(
      (element) => !element.isFactory && element.isPrivate,
      orElse: () => throw InvalidGenerationSourceError(
        'Missing private constructor',
        element: element,
      ),
    );

    Model modelType;

    final superClass = classElement.allSupertypes;

    if (superClass.any((element) => element
        .getDisplayString(withNullability: false)
        .startsWith('ValueObject'))) {
      modelType = Model.valueObject;
    } else if (superClass.any((element) => element
        .getDisplayString(withNullability: false)
        .startsWith('KtListEntity'))) {
      modelType = Model.ktListEntity;
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
      case Model.ktListEntity:
        return KtListEntityGenerator(
                className: className, factoryConstructor: factoryConstructor)
            .generate();
      case Model.entity:
        return EntityGenerator(
                className: className, factoryConstructor: factoryConstructor)
            .generate();
    }
  }
}
