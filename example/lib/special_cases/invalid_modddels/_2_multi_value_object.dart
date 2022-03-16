import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:modddels_annotations/modddels.dart';

part '_2_multi_value_object.freezed.dart';

/* -------------------------------------------------------------------------- */
/*              Making a MultiValueObject that is always invalid              */
/* -------------------------------------------------------------------------- */

/// 1. Using Freezed
@freezed
class InvalidBook1 extends InvalidValueObject<BookValueFailure>
    with _$InvalidBook1 {
  const factory InvalidBook1(
      {required BookValueFailure valueFailure,
      required String title,
      required String author,
      required}) = _InvalidBook1;

  const InvalidBook1._();
}

/// 2. Using Equatable
class InvalidBook2 extends InvalidValueObject with EquatableMixin, Stringify {
  const InvalidBook2({
    required this.valueFailure,
    required this.title,
    required this.author,
  });

  @override
  final BookValueFailure valueFailure;

  final String author;
  final String title;

  @override
  List<Object?> get props => [valueFailure, author, title];

  @override
  StringifyMode get stringifyMode => StringifyMode.always;
}

/// --------------
@freezed
class BookValueFailure extends ValueFailure with _$BookValueFailure {
  const factory BookValueFailure.invalid() = _Invalid;
}
