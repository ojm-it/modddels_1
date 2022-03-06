import 'package:equatable/equatable.dart';
import 'package:modddels_annotations/src/modddels/entities/common.dart';
import 'package:modddels_annotations/src/modddels/entities/general_entity.dart';
import 'package:modddels_annotations/src/modddels/entities/simple_entity.dart';
import 'package:modddels_annotations/src/modddels/value_objects/value_object.dart';
import 'package:modddels_annotations/src/testers/testers_utils.dart';

enum StringifyMode {
  always,
  never,
  debugMode,
}

class ModddelAnnotation {
  const ModddelAnnotation({
    this.generateTester = true,
    this.maxSutDescriptionLength = 100,
    this.stringifyMode = StringifyMode.always,
  });

  /// Whether to generate a Tester for this Modddel.
  ///
  /// Defaults to `true`.
  final bool generateTester;

  /// The tests generated by the methods of the Tester have a description that
  /// usually contain the String representation of the SUT.
  ///
  /// This [maxSutDescriptionLength] is the maximum length of that String,
  /// beyond which it is ellipsized.
  ///
  /// Defaults to `100`.
  ///
  /// You can disable this "ellipsisation" by setting this
  /// [maxSutDescriptionLength] to [TesterUtils.noEllipsis].
  final int maxSutDescriptionLength;

  /// Dictates how [Equatable.stringify] method should be overridden for this
  /// modddel, and thus how the `toString` method will behave.
  ///
  /// - [StringifyMode.never] : The `toString` method won't include the props of
  ///   the modddel in neither Debug mode nor Release mode.
  ///
  ///   Behind the scenes, the [stringifyMode] method is overridden to return
  ///   `false`.
  ///
  /// - [StringifyMode.always] : The `toString` method will include the props of
  ///   the modddel in both Debug mode and Release mode.
  ///
  ///   Behind the scenes, the [stringifyMode] method is overridden to return
  ///   `true`.
  ///
  /// - [StringifyMode.debugMode] : The `toString` method will include the props
  ///   of the modddel in Debug mode, and won't include them in Release mode.
  ///
  ///   Behind the scenes, the [stringifyMode] method is overridden to return
  ///   `null`, which means it falls back to the value of
  ///   [EquatableConfig.stringify], which defaults to true in debug mode and
  ///   false in release mode.
  ///
  /// Defaults to [StringifyMode.always].
  final StringifyMode stringifyMode;
}

class ValidAnnotation {
  const ValidAnnotation();
}

class WithGetterAnnotation {
  const WithGetterAnnotation();
}

class ValidWithGetterAnnotation {
  const ValidWithGetterAnnotation();
}

const modddel = ModddelAnnotation();

/// This annotation can only be used inside a [SimpleEntity] or a [GeneralEntity], in
/// front of a factory parameter.
///
/// Use this annotation :
/// - When you want a a [SimpleEntity] or a [GeneralEntity] to contain a modddel that should be considered as
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
/// Unlike a [SimpleEntity], the [GeneralEntity] hides its modddels inside the
/// [ValidEntity] and [InvalidEntity] union-cases, so you can only access them
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

class InvalidNull {
  const InvalidNull(this.generalFailure);

  final String generalFailure;
}