import 'package:example/value_objects.dart/name.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/collection.dart';
import 'package:modddels_annotations/modddels_annotations.dart';

part 'namelist4.freezed.dart';
part 'namelist4.g.dart';

@modddel
class NameList4 extends SizedListGeneralEntity<NameList4SizeFailure,
    NameList4GeneralFailure, InvalidNameList4, ValidNameList4> with $NameList4 {
  factory NameList4(KtList<Name> list) {
    return $NameList4._create(list);
  }

  const NameList4._();

  @override
  Option<NameList4SizeFailure> validateSize(int listSize) {
    if (listSize == 0) {
      return some(const NameList4SizeFailure.empty());
    }
    return none();
  }

  @override
  Option<NameList4GeneralFailure> validateGeneral(ValidNameList4 valid) {
    if (valid.list.all((element) => element.value == 'Bizarre')) {
      return some(const NameList4GeneralFailure.bizarre());
    }
    return none();
  }
}

@freezed
class NameList4SizeFailure extends SizeFailure with _$NameList4SizeFailure {
  const factory NameList4SizeFailure.empty() = _Empty;
}

@freezed
class NameList4GeneralFailure extends GeneralFailure
    with _$NameList4GeneralFailure {
  const factory NameList4GeneralFailure.bizarre() = _Bizarre;
}
