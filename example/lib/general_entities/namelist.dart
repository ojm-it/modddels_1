import 'package:example/value_objects.dart/name.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/collection.dart';
import 'package:modddels_annotations/modddels_annotations.dart';

part 'namelist.freezed.dart';
part 'namelist.g.dart';

@modddel
class NameList extends ListGeneralEntity<
    NameListEntityFailure,
    InvalidNameListGeneral,
    InvalidNameListContent,
    InvalidNameList,
    ValidNameList> with $NameList {
  factory NameList(KtList<Name> list) {
    return $NameList._create(list);
  }

  const NameList._();

  @override
  Option<NameListEntityFailure> validateGeneral(ValidNameList valid) {
    if (valid.list.isEmpty()) {
      return some(const NameListEntityFailure.empty());
    }
    return none();
  }
}

@freezed
class NameListEntityFailure extends GeneralEntityFailure
    with _$NameListEntityFailure {
  const factory NameListEntityFailure.empty() = _Empty;
}
