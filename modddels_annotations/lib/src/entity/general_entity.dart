import 'package:fpdart/fpdart.dart';
import 'package:modddels_annotations/src/entity/common.dart';

import '../common.dart';
import 'package:equatable/equatable.dart';

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
    I extends InvalidEntity,
    V extends ValidEntity> extends Modddel<I, V> {
  const GeneralEntity();

  ///After this [GeneralEntity]'s modddels have been validated and are valid, this
  ///validates the entity as a whole.
  /// - If it returns some() [GeneralEntityFailure], then this [GeneralEntity] will be
  ///   an [InvalidEntityContent]
  /// - If it returns none() [GeneralEntityFailure], then this [GeneralEntity] will be
  ///   a [ValidEntity]
  Option<F> validateGeneral(V valid);
}

///An [InvalidEntityGeneral] is an [InvalidEntity] caused by a
///[GeneralEntityFailure]. All the modddels inside this [GeneralEntity] are valid, but
///the [GeneralEntity] as a whole is invalid.
///
abstract class InvalidEntityGeneral<F extends GeneralEntityFailure>
    extends InvalidEntity {
  F get generalEntityFailure;
}

///A [GeneralEntityFailure] is a [Failure] of an [GeneralEntity] as a whole.
abstract class GeneralEntityFailure implements Failure {}
