import 'package:fpdart/fpdart.dart';
import 'package:modddels_annotations/src/modddels/modddel.dart';

/// A [ValueObject] is a [Modddel] that holds a "value", which is validated via
/// the `validateValue` method. This method returns `some` [ValueFailure] if the
/// value is invalid, otherwise returns `none`.
///
/// When creating the ValueObject, the validation is made in this order :
///
/// 1. **Value Validation** : If the value is invalid, this [ValueObject]
///    becomes an [InvalidValueObject] that holds the [ValueFailure].
/// 2. **→ Validations passed** : This [ValueObject] is valid, and becomes a
///    [ValidValueObject], from which you can access the valid value.
abstract class ValueObject<
    F extends ValueFailure,
    I extends InvalidValueObject<F>,
    V extends ValidValueObject> extends Modddel<I, V> {
  const ValueObject();

  /// Validates the value that will be held inside this [ValueObject]. This
  /// method should return `some` [ValueFailure] if the value is invalid,
  /// otherwise it should return `none`.
  Option<F> validateValue(V input);
}

/// A [ValidValueObject] is the "valid" union-case of a [ValueObject]. It holds
/// the validated "value".
abstract class ValidValueObject extends ValidModddel {
  const ValidValueObject();
}

/// An [InvalidValueObject] is is the "invalid" union-case of a [ValueObject].
/// It holds the [ValueFailure] that made it invalid.
abstract class InvalidValueObject<F extends ValueFailure>
    extends InvalidModddel {
  const InvalidValueObject();

  /// The [ValueFailure] that made this [ValueObject] invalid.
  F get valueFailure;

  // Note to self : We override `failure` for easier usage when we directly
  // extend this class.
  @override
  Failure get failure => valueFailure;
}

/// A [ValueFailure] is a [Failure] caused by an invalid value of a
/// [ValueObject]
abstract class ValueFailure extends Failure {
  const ValueFailure();
}
