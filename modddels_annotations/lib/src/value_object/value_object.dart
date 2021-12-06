import 'package:fpdart/fpdart.dart';
import 'package:equatable/equatable.dart';
import '../common.dart';

///A [ValueObject] is a [Modddel] that holds a value of type [T].
///
///When you instantiate the [ValueObject] with the input value, it is validated
///with the [validate] method.
/// - If it's valid, then this [ValueObject] will be a [ValidValueObject] of
///   type [V], that holds the value.
/// - If it's invalid, then this [ValueObject] will be an [InvalidValueObject]
///   of type [I], that holds the [ValueFailure] of type [F]
abstract class ValueObject<
    T,
    F extends ValueFailure<T>,
    I extends InvalidValueObject<T, F>,
    V extends ValidValueObject<T>> extends Modddel<I, V> {
  const ValueObject();

  ///Validates the value that will be held inside this [ValueObject].
  /// - If it returns some() [ValueFailure], then this [ValueObject] will be an [InvalidValueObject]
  /// - If it returns none() [ValueFailure], then this [ValueObject] will be a [ValidValueObject]
  Option<F> validate(T input);

  ///Helper method that converts the [validate] result to an [Either] where left
  ///is [ValueFailure], and right is the value [T].
  Either<F, T> validateWithResult(T input) {
    return validate(input).match(
      (valueFailure) => left(valueFailure),
      () => right(input),
    );
  }
}

///A [ValidValueObject] is a [ValueObject] that is valid. It holds the validated
///[value] of type [T].
abstract class ValidValueObject<T> extends ValidModddel {
  T get value;
}

///An [InvalidValueObject] is a [ValueObject] that is invalid. It holds the
///[ValueFailure] that made it invalid.
abstract class InvalidValueObject<T, F extends ValueFailure<T>>
    extends InvalidModddel {
  @override
  F get failure;
}

///A [ValueFailure] is a [Failure] caused by an invalid value of a [ValueObject]
abstract class ValueFailure<T> extends Failure {
  ///All the freezed subclasses union cases should have in their constructor the
  ///proprety [failedValue], so that it becomes accessible.
  ///
  ///See https://pub.dev/packages/freezed#unionssealed-classes
  T get failedValue;
}
