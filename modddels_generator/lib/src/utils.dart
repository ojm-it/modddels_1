import 'package:analyzer/dart/element/element.dart';

/// ⚠️ We shouldn't import the testers, because they use the package
/// 'flutter_test' which in turn imports dart:ui, which is not allowed in a
/// builder.
import 'package:modddels_annotations/modddels.dart';
import 'package:source_gen/source_gen.dart';

class ValueObjectClassInfo {
  ValueObjectClassInfo(this.valueType, this.className) {
    valueFailure = '${className}ValueFailure';
    invalidValueObject = 'Invalid$className';
    validValueObject = 'Valid$className';
  }

  final String className;
  final String valueType;
  late final String valueFailure;
  late final String invalidValueObject;
  late final String validValueObject;
}

/* -------------------------------------------------------------------------- */
/*                         Simple Entities Class Info                         */
/* -------------------------------------------------------------------------- */

abstract class BaseEntityClassInfo {
  BaseEntityClassInfo(this.className) {
    invalidEntityContent = 'Invalid${className}Content';
    validEntity = 'Valid$className';
  }

  final String className;
  late final String invalidEntityContent;
  late final String validEntity;
}

class SimpleEntityClassInfo extends BaseEntityClassInfo {
  SimpleEntityClassInfo(
      String className, List<ParameterElement> namedParameters)
      : super(className) {
    this.namedParameters =
        namedParameters.map((p) => EntityParameter(p)).toList();
  }
  late final List<EntityParameter> namedParameters;
}

class ListEntityClassInfo extends BaseEntityClassInfo {
  ListEntityClassInfo(String className, this.ktListType) : super(className) {
    ktListTypeValid = 'Valid$ktListType';
  }

  final String ktListType;

  late final String ktListTypeValid;
}

class SizedListEntityClassInfo extends ListEntityClassInfo {
  SizedListEntityClassInfo(String className, String ktListType)
      : super(className, ktListType) {
    sizeFailure = '${className}SizeFailure';
    invalidEntity = 'Invalid$className';
    invalidEntitySize = 'Invalid${className}Size';
  }

  late final String sizeFailure;
  late final String invalidEntity;
  late final String invalidEntitySize;
}

/* -------------------------------------------------------------------------- */
/*                         General Entities class info                        */
/* -------------------------------------------------------------------------- */

abstract class BaseGeneralEntityClassInfo {
  BaseGeneralEntityClassInfo(this.className) {
    generalFailure = '${className}GeneralFailure';
    invalidEntityGeneral = 'Invalid${className}General';
    invalidEntityContent = 'Invalid${className}Content';
    invalidEntity = 'Invalid$className';
    validEntity = 'Valid$className';
  }

  final String className;
  late final String generalFailure;
  late final String invalidEntityGeneral;
  late final String invalidEntityContent;
  late final String invalidEntity;
  late final String validEntity;
}

class GeneralEntityClassInfo extends BaseGeneralEntityClassInfo {
  GeneralEntityClassInfo(
      String className, List<ParameterElement> namedParameters)
      : super(className) {
    this.namedParameters =
        namedParameters.map((p) => EntityParameter(p)).toList();

    validEntityContent = '_Valid${className}Content';
  }
  late final List<EntityParameter> namedParameters;
  late final String validEntityContent;
}

class ListGeneralEntityClassInfo extends BaseGeneralEntityClassInfo {
  ListGeneralEntityClassInfo(String className, this.ktListType)
      : super(className) {
    ktListTypeValid = 'Valid$ktListType';
  }

  final String ktListType;

  late final String ktListTypeValid;
}

class SizedListGeneralEntityClassInfo extends ListGeneralEntityClassInfo {
  SizedListGeneralEntityClassInfo(String className, String ktListType)
      : super(className, ktListType) {
    sizeFailure = '${className}SizeFailure';
    invalidEntitySize = 'Invalid${className}Size';
  }

  late final String sizeFailure;
  late final String invalidEntitySize;
}

/* -------------------------------------------------------------------------- */
/*                                    Other                                   */
/* -------------------------------------------------------------------------- */

class EntityParameter {
  EntityParameter(this.parameter) : assert(parameter.isNamed);
  final ParameterElement parameter;

  static String optionalize(String type) {
    return type.endsWith('?') ? type : '$type?';
  }

  String get type => hasTypeNameAnnotation
      ? _typeNameChecker
          .firstAnnotationOfExact(parameter)!
          .getField('typeName')!
          .toStringValue()!
      : parameter.type.toString();

  String get typeWithoutNullabilitySuffix =>
      type.endsWith('?') ? type.substring(0, type.length - 1) : type;

  String get name => parameter.name;

  String get nameCapitalized => name.capitalize();

  String get validName => 'valid$nameCapitalized';

  String get invalidName => 'invalid$nameCapitalized';

  String get optionalType => optionalize(type);

  bool get hasDefaultValue => parameter.hasDefaultValue;

  bool get isNullable => type.endsWith('?');

  /// True if the parameter has the `@valid` annotation or the
  /// `@validWithGetter` annotation
  bool get hasValidAnnotation =>
      _validChecker.hasAnnotationOfExact(parameter) ||
      _validWithGetterChecker.hasAnnotationOfExact(parameter);

  /// True if the parameter has the `@invalid` annotation or the
  /// `@invalidWithGetter` annotation
  bool get hasInvalidAnnotation =>
      _invalidChecker.hasAnnotationOfExact(parameter) ||
      _invalidWithGetterChecker.hasAnnotationOfExact(parameter);

  /// True if the parameter has the `@withGetter` annotation, the
  /// `@validWithGetter` annotation, or the `@invalidWithGetter` annotation
  bool get hasWithGetterAnnotation =>
      _withGetterChecker.hasAnnotationOfExact(parameter) ||
      _validWithGetterChecker.hasAnnotationOfExact(parameter) ||
      _invalidWithGetterChecker.hasAnnotationOfExact(parameter);

  bool get hasInvalidNullAnnotation =>
      _invalidNullChecker.hasAnnotationOfExact(parameter);

  /// True if the parameter has the `@TypeName` annotation.
  bool get hasTypeNameAnnotation =>
      _typeNameChecker.hasAnnotationOfExact(parameter);

  String get invalidNullGeneralFailure {
    final annotation = _invalidNullChecker.annotationsOfExact(parameter).single;

    final generalFailure =
        annotation.getField('generalFailure')?.toStringValue();

    if (generalFailure == null) {
      throw InvalidGenerationSourceError(
        "The InvalidAnnotation should contain a String value.",
        element: parameter,
      );
    }

    return generalFailure;
  }
}

const _validChecker = TypeChecker.fromRuntime(ValidAnnotation);

const _invalidChecker = TypeChecker.fromRuntime(InvalidAnnotation);

const _withGetterChecker = TypeChecker.fromRuntime(WithGetterAnnotation);

const _validWithGetterChecker =
    TypeChecker.fromRuntime(ValidWithGetterAnnotation);

const _invalidWithGetterChecker =
    TypeChecker.fromRuntime(InvalidWithGetterAnnotation);

const _invalidNullChecker = TypeChecker.fromRuntime(InvalidNull);

const _typeNameChecker = TypeChecker.fromRuntime(TypeName);

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
