import 'package:fpdart/fpdart.dart';
import 'package:modddels_annotations/src/common.dart';
import 'package:modddels_annotations/src/entity/common.dart';

abstract class SizedListGeneralEntity<
    FS extends SizeFailure,
    FG extends GeneralFailure,
    I extends InvalidEntity,
    V extends ValidEntity> extends Modddel<I, V> {
  const SizedListGeneralEntity();

  //TODO update this documentation.

  Option<FS> validateSize(int listSize);

  Option<FG> validateGeneral(V valid);
}
