extension StringExtension on String {
  /// Turns the first letter of this String to upper-case.
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
