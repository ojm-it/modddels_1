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

/// This annotation can only be used inside an [Entity] or a [GeneralEntity], in
/// front of a factory parameter.
///
/// Use this annotation :
/// - When you want an entity to contain a modddel that should be considered as
///   being valid (so it shouldn't be validated)
/// - When a parameter isn't a modddel and should be considered as being valid.
///   For example : a [ValidValueObject], a [ValidEntity], a boolean...
///
/// Example :
/// ```dart
/// factory FullName({
///    required Name firstName,
///    required Name lastName,
///    @valid required bool hasMiddleName,
///  }) { ...
/// ```

const valid = ValidAnnotation();

/// This annotation can only be used inside a [GeneralEntity], in front of a
/// factory parameter.
///
/// Use this annotation if you want to have a direct getter for a modddel from
/// the unvalidated [GeneralEntity].
///
/// Unlike a normal Entity, the [GeneralEntity] hides its modddels inside the
/// [ValidEntity] and [InvalidEntity] union cases, so you can only access them
/// after calling the "mapValidity" method (or other map methods).
///
/// For example :
///
/// ```dart
///   final firstName = fullName.firstName; //ERROR : The getter 'firstName'
///   isn't defined for the type 'FullName'.
///
///   final firstName = fullName.mapValidity( valid: (valid) => valid.firstName,
///       invalid: (invalid) => invalid.firstName); //No error.
/// ```
///
/// That's because the GeneralEntity may have a GeneralFailure, which may be
/// unnoticed by you the developer.
///
///  Nonetheless, there are some usecases where the modddel doesn't have an
///  impact on the general validation, so it's safe to have a direct getter. For
///  example : Having a getter for an "id" field.
///
/// Example :
/// ```dart
/// factory FullName({
///    @withGetter required UniqueId id,
///    required Name firstName,
///    required Name lastName,
///  }) { ...
/// ```

const withGetter = WithGetterAnnotation();

/// Same as specifying both the [valid] and [withGetter] annotations.
///
/// Example :
/// ```dart
/// factory FullName({
///    @validWithGetter required String id,
///    required Name firstName,
///    required Name lastName,
///  }) { ...
/// ```
const validWithGetter = ValidWithGetterAnnotation();
