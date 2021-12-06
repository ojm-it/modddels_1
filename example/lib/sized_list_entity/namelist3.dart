import 'package:example/value_objects.dart/name.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/collection.dart';
import 'package:modddels_annotations/modddels_annotations.dart';

part 'namelist3.g.dart';
part 'namelist3.freezed.dart';

@modddel
class NameList3 extends SizedListEntity<NameList3SizeFailure, InvalidNameList3,
    ValidNameList3> with $NameList3 {
  factory NameList3(KtList<Name> list) {
    return $NameList3._create(list);
  }

  const NameList3._();

  @override
  Option<NameList3SizeFailure> validateSize(int listSize) {
    if (listSize == 0) {
      return some(const NameList3SizeFailure.empty());
    }
    return none();
  }
}

@freezed
class NameList3SizeFailure extends SizeFailure with _$NameList3SizeFailure {
  const factory NameList3SizeFailure.empty() = _Empty;
}
