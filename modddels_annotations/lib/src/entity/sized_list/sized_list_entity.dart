import 'package:fpdart/fpdart.dart';
import 'package:modddels_annotations/src/common.dart';
import 'package:modddels_annotations/src/entity/common.dart';

abstract class SizedListEntity<F extends SizeFailure, I extends InvalidEntity,
    V extends ValidEntity> extends Modddel<I, V> {
  const SizedListEntity();

  Option<F> validateSize(int listSize);
}
