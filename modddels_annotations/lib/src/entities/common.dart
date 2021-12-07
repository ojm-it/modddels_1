import 'package:modddels_annotations/modddels_annotations.dart';
import 'package:modddels_annotations/src/modddel.dart';

///A [ValidEntity] is an [GeneralEntity] that is valid. It holds all the valid
///modddels as [ValidValueObject]s / [ValidEntity]s.
abstract class ValidEntity extends ValidModddel {}

///An [InvalidEntity] is an [GeneralEntity] that is invalid. It can either be :
/// - An [InvalidEntityContent]
/// - An [InvalidEntityGeneral]
abstract class InvalidEntity extends InvalidModddel {}

///An [InvalidEntityContent] is an [InvalidEntity] made invalid because one of
///its modddels is invalid. It holds the [Failure] of the invalid modddel.
abstract class InvalidEntityContent extends InvalidEntity {
  ///The failure of the invalid modddel inside this [GeneralEntity]
  Failure get contentFailure;
}

abstract class InvalidEntitySize<F extends SizeFailure> extends InvalidEntity {
  F get sizeFailure;
}

abstract class SizeFailure extends Failure {}

///An [InvalidEntityGeneral] is an [InvalidEntity] caused by a
///[GeneralFailure]. All the modddels inside this [GeneralEntity] are valid, but
///the [GeneralEntity] as a whole is invalid.
///
abstract class InvalidEntityGeneral<F extends GeneralFailure>
    extends InvalidEntity {
  F get generalFailure;
}

///A [GeneralFailure] is a [Failure] of an [GeneralEntity] as a whole.
abstract class GeneralFailure extends Failure {}
