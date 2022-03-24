import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';

/// ⚠️ We shouldn't import the testers, because they use the package
/// 'flutter_test' which in turn imports dart:ui, which is not allowed in a
/// builder.
import 'package:modddels_annotations/modddels.dart';
import 'package:modddels_generator/src/core/utils.dart';
import 'package:source_gen/source_gen.dart';

/// This class represents a of a factory constructor of a [Modddel].
class ModddelParameter {
  ModddelParameter._({
    required this.parameterElement,
    required this.doc,
  });

  static Future<ModddelParameter> create({
    required BuildStep buildStep,
    required ParameterElement parameterElement,
  }) async {
    final doc =
        (await documentationOfParameter(parameterElement, buildStep)).trim();

    return ModddelParameter._(
      parameterElement: parameterElement,
      doc: doc,
    );
  }

  final ParameterElement parameterElement;

  /// The documentation of the parameter
  final String doc;

  /// Returns the nullable version of the given [type].
  static String optionalize(String type) {
    return type.endsWith('?') ? type : '$type?';
  }

  /// The type of this [ModddelParameter].
  ///
  /// If the parameter is annotated with the [TypeName] annotation, it returns
  /// the value of its field [TypeName.typeName]. Otherwise, returns the type of
  /// the parameter.
  String get type => hasTypeNameAnnotation
      ? _typeNameChecker
          .firstAnnotationOfExact(parameterElement)!
          .getField('typeName')!
          .toStringValue()!
      : parameterElement.type.toString();

  /// The non-nullable version of [type].
  String get nonNullableType =>
      type.endsWith('?') ? type.substring(0, type.length - 1) : type;

  /// The nullable version of [type].
  String get nullableType => optionalize(type);

  /// The name of the parameter.
  String get name => parameterElement.name;

  /// The [name] of the parameter, with the first letter in upper-case.
  String get nameCapitalized => name.capitalize();

  /// The "valid" version of the [name].
  ///
  /// Example : 'validAge'
  String get validName => 'valid$nameCapitalized';

  /// The "invalid" version of the [name].
  ///
  /// Example : 'invalidAge'
  String get invalidName => 'invalid$nameCapitalized';

  /// Whether the parameter has a default value.
  bool get hasDefaultValue => parameterElement.hasDefaultValue;

  /// Returns the Dart code of the default value of the parameter.
  ///
  /// This should only be called if the parameter has a default value.
  String get defaultValue {
    assert(hasDefaultValue);
    return parameterElement.defaultValueCode!;
  }

  /// Whether the parameter is required.
  bool get isRequired => parameterElement.isRequiredNamed;

  /// Whether the type of the parameter is nullable.
  bool get isNullable => type.endsWith('?');

  /// True if the parameter has the `@valid` annotation or the
  /// `@validWithGetter` annotation
  bool get hasValidAnnotation =>
      _validChecker.hasAnnotationOfExact(parameterElement) ||
      _validWithGetterChecker.hasAnnotationOfExact(parameterElement);

  /// True if the parameter has the `@invalid` annotation or the
  /// `@invalidWithGetter` annotation
  bool get hasInvalidAnnotation =>
      _invalidChecker.hasAnnotationOfExact(parameterElement) ||
      _invalidWithGetterChecker.hasAnnotationOfExact(parameterElement);

  /// True if the parameter has the `@withGetter` annotation, the
  /// `@validWithGetter` annotation, or the `@invalidWithGetter` annotation
  bool get hasWithGetterAnnotation =>
      _withGetterChecker.hasAnnotationOfExact(parameterElement) ||
      _validWithGetterChecker.hasAnnotationOfExact(parameterElement) ||
      _invalidWithGetterChecker.hasAnnotationOfExact(parameterElement);

  /// True if the parameter has the `@NullFailure` annotation.
  bool get hasNullFailureAnnotation =>
      _nullFailureChecker.hasAnnotationOfExact(parameterElement);

  /// True if the parameter has the `@TypeName` annotation.
  bool get hasTypeNameAnnotation =>
      _typeNameChecker.hasAnnotationOfExact(parameterElement);

  /// Returns the value of the `@NullFailure` annotation's field
  /// [NullFailure.failure].
  ///
  /// This should only be called if this parameter has the `@NullFailure`
  /// annotation.
  String get nullFailureString {
    assert(hasNullFailureAnnotation);

    return _nullFailureChecker
        .firstAnnotationOfExact(parameterElement)!
        .getField('failure')!
        .toStringValue()!;
  }
}

const _validChecker = TypeChecker.fromRuntime(ValidAnnotation);

const _invalidChecker = TypeChecker.fromRuntime(InvalidAnnotation);

const _withGetterChecker = TypeChecker.fromRuntime(WithGetterAnnotation);

const _validWithGetterChecker =
    TypeChecker.fromRuntime(ValidWithGetterAnnotation);

const _invalidWithGetterChecker =
    TypeChecker.fromRuntime(InvalidWithGetterAnnotation);

const _nullFailureChecker = TypeChecker.fromRuntime(NullFailure);

const _typeNameChecker = TypeChecker.fromRuntime(TypeName);
