import 'package:example/value_objects/1_single_value_object/name.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/collection.dart';
import 'package:modddels_annotations/modddels_annotations.dart';

part 'whitelist.freezed.dart';
part 'whitelist.modddel.dart';

@modddel
class WhiteList extends SizedListEntity<WhiteListSizeFailure, InvalidWhiteList,
    ValidWhiteList> with $WhiteList {
  static const maxLength = 10;

  factory WhiteList(KtList<Name> list) {
    return $WhiteList._create(list);
  }

  const WhiteList._();

  @override
  Option<WhiteListSizeFailure> validateSize(int listSize) {
    if (listSize > maxLength) {
      return some(const WhiteListSizeFailure.tooBig());
    }
    return none();
  }
}

@freezed
class WhiteListSizeFailure extends SizeFailure with _$WhiteListSizeFailure {
  const factory WhiteListSizeFailure.tooBig() = _TooBig;
}
