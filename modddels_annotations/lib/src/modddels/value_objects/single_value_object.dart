import 'package:modddels_annotations/src/modddels/value_objects/value_object.dart';

/// A [SingleValueObject] is a [ValueObject] that holds a single value.
abstract class SingleValueObject<
    T extends Object?,
    F extends ValueFailure,
    I extends InvalidSingleValueObject<T, F>,
    V extends ValidSingleValueObject<T>> extends ValueObject<F, I, V> {
  const SingleValueObject();
}

/// A [ValidValueObject] is the "valid" union-case of a [SingleValueObject]. It
/// holds the validated [value].
abstract class ValidSingleValueObject<T> extends ValidValueObject {
  const ValidSingleValueObject();

  /// The validated value.
  T get value;
}

/// An [InvalidSingleValueObject] is the "invalid" union-case of a
/// [SingleValueObject]. It holds the [failedValue] that made it invalid.
abstract class InvalidSingleValueObject<T, F extends ValueFailure>
    extends InvalidValueObject<F> {
  const InvalidSingleValueObject();

  /// The invalid value of the [SingleValueObject].
  T get failedValue;
}
