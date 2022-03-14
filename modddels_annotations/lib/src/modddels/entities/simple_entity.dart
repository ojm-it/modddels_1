import 'package:modddels_annotations/src/modddels/entities/common.dart';

/// A [SimpleEntity] is an [Entity] that holds multiple modddels as separate
/// fields. The only validation step is the "Content Validation", so if all
/// the modddels are valid, the [SimpleEntity] is valid too.
///
/// When creating a [SimpleEntity], the validation is made in this order :
///
/// 1. **Content Validation** : If any of its modddels is invalid, then this
///    [SimpleEntity] becomes an [InvalidEntityContent] that holds the
///    `contentFailure` (which is the failure of the first encountered invalid
///    modddel).
/// 2. **→ Validations passed** : The [SimpleEntity] is valid, and becomes a
///    [ValidEntity] that holds the valid version of its modddels.

abstract class SimpleEntity<C extends InvalidEntityContent,
    V extends ValidEntity> extends Entity<C, V> {
  const SimpleEntity();
}
