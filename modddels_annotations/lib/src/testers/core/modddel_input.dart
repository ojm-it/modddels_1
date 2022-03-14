import 'package:equatable/equatable.dart';
import 'package:modddels_annotations/modddels.dart';
import 'package:modddels_annotations/src/testers/core/tester.dart';

/// This class represents the "input" of a [Modddel], i.e the field(s) that we
/// use to construct the [Modddel]. Simply said, it's the "data-class version"
/// of the modddel.
///
/// It is used by the [Tester] to test for sanitization, i.e the changes that
/// are made to the input before being stored inside the [Modddel].
///
/// _Example :_
///
/// ```dart
/// factory Person({
///     @valid required String id,
///     required Name name,
///   }) {
///     final sanitizedId = id.trim();
///
///     return $Person._create(
///       id: sanitizedId,
///       name: name,
///     );
///   }
/// ```
///
/// This is the factory constructor of a [SimpleEntity] `Name`. If we make an
/// instance `FullName(id: ' 12345 ', name: Name('Avi'))`, then :
/// - The input is : `id: ' 12345 ', name: Name('Avi')`
/// - The sanitized input is : `id: '12345', name: Name('Avi')`
///
/// The [ModddelInput] of this specific [SimpleEntity] will be a data-class that
/// contains the fields `String id` and `Name name`.
abstract class ModddelInput<M extends Modddel> extends Equatable {
  const ModddelInput();

  /// Returns this [ModddelInput] after it has been sanitized by the [Modddel].
  ModddelInput<M> get sanitizedInput;

  @override
  bool? get stringify => true;
}
