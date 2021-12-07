import 'package:modddels_annotations/src/entities/common.dart';

import '../modddel.dart';

/// An [Entity] is a [Modddel] that holds multiple modddels (ValueObjects,
/// Entities...).
///
/// When creating an [Entity], the validation is made in this order :
///
/// 1. **Content Validation** : If any of its modddels is invalid, then this
///    [Entity] becomes an [InvalidEntityContent] that holds the
///    `contentFailure` (which is the failure of the first encountered invalid
///    modddel).
/// 2. **→ Validations passed** : The [Entity] is valid, and becomes a
///    [ValidEntity] that holds the valid version of its modddels.

abstract class Entity<C extends InvalidEntityContent, V extends ValidEntity>
    extends Modddel<C, V> {
  const Entity();
}
