import 'package:modddels_annotations/modddels_annotations.dart';
import 'package:modddels_annotations/src/modddel.dart';

/// A [ValidEntity] is the valid union case of an entity. It holds all the valid
/// versions of the modddels contained inside the entity.
abstract class ValidEntity extends ValidModddel {}

/// A [InvalidEntity] is the invalid union case of an entity. It can be further
/// subdivided into other specific invalid union cases, depending on the failured
/// (the failed validation).
abstract class InvalidEntity extends InvalidModddel {}

/// An [InvalidEntitySize] is an [InvalidEntity] made invalid the size of the
/// list of modddels it is holding is invalid. It holds the [SizeFailure].
abstract class InvalidEntitySize<F extends SizeFailure> extends InvalidEntity {
  F get sizeFailure;
}

/// An [InvalidEntityContent] is an [InvalidEntity] made invalid because one of
/// its modddels is invalid. It holds the [Failure] of the first encountered
/// invalid modddel.
abstract class InvalidEntityContent extends InvalidEntity {
  /// The failure of the first encountered invalid modddel inside this entity.
  Failure get contentFailure;
}

/// An [InvalidEntityGeneral] is an [InvalidEntity] caused by a [GeneralFailure].
/// All the modddels inside this [InvalidEntityGeneral] are valid, but the entity
/// is invalid as a whole.

abstract class InvalidEntityGeneral<F extends GeneralFailure>
    extends InvalidEntity {
  F get generalFailure;
}

/// A [SizeFailure] is a [Failure] of the size of a [SizedListEntity] or
/// [SizedListGeneralEntity].
abstract class SizeFailure extends Failure {}

/// A [GeneralFailure] is a [Failure] of the entity as a whole.
abstract class GeneralFailure extends Failure {}
