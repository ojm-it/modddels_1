import 'package:fpdart/fpdart.dart';
import 'package:modddels_annotations/modddels_annotations.dart';

part 'profile.g.dart';

@modddel
class Name extends ValueObject<String, NameValueFailure, InvalidName, ValidName>
    with _$Name {
  factory Name(String input) {
    return _$Name.create(input);
  }

  const Name._();
}
