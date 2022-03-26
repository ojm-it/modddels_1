part of 'class_info.dart';

class ListEntityClassInfo extends _BaseEntityClassInfo with _ListClassInfo {
  ListEntityClassInfo._({
    required this.factoryConstructor,
    required this.parametersTemplate,
    required this.className,
    required this.ktListType,
    required this.listParameter,
  }) : super._();

  static Future<ListEntityClassInfo> create({
    required BuildStep buildStep,
    required String className,
    required ConstructorElement factoryConstructor,
  }) async {
    final parameterElements = factoryConstructor.parameters;

    final parametersTemplate = await ParametersTemplate.fromParameterElements(
        buildStep, parameterElements);

    final listParameter = parametersTemplate.allParameters.firstWhere(
      (element) => element.name == 'list',
      orElse: () => throw InvalidGenerationSourceError(
        'The factory constructor should have a parameter named "list"',
        element: factoryConstructor,
      ),
    );

    final listParameterType = listParameter.type;
    final regex = RegExp(r"^KtList<(.*)>$");
    final ktListType = regex.firstMatch(listParameterType)?.group(1);

    if (ktListType == null || ktListType.isEmpty || ktListType == 'dynamic') {
      throw InvalidGenerationSourceError(
        'The "list" parameter should be of type KtList<_modeltype_>, where "model_type" is the type of your model',
        element: listParameter.parameterElement,
      );
    }

    return ListEntityClassInfo._(
      factoryConstructor: factoryConstructor,
      parametersTemplate: parametersTemplate,
      className: className,
      listParameter: listParameter,
      ktListType: ktListType,
    );
  }

  @override
  final ConstructorElement factoryConstructor;

  @override
  final ParametersTemplate parametersTemplate;

  @override
  final String className;

  @override
  final Parameter listParameter;

  @override
  final String ktListType;

  @override
  void verifySourceErrors() {
    if (ktListType.endsWith('?')) {
      throw InvalidGenerationSourceError(
        'The generic type of the KtList should not be nullable',
        element: listParameter.parameterElement,
      );
    }
  }
}

class SizedListEntityClassInfo extends _BaseEntityClassInfo
    with _ListClassInfo, _SizedClassInfo {
  SizedListEntityClassInfo._({
    required this.factoryConstructor,
    required this.parametersTemplate,
    required this.className,
    required this.listParameter,
    required this.ktListType,
  }) : super._();

  static Future<SizedListEntityClassInfo> create({
    required BuildStep buildStep,
    required String className,
    required ConstructorElement factoryConstructor,
  }) async {
    final parameterElements = factoryConstructor.parameters;

    final parametersTemplate = await ParametersTemplate.fromParameterElements(
        buildStep, parameterElements);

    final listParameter = parametersTemplate.allParameters.firstWhere(
      (element) => element.name == 'list',
      orElse: () => throw InvalidGenerationSourceError(
        'The factory constructor should have a parameter named "list"',
        element: factoryConstructor,
      ),
    );

    final listParameterType = listParameter.type;
    final regex = RegExp(r"^KtList<(.*)>$");
    final ktListType = regex.firstMatch(listParameterType)?.group(1);

    if (ktListType == null || ktListType.isEmpty || ktListType == 'dynamic') {
      throw InvalidGenerationSourceError(
        'The "list" parameter should be of type KtList<_modeltype_>, where "model_type" is the type of your model',
        element: listParameter.parameterElement,
      );
    }

    return SizedListEntityClassInfo._(
      factoryConstructor: factoryConstructor,
      parametersTemplate: parametersTemplate,
      className: className,
      listParameter: listParameter,
      ktListType: ktListType,
    );
  }

  @override
  final ConstructorElement factoryConstructor;

  @override
  final ParametersTemplate parametersTemplate;

  @override
  final String className;

  @override
  final Parameter listParameter;

  @override
  final String ktListType;

  @override
  void verifySourceErrors() {
    if (ktListType.endsWith('?')) {
      throw InvalidGenerationSourceError(
        'The generic type of the KtList should not be nullable',
        element: listParameter.parameterElement,
      );
    }
  }
}

