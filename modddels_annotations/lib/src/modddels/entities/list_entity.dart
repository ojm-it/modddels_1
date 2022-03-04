import 'package:modddels_annotations/src/modddels/entities/common.dart';
import 'package:modddels_annotations/src/modddels/entities/simple_entity.dart';
import 'package:modddels_annotations/src/modddels/entities/sized_list_entity.dart';
import 'package:modddels_annotations/src/modddels/modddel.dart';

/// A [ListEntity] is similar to a [SimpleEntity] in a sense that it holds a List of
/// other modddels (of the same type).
///
/// When creating a [ListEntity], the validation is made in this order :
///
/// 1. **Content validation** : If any of the modddels is invalid, then this
///    ListEntity becomes an [InvalidEntityContent] that holds the
///    `contentFailure` (which is the failure of the first encountered invalid
///    modddel).
/// 2. **→ Validations passed** : This ListEntity is valid, and becomes a
///    [ValidEntity] that holds the valid version of its modddels.
///
/// NB: When empty, the ListEntity is considered valid. If you want a different
/// behaviour, consider using a [SizedListEntity] and providing your own size
/// validation.
abstract class ListEntity<C extends InvalidEntityContent, V extends ValidEntity>
    extends Modddel<C, V> {
  const ListEntity();
}
