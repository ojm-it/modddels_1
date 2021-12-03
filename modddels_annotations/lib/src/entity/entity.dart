import 'package:fpdart/fpdart.dart';
import 'package:modddels_annotations/src/entity/common.dart';

import '../common.dart';
import 'package:equatable/equatable.dart';
import '../value_object/value_object.dart';

///An [Entity] is a [Modddel] that holds multiple modddels : [ValueObject]s or
///Entities.
///
/// - If any of its moddels is invalid, then this [Entity will ] be an
///   [InvalidEntityContent] of type [C].
///
/// - If all the modddels are valid, then this [Entity] will be a
///     [ValidEntity] of type [V]
///
abstract class Entity<C extends InvalidEntityContent, V extends ValidEntity>
    extends Equatable with Modddel {
  const Entity();

  ///This is the list of all the class members, used by Equatable for the
  ///hashCode and equality functions.
  @override
  List<Object?> get props => match(
      valid: (valid) => valid.allProps, invalid: (invalid) => invalid.allProps);

  ///Whether this [Entity] is a [ValidEntity]
  bool get isValid =>
      match(valid: (valid) => true, invalid: (invalid) => false);

  ///Execute [valid] when this [Entity] is valid, otherwise execute [invalid].
  TResult match<TResult extends Object?>({
    required TResult Function(V valid) valid,
    required TResult Function(C invalid) invalid,
  });

  ///Converts this [Entity] to an [Either] where left is [InvalidEntityContent], and
  ///right is [ValidEntity].
  Either<C, V> get toEither => match(
        valid: (valid) => right(valid),
        invalid: (invalid) => left(invalid),
      );

  ///Same as [toEither], but the left is broadened to be the [Failure] of one of
  ///the modddels, that caused this [Entity] to be invalid.
  Either<Failure, V> get toBroadEither => match(
      valid: (valid) => right(valid),
      invalid: (invalid) => left(invalid.contentFailure));
}
