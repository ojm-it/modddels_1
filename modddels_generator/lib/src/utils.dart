import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type_visitor.dart';

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

class EntityClassInfo {
  EntityClassInfo(this.className, List<ParameterElement> namedParameters) {
    this.namedParameters =
        namedParameters.map((p) => EntityParameter(p)).toList();
    generalEntityFailure = '${className}EntityFailure';
    invalidEntityGeneral = 'Invalid${className}General';
    invalidEntityContent = 'Invalid${className}Content';
    invalidEntity = 'Invalid$className';
    validEntity = 'Valid$className';
  }

  final String className;
  late final List<EntityParameter> namedParameters;
  late final String generalEntityFailure;
  late final String invalidEntityGeneral;
  late final String invalidEntityContent;
  late final String invalidEntity;
  late final String validEntity;
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

  bool get hasValidAnnotation =>
      parameter.metadata.any((m) => m.toSource().contains('@valid'));
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
