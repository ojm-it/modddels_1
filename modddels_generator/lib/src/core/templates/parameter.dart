import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';

import 'package:modddels_annotations/modddels.dart';
import 'package:modddels_generator/src/core/templates/annotations.dart';
import 'package:modddels_generator/src/core/utils.dart';

abstract class Parameter {
  /// If this parameter was constructed from a [ParameterElement] using
  /// [ExpandedParameter.fromParameterElement] or
  /// [LocalParameter.fromParameterElement], then returns that parameterElement.
  ///
  /// Otherwise returns null.
  ParameterElement? get parameterElement;

  /// The name of this parameter.
  String get name;

  /// The type of this parameter.
  String get type;

  /// The default value of this parameter, if any.
  String? get defaultValue;

  /// Whether the parameter is preceded with the "required" keyword.
  bool get hasRequired;

  /// The list of decorators of this parameter.
  List<String> get decorators;

  bool get showDefaultValue;

  /// The documentation of the parameter
  String get doc;

  /// Whether the parameter has the `@valid` annotation or the
  /// `@validWithGetter` annotation
  bool get hasValidAnnotation;

  /// Whether the parameter has the `@invalid` annotation or the
  /// `@invalidWithGetter` annotation
  bool get hasInvalidAnnotation;

  /// Whether the parameter has the `@withGetter` annotation, the
  /// `@validWithGetter` annotation, or the `@invalidWithGetter` annotation
  bool get hasWithGetterAnnotation;

  /// Whether the parameter has the `@NullFailure` annotation.
  bool get hasNullFailureAnnotation;

  /// The value of the `@NullFailure` annotation's field [NullFailure.failure],
  /// or null if the parameter doesn't have such annotation.
  String? get nullFailureString;

  /// Whether the parameter has a default value.
  bool get hasDefaultValue => defaultValue != null;

  /// Whether the type of the parameter is nullable.
  bool get isNullable => type.endsWith('?');

  /// The non-nullable version of [type].
  String get nonNullableType =>
      type.endsWith('?') ? type.substring(0, type.length - 1) : type;

  /// The nullable version of [type].
  String get nullableType => type.endsWith('?') ? type : '$type?';

  /// The [name] of the parameter, with the first letter in upper-case.
  String get _nameCapitalized => name.capitalize();

  /// The "valid" version of the [name].
  ///
  /// Example : 'validAge'
  String get validName => 'valid$_nameCapitalized';

  /// The "invalid" version of the [name].
  ///
  /// Example : 'invalidAge'
  String get invalidName => 'invalid$_nameCapitalized';

  /// Whether this parameter is an [ExpandedParameter] or a [LocalParameter].
  bool get isExpandedParameter;

  /// Converts this parameter to an [ExpandedParameter].
  ExpandedParameter toExpandedParameter({bool showDefaultValue = false}) {
    return ExpandedParameter(
      parameterElement: parameterElement,
      name: name,
      type: type,
      defaultValue: defaultValue,
      hasRequired: hasRequired,
      decorators: decorators,
      doc: doc,
      showDefaultValue: showDefaultValue,
      hasValidAnnotation: hasValidAnnotation,
      hasInvalidAnnotation: hasInvalidAnnotation,
      hasWithGetterAnnotation: hasWithGetterAnnotation,
      hasNullFailureAnnotation: hasNullFailureAnnotation,
      nullFailureString: nullFailureString,
    );
  }

  /// Converts this parameter to a [LocalParameter].
  LocalParameter toLocalParameter() {
    return LocalParameter(
      parameterElement: parameterElement,
      name: name,
      type: type,
      defaultValue: defaultValue,
      hasRequired: hasRequired,
      decorators: decorators,
      doc: doc,
      hasValidAnnotation: hasValidAnnotation,
      hasInvalidAnnotation: hasInvalidAnnotation,
      hasWithGetterAnnotation: hasWithGetterAnnotation,
      hasNullFailureAnnotation: hasNullFailureAnnotation,
      nullFailureString: nullFailureString,
    );
  }

