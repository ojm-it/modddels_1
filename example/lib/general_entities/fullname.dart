import 'package:example/value_objects.dart/name.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:modddels_annotations/modddels_annotations.dart';
import 'package:fpdart/fpdart.dart';

part 'fullname.g.dart';
part 'fullname.freezed.dart';

@modddel
class FullName
    extends GeneralEntity<FullNameEntityFailure, InvalidFullName, ValidFullName>
    with $FullName {
  factory FullName({
    required Name firstName,
    @withGetter required Name lastName,
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
  Option<FullNameEntityFailure> validateGeneral(ValidFullName valid) {
    if (valid.firstName.value.length + valid.lastName.value.length > 30) {
      return some(const FullNameEntityFailure.tooLong());
    }
    return none();
  }
}

@freezed
class FullNameEntityFailure extends GeneralEntityFailure
    with _$FullNameEntityFailure {
  const factory FullNameEntityFailure.tooLong() = _TooLong;
}