class ListGeneralEntityClassInfo extends _BaseEntityClassInfo
    with _ListClassInfo, _GeneralClassInfo {
  ListGeneralEntityClassInfo._({
    required this.factoryConstructor,
    required this.parametersTemplate,
    required this.className,
    required this.listParameter,
    required this.ktListType,
  }) : super._();

  static Future<ListGeneralEntityClassInfo> create({
    required BuildStep buildStep,
    required String className,
    required ConstructorElement factoryConstructor,
  }) async {
    final parameterElements = factoryConstructor.parameters;

    final parametersTemplate = await ParametersTemplate.fromParameterElements(
        buildStep, parameterElements);

    final listParameter = parametersTemplate.allParameters.firstWhere(
      (element) => element.name == 'list',
      orElse: () => throw InvalidGenerationSourceError(
        'The factory constructor should have a parameter named "list"',
        element: factoryConstructor,
      ),
    );

    final listParameterType = listParameter.type;
    final regex = RegExp(r"^KtList<(.*)>$");
    final ktListType = regex.firstMatch(listParameterType)?.group(1);

    if (ktListType == null || ktListType.isEmpty || ktListType == 'dynamic') {
      throw InvalidGenerationSourceError(
        'The "list" parameter should be of type KtList<_modeltype_>, where "model_type" is the type of your model',
        element: listParameter.parameterElement,
      );
    }

    return ListGeneralEntityClassInfo._(
      factoryConstructor: factoryConstructor,
      parametersTemplate: parametersTemplate,
      className: className,
      listParameter: listParameter,
      ktListType: ktListType,
    );
  }

  @override
  final ConstructorElement factoryConstructor;

  @override
  final ParametersTemplate parametersTemplate;

  @override
  final String className;

  @override
  final Parameter listParameter;

  @override
  final String ktListType;

  @override
  void verifySourceErrors() {
    if (ktListType.endsWith('?')) {
      throw InvalidGenerationSourceError(
        'The generic type of the KtList should not be nullable',
        element: listParameter.parameterElement,
      );
    }
  }
}

class SizedListGeneralEntityClassInfo extends _BaseEntityClassInfo
    with _ListClassInfo, _GeneralClassInfo, _SizedClassInfo {
  SizedListGeneralEntityClassInfo._({
    required this.factoryConstructor,
    required this.parametersTemplate,
    required this.className,
    required this.listParameter,
    required this.ktListType,
  }) : super._();

  static Future<SizedListGeneralEntityClassInfo> create({
    required BuildStep buildStep,
    required String className,
    required ConstructorElement factoryConstructor,
  }) async {
    final parameterElements = factoryConstructor.parameters;

    final parametersTemplate = await ParametersTemplate.fromParameterElements(
        buildStep, parameterElements);

    final listParameter = parametersTemplate.allParameters.firstWhere(
      (element) => element.name == 'list',
      orElse: () => throw InvalidGenerationSourceError(
        'The factory constructor should have a parameter named "list"',
        element: factoryConstructor,
      ),
    );

    final listParameterType = listParameter.type;
    final regex = RegExp(r"^KtList<(.*)>$");
    final ktListType = regex.firstMatch(listParameterType)?.group(1);

    if (ktListType == null || ktListType.isEmpty || ktListType == 'dynamic') {
      throw InvalidGenerationSourceError(
        'The "list" parameter should be of type KtList<_modeltype_>, where "model_type" is the type of your model',
        element: listParameter.parameterElement,
      );
    }

    return SizedListGeneralEntityClassInfo._(
      factoryConstructor: factoryConstructor,
      parametersTemplate: parametersTemplate,
      className: className,
      listParameter: listParameter,
      ktListType: ktListType,
    );
  }

  @override
  final ConstructorElement factoryConstructor;

  @override
  final ParametersTemplate parametersTemplate;

  @override
  final String className;

  @override
  final Parameter listParameter;

  @override
  final String ktListType;

  @override
  void verifySourceErrors() {
    if (ktListType.endsWith('?')) {
      throw InvalidGenerationSourceError(
        'The generic type of the KtList should not be nullable',
        element: listParameter.parameterElement,
      );
    }
  }
}
