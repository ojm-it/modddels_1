import 'package:modddels_annotations/src/modddels/entities/common.dart';
import 'package:modddels_annotations/src/modddels/modddel.dart';

/// A [SimpleEntity] is a [Modddel] that holds multiple modddels (ValueObjects,
/// Entities...).
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
    V extends ValidEntity> extends Modddel<C, V> {
  const SimpleEntity();
}
