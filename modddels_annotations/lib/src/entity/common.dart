import 'package:modddels_annotations/modddels_annotations.dart';
import 'package:modddels_annotations/src/common.dart';

///A [ValidEntity] is an [GeneralEntity] that is valid. It holds all the valid
///modddels as [ValidValueObject]s / [ValidEntity]s.
abstract class ValidEntity {
  ///This is the list of all the class members, used by Equatable for the
  ///hashCode and equality functions.
  List<Object?> get allProps;
}

///An [InvalidEntityContent] is an [InvalidEntity] made invalid because one of
///its modddels is invalid. It holds the [Failure] of the invalid modddel.
abstract class InvalidEntityContent {
  ///The failure of the invalid modddel inside this [GeneralEntity]
  Failure get contentFailure;

  ///This is the list of all the class members, used by Equatable for the
  ///hashCode and equality functions.
  List<Object?> get allProps;
}
