import 'package:modddels_annotations/modddels_annotations.dart';
import 'package:modddels_annotations/src/entity/common.dart';

///A KtListGeneralEntity is a [KtListEntity] which provides an extra validation step, just like a [GeneralEntity].
abstract class KtListGeneralEntity<
    F extends GeneralEntityFailure,
    G extends InvalidEntityGeneral<F>,
    C extends InvalidEntityContent,
    I extends InvalidEntity,
    V extends ValidEntity> extends GeneralEntity<F, G, C, I, V> {
  const KtListGeneralEntity();
}
