import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:modddels_annotations/modddels.dart';

part '_2_multi_value_object.freezed.dart';

/* -------------------------------------------------------------------------- */
/*               Making a MultiValueObject that is always valid               */
/* -------------------------------------------------------------------------- */

/// 1. Using Freezed
@freezed
class ValidUser1 extends ValidValueObject with _$ValidUser1 {
  const factory ValidUser1({required String name, required int age}) =
      _ValidUser1;
}

/// 2. Using Equatable
class ValidUser2 extends ValidValueObject with EquatableMixin, Stringify {
  const ValidUser2({required this.name, required this.age});

  final String name;

  final int age;

  @override
  List<Object?> get props => [name, age];

  @override
  StringifyMode get stringifyMode => StringifyMode.always;
}
