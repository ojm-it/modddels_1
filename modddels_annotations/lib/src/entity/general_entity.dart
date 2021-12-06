import 'package:fpdart/fpdart.dart';
import 'package:modddels_annotations/src/entity/common.dart';

import '../common.dart';

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
abstract class GeneralEntity<F extends GeneralFailure, I extends InvalidEntity,
    V extends ValidEntity> extends Modddel<I, V> {
  const GeneralEntity();

  ///After this [GeneralEntity]'s modddels have been validated and are valid, this
  ///validates the entity as a whole.
  /// - If it returns some() [GeneralFailure], then this [GeneralEntity] will be
  ///   an [InvalidEntityContent]
  /// - If it returns none() [GeneralFailure], then this [GeneralEntity] will be
  ///   a [ValidEntity]
  Option<F> validateGeneral(V valid);
}
