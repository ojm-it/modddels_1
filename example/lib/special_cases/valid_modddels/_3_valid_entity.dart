/* -------------------------------------------------------------------------- */
/*                 Making a SimpleEntity that is always valid                 */
/* -------------------------------------------------------------------------- */

import 'package:equatable/equatable.dart';
import 'package:example/entities/4_general_entity/fullname.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:modddels_annotations/modddels.dart';

part '_3_valid_entity.freezed.dart';

/* -------------------------------------------------------------------------- */
/*                    Making an Entity that is always valid                   */
/* -------------------------------------------------------------------------- */

/// 1. Using Freezed
@freezed
class ValidPerson1 extends ValidEntity with _$ValidPerson1 {
  const factory ValidPerson1({
    required ValidFullName validFullName,
    required bool isOld,
  }) = _ValidPerson1;
}

/// 2. Using Equatable
class ValidPerson2 extends ValidEntity with EquatableMixin, Stringify {
  const ValidPerson2({
    required this.validFullName,
    required this.isOld,
  });

  final ValidFullName validFullName;
  final bool isOld;

  @override
  List<Object?> get props => [validFullName, isOld];

  @override
  StringifyMode get stringifyMode => StringifyMode.always;
}
