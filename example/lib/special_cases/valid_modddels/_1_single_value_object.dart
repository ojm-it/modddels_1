import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:modddels_annotations/modddels.dart';

part '_1_single_value_object.freezed.dart';

/* -------------------------------------------------------------------------- */
/*               Making a SingleValueObject that is always valid              */
/* -------------------------------------------------------------------------- */

/// 1. Using Freezed
@freezed
class ValidId1 extends ValidSingleValueObject<String> with _$ValidId1 {
  const factory ValidId1(String value) = _ValidId1;
}

/// 2. Using Equatable
class ValidId2 extends ValidSingleValueObject<String>
    with EquatableMixin, Stringify {
  const ValidId2(this.value);

  @override
  final String value;

  @override
  List<Object?> get props => [value];

  @override
  StringifyMode get stringifyMode => StringifyMode.always;
}
