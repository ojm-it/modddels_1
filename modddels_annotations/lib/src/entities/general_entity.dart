import 'package:fpdart/fpdart.dart';
import 'package:modddels_annotations/src/entities/common.dart';

import '../modddel.dart';

/// A [GeneralEntity] is similar to an [Entity], but it provides an extra
/// validation step at the end that validates the entity as a whole, via the
/// `validateGeneral` method. This method returns `some` [GeneralFailure] if the
/// entity isn't valid as a whole, otherwise returns `none`.
///
/// When creating a [GeneralEntity], the validation is made in this order :
///
/// 1. **Content validation** : If any of the modddels is invalid, then this
///    [GeneralEntity] becomes an [InvalidEntityContent] that holds the
///    `contentFailure` (which is the failure of the first encountered invalid
///    modddel).
/// 2. **General validation** : If this [GeneralEntity] is invalid as a whole,
///    then it becomes an [InvalidEntityGeneral] that holds the
///    [GeneralFailure].
/// 3. **→ Validations passed** : This [GeneralEntity] is valid, and becomes a
///    [ValidEntity] that holds the valid version of its modddels.
abstract class GeneralEntity<F extends GeneralFailure, I extends InvalidEntity,
    V extends ValidEntity> extends Modddel<I, V> {
  const GeneralEntity();

  /// Validates this [GeneralEntity] as a whole, after all its modddels have
  /// been validated. This method should return `some` [GeneralFailure] if this
  /// [GeneralEntity] is invalid as a whole, otherwise it should
  /// return `none`.
  Option<F> validateGeneral(V valid);
}
