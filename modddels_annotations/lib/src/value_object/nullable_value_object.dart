import 'package:fpdart/fpdart.dart';
import 'package:modddels_annotations/src/modddel.dart';
import 'package:modddels_annotations/src/value_object/value_object.dart';

///
abstract class NullableValueObject<
    T extends Object,
    F extends ValueFailure<T?>,
    I extends InvalidValueObject<T?, F>,
    V extends ValidValueObject<T>> extends Modddel<I, V> {
  const NullableValueObject();

  /// Validates the value that will be held inside this [ValueObject]. This
  /// method should return `some` [ValueFailure] if the value is invalid, otherwise
  /// it should return `none`.
  Option<F> validateValue(T input);

  /// This should return the [ValueFailure] corresponding to when the value is
  /// `null`.
  F nullFailure();
}
