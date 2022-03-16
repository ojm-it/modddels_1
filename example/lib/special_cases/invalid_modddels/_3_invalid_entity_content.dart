import 'package:equatable/equatable.dart';
import 'package:example/value_objects/1_single_value_object/name.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:modddels_annotations/modddels.dart';

part '_3_invalid_entity_content.freezed.dart';

/* -------------------------------------------------------------------------- */
/*               Making an Entity that is always invalid content              */
/* -------------------------------------------------------------------------- */

/// 1. Using Freezed
@freezed
class InvalidPersonContent1 extends InvalidEntityContent
    with _$InvalidPersonContent1 {
  const factory InvalidPersonContent1({
    required Name firstName,
    required InvalidName invalidLastName,
  }) = _InvalidPersonContent1;

  const InvalidPersonContent1._();

  @override
  Failure get contentFailure => invalidLastName.failure;
}

/// 2. Using Equatable
class InvalidPersonContent2 extends InvalidEntityContent
    with EquatableMixin, Stringify {
  InvalidPersonContent2(this.firstName, this.invalidName);

  final Name firstName;
  final InvalidName invalidName;

  @override
  Failure get contentFailure => invalidName.failure;

  @override
  List<Object?> get props => [contentFailure, firstName, invalidName];

  @override
  StringifyMode get stringifyMode => StringifyMode.always;
}
