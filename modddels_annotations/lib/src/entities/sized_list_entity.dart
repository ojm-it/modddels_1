import 'package:fpdart/fpdart.dart';
import 'package:modddels_annotations/src/modddel.dart';
import 'package:modddels_annotations/src/entities/common.dart';

abstract class SizedListEntity<F extends SizeFailure, I extends InvalidEntity,
    V extends ValidEntity> extends Modddel<I, V> {
  const SizedListEntity();

  Option<F> validateSize(int listSize);
}
