import 'package:flutter/foundation.dart';
import 'package:modddels_annotations/src/testers/core/custom_description.dart';
import 'package:flutter_test/flutter_test.dart';

/// This is the base class of all Test cases. Conceptually, it represents one
/// [test].
@immutable
abstract class TestCase {
  /// If provided, allows you to customize the [test]'s description.
  CustomDescription? get customDescription;

  /// Returns the final [test]'s description after taking into account
  /// the [customDescription].
  String getFinalDescription(String description) => customDescription != null
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
