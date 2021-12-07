import 'package:modddels_annotations/modddels_annotations.dart';
import 'package:modddels_annotations/src/entities/common.dart';

/// A ListEntity is similar to an Entity in a sense that it holds a List of
/// other modddels (of the same type). Again :
///  - If any of the moddels is invalid, then the whole entity is Invalid. (It
///    becomes an [InvalidEntityContent] ).
///  - If all the modddels are valid, then the entity is valid (It becomes a
///    [ValidEntity]).
///
/// NB: When empty, the ListEntity is considered valid. If you want a
/// different behaviour, consider using a [ListGeneralEntity] and providing
/// your own general validation.
abstract class ListEntity<C extends InvalidEntityContent, V extends ValidEntity>
    extends Modddel<C, V> {
  const ListEntity();
}
