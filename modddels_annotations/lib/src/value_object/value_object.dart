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
    V extends ValidValueObject<T>> extends Equatable with Modddel {
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

  ///Whether this [ValueObject] is a [ValidValueObject]
  bool get isValid => map(valid: (valid) => true, invalid: (invalid) => false);

  ///Executes [valid] when this [ValueObject] is valid, otherwise executes [invalid].
  TResult map<TResult extends Object?>({
    required TResult Function(V valid) valid,
    required TResult Function(I invalid) invalid,
  });

  ///Converts this [ValueObject] to an [Either] where left is
  ///[InvalidValueObject], and right is [ValidValueObject].
  Either<I, V> get toEither => map(
        valid: (valid) => right(valid),
        invalid: (invalid) => left(invalid),
      );

  ///Same as [toEither], but the left is broadened to be the [Failure] that
  ///caused this [ValueObject] to be invalid.
  ///
  ///NB: The [Failure] is always a [ValueFailure], but the type is broaded to
  ///[Failure] on purpose.
  Either<Failure, V> get toBroadEither => map(
        valid: (valid) => right(valid),
        invalid: (invalid) => left(invalid.failure),
      );

  ///This is the list of all the class members, used by Equatable for the
  ///hashCode and equality functions.
  @override
  List<Object?> get props => map(
      valid: (valid) => valid.allProps, invalid: (invalid) => invalid.allProps);
}

///A [ValidValueObject] is a [ValueObject] that is valid. It holds the validated
///[value] of type [T].
abstract class ValidValueObject<T> {
  T get value;

  ///This is the list of all the class members, used by Equatable for the
  ///hashCode and equality functions.
  List<Object?> get allProps;
}

///An [InvalidValueObject] is a [ValueObject] that is invalid. It holds the
///[ValueFailure] that made it invalid.
abstract class InvalidValueObject<T, F extends ValueFailure<T>> {
  F get failure;

  ///This is the list of all the class members, used by Equatable for the
  ///hashCode and equality functions.
  List<Object?> get allProps;
}

///A [ValueFailure] is a [Failure] caused by an invalid value of a [ValueObject]
abstract class ValueFailure<T> implements Failure {
  ///All the freezed subclasses union cases should have in their constructor the
  ///proprety [failedValue], so that it becomes accessible.
  ///
  ///See https://pub.dev/packages/freezed#unionssealed-classes
  T get failedValue;
}
