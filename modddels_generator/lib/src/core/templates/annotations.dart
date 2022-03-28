import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

import 'package:modddels_annotations/modddels.dart';

const _validChecker = TypeChecker.fromRuntime(ValidAnnotation);

const _invalidChecker = TypeChecker.fromRuntime(InvalidAnnotation);

const _withGetterChecker = TypeChecker.fromRuntime(WithGetterAnnotation);

const _validWithGetterChecker =
    TypeChecker.fromRuntime(ValidWithGetterAnnotation);

const _invalidWithGetterChecker =
    TypeChecker.fromRuntime(InvalidWithGetterAnnotation);

const _nullFailureChecker = TypeChecker.fromRuntime(NullFailure);

const _typeNameChecker = TypeChecker.fromRuntime(TypeName);

extension ElementAnnotationX on ElementAnnotation {
  /// Helper method that checks whether the [typeChecker] represents the exact
  /// same type as this [ElementAnnotation].
  bool _matchesChecker(TypeChecker typeChecker) =>
      typeChecker.isExactlyType(computeConstantValue()!.type!);

  /// Whether this annotation is the [ValidAnnotation]
  bool get isValid => _matchesChecker(_validChecker);

  /// Whether this annotation is the [InvalidAnnotation]
  bool get isInvalid => _matchesChecker(_invalidChecker);

  /// Whether this annotation is the [WithGetterAnnotation]
  bool get isWithGetter => _matchesChecker(_withGetterChecker);

  /// Whether this annotation is the [ValidWithGetterAnnotation]
  bool get isValidWithGetter => _matchesChecker(_validWithGetterChecker);

  /// Whether this annotation is the [InvalidWithGetterAnnotation]
  bool get isInvalidWithGetter => _matchesChecker(_invalidWithGetterChecker);

  /// Whether this annotation is the [NullFailure] annotation
  bool get isNullFailure => _matchesChecker(_nullFailureChecker);

  /// Whether this annotation is the [TypeName] annotation
  bool get isTypeName => _matchesChecker(_typeNameChecker);
}

extension ParameterElementX on ParameterElement {
  /// The type of this [ParameterElement] after taking into account the
  /// [TypeName] annotation.
  ///
  /// If the parameter is annotated with the [TypeName] annotation, it returns
  /// the value of its field [TypeName.typeName]. Otherwise, returns the type of
  /// the parameter.
  String get paramType =>
      hasTypeNameAnnotation ? typeNameString : type.toString();

  /// True if the parameter has the `@valid` annotation or the
  /// `@validWithGetter` annotation
  bool get hasValidAnnotation =>
      metadata.any((meta) => meta.isValid || meta.isValidWithGetter);

  /// True if the parameter has the `@invalid` annotation or the
  /// `@invalidWithGetter` annotation
  bool get hasInvalidAnnotation =>
      metadata.any((meta) => meta.isInvalid || meta.isInvalidWithGetter);

  /// True if the parameter has the `@withGetter` annotation, the
  /// `@validWithGetter` annotation, or the `@invalidWithGetter` annotation
  bool get hasWithGetterAnnotation => metadata.any((meta) =>
      meta.isWithGetter || meta.isValidWithGetter || meta.isInvalidWithGetter);

  /// True if the parameter has the `@NullFailure` annotation.
  bool get hasNullFailureAnnotation =>
      metadata.any((meta) => meta.isNullFailure);

  /// True if the parameter has the `@TypeName` annotation.
  bool get hasTypeNameAnnotation => metadata.any((meta) => meta.isTypeName);

  /// Returns the value of the `@TypeName` annotation's field
  /// [TypeName.typeName].
  ///
  /// This should only be called if this parameter has the `@TypeName`
  /// annotation.
  String get typeNameString {
    assert(hasTypeNameAnnotation);

    return _typeNameChecker
        .firstAnnotationOfExact(this)!
        .getField('typeName')!
        .toStringValue()!;
  }

  /// Returns the value of the `@NullFailure` annotation's field
  /// [NullFailure.failure].
  ///
  /// This should only be called if this parameter has the `@NullFailure`
  /// annotation.
  String get nullFailureString {
    assert(hasNullFailureAnnotation);

    return _nullFailureChecker
        .firstAnnotationOfExact(this)!
        .getField('failure')!
        .toStringValue()!;
  }

  /// Return the Dart code of the default value, or null if no default value.
  String? get defaultValue => hasDefaultValue ? defaultValueCode! : null;
}
