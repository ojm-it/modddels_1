import 'package:example/value_objects/1_single_value_object/name.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:modddels_annotations/modddels_annotations.dart';
import 'package:fpdart/fpdart.dart';

part 'fullname.freezed.dart';
part 'fullname.g.dart';

@modddel
class FullName extends GeneralEntity<FullNameGeneralFailure, InvalidFullName,
    ValidFullName> with $FullName {
  factory FullName({
    required Name firstName,
    @NullFailure('const FullNameGeneralFailure.incomplete()')
    @withGetter
        required Name? lastName,
    @validWithGetter bool hasMiddleName = false,
  }) {
    return $FullName._create(
      firstName: firstName,
      lastName: lastName,
      hasMiddleName: hasMiddleName,
    );
  }

  const FullName._();

  @override
  Option<FullNameGeneralFailure> validateGeneral(ValidFullName valid) {
    if (valid.firstName.value.length + valid.lastName.value.length > 30) {
      return some(const FullNameGeneralFailure.tooLong());
    }
    return none();
  }
}

@freezed
class FullNameGeneralFailure extends GeneralFailure
    with _$FullNameGeneralFailure {
  const factory FullNameGeneralFailure.tooLong() = _TooLong;
  const factory FullNameGeneralFailure.incomplete() = _Incomplete;
}
