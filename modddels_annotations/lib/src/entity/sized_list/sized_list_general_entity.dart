import 'package:fpdart/fpdart.dart';
import 'package:modddels_annotations/src/common.dart';
import 'package:modddels_annotations/src/entity/common.dart';

abstract class SizedListGeneralEntity<
    FG extends GeneralFailure,
    FS extends SizeFailure,
    I extends InvalidEntity,
    V extends ValidEntity> extends Modddel<I, V> {
  const SizedListGeneralEntity();

  //TODO update this documentation.

  Option<FG> validateGeneral(V valid);

  Option<FS> validateSize(int listSize);
}