  Parameter copyWith({
    ParameterElement? parameterElement,
    String? name,
    String? type,
    String? defaultValue,
    bool? hasRequired,
    List<String>? decorators,
    bool? showDefaultValue,
    String? doc,
    bool? hasValidAnnotation,
    bool? hasInvalidAnnotation,
    bool? hasWithGetterAnnotation,
    bool? hasNullFailureAnnotation,
    String? nullFailureString,
  }) {
    return isExpandedParameter
        ? ExpandedParameter(
            parameterElement: parameterElement ?? this.parameterElement,
            name: name ?? this.name,
            type: type ?? this.type,
            defaultValue: defaultValue ?? this.defaultValue,
            hasRequired: hasRequired ?? this.hasRequired,
            decorators: decorators ?? this.decorators,
            showDefaultValue: showDefaultValue ?? this.showDefaultValue,
            doc: doc ?? this.doc,
            hasValidAnnotation: hasValidAnnotation ?? this.hasValidAnnotation,
            hasInvalidAnnotation:
                hasInvalidAnnotation ?? this.hasInvalidAnnotation,
            hasWithGetterAnnotation:
                hasWithGetterAnnotation ?? this.hasWithGetterAnnotation,
            hasNullFailureAnnotation:
                hasNullFailureAnnotation ?? this.hasNullFailureAnnotation,
            nullFailureString: nullFailureString ?? this.nullFailureString,
          )
        : LocalParameter(
            parameterElement: parameterElement ?? this.parameterElement,
            name: name ?? this.name,
            type: type ?? this.type,
            defaultValue: defaultValue ?? this.defaultValue,
            hasRequired: hasRequired ?? this.hasRequired,
            decorators: decorators ?? this.decorators,
            doc: doc ?? this.doc,
            hasValidAnnotation: hasValidAnnotation ?? this.hasValidAnnotation,
            hasInvalidAnnotation:
                hasInvalidAnnotation ?? this.hasInvalidAnnotation,
            hasWithGetterAnnotation:
                hasWithGetterAnnotation ?? this.hasWithGetterAnnotation,
            hasNullFailureAnnotation:
                hasNullFailureAnnotation ?? this.hasNullFailureAnnotation,
            nullFailureString: nullFailureString ?? this.nullFailureString,
          );
  }
}

/// An [ExpandedParameter] represents a parameter which type is displayed. For
/// example : `String name`
///
/// **The [toString] adapts to the provided arguments :**
///
/// If [hasRequired] is true, then the 'required' keyword is added. For example
/// : `required String name`
///
/// If [defaultValue] is provided, and [showDefaultValue] is set to true, and
/// [hasRequired] is false, then the default value of the parameter is appended.
/// For example : `String name = 'Avi'`
///
/// If [decorators] is provided, then those are included too. For example :
/// `@deprecated String name`
///
class ExpandedParameter extends Parameter {
  ExpandedParameter({
    this.parameterElement,
    required this.name,
    required this.type,
    required this.defaultValue,
    required this.hasRequired,
    required this.decorators,
    required this.doc,
    this.showDefaultValue = false,
    required this.hasValidAnnotation,
    required this.hasInvalidAnnotation,
    required this.hasWithGetterAnnotation,
    required this.hasNullFailureAnnotation,
    required this.nullFailureString,
  }) : assert(hasNullFailureAnnotation == (nullFailureString != null));

  ExpandedParameter.empty({
    this.parameterElement,
    required this.name,
    this.type = 'dynamic',
    this.defaultValue,
    this.hasRequired = false,
    this.decorators = const [],
    this.doc = '',
    this.showDefaultValue = false,
    this.hasValidAnnotation = false,
    this.hasInvalidAnnotation = false,
    this.hasWithGetterAnnotation = false,
    this.hasNullFailureAnnotation = false,
    this.nullFailureString,
  }) : assert(hasNullFailureAnnotation == (nullFailureString != null));

  @override
  final ParameterElement? parameterElement;

  @override
  final String name;

  @override
  final String type;

  @override
  final String? defaultValue;

  @override
  final bool hasRequired;

  @override
  final List<String> decorators;

  /// Whether to show the [defaultValue] if it's provided.
  ///
  /// Defaults to `false`.
  ///
  /// NB : If [hasRequired] is true, then the [defaultValue] is never shown
  /// because a required parameter can't have a default value.
  @override
  final bool showDefaultValue;

  @override
  final String doc;

  @override
  final bool hasValidAnnotation;

  @override
  final bool hasInvalidAnnotation;

  @override
  final bool hasWithGetterAnnotation;

  @override
  final bool hasNullFailureAnnotation;

  @override
  final String? nullFailureString;

  @override
  bool get isExpandedParameter => true;

  @override
  String toString() {
    var res = ' $type $name';
    if (hasRequired) {
      res = 'required $res';
    }
    if (decorators.isNotEmpty) {
      res = '${decorators.join()} $res';
    }

    /// A required parameter can't have a default value
    if (showDefaultValue && defaultValue != null && !hasRequired) {
      res = '$res = $defaultValue';
    }
    return res;
  }

