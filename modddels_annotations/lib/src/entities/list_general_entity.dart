import 'package:fpdart/fpdart.dart';
import 'package:modddels_annotations/modddels_annotations.dart';
import 'package:modddels_annotations/src/entities/common.dart';

///A ListGeneralEntity is a [ListEntity] which provides an extra validation step, just like a [GeneralEntity].
abstract class ListGeneralEntity<F extends GeneralFailure,
    I extends InvalidEntity, V extends ValidEntity> extends Modddel<I, V> {
  const ListGeneralEntity();

  //TODO update this documentation.

  ///After this [GeneralEntity]'s modddels have been validated and are valid, this
  ///validates the entity as a whole.
  /// - If it returns some() [GeneralFailure], then this [GeneralEntity] will be
  ///   an [InvalidEntityContent]
  /// - If it returns none() [GeneralFailure], then this [GeneralEntity] will be
  ///   a [ValidEntity]
  Option<F> validateGeneral(V valid);
}
