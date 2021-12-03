import 'package:modddels_annotations/src/entity/common.dart';
import 'package:modddels_annotations/src/entity/entity.dart';

abstract class KtListEntity<C extends InvalidEntityContent,
    V extends ValidEntity> extends Entity<C, V> {
  const KtListEntity();
}