  static Future<ExpandedParameter> fromParameterElement({
    required ParameterElement parameterElement,
    required BuildStep buildStep,
    bool showDefaultValue = false,
  }) async {
    final doc = await documentationOfParameter(parameterElement, buildStep);
    return ExpandedParameter(
      parameterElement: parameterElement,
      name: parameterElement.name,
      type: parameterElement.paramType,
      defaultValue: parameterElement.defaultValue,
      hasRequired: parameterElement.isRequiredNamed,
      decorators: parseDecorators(parameterElement.metadata),
      doc: doc,
      showDefaultValue: showDefaultValue,
      hasValidAnnotation: parameterElement.hasValidAnnotation,
      hasInvalidAnnotation: parameterElement.hasInvalidAnnotation,
      hasWithGetterAnnotation: parameterElement.hasWithGetterAnnotation,
      hasNullFailureAnnotation: parameterElement.hasNullFailureAnnotation,
      nullFailureString: parameterElement.hasNullFailureAnnotation
          ? parameterElement.nullFailureString
          : null,
    );
  }
}

/// A [LocalParameter] represents a parameter which is assigned to "this". For
/// example : `this.name`
///
/// **The [toString] adapts to the provided arguments :**
///
/// If [hasRequired] is true, then the 'required' keyword is added. For example
/// : `required this.name`
///
/// If [defaultValue] is provided, and [hasRequired] is false, then the default
/// value of the parameter is appended. For example : `this.name = 'Avi'`
///
/// If [decorators] is provided, then those are included too. For example :
/// `@deprecated String name`
///
class LocalParameter extends Parameter {
  LocalParameter({
    this.parameterElement,
    required this.name,
    required this.type,
    required this.defaultValue,
    required this.hasRequired,
    required this.decorators,
    required this.doc,
    required this.hasValidAnnotation,
    required this.hasInvalidAnnotation,
    required this.hasWithGetterAnnotation,
    required this.hasNullFailureAnnotation,
    required this.nullFailureString,
  }) : assert(hasNullFailureAnnotation == (nullFailureString != null));

  LocalParameter.empty({
    this.parameterElement,
    required this.name,
    this.type = 'dynamic',
    this.defaultValue,
    this.hasRequired = false,
    this.decorators = const [],
    this.doc = '',
    this.hasValidAnnotation = false,
    this.hasInvalidAnnotation = false,
    this.hasWithGetterAnnotation = false,
    this.hasNullFailureAnnotation = false,
    this.nullFailureString,
  }) : assert(hasNullFailureAnnotation == (nullFailureString != null));

  @override
  final ParameterElement? parameterElement;

  @override
  final String name;

  @override
  final String type;

  @override
  final String? defaultValue;

  @override
  final bool hasRequired;

  @override
  final List<String> decorators;

  /// For a [LocalParameter], the [defaultValue] is always shown when it's
  /// provided.
  ///
  /// NB : If [hasRequired] is true, then the [defaultValue] is not shown
  /// because a required parameter can't have a default value.
  @override
  bool get showDefaultValue => true;

  @override
  final String doc;

  @override
  final bool hasValidAnnotation;

  @override
  final bool hasInvalidAnnotation;

  @override
  final bool hasWithGetterAnnotation;

  @override
  final bool hasNullFailureAnnotation;

  @override
  final String? nullFailureString;

  @override
  bool get isExpandedParameter => false;

  @override
  String toString() {
    var res = 'this.$name';
    if (hasRequired) {
      res = 'required $res';
    }
    if (decorators.isNotEmpty) {
      res = '${decorators.join()} $res';
    }

    /// A required parameter can't have a default value
    if (showDefaultValue && defaultValue != null && !hasRequired) {
      res = '$res = $defaultValue';
    }
    return res;
  }

  static Future<LocalParameter> fromParameterElement({
    required ParameterElement parameterElement,
    required BuildStep buildStep,
  }) async {
    final doc = await documentationOfParameter(parameterElement, buildStep);
    return LocalParameter(
      parameterElement: parameterElement,
      name: parameterElement.name,
      type: parameterElement.paramType,
      defaultValue: parameterElement.defaultValue,
      hasRequired: parameterElement.isRequiredNamed,
      decorators: parseDecorators(parameterElement.metadata),
      doc: doc,
      hasValidAnnotation: parameterElement.hasValidAnnotation,
      hasInvalidAnnotation: parameterElement.hasInvalidAnnotation,
      hasWithGetterAnnotation: parameterElement.hasWithGetterAnnotation,
      hasNullFailureAnnotation: parameterElement.hasNullFailureAnnotation,
      nullFailureString: parameterElement.hasNullFailureAnnotation
          ? parameterElement.nullFailureString
          : null,
    );
  }
}
