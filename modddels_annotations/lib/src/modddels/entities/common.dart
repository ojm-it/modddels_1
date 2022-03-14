import 'package:modddels_annotations/src/modddels/entities/sized_list_entity.dart';
import 'package:modddels_annotations/src/modddels/entities/sized_list_general_entity.dart';
import 'package:modddels_annotations/src/modddels/modddel.dart';

/// An [Entity] is a [Modddel] that holds multiple modddels (ValueObjects,
/// Entities...).
///
/// In order to be valid, all the modddels inside the [Entity] must be valid
/// too. This is called "Content Validation".
///
/// In addition to the "Content Validation", entities can have additionnal
/// validations steps that can occur either before or after the "Content
/// Validation" step.
abstract class Entity<I extends InvalidEntity, V extends ValidEntity>
    extends Modddel<I, V> {
  const Entity();
}

/// A [ValidEntity] is the valid union-case of an entity. It holds all the valid
/// versions of the modddels contained inside the entity.
abstract class ValidEntity extends ValidModddel {
  const ValidEntity();
}

/// A [InvalidEntity] is the invalid union-case of an entity. It can be further
/// subdivided into other specific invalid union-cases, depending on the
/// failured (the failed validation).
abstract class InvalidEntity extends InvalidModddel {
  const InvalidEntity();
}

/// An [InvalidEntitySize] is an [InvalidEntity] made invalid the size of the
/// list of modddels it is holding is invalid. It holds the [SizeFailure].
abstract class InvalidEntitySize<F extends SizeFailure> extends InvalidEntity {
  const InvalidEntitySize();

  F get sizeFailure;

  // Note to self : We override `failure` for easier usage when we directly
  // extend this class.
  @override
  Failure get failure => sizeFailure;
}

/// An [InvalidEntityContent] is an [InvalidEntity] made invalid because one of
/// its modddels is invalid. It holds the [Failure] of the first encountered
/// invalid modddel.
abstract class InvalidEntityContent extends InvalidEntity {
  const InvalidEntityContent();

  /// The failure of the first encountered invalid modddel inside this entity.
  Failure get contentFailure;

  // Note to self : We override `failure` for easier usage when we directly
  // extend this class.
  @override
  Failure get failure => contentFailure;
}

/// An [InvalidEntityGeneral] is an [InvalidEntity] caused by a
/// [GeneralFailure]. All the modddels inside this [InvalidEntityGeneral] are
/// valid, but the entity is invalid as a whole.
abstract class InvalidEntityGeneral<F extends GeneralFailure>
    extends InvalidEntity {
  const InvalidEntityGeneral();

  F get generalFailure;

  // Note to self : We override `failure` for easier usage when we directly
  // extend this class.
  @override
  Failure get failure => generalFailure;
}

/// A [SizeFailure] is a [Failure] of the size of a [SizedListEntity] or
/// [SizedListGeneralEntity].
abstract class SizeFailure extends Failure {
  const SizeFailure();
}

/// A [GeneralFailure] is a [Failure] of the entity as a whole.
abstract class GeneralFailure extends Failure {
  const GeneralFailure();
}
