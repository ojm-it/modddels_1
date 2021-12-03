import 'package:modddels_annotations/modddels_annotations.dart';

abstract class KtListGeneralEntity<
    F extends GeneralEntityFailure,
    G extends InvalidEntityGeneral<F>,
    C extends InvalidEntityContent,
    I extends InvalidEntity<F, G, C>,
    V extends ValidEntity> extends GeneralEntity<F, G, C, I, V> {
  const KtListGeneralEntity();
}
