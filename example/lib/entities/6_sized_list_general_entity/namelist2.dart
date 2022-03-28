import 'package:example/value_objects/1_single_value_object/name.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/collection.dart';
import 'package:modddels_annotations/modddels_annotations.dart';

part 'namelist2.freezed.dart';
part 'namelist2.modddel.dart';

@modddel
class NameList2 extends SizedListGeneralEntity<NameList2SizeFailure,
    NameList2GeneralFailure, InvalidNameList2, ValidNameList2> with $NameList2 {
  factory NameList2(KtList<Name> list) {
    return $NameList2._create(list);
  }

  static const hackerName = 'anonymous';

  const NameList2._();

  @override
  Option<NameList2SizeFailure> validateSize(int listSize) {
    if (listSize == 0) {
      return some(const NameList2SizeFailure.empty());
    }
    return none();
  }

  @override
  Option<NameList2GeneralFailure> validateGeneral(ValidNameList2 valid) {
    if (valid.list.any((element) => element.value == hackerName)) {
      return some(const NameList2GeneralFailure.compromised());
    }
    return none();
  }
}

@freezed
class NameList2SizeFailure extends SizeFailure with _$NameList2SizeFailure {
  const factory NameList2SizeFailure.empty() = _Empty;
}

@freezed
class NameList2GeneralFailure extends GeneralFailure
    with _$NameList2GeneralFailure {
  const factory NameList2GeneralFailure.compromised() = _Compromised;
}
