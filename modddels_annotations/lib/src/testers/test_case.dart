import 'package:flutter_test/flutter_test.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'test_case.freezed.dart';

/// This is the base class of all Test cases. Conceptually, it represents one
/// [test].
abstract class TestCase {
  /// If provided, allows you to customize the [test]'s description.
  CustomDescription? get customDescription;

  /// Returns the final [test]'s description after taking into account
  /// the [customDescription].
  String getDescription(String description) => customDescription != null
      ? customDescription!.when(
          replaceDescription: (newDescription) => newDescription,
          addPrefix: (prefix) => '$prefix$description',
          addSuffix: (suffix) => '$description$suffix',
          addPrefixAndSuffix: (prefix, suffix) => '$prefix$description$suffix',
          modifyDescription: (modifyDescription) =>
              modifyDescription(description))
      : description;

  /// See [test]
  String? get testOn;

  /// See [test]
  Timeout? get timeout;

  /// See [test]
  dynamic get skip;

  /// See [test]
  dynamic get tags;

  /// See [test]
  Map<String, dynamic>? get onPlatform;

  /// See [test]
  int? get retry;
}

@freezed
class CustomDescription with _$CustomDescription {
  /// Use this if you want to provide your own description.
  const factory CustomDescription.replaceDescription(String newDescription) =
      _ReplaceDescription;

  /// Use this if you want to add a prefix to the description.
  const factory CustomDescription.addPrefix(String prefix) = _AddPrefix;

  /// Use this if you want to add a suffix to the description.
  const factory CustomDescription.addSuffix(String suffix) = _AddSuffix;

  /// Use this if you want to add a prefix and a suffix to the description.
  const factory CustomDescription.addPrefixAndSuffix(
      String prefix, String suffix) = _AddPrefixAndSuffix;

  /// Use this if you want to have a callback to modify the description.
  const factory CustomDescription.modifyDescription(
          String Function(String description) modifyDescription) =
      _ModifyDescription;
}
