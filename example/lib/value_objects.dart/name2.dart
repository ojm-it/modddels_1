import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:modddels_annotations/modddels_annotations.dart';

part 'name2.freezed.dart';
part 'name2.g.dart';

@modddel
class Name2 extends NullableValueObject<String, Name2ValueFailure, InvalidName2,
    ValidName2> with $Name2 {
  factory Name2(String? input) {
    return $Name2._create(input);
  }

  const Name2._();

  @override
  Option<Name2ValueFailure> validateValue(String input) {
    //TODO Implement validateValue
    return none();
  }

  @override
  Name2ValueFailure nullFailure() {
    return const Name2ValueFailure.empty(failedValue: null);
  }
}

@freezed
class Name2ValueFailure extends ValueFailure<String?> with _$Name2ValueFailure {
  const factory Name2ValueFailure.empty({
    required String? failedValue,
  }) = _Empty;
}
