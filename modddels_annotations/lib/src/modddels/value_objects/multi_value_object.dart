import 'package:modddels_annotations/src/modddels/value_objects/single_value_object.dart';
import 'package:modddels_annotations/src/modddels/value_objects/value_object.dart';

/// A [MultiValueObject] is a [ValueObject] where the "value" is not represented
/// by a single value, but rather a combination of multiple fields. Each field
/// is valid separately, but when put together, they form a "value" that needs
/// to be validated.
///
/// _Example :_
///
/// ```dart
/// @modddel
/// class GeoPoint extends MultiValueObject<GeoPointValueFailure, InvalidGeoPoint,
///     ValidGeoPoint> with $GeoPoint {
///   factory GeoPoint({
///     required double latitude,
///     required double longitude,
///   }) {
///     return $GeoPoint._create(
///       latitude: latitude,
///       longitude: longitude,
///     );
///   }
///
///   const GeoPoint._();
///
///   @override
///   Option<GeoPointValueFailure> validateValue(ValidGeoPoint valid) {
///     if(latitude == 0 && longitude == 0){
///       return const GeoPointValueFailure.nullIsland();
///     }
///     return none();
///   }
/// }
/// ```
///
/// In this example, a `GeoPoint` is invalid when both its `latitude` and
/// `longitude` equal 0. Separately, the `latitude` and `longitude` fields are
/// always valid.
///
/// Without a [MultiValueObject], you would need to :
///
/// 1. Create a Data class `GeoPointPrimitive`
/// 2. Create a [SingleValueObject] named `GeoPoint`, which holds as a value a
///    `GeoPointPrimitive`.
///
/// This would add a lot of boilerplate code, and would prevent the use of some
/// features such as annotating a specific field with the `@NullFailure`
/// annotation.
abstract class MultiValueObject<
    F extends ValueFailure,
    I extends InvalidValueObject<F>,
    V extends ValidValueObject> extends ValueObject<F, I, V> {
  const MultiValueObject();
}
