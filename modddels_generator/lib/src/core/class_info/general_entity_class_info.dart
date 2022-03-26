part of 'class_info.dart';

class GeneralEntityClassInfo extends _BaseEntityClassInfo
    with _GeneralClassInfo, _CopyWithClassInfo {
  GeneralEntityClassInfo._({
    required this.factoryConstructor,
    required this.className,
    required this.parametersTemplate,
  }) : super._();

  static Future<GeneralEntityClassInfo> create({
    required BuildStep buildStep,
    required String className,
    required ConstructorElement factoryConstructor,
  }) async {
    final parameterElements = factoryConstructor.parameters;

    final parametersTemplate = await ParametersTemplate.fromParameterElements(
      buildStep,
      parameterElements,
    );

    return GeneralEntityClassInfo._(
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

  /// The class name of the private class "_ValidContent".
  ///
  /// Example : '_ValidUserContent'
  String get validContent => '_Valid${className}Content';

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
          'The parameters of the factory constructor should have valid types, and should not be dynamic. '
          'Consider using the @TypeName annotation to manually provide the type.',
          element: param.parameterElement,
        );
      }
    }

    if (parametersTemplate.allParameters
        .every((param) => param.hasValidAnnotation)) {
      throw InvalidGenerationSourceError(
        'A GeneralEntity can\'t have all its fields marked with @valid.',
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
      if (param.hasInvalidAnnotation && param.hasNullFailureAnnotation) {
        throw InvalidGenerationSourceError(
          'The @invalid and @NullFailure annotations can\'t be used together on the same parameter.',
          element: param.parameterElement,
        );
      }
    }

    for (final param in parametersTemplate.allParameters) {
      if (param.hasNullFailureAnnotation && !param.isNullable) {
        throw InvalidGenerationSourceError(
          'The @NullFailure annotation can only be used with nullable parameters.',
          element: param.parameterElement,
        );
      }
    }
  }
}
