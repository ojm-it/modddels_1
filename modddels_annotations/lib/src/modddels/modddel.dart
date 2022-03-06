import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:modddels_annotations/src/modddels/annotations.dart';
import 'package:modddels_annotations/src/modddels/entities/common.dart';
import 'package:modddels_annotations/src/modddels/value_objects/value_object.dart';

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
    extends Equatable with Stringify {
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
}

/// This is the base class for the "Valid" union-case of a modddel.
///
/// NB : This class's subclasses such as [ValidValueObject] are used as
/// interfaces in the generated "Valid" classes. However, you can directly
/// extend them if you want to have a modddel that is always valid.
///
/// Example :
///
/// ```dart
/// class ValidName extends ValidValueObject<String> {
///   ValidName(this.value);
///
///   @override
///   final String value;
///
///   @override
///   List<Object?> get props => [value];
///
///   @override
///   StringifyMode get stringifyMode => StringifyMode.always;
/// }
/// ```

// Note to self : This extends [Equatable] and mixins [Stringify] for the
// use-case where we directly extend this class's subclasses such as
// [ValidValueObject].
abstract class ValidModddel extends Equatable with Stringify {}

/// This is the base class for the "Invalid" union-case of a modddel.
///
/// NB : This class's subclasses such as [InvalidValueObject] are used as
/// interfaces in the generated "Invalid" classes. However, you can directly
/// extend them if you want to have a modddel that is always invalid.
///
/// Example :
///
/// ```dart
/// class InvalidName extends InvalidValueObject<String,NameValueFailure>{
///
///   InvalidName(this.valueFailure);
///
///   @override
///   final NameValueFailure valueFailure;
///
///   @override
///   List<Object?> get props => [valueFailure];
///
///   @override
///   StringifyMode get stringifyMode => StringifyMode.always;
/// }
/// ```

// Note to self : This extends [Equatable] and mixins [Stringify] for the
// use-case where we directly extend this class's subclasses such as
// [InvalidValueObject].
abstract class InvalidModddel extends Equatable with Stringify {
  Failure get failure;
}

mixin Stringify {
  /// See [Equatable.stringify]
  bool? get stringify {
    switch (stringifyMode) {
      case StringifyMode.always:
        return true;
      case StringifyMode.never:
        return false;
      case StringifyMode.debugMode:
        return null;
    }
  }

  /// See [ModddelAnnotation.stringifyMode]
  StringifyMode get stringifyMode;
}

/// The base class for all the possible failures a [Modddel] can have.
///
/// For example : [ValueFailure], [GeneralFailure], [SizeFailure]...
abstract class Failure {}
