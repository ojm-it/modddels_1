import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:modddels_annotations/modddels.dart';

part '_1_single_value_object.freezed.dart';

/* -------------------------------------------------------------------------- */
/*              Making a SingleValueObject that is always invalid             */
/* -------------------------------------------------------------------------- */

/// 1. Using Freezed
@freezed
class InvalidId extends InvalidSingleValueObject<String, IdValueFailure>
    with _$InvalidId {
  const factory InvalidId({
    required String failedValue,
    required IdValueFailure valueFailure,
  }) = _InvalidId;

  const InvalidId._();
}

/// 2. Using Equatable
class InvalidId2 extends InvalidSingleValueObject<String, IdValueFailure>
    with EquatableMixin, Stringify {
  const InvalidId2({
    required this.valueFailure,
    required this.failedValue,
  });

  @override
  final IdValueFailure valueFailure;

  @override
  final String failedValue;

  @override
  List<Object?> get props => [valueFailure, failedValue];

  @override
  StringifyMode get stringifyMode => StringifyMode.always;
}

/// --------------
@freezed
class IdValueFailure extends ValueFailure with _$IdValueFailure {
  const factory IdValueFailure.invalid() = _Invalid;
}
