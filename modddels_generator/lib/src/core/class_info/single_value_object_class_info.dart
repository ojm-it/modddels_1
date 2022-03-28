part of 'class_info.dart';

class SingleValueObjectClassInfo extends _BaseValueObjectClassInfo {
  SingleValueObjectClassInfo._({
    required this.factoryConstructor,
    required this.className,
    required this.parametersTemplate,
    required this.inputParameter,
  }) : super._();

  static Future<SingleValueObjectClassInfo> create({
    required BuildStep buildStep,
    required String className,
    required ConstructorElement factoryConstructor,
  }) async {
    final parameterElements = factoryConstructor.parameters;

    final parametersTemplate = await ParametersTemplate.fromParameterElements(
        buildStep, parameterElements);

    final inputParameter = parametersTemplate.allParameters.firstWhere(
      (element) => element.name == 'input',
      orElse: () => throw InvalidGenerationSourceError(
        'The factory constructor should have a parameter named "input"',
        element: factoryConstructor,
      ),
    );

    return SingleValueObjectClassInfo._(
      factoryConstructor: factoryConstructor,
      className: className,
      parametersTemplate: parametersTemplate,
      inputParameter: inputParameter,
    );
  }

  @override
  final ConstructorElement factoryConstructor;

  @override
  final String className;

  @override
  final ParametersTemplate parametersTemplate;

  /// The "input" parameter.
  final Parameter inputParameter;

  @override
  void verifySourceErrors() {
    if (inputParameter.type == 'dynamic') {
      throw InvalidGenerationSourceError(
        'The "input" parameter should have a valid type, and should not be dynamic. '
        'Consider using the @TypeName annotation to manually provide the type.',
        element: inputParameter.parameterElement,
      );
    }

    if (inputParameter.hasValidAnnotation ||
        inputParameter.hasInvalidAnnotation ||
        inputParameter.hasWithGetterAnnotation) {
      throw InvalidGenerationSourceError(
        'The @valid, @invalid and @withGetter annotations can\'t be used with '
        'a SingleValueObject.',
        element: inputParameter.parameterElement,
      );
    }

    if (inputParameter.hasNullFailureAnnotation && !inputParameter.isNullable) {
      throw InvalidGenerationSourceError(
        'The @NullFailure annotation can only be used with a nullable parameter.',
        element: inputParameter.parameterElement,
      );
    }
  }
}
