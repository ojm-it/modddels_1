import 'package:fpdart/fpdart.dart';
import 'package:modddels_annotations/src/modddels/entities/common.dart';
import 'package:modddels_annotations/src/modddels/entities/list_general_entity.dart';
import 'package:modddels_annotations/src/modddels/modddel.dart';

/// A [SizedListGeneralEntity] is similar to a [ListGeneralEntity], but its size
/// is validated via the `validateSize` method. This method returns `some`
/// [SizeFailure] if the size is invalid, otherwise returns `none`.
///
/// When creating a [SizedListGeneralEntity], the validation is made in this order
/// :
///
/// 1. **Size validation** : If the size is invalid, then this
///    [SizedListGeneralEntity] becomes an [InvalidEntitySize].
/// 2. **Content validation** : If any of the modddels is invalid, then this
///    SizedListGeneralEntity becomes an [InvalidEntityContent] that holds the
///    `contentFailure` (which is the failure of the first encountered invalid
///    modddel).
/// 3. **General validation** : If this [SizedListGeneralEntity] is invalid as a
///    whole, then it becomes an [InvalidEntityGeneral] that holds the
///    [GeneralFailure].
/// 4. **→ Validations passed** : This [SizedListGeneralEntity] is valid, and
///    becomes a [ValidEntity] that holds the valid version of its modddels.
///
/// > **NB :** You may notice that the **Size validation** occurs first, before
/// > the **Content validation**. This is so that no matter if this modddel's
/// > content is valid or not, if its size is invalid, it becomes an
/// > [InvalidEntitySize] holding a [SizeFailure].
/// >
/// > If you want the size to be validated only if all the modddels are valid,
/// > you can do so in the **General validation** step, so that the size is
/// > validated last. In that case, if the size is invalid, then this modddel
/// > becomes an [InvalidEntityGeneral] holding a [GeneralFailure].

abstract class SizedListGeneralEntity<
    FS extends SizeFailure,
    FG extends GeneralFailure,
    I extends InvalidEntity,
    V extends ValidEntity> extends Modddel<I, V> {
  const SizedListGeneralEntity();

  /// Validates the size of the list of this [SizedListGeneralEntity]. This
  /// method should return `some` [SizeFailure] if the size is invalid, otherwise
  /// it should return `none`.
  Option<FS> validateSize(int listSize);

  /// Validates this [SizedListGeneralEntity] as a whole, after all its modddels have
  /// been validated. This method should return `some` [GeneralFailure] if this
  /// [SizedListGeneralEntity] is invalid as a whole, otherwise it should
  /// return `none`.
  Option<FG> validateGeneral(V valid);
}
