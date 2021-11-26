import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/collection.dart';
import 'package:modddels_annotations/modddels_annotations.dart';
import 'package:example/name.dart';

part 'namelist.freezed.dart';
part 'namelist.g.dart';

@modddel
class NameList extends KtListEntity<
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
    //TODO Implement validate
    return none();
  }
}

@freezed
class NameListEntityFailure extends GeneralEntityFailure
    with _$NameListEntityFailure {
  const factory NameListEntityFailure.empty() = _Empty;
}
