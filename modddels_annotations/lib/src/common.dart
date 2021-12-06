import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:modddels_annotations/src/entity/entity.dart';

import 'entity/general_entity.dart';
import 'value_object/value_object.dart';

///The base class for [Entity], [GeneralEntity] and [ValueObject]
abstract class Modddel<I extends InvalidModddel, V extends ValidModddel>
    with EquatableMixin {
  const Modddel();

  ///Whether this [ValueObject] is a [ValidValueObject]
  bool get isValid => mapValidity(
        valid: (valid) => true,
        invalid: (invalid) => false,
      );

  ///Executes [valid] when this [ValueObject] is valid, otherwise executes [invalid].
  TResult mapValidity<TResult extends Object?>({
    required TResult Function(V valid) valid,
    required TResult Function(I invalid) invalid,
  });

  ///Converts this [ValueObject] to an [Either] where left is
  ///[InvalidValueObject], and right is [ValidValueObject].
  Either<I, V> get toEither => mapValidity(
        valid: (valid) => right(valid),
        invalid: (invalid) => left(invalid),
      );

  ///Same as [toEither], but the left is broadened to be the [Failure] that
  ///caused this [ValueObject] to be invalid.
  ///
  ///NB: The [Failure] is always a [ValueFailure], but the type is broaded to
  ///[Failure] on purpose.
  Either<Failure, V> get toBroadEither => mapValidity(
        valid: (valid) => right(valid),
        invalid: (invalid) => left(invalid.failure),
      );

  ///This is the list of all the class members, used by Equatable for the
  ///hashCode and equality functions.
  @override
  List<Object?> get props => mapValidity(
        valid: (valid) => valid.allProps,
        invalid: (invalid) => invalid.allProps,
      );
}

abstract class ValidModddel {
  ///This is the list of all the class members, used by Equatable for the
  ///hashCode and equality functions.
  List<Object?> get allProps;
}

abstract class InvalidModddel {
  Failure get failure;

  ///This is the list of all the class members, used by Equatable for the
  ///hashCode and equality functions.
  List<Object?> get allProps;
}

///The base class for [GeneralFailure] and [ValueFailure]
abstract class Failure {}
