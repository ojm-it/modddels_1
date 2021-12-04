import 'package:example/value_objects.dart/name.dart';
import 'package:fpdart/fpdart.dart';
import 'package:kt_dart/collection.dart';
import 'package:modddels_annotations/modddels_annotations.dart';

part 'namelist2.g.dart';

@modddel
class NameList2 extends KtListEntity<InvalidNameList2Content, ValidNameList2>
    with $NameList2 {
  factory NameList2(KtList<Name> list) {
    return $NameList2._create(list);
  }

  const NameList2._();
}
