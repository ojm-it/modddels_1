import 'package:modddels_annotations/modddels_annotations.dart';
import 'package:modddels_annotations/src/entity/common.dart';
import 'package:modddels_annotations/src/entity/entity.dart';

/// A KtListEntity is similar to an Entity in a sense that it holds a List of
/// other modddels (of the same type). Again :
///  - If any of the moddels is invalid, then the whole entity is Invalid. (It
///    becomes an [InvalidEntityContent] ).
///  - If all the modddels are valid, then the entity is valid (It becomes a
///    [ValidEntity]).
///
/// NB: When empty, the KtListEntity is considered valid. If you want a
/// different behaviour, consider using a [KtListGeneralEntity] and providing
/// your own general validation.
abstract class KtListEntity<C extends InvalidEntityContent,
    V extends ValidEntity> extends Entity<C, V> {
  const KtListEntity();
}


//TODO

// abstract class SizedKtListEntity<C extends InvalidEntityContent,
//     V extends ValidEntity> extends Entity<C, V> {
//   const SizedKtListEntity();
// }


