import 'package:fpdart/fpdart.dart';
import 'package:modddels_annotations/src/entity/common.dart';
import 'package:modddels_annotations/src/entity/entity.dart';

import '../common.dart';
import 'package:equatable/equatable.dart';
import '../value_object/value_object.dart';

///A GeneralEntity is an Entity that provides an extra validation step, that
///validates the whole entity as a whole.
///
///### Detailed explanation :
///
///When instantiated, it first verifies that all its modddels are valid.
/// - If one of its modddels is invalid, then this [GeneralEntity] will be an
///   [InvalidEntity] of type [I], more precisely an [InvalidEntityContent] of
///   type [C].
/// - If all the modddels are valid, then this [GeneralEntity] is validated with the
///   [validateGeneral] method.
///   - If it's invalid, then this [GeneralEntity] will be an [InvalidEntity] of type
///     [I], more precisely, an [InvalidEntityGeneral] of type [G]
///   - If it's valid, then this [GeneralEntity] will be a [ValidEntity] of type [V]
abstract class GeneralEntity<
    F extends GeneralEntityFailure,
    G extends InvalidEntityGeneral<F>,
    C extends InvalidEntityContent,
    I extends InvalidEntity<F, G, C>,
    V extends ValidEntity> extends Equatable with Modddel {
  const GeneralEntity();

  ///This is the list of all the class members, used by Equatable for the
  ///hashCode and equality functions.
  @override
  List<Object?> get props => map(
      valid: (valid) => valid.allProps, invalid: (invalid) => invalid.allProps);

  ///After this [GeneralEntity]'s modddels have been validated and are valid, this
  ///validates the entity as a whole.
  /// - If it returns some() [GeneralEntityFailure], then this [GeneralEntity] will be
  ///   an [InvalidEntityContent]
  /// - If it returns none() [GeneralEntityFailure], then this [GeneralEntity] will be
  ///   a [ValidEntity]
  Option<F> validateGeneral(V valid);

  ///Whether this [GeneralEntity] is a [ValidEntity]
  bool get isValid => map(valid: (valid) => true, invalid: (invalid) => false);

  ///Execute [valid] when this [GeneralEntity] is valid, otherwise execute [invalid].
  TResult map<TResult extends Object?>({
    required TResult Function(V valid) valid,
    required TResult Function(I invalid) invalid,
  });

  ///Converts this [GeneralEntity] to an [Either] where left is [InvalidEntity], and
  ///right is [ValidEntity].
  Either<I, V> get toEither => map(
        valid: (valid) => right(valid),
        invalid: (invalid) => left(invalid),
      );

  ///Same as [toEither], but the left is broadened to be the [Failure] that
  ///caused this [GeneralEntity] to be invalid.
  ///
  ///NB: The [Failure] is either a [GeneralEntityFailure] of this entity, or a
  ///[Failure] of one of its modddels
  Either<Failure, V> get toBroadEither => map(
      valid: (valid) => right(valid),
      invalid: (invalid) => left(invalid.invalidMatch(
          invalidEntityGeneral: (invalidEntityGeneral) =>
              invalidEntityGeneral.generalEntityFailure,
          invalidEntityContent: (invalidEntityContent) =>
              invalidEntityContent.contentFailure)));
}

///An [InvalidEntity] is an [GeneralEntity] that is invalid. It can either be :
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

///An [InvalidEntityGeneral] is an [InvalidEntity] caused by a
///[GeneralEntityFailure]. All the modddels inside this [GeneralEntity] are valid, but
///the [GeneralEntity] as a whole is invalid.
///
abstract class InvalidEntityGeneral<F extends GeneralEntityFailure> {
  F get generalEntityFailure;

  ///This is the list of all the class members, used by Equatable for the
  ///hashCode and equality functions.
  List<Object?> get allProps;
}

///A [GeneralEntityFailure] is a [Failure] of an [GeneralEntity] as a whole.
abstract class GeneralEntityFailure implements Failure {}
