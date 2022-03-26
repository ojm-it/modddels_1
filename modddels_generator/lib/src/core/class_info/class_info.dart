/// ⚠️ We shouldn't import the testers, because they use the package
/// 'flutter_test' which in turn imports dart:ui, which is not allowed in a
/// builder.
import 'package:modddels_annotations/modddels.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:modddels_generator/src/core/templates/parameter.dart';
import 'package:modddels_generator/src/core/templates/parameters_template.dart';
import 'package:source_gen/source_gen.dart';

part 'general_entity_class_info.dart';
part 'list_class_info.dart';
part 'multi_value_object_class_info.dart';
part 'simple_entity_class_info.dart';
part 'single_value_object_class_info.dart';

abstract class _BaseClassInfo {
  _BaseClassInfo._() {
    verifySourceErrors();
  }

  ConstructorElement get factoryConstructor;

  /// The [ParametersTemplate] of the parameters specified inside the
  /// [factoryConstructor] of the modddel.
  ///
  /// By default, the parameters are all [ExpandedParameter]s with
  /// [ExpandedParameter.showDefaultValue] set to false.
  ParametersTemplate get parametersTemplate;

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

  /// This function is called during the classInfo instantiation.
  ///
  /// It must be used to make verifications that throw errors such as
  /// [InvalidGenerationSourceError].
  void verifySourceErrors();
}

/* -------------------------------------------------------------------------- */
/*                                   Mixins                                   */
/* -------------------------------------------------------------------------- */
mixin _CopyWithClassInfo on _BaseClassInfo {
  /// The abstract CopyWith class.
  ///
  /// Example : '_$UserCopyWith'
  String get copyWith => '_\$${className}CopyWith';

  /// The implementation of the CopyWith class.
  ///
  /// Example : '_$UserCopyWithImpl'
  String get copyWithImpl => '_\$${className}CopyWithImpl';
}

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
  /// The "list" parameter
  Parameter get listParameter;

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
/*                           ValueObjects Class Info                          */
/* -------------------------------------------------------------------------- */

abstract class _BaseValueObjectClassInfo extends _BaseClassInfo {
  _BaseValueObjectClassInfo._() : super._();

  /// The class name of the "Invalid" [ValueObject]
  ///
  /// Example : 'InvalidAge'
  String get invalid => 'Invalid$className';

  /// The class name of the [ValueFailure]
  ///
  /// Example : 'AgeValueFailure'
  String get valueFailure => '${className}ValueFailure';
}

/* -------------------------------------------------------------------------- */
/*                             Entities Class Info                            */
/* -------------------------------------------------------------------------- */

abstract class _BaseEntityClassInfo extends _BaseClassInfo {
  _BaseEntityClassInfo._() : super._();

  /// The class name of the [InvalidEntityContent].
  ///
  /// Example : 'InvalidUserContent'
  String get invalidContent => 'Invalid${className}Content';
}
