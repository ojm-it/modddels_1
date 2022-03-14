import 'dart:math';

import 'package:modddels_annotations/modddels.dart';

abstract class TesterUtils {
  static const noEllipsis = -1;

  /// Formats the classname of the [failure] into a readable format.
  ///
  /// Basically, it removes the '_' & '$' signs typically added by freezed.
  ///
  /// For example : `_$_Empty`  becomes `Empty`.
  static String formatFailure(Failure failure) {
    final className = failure.runtimeType.toString();

    final regex = RegExp(r"^[_$]*(.*)$");

    final formattedClassName = regex.firstMatch(className)?.group(1);

    return formattedClassName ?? className;
  }

  /// Formats an [object]'s string representation so that :
  ///
  /// - Any newline character is replaced by the raw string '\n'
  /// - Any tab character is replaced by the raw string '\t'
  /// - The string is ellipsized if it exceeds [maxLength] * [maxLengthFactor],
  ///   using the [TesterUtils.ellipsize] function.
  ///
  ///   This step can be skipped by setting [maxLength] to
  ///   [TesterUtils.noEllipsis].
  static String formatObject(
    Object? object, {
    required int maxLength,
    double maxLengthFactor = 1,
  }) {
    assert(maxLength == TesterUtils.noEllipsis || maxLength > 0);
    assert(maxLengthFactor > 0 && maxLengthFactor <= 1);

    final result =
        object.toString().replaceAll('\n', r'\n').replaceAll('\t', r'\t');

    if (maxLength == TesterUtils.noEllipsis) {
      return result;
    }

    final _maxLength = (maxLength * maxLengthFactor).ceil();

    return ellipsize(result, maxLength: _maxLength);
  }

  /// Shortens the [text] using an ellipsis if its length exceeds [maxLength].
  ///
  /// If [showEllipsisCount] is true, then it shows the number of characters
  /// that were "ellipsized away" between parenthesis.
  ///
  /// Example :
  /// ```dart
  /// final text = 'This is a new text';
  ///
  /// final ellipsized1 = _ellipsize(
  ///   text,
  ///   maxLength: 14,
  ///   showEllipsisCount: false,
  /// );
  /// /// => 'This is a new…'
  ///
  /// final ellipsized2 = _ellipsize(
  ///   text,
  ///   maxLength: 14,
  ///   showEllipsisCount: true,
  /// );
  /// /// => 'This is … (+4)'
  ///
  /// /// Notice how both strings are exactly 14 characters long.
  /// ```
  static String ellipsize(
    String text, {
    required int maxLength,
    bool showEllipsisCount = true,
  }) {
    assert(maxLength > 0);

    if (text.length <= maxLength) {
      return text;
    }

    if (!showEllipsisCount) {
      // The final string result should not exceed maxLength, so we take into
      // take into account the added '…' character
      final end = maxLength - 1;
      return '${text.substring(0, end)}…';
    }

    /// The number of characters hidden by the ellipsis.
    final ellipsisCount = text.length - maxLength;

    /// The final resulting string should not exceed maxLength, so we take into
    /// account the extra characters : `… (+)` and the length of `ellipsisCount`
    final extraCharactersCount = 5 + ellipsisCount.toString().length;

    final end = max(maxLength - extraCharactersCount, 0);

    return '${text.substring(0, end)}… (+$ellipsisCount)';
  }
}
