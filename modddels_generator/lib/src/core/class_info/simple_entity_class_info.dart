part of 'class_info.dart';

class SimpleEntityClassInfo extends _BaseEntityClassInfo
    with _CopyWithClassInfo {
  SimpleEntityClassInfo._({
    required this.factoryConstructor,
    required this.className,
    required this.parametersTemplate,
  }) : super._();

  static Future<SimpleEntityClassInfo> create({
    required BuildStep buildStep,
    required String className,
    required ConstructorElement factoryConstructor,
  }) async {
    final parameterElements = factoryConstructor.parameters;

    final parametersTemplate = await ParametersTemplate.fromParameterElements(
        buildStep, parameterElements);

    return SimpleEntityClassInfo._(
      factoryConstructor: factoryConstructor,
      className: className,
      parametersTemplate: parametersTemplate,
    );
  }

  @override
  final ConstructorElement factoryConstructor;

  @override
  final String className;

  @override
  final ParametersTemplate parametersTemplate;

  @override
  void verifySourceErrors() {
    if (parametersTemplate.allParameters.isEmpty) {
      throw InvalidGenerationSourceError(
        'The factory constructor should contain at least one parameter',
        element: factoryConstructor,
      );
    }

    for (final param in parametersTemplate.allParameters) {
      if (param.type == 'dynamic') {
        throw InvalidGenerationSourceError(
          'The parameters of the factory constructor should have valid types, and should not be dynamic.'
          'Consider using the @TypeName annotation to manually provide the type.',
          element: param.parameterElement,
        );
      }
    }

    /// TODO when adding the @dependency feature, don't forget to exclude
    /// the parameters annotated with it.
    if (parametersTemplate.allParameters
        .every((param) => param.hasValidAnnotation)) {
      throw InvalidGenerationSourceError(
        'A SimpleEntity can\'t have all its fields marked with @valid.',
        element: factoryConstructor,
      );
    }

    for (final param in parametersTemplate.allParameters) {
      if (param.hasValidAnnotation && param.hasInvalidAnnotation) {
        throw InvalidGenerationSourceError(
          'The @valid and @invalid annotations can\'t be used together on the same parameter.',
          element: param.parameterElement,
        );
      }
    }

    for (final param in parametersTemplate.allParameters) {
      if (param.hasInvalidAnnotation && !param.isNullable) {
        throw InvalidGenerationSourceError(
          'The @invalid annotation can only be used on nullable parameters.',
          element: param.parameterElement,
        );
      }
    }

    for (final param in parametersTemplate.allParameters) {
      if (param.hasWithGetterAnnotation) {
        throw InvalidGenerationSourceError(
          'The @withGetter annotation is reserved for General Entities, and is useless for Simple Entities.',
          element: param.parameterElement,
        );
      }
    }

    for (final param in parametersTemplate.allParameters) {
      if (param.hasNullFailureAnnotation) {
        throw InvalidGenerationSourceError(
          'The @NullFailure annotation can\'t be used with a SimpleEntity',
          element: param.parameterElement,
        );
      }
    }
  }
}
