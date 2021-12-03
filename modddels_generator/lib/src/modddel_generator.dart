import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:modddels_annotations/modddels_annotations.dart';
import 'package:modddels_generator/src/value_object_generator.dart';
import 'package:source_gen/source_gen.dart';

import 'general_entity_generator.dart';
import 'ktlist_general_entity_generator.dart';

enum Model {
  valueObject,
  generalEntity,
  ktListGeneralEntity,
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

    final superClass = classElement.allSupertypes;

    if (superClass.any((element) => element
        .getDisplayString(withNullability: false)
        .startsWith('ValueObject'))) {
      modelType = Model.valueObject;
    } else if (superClass.any((element) => element
        .getDisplayString(withNullability: false)
        .startsWith('KtListGeneralEntity'))) {
      modelType = Model.ktListGeneralEntity;
    } else if (superClass.any((element) => element
        .getDisplayString(withNullability: false)
        .startsWith('GeneralEntity'))) {
      modelType = Model.generalEntity;
    } else {
      throw InvalidGenerationSourceError(
        'Should either extend GeneralEntity, KtListGeneralEntity, or ValueObject',
        element: classElement,
      );
    }

    switch (modelType) {
      case Model.valueObject:
        return ValueObjectGenerator(
                className: className, factoryConstructor: factoryConstructor)
            .generate();
      case Model.ktListGeneralEntity:
        return KtListGeneralEntityGenerator(
                className: className, factoryConstructor: factoryConstructor)
            .generate();
      case Model.generalEntity:
        return GeneralEntityGenerator(
                className: className, factoryConstructor: factoryConstructor)
            .generate();
    }
  }
}
