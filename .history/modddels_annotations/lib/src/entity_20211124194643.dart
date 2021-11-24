import 'common.dart';
import 'package:equatable/equatable.dart';

///An [Entity] is a [Modddel] that holds multiple modddels : [ValueObject]s or
///Entities.
///
///When instantiated, it first verifies that all its modddels are valid.
/// - If one of its modddels is invalid, then this [Entity] will be an
///   [InvalidEntity] of type [I], more precisely an [InvalidEntityContent] of
///   type [C].
/// - If all the modddels are valid, then this [Entity] is validated with the
///   [validateGeneral] method.
///   - If it's invalid, then this [Entity] will be an [InvalidEntity] of type
///     [I], more precisely, an [InvalidEntityGeneral] of type [G]
///   - If it's valid, then this [Entity] will be a [ValidEntity] of type [V]
abstract class Entity<
    F extends GeneralEntityFailure,
    G extends InvalidEntityGeneral<F>,
    C extends InvalidEntityContent,
    I extends InvalidEntity<F, G, C>,
    V extends ValidEntity> extends Equatable with Modddel {
  const Entity();

  ///This is the list of all the class members, used by Equatable for the
  ///hashCode and equality functions.
  @override
  List<Object?> get props => match(
      valid: (valid) => valid.allProps, invalid: (invalid) => invalid.allProps);

  ///After this [Entity]'s modddels have been validated and are valid, this
  ///validates the entity as a whole.
  /// - If it returns some() [GeneralEntityFailure], then this [Entity] will be
  ///   an [InvalidEntityContent]
  /// - If it returns none() [GeneralEntityFailure], then this [Entity] will be
  ///   a [ValidEntity]
  Option<F> validateGeneral(V valid);

  ///Whether this [Entity] is a [ValidEntity]
  bool get isValid =>
      match(valid: (valid) => true, invalid: (invalid) => false);

  ///Execute [valid] when this [Entity] is valid, otherwise execute [invalid].
  TResult match<TResult extends Object?>({
    required TResult Function(V value) valid,
    required TResult Function(I value) invalid,
  });

  ///Converts this [Entity] to an [Either] where left is [InvalidEntity], and
  ///right is [ValidEntity].
  Either<I, V> get toEither => match(
        valid: (valid) => right(valid),
        invalid: (invalid) => left(invalid),
      );

  ///Same as [toEither], but the left is broadened to be the [Failure] that
  ///caused this [Entity] to be invalid.
  ///
  ///NB: The [Failure] is either a [GeneralEntityFailure] of this entity, or a
  ///[Failure] of one of its modddels
  Either<Failure, V> get toBroadEither => match(
      valid: (valid) => right(valid),
      invalid: (invalid) => left(invalid.invalidMatch(
          invalidEntityGeneral: (invalidEntityGeneral) =>
              invalidEntityGeneral.generalEntityFailure,
          invalidEntityContent: (invalidEntityContent) =>
              invalidEntityContent.contentFailure)));
}

///A [ValidEntity] is an [Entity] that is valid. It holds all the valid
///modddels as [ValidValueObject]s / [ValidEntity]s.
abstract class ValidEntity {
  ///This is the list of all the class members, used by Equatable for the
  ///hashCode and equality functions.
  List<Object?> get allProps;
}

///An [InvalidEntity] is an [Entity] that is invalid. It can either be :
/// - An [InvalidEntityContent]
/// - An [InvalidEntityGeneral]
abstract class InvalidEntity<F extends GeneralEntityFailure,
    G extends InvalidEntityGeneral<F>, C extends InvalidEntityContent> {
  ///Executes [invalidEntityGeneral] when this [InvalidEntity] is an
  ///[InvalidEntityGeneral], and executes [invalidEntityContent] when it is an
  ///[InvalidEntityContent].
  TResult invalidMatch<TResult extends Object?>({
    required TResult Function(G invalidEntityGeneral) invalidEntityGeneral,
    required TResult Function(C invalidEntityContent) invalidEntityContent,
  });

  ///Same as [invalidMatch], but gives a direct access to the failures in the
  ///callbacks
  TResult invalidWhen<TResult extends Object?>({
    required TResult Function(F generalEntityFailure) generalEntityFailure,
    required TResult Function(Failure contentFailure) contentFailure,
  });

  ///This is the list of all the class members, used by Equatable for the
  ///hashCode and equality functions.
  List<Object?> get allProps;
}

///entities) An [InvalidEntityContent] is an [InvalidEntity] because one of its
///modddels is invalid. It holds the [Failure] of the invalid modddel.
abstract class InvalidEntityContent {
  ///The failure of the invalid modddel inside this [Entity]
  Failure get contentFailure;
}

///An [InvalidEntityGeneral] is an [InvalidEntity] caused by a
///[GeneralEntityFailure]. All the modddels inside this [Entity] are valid, but
///the [Entity] as a whole is invalid.
///
abstract class InvalidEntityGeneral<F extends GeneralEntityFailure> {
  F get generalEntityFailure;
}

///A [GeneralEntityFailure] is a [Failure] of an [Entity] as a whole.
abstract class GeneralEntityFailure implements Failure {}
