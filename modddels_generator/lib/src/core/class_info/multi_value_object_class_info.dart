part of 'class_info.dart';

class MultiValueObjectClassInfo extends _BaseValueObjectClassInfo
    with _CopyWithClassInfo {
  MultiValueObjectClassInfo._({
    required this.factoryConstructor,
    required this.className,
    required this.parametersTemplate,
  }) : super._();

  static Future<MultiValueObjectClassInfo> create({
    required BuildStep buildStep,
    required String className,
    required ConstructorElement factoryConstructor,
  }) async {
    final parameterElements = factoryConstructor.parameters;

    final parametersTemplate = await ParametersTemplate.fromParameterElements(
        buildStep, parameterElements);

    return MultiValueObjectClassInfo._(
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

  /// The class name of the private class "_Holder".
  ///
  /// Example : '_NameHolder'
  String get holder => '_${className}Holder';

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

    for (final param in parametersTemplate.allParameters) {
      if (param.hasValidAnnotation ||
          param.hasInvalidAnnotation ||
          param.hasWithGetterAnnotation) {
        throw InvalidGenerationSourceError(
          'The @valid, @invalid and @withGetter annotations can\'t be used with '
          'a MultiValueObject.',
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
