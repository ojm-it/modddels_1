import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:modddels_annotations/modddels_annotations.dart';

part 'name.freezed.dart';
part 'name.modddel.dart';

@modddel
class Name extends MultiValueObject<NameValueFailure, InvalidName, ValidName>
    with $Name {
  factory Name({
    /// The first name.
    required String firstName,

    /// The last name, important too.
    @NullFailure('const NameValueFailure.incomplete()')
        required String? lastName,
    bool? hasMiddleName = false,
  }) {
    return $Name._create(
      firstName: firstName,
      lastName: lastName,
      hasMiddleName: hasMiddleName,
    );
  }

  const Name._();

  @override
  Option<NameValueFailure> validateValue(ValidName input) {
    if (input.firstName.isEmpty && input.lastName.isEmpty) {
      return some(const NameValueFailure.empty());
    }
    return none();
  }
}

@freezed
class NameValueFailure extends ValueFailure with _$NameValueFailure {
  const factory NameValueFailure.empty() = _Empty;
  const factory NameValueFailure.incomplete() = _Incomplete;
}
