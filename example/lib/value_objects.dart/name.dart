import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:modddels_annotations/modddels_annotations.dart';

part 'name.g.dart';
part 'name.freezed.dart';

@modddel
class Name
    extends SingleValueObject<String, NameValueFailure, InvalidName, ValidName>
    with $Name {
  factory Name(String input) {
    final sanitizedInput = input.trim();
    return $Name._create(sanitizedInput);
  }

  const Name._();

  @override
  Option<NameValueFailure> validateValue(ValidName input) {
    if (input.value.isEmpty) {
      return some(const NameValueFailure.empty());
    }
    return none();
  }
}

@freezed
class NameValueFailure extends ValueFailure with _$NameValueFailure {
  const factory NameValueFailure.empty() = _Empty;
}
