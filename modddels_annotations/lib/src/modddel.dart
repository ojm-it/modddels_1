import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:modddels_annotations/modddels_annotations.dart';

/// This is the base class for all the Modddels.
///
/// Modddels are "validated" objects that can have two states : Valid or
/// Invalid.
///
/// Depending on the modddel, there are different types of validations, which
/// are run in a specific order. If all the validations pass, then the modddel
/// is Valid. Otherwise, it is Invalid and holds a failure. The Invalid state is
/// further subdivided into multiple states, each one corresponding to a failed
/// validation.
///
/// Each state is represented by a Union case class.

abstract class Modddel<I extends InvalidModddel, V extends ValidModddel>
    extends Equatable {
  const Modddel();

  /// Whether this [Modddel] is a valid or not.
  bool get isValid => mapValidity(
        valid: (valid) => true,
        invalid: (invalid) => false,
      );

  /// Executes [valid] when this [Modddel] is valid, otherwise executes [invalid].
  TResult mapValidity<TResult extends Object?>({
    required TResult Function(V valid) valid,
    required TResult Function(I invalid) invalid,
  });

  /// Converts this [Modddel] to an [Either] where left is
  /// the invalid union-case, and right is the valid union-case.
  Either<I, V> get toEither => mapValidity(
        valid: (valid) => right(valid),
        invalid: (invalid) => left(invalid),
      );

  /// Converts this [Modddel] to an [Either] where left is the [Failure] of the
  /// invalid union-case, and right is the valid union-case.
  Either<Failure, V> get toBroadEither => mapValidity(
        valid: (valid) => right(valid),
        invalid: (invalid) => left(invalid.failure),
      );

  /// This is the list of all the class members, used by Equatable for the
  /// hashCode and equality functions.
  @override
  List<Object?> get props => mapValidity(
        valid: (valid) => valid.allProps,
        invalid: (invalid) => invalid.allProps,
      );
}

/// This is the base class for the "Valid" union-case of a modddel.
abstract class ValidModddel {
  /// This is the list of all the class members, used by Equatable for the
  /// hashCode and equality functions.
  List<Object?> get allProps;
}

/// This is the base class for the "Invalid" union-case of a modddel.
abstract class InvalidModddel {
  Failure get failure;

  /// This is the list of all the class members, used by Equatable for the
  /// hashCode and equality functions.
  List<Object?> get allProps;
}

/// The base class for all the possible failures a [Modddel] can have.
///
/// For example : [ValueFailure], [GeneralFailure], [SizeFailure]...
abstract class Failure {}
