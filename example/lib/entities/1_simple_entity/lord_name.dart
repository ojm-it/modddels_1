import 'package:example/value_objects/1_single_value_object/name.dart';
import 'package:modddels_annotations/modddels_annotations.dart';
import 'package:fpdart/fpdart.dart';

part 'lord_name.g.dart';

@modddel
class LordName extends SimpleEntity<InvalidLordNameContent, ValidLordName>
    with $LordName {
  factory LordName({
    required Name parentName,
    required Name firstName,
    @valid bool isLord = true,
  }) {
    return $LordName._create(
      firstName: firstName,
      parentName: parentName,
      isLord: isLord,
    );
  }

  const LordName._();
}
