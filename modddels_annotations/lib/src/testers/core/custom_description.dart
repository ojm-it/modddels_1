import 'package:freezed_annotation/freezed_annotation.dart';

part 'custom_description.freezed.dart';

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
