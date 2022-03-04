import 'package:fpdart/fpdart.dart';
import 'package:modddels_annotations/src/modddels/entities/common.dart';
import 'package:modddels_annotations/src/modddels/entities/list_entity.dart';
import 'package:modddels_annotations/src/modddels/modddel.dart';

/// A [SizedListEntity] is similar to a [ListEntity], but its size is validated
/// via the `validateSize` method. This method returns `some` [SizeFailure] if
/// the size is invalid, otherwise returns `none`.
///
/// When creating a [SizedListEntity], the validation is made in this order :
///
/// 1. **Size validation** : If the size is invalid, then this [SizedListEntity]
///    becomes an [InvalidEntitySize] that holds the [SizeFailure].
/// 2. **Content validation** : If any of the modddels is invalid, then this
///    [SizedListEntity] becomes an [InvalidEntityContent] that holds the
///    `contentFailure` (which is the failure of the first encountered invalid
///    modddel).
/// 3. **→ Validations passed** : This [SizedListEntity] is valid, and becomes a
///    [ValidEntity] that holds the valid version of its modddels.
abstract class SizedListEntity<F extends SizeFailure, I extends InvalidEntity,
    V extends ValidEntity> extends Modddel<I, V> {
  const SizedListEntity();

  /// Validates the size of the list of this [SizedListEntity]. This
  /// method should return `some` [SizeFailure] if the size is invalid, otherwise
  /// it should return `none`.
  Option<F> validateSize(int listSize);
}
