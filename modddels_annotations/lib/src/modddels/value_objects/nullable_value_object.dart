import 'package:fpdart/fpdart.dart';
import 'package:modddels_annotations/modddels.dart';

/// If your ValueObject holds a nullable value that you want to be non-nullable
/// in the `ValidValueObject`, then you should use instead a
/// `NullableValueObject`.
///
/// Example :
///
/// ```dart
/// @modddel
/// class Name2 extends NullableValueObject<String, Name2ValueFailure, InvalidName2,
///     ValidName2> with $Name2 {
///   factory Name2(String? input) {
///     return $Name2._create(input);
///   }
///
///   const Name2._();
///
///   @override
///   Option<Name2ValueFailure> validateValue(String input) {
///     ...
///   }
///
///   @override
///   Name2ValueFailure nullFailure() {
///     return const Name2ValueFailure.none(failedValue: null);
///   }
/// }
///
/// @freezed
/// class Name2ValueFailure extends ValueFailure<String?> with _$Name2ValueFailure {
///   const factory Name2ValueFailure.none({
///     required String? failedValue,
///   }) = _None;
/// }
///
/// ```
///
/// Here, if the value is null, then the ValueObject will be an
/// `InvalidValueObject` with a value failure `Name2ValueFailure.none`.
///
/// >**NB :** This null verification is done just before the `validateValue`
/// >method is called. So the value passed in the `validateValue` method will be
/// >non-nullable.
abstract class NullableValueObject<
    T extends Object,
    F extends ValueFailure<T?>,
    I extends InvalidValueObject<T?, F>,
    V extends ValidValueObject<T>> extends Modddel<I, V> {
  const NullableValueObject();

  /// Validates the value that will be held inside this [NullableValueObject].
  /// This method should return `some` [ValueFailure] if the value is invalid,
  /// otherwise it should return `none`.
  Option<F> validateValue(T input);

  /// This should return the [ValueFailure] corresponding to when the value is
  /// `null`.
  F nullFailure();
}
