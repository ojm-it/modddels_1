import 'package:analyzer/dart/element/element.dart';

/// ⚠️ We shouldn't import the testers, because they use the package
/// 'flutter_test' which in turn imports dart:ui, which is not allowed in a
/// builder.
import 'package:modddels_annotations/modddels.dart';
import 'package:modddels_generator/src/core/modddel_parameter.dart';

abstract class _BaseClassInfo {
  /// The class name of the modddel
  ///
  /// Example : 'Age'
  String get className;

  /// The class name of the "Valid" modddel
  ///
  /// Example : 'ValidAge'
  String get valid => 'Valid$className';

  /// The class name of the "ModddelInput" of the modddel
  ///
  /// Example : '_AgeInput'
  String get modddelInput => '_${className}Input';
}

/* -------------------------------------------------------------------------- */
/*                           ValueObjects Class Info                          */
/* -------------------------------------------------------------------------- */

abstract class _BaseValueObjectClassInfo extends _BaseClassInfo {
  /// The class name of the "Invalid" [ValueObject]
  ///
  /// Example : 'InvalidAge'
  String get invalid => 'Invalid$className';

  /// The class name of the [ValueFailure]
  ///
  /// Example : 'AgeValueFailure'
  String get valueFailure => '${className}ValueFailure';
}

class SingleValueObjectClassInfo extends _BaseValueObjectClassInfo {
  SingleValueObjectClassInfo({
    required this.className,
    required this.singleValueType,
  });

  @override
  final String className;

  /// The type of the single value held inside the [SingleValueObject]
  ///
  /// Example : 'int'
  final String singleValueType;
}

class MultiValueObjectClassInfo extends _BaseValueObjectClassInfo {
  MultiValueObjectClassInfo({
    required this.className,
    required List<ParameterElement> namedParameters,
  }) {
    this.namedParameters =
        namedParameters.map((p) => ModddelParameter(p)).toList();
  }

  @override
  final String className;

  /// The list of named parameters of the [MultiValueObject]
  late final List<ModddelParameter> namedParameters;

  /// The class name of the private class "_Holder".
  ///
  /// Example : '_NameHolder'
  String get holder => '_${className}Holder';
}

/* -------------------------------------------------------------------------- */
/*                             Entities Class Info                            */
/* -------------------------------------------------------------------------- */

/* --------------------------------- Mixins --------------------------------- */

mixin _GeneralClassInfo on _BaseEntityClassInfo {
  /// The class name of the [InvalidEntity].
  ///
  /// Example : 'InvalidUser'
  String get invalid => 'Invalid$className';

  /// The class name of the [InvalidEntityGeneral].
  ///
  /// Example : 'InvalidUserGeneral'
  String get invalidGeneral => 'Invalid${className}General';

  /// The class name of the [GeneralFailure].
  ///
  /// Example : 'UserGeneralFailure'
  String get generalFailure => '${className}GeneralFailure';
}

mixin _SizedClassInfo on _BaseEntityClassInfo {
  /// The class name of the [InvalidEntity].
  ///
  /// Example : 'InvalidUserList'
  String get invalid => 'Invalid$className';

  /// The class name of the [InvalidEntitySize].
  ///
  /// Example : 'InvalidUserListSize'
  String get invalidSize => 'Invalid${className}Size';

  /// The class name of the [SizeFailure].
  ///
  /// Example : 'UserListSizeFailure'
  String get sizeFailure => '${className}SizeFailure';
}

mixin _ListClassInfo on _BaseEntityClassInfo {
  /// The generic type of the KtList.
  ///
  /// Example : For `KtList<Age>`, the type is 'Age'
  String get ktListType;

  /// The "Valid" version of [ktListType]
  ///
  /// Example : For `KtList<Age>`, this will be 'ValidAge'
  String get ktListTypeValid => 'Valid$ktListType';
}

/* -------------------------------------------------------------------------- */

abstract class _BaseEntityClassInfo extends _BaseClassInfo {
  /// The class name of the [InvalidEntityContent].
  ///
  /// Example : 'InvalidUserContent'
  String get invalidContent => 'Invalid${className}Content';
}

class SimpleEntityClassInfo extends _BaseEntityClassInfo {
  SimpleEntityClassInfo({
    required this.className,
    required List<ParameterElement> namedParameters,
  }) {
    this.namedParameters =
        namedParameters.map((p) => ModddelParameter(p)).toList();
  }

  @override
  final String className;

  /// The list of named parameters of the [SimpleEntity]
  late final List<ModddelParameter> namedParameters;
}

class GeneralEntityClassInfo extends _BaseEntityClassInfo
    with _GeneralClassInfo {
  GeneralEntityClassInfo({
    required this.className,
    required List<ParameterElement> namedParameters,
  }) {
    this.namedParameters =
        namedParameters.map((p) => ModddelParameter(p)).toList();
  }

  @override
  final String className;

  /// The list of named parameters of the [GeneralEntity]
  late final List<ModddelParameter> namedParameters;

  /// The class name of the private class "_ValidContent".
  ///
  /// Example : '_ValidUserContent'
  String get validContent => '_Valid${className}Content';
}

class ListEntityClassInfo extends _BaseEntityClassInfo with _ListClassInfo {
  ListEntityClassInfo({
    required this.className,
    required this.ktListType,
  });

  @override
  final String className;

  @override
  final String ktListType;
}

class SizedListEntityClassInfo extends _BaseEntityClassInfo
    with _ListClassInfo, _SizedClassInfo {
  SizedListEntityClassInfo({
    required this.className,
    required this.ktListType,
  });

  @override
  final String className;

  @override
  final String ktListType;
}

class ListGeneralEntityClassInfo extends _BaseEntityClassInfo
    with _ListClassInfo, _GeneralClassInfo {
  ListGeneralEntityClassInfo({
    required this.className,
    required this.ktListType,
  });

  @override
  final String className;

  @override
  final String ktListType;
}

class SizedListGeneralEntityClassInfo extends _BaseEntityClassInfo
    with _ListClassInfo, _GeneralClassInfo, _SizedClassInfo {
  SizedListGeneralEntityClassInfo({
    required this.className,
    required this.ktListType,
  });

  @override
  final String className;

  @override
  final String ktListType;
}
