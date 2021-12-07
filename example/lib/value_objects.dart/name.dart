import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:modddels_annotations/modddels_annotations.dart';

part 'name.g.dart';
part 'name.freezed.dart';

@modddel
class Name extends ValueObject<String, NameValueFailure, InvalidName, ValidName>
    with $Name {
  factory Name(String input) {
    return $Name._create(input);
  }

  const Name._();

  @override
  Option<NameValueFailure> validateValue(String input) {
    if (input.isEmpty) {
      return some(NameValueFailure.empty(failedValue: input));
    }
    return none();
  }
}

@freezed
class NameValueFailure extends ValueFailure<String> with _$NameValueFailure {
  const factory NameValueFailure.empty({
    required String failedValue,
  }) = _Empty;
}
