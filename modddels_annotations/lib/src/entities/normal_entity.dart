import 'package:modddels_annotations/src/entities/common.dart';

import '../modddel.dart';
import '../value_object/value_object.dart';

///An [Entity] is a [Modddel] that holds multiple modddels : [ValueObject]s or
///Entities.
///
/// - If any of its moddels is invalid, then this [Entity] will be an
///   [InvalidEntityContent] of type [C].
///
/// - If all the modddels are valid, then this [Entity] will be a
///     [ValidEntity] of type [V]
///
abstract class Entity<C extends InvalidEntityContent, V extends ValidEntity>
    extends Modddel<C, V> {
  const Entity();
}
