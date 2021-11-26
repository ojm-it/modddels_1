import 'package:example/fullname.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/collection.dart';
import 'package:modddels_annotations/modddels_annotations.dart';

part 'fullname_list.g.dart';
part 'fullname_list.freezed.dart';

@modddel
class FullNameList extends KtListEntity<
    FullNameListEntityFailure,
    InvalidFullNameListGeneral,
    InvalidFullNameListContent,
    InvalidFullNameList,
    ValidFullNameList> with $FullNameList {
  factory FullNameList(KtList<FullName> list) {
    return $FullNameList._create(list);
  }

  const FullNameList._();

  @override
  Option<FullNameListEntityFailure> validateGeneral(ValidFullNameList valid) {
    //TODO Implement validate
    return none();
  }
}

@freezed
class FullNameListEntityFailure extends GeneralEntityFailure
    with _$FullNameListEntityFailure {
  const factory FullNameListEntityFailure.empty() = _Empty;
}
