import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:modddels_annotations/modddels_annotations.dart';
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
/*                              Entity Class Info                             */
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

class EntityClassInfo extends BaseEntityClassInfo {
  EntityClassInfo(String className, List<ParameterElement> namedParameters)
      : super(className) {
    this.namedParameters =
        namedParameters.map((p) => EntityParameter(p)).toList();
  }
  late final List<EntityParameter> namedParameters;
}

class EntityParameter {
  EntityParameter(this.parameter) : assert(parameter.isNamed);
  final ParameterElement parameter;

  static String optionalize(String type) {
    return type.endsWith('?') ? type : '$type?';
  }

  String get type => parameter.type.toString();

  String get typeWithoutNullabilitySuffix =>
      type.endsWith('?') ? type.substring(0, type.length - 1) : type;

  String get name => parameter.name;

  String get nameCapitalized => name.capitalize();

  String get validName => 'valid$nameCapitalized';

  String get invalidName => 'invalid$nameCapitalized';

  String get optionalType => optionalize(type);

  bool get isRequired => parameter.isRequiredNamed;

  bool get hasDefaultValue => parameter.hasDefaultValue;

  bool get isNullable =>
      parameter.type.nullabilitySuffix == NullabilitySuffix.question;

  ///True if the parameter has the `@valid` annotation or the `@validWithGetter`
  ///annotation
  bool get hasValidAnnotation =>
      _validChecker.hasAnnotationOfExact(parameter) ||
      _validWithGetterChecker.hasAnnotationOfExact(parameter);

  ///True if the parameter has the `@withGetter` annotation or the
  ///`@validWithGetter` annotation

  bool get hasWithGetterAnnotation =>
      _withGetterChecker.hasAnnotationOfExact(parameter) ||
      _validWithGetterChecker.hasAnnotationOfExact(parameter);
}

const _validChecker = TypeChecker.fromRuntime(ValidAnnotation);

const _withGetterChecker = TypeChecker.fromRuntime(WithGetterAnnotation);

const _validWithGetterChecker =
    TypeChecker.fromRuntime(ValidWithGetterAnnotation);

class KtListEntityClassInfo extends BaseEntityClassInfo {
  KtListEntityClassInfo(String className, this.ktListType) : super(className) {
    ktListTypeValid = 'Valid$ktListType';
  }

  final String ktListType;

  late final String ktListTypeValid;
}

/* -------------------------------------------------------------------------- */
/*                          General Entity class info                         */
/* -------------------------------------------------------------------------- */

abstract class BaseGeneralEntityClassInfo {
  BaseGeneralEntityClassInfo(this.className) {
    generalEntityFailure = '${className}EntityFailure';
    invalidEntityGeneral = 'Invalid${className}General';
    invalidEntityContent = 'Invalid${className}Content';
    invalidEntity = 'Invalid$className';
    validEntity = 'Valid$className';
  }

  final String className;
  late final String generalEntityFailure;
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
  }
  late final List<EntityParameter> namedParameters;
}

class KtListGeneralEntityClassInfo extends BaseGeneralEntityClassInfo {
  KtListGeneralEntityClassInfo(String className, this.ktListType)
      : super(className) {
    ktListTypeValid = 'Valid$ktListType';
  }

  final String ktListType;

  late final String ktListTypeValid;
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
