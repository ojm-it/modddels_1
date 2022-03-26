import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';

import 'package:modddels_generator/src/core/templates/parameter.dart';

enum Optionality {
  keepSame,
  makeAllRequired,
  makeAllOptional,
}

/// The [ParametersTemplate] is a template that represents the parameters of a
/// constructor or a function.
///
/// The parameters can either be :
/// - (A) All [ExpandedParameter]s with [ExpandedParameter.showDefaultValue] set
///   to false. **This is the default.**
/// - (B) All [ExpandedParameter]s with [ExpandedParameter.showDefaultValue] set
///   to true.
/// - (C) All [LocalParameter]s.
///
/// Example :
///
/// ```dart
/// // The part between parenthesis is the template part.
///
/// // (A)
/// void sayHello(String name, {int? intensity});
///
/// // (B)
/// void sayHello(String name, {int? intensity = 0,})
///
/// // (C)
/// const Hello(this.name,{this.intensity = 0,})
/// ```
///

class ParametersTemplate {
  ParametersTemplate._(
    this.requiredPositionalParameters, {
    this.optionalPositionalParameters = const [],
    this.namedParameters = const [],
  });

  /// By default : The Parameters template is made of [ExpandedParameter]s,
  /// with [ExpandedParameter.showDefaultValue] set to false.
  static Future<ParametersTemplate> fromParameterElements(
      BuildStep buildStep, List<ParameterElement> parameters) async {
    Future<Parameter> asParameter(ParameterElement e) async {
      return await ExpandedParameter.fromParameterElement(
        buildStep: buildStep,
        parameterElement: e,
        showDefaultValue: false,
      );
    }

    return ParametersTemplate._(
      await Future.wait(
        parameters.where((p) => p.isRequiredPositional).map(asParameter),
      ),
      optionalPositionalParameters: await Future.wait(
        parameters.where((p) => p.isOptionalPositional).map(asParameter),
      ),
      namedParameters: await Future.wait(
        parameters.where((p) => p.isNamed).map(asParameter),
      ),
    );
  }

  final List<Parameter> requiredPositionalParameters;
  final List<Parameter> optionalPositionalParameters;
  final List<Parameter> namedParameters;

  /// The list of all the positional parameters (required and optional)
  List<Parameter> get allPositionalParameters => [
        ...requiredPositionalParameters,
        ...optionalPositionalParameters,
      ];

  /// The list of all the parameters
  List<Parameter> get allParameters => [
        ...requiredPositionalParameters,
        ...optionalPositionalParameters,
        ...namedParameters,
      ];

  /// Returns a [ParametersTemplate] where all the parameters are converted
  /// to [LocalParameter]s.
  ParametersTemplate asLocal() {
    List<Parameter> asLocal(List<Parameter> parameters) {
      return parameters.map((e) => e.toLocalParameter()).toList();
    }

    return ParametersTemplate._(
      asLocal(requiredPositionalParameters),
      optionalPositionalParameters: asLocal(optionalPositionalParameters),
      namedParameters: asLocal(namedParameters),
    );
  }

  /// Returns a [ParametersTemplate] where all the parameters are converted
  /// to [ExpandedParameter]s.
  ParametersTemplate asExpanded({bool showDefaultValue = false}) {
    List<Parameter> asExpanded(List<Parameter> parameters) {
      return parameters
          .map((e) => e.toExpandedParameter(showDefaultValue: showDefaultValue))
          .toList();
    }

    return ParametersTemplate._(
      asExpanded(requiredPositionalParameters),
      optionalPositionalParameters: asExpanded(optionalPositionalParameters),
      namedParameters: asExpanded(namedParameters),
    );
  }

  /// Returns a [ParametersTemplate] where all the parameters are converted
  /// to named parameters, with the desired [optionality].
  ParametersTemplate asNamed({required Optionality optionality}) {
    List<Parameter> asHasRequired(List<Parameter> parameters) =>
        parameters.map((e) => e.copyWith(hasRequired: true)).toList();

    List<Parameter> change(List<Parameter> parameters) {
      return parameters.map((e) {
        switch (optionality) {
          case Optionality.keepSame:
            return e;
          case Optionality.makeAllRequired:
            return e.copyWith(hasRequired: true);
          case Optionality.makeAllOptional:
            return e.copyWith(hasRequired: false);
        }
      }).toList();
    }

    return ParametersTemplate._(
      [],
      namedParameters: [
        ...change(asHasRequired(requiredPositionalParameters)),
        ...change(optionalPositionalParameters),
        ...change(namedParameters),
      ],
    );
  }

  /// Returns a copy of this [ParametersTemplate] with the [transformParameter]
  /// callback applied to every parameter.
  ParametersTemplate transformParameters(
      Parameter Function(Parameter parameter) transformParameter) {
    return ParametersTemplate._(
      requiredPositionalParameters.map(transformParameter).toList(),
      namedParameters: namedParameters.map(transformParameter).toList(),
      optionalPositionalParameters:
          optionalPositionalParameters.map(transformParameter).toList(),
    );
  }

  @override
  String toString() {
    final buffer = StringBuffer()..writeAll(requiredPositionalParameters, ', ');

    if (buffer.isNotEmpty &&
        (optionalPositionalParameters.isNotEmpty ||
            namedParameters.isNotEmpty)) {
      buffer.write(', ');
    }
    if (optionalPositionalParameters.isNotEmpty) {
      buffer
        ..write('[')
        ..writeAll(optionalPositionalParameters, ', ')
        ..write(']');
    }
    if (namedParameters.isNotEmpty) {
      buffer
        ..write('{')
        ..writeAll(namedParameters, ', ')
        ..write('}');
    }

    return buffer.toString();
  }

  ParametersTemplate copyWith({
    List<Parameter>? requiredPositionalParameters,
    List<Parameter>? optionalPositionalParameters,
    List<Parameter>? namedParameters,
  }) {
    return ParametersTemplate._(
      requiredPositionalParameters ?? this.requiredPositionalParameters,
      optionalPositionalParameters:
          optionalPositionalParameters ?? this.optionalPositionalParameters,
      namedParameters: namedParameters ?? this.namedParameters,
    );
  }
}
