import 'package:modddels_annotations/modddels_annotations.dart';

class ModddelAnnotation {
  const ModddelAnnotation();
}

const modddel = ModddelAnnotation();

class ValidAnnotation {
  const ValidAnnotation();
}

class WithGetterAnnotation {
  const WithGetterAnnotation();
}

class ValidWithGetterAnnotation {
  const ValidWithGetterAnnotation();
}

/// Use this annotation when you want an element of the entity is not a modddel.
/// (for example a simple bool), so it won't be validated.
const valid = ValidAnnotation();

/// Use this annotation when you if you want to have a direct getter from the
/// unvalidated [GeneralEntity].
///
/// NB: Generally, it's better for the modddels to stay hidden inside the
/// [ValidEntity] and [InvalidEntity], and not be accessed directly from withing
/// the [GeneralEntity]. That's because the [GeneralEntity] may have a
/// [GeneralEntityFailure], which may be inadvertantly unnoticed by you the
/// developer.

const withGetter = WithGetterAnnotation();

/// Same as specifying both the [valid] and [withGetter] annotations
const validWithGetter = ValidWithGetterAnnotation();
