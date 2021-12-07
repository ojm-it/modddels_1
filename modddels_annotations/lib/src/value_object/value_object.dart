import 'package:fpdart/fpdart.dart';
import '../modddel.dart';

/// A [ValueObject] is a [Modddel] that holds a single value, which is validated
/// via the `validateValue` method. This method returns `some` [ValueFailure] if the
/// value is invalid, otherwise returns `none`.
///
/// When creating the SizedListEntity, the validation is made in this order :
///
/// 1. **Value Validation** : If the value is invalid, this [ValueObject] becomes an
///    [InvalidValueObject] that holds the [ValueFailure].
/// 2. **→ Validations passed** : This [ValueObject] is valid, and becomes a
///    [ValidValueObject], from which you can access the valid value.
abstract class ValueObject<
    T,
    F extends ValueFailure<T>,
    I extends InvalidValueObject<T, F>,
    V extends ValidValueObject<T>> extends Modddel<I, V> {
  const ValueObject();

  /// Validates the value that will be held inside this [ValueObject]. This
  /// method should return `some` [ValueFailure] if the value is invalid, otherwise
  /// it should return `none`.
  Option<F> validateValue(T input);
}

/// A [ValidValueObject] is the "valid" union-case of a [ValueObject]. It holds
/// the validated [value].
abstract class ValidValueObject<T> extends ValidModddel {
  /// The validated value.
  T get value;
}

/// An [InvalidValueObject] is is the "invalid" union-case of a [ValueObject]. It
/// holds the [ValueFailure] that made it invalid.
abstract class InvalidValueObject<T, F extends ValueFailure<T>>
    extends InvalidModddel {
  /// The [ValueFailure] that made this [ValueObject] invalid.
  @override
  F get failure;
}

/// A [ValueFailure] is a [Failure] caused by an invalid value of a [ValueObject]
abstract class ValueFailure<T> extends Failure {
  /// The invalid value of the [ValueObject].
  ///
  /// NB : All the freezed subclasses union-cases should have in their constructor the
  /// proprety [failedValue], so that it becomes a class member.
  /// See https://pub.dev/packages/freezed#unionssealed-classes
  T get failedValue;
}
