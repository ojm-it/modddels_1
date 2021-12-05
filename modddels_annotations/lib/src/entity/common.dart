import 'package:modddels_annotations/modddels_annotations.dart';
import 'package:modddels_annotations/src/common.dart';

///A [ValidEntity] is an [GeneralEntity] that is valid. It holds all the valid
///modddels as [ValidValueObject]s / [ValidEntity]s.
abstract class ValidEntity extends ValidModddel {}

abstract class InvalidEntity extends InvalidModddel {}

///An [InvalidEntityContent] is an [InvalidEntity] made invalid because one of
///its modddels is invalid. It holds the [Failure] of the invalid modddel.
abstract class InvalidEntityContent extends InvalidEntity {
  ///The failure of the invalid modddel inside this [GeneralEntity]
  Failure get contentFailure;
}
