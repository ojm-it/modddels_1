import 'package:example/value_objects/1_single_value_object/name.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/collection.dart';
import 'package:modddels_annotations/modddels_annotations.dart';

part 'namelist.freezed.dart';
part 'namelist.modddel.dart';

@modddel
class NameList extends ListGeneralEntity<NameListGeneralFailure,
    InvalidNameList, ValidNameList> with $NameList {
  factory NameList(KtList<Name> list) {
    return $NameList._create(list);
  }

  static const hackerName = 'anonymous';

  const NameList._();

  @override
  Option<NameListGeneralFailure> validateGeneral(ValidNameList valid) {
    if (valid.list.any((element) => element.value == hackerName)) {
      return some(const NameListGeneralFailure.compromised());
    }
    return none();
  }
}

@freezed
class NameListGeneralFailure extends GeneralFailure
    with _$NameListGeneralFailure {
  const factory NameListGeneralFailure.compromised() = _Compromised;
}
