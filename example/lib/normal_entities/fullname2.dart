import 'package:example/value_objects.dart/name.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:modddels_annotations/modddels_annotations.dart';
import 'package:fpdart/fpdart.dart';

part 'fullname2.g.dart';

@modddel
class FullName2 extends Entity<InvalidFullName2Content, ValidFullName2>
    with $FullName2 {
  factory FullName2({
    required Name firstName,
    required Name lastName,
    @valid bool hasMiddleName = false,
  }) {
    return $FullName2._create(
      firstName: firstName,
      lastName: lastName,
      hasMiddleName: hasMiddleName,
    );
  }

  const FullName2._();
}
