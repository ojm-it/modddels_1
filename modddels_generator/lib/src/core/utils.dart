import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:modddels_generator/src/core/templates/annotations.dart';

/// Returns the decorators except `@required` and all modddels annotations.
List<String> parseDecorators(List<ElementAnnotation> metadata) {
  return metadata
      .where((meta) =>
          !meta.isRequired &&
          !meta.isValid &&
          !meta.isInvalid &&
          !meta.isWithGetter &&
          !meta.isValidWithGetter &&
          !meta.isInvalidWithGetter &&
          !meta.isNullFailure &&
          !meta.isTypeName)
      .map((meta) => meta.toSource())
      .toList();
}

/// Returns the documentation of the given parameter. The implementation details
/// are taken from freezed.
Future<String> documentationOfParameter(
  ParameterElement parameter,
  BuildStep buildStep,
) async {
  final builder = StringBuffer();

  final astNode = await tryGetAstNodeForElement(parameter, buildStep);

  for (Token? token = astNode.beginToken.precedingComments;
      token != null;
      token = token.next) {
    builder.writeln(token);
  }

  return builder.toString();
}

Future<AstNode> tryGetAstNodeForElement(
  Element element,
  BuildStep buildStep,
) async {
  var library = element.library!;

  while (true) {
    try {
      final result = library.session.getParsedLibraryByElement(library)
          as ParsedLibraryResult?;

      return result!.getElementDeclaration(element)!.node;
    } on InconsistentAnalysisException {
      library = await buildStep.resolver.libraryFor(
        await buildStep.resolver.assetIdForElement(element.library!),
      );
    }
  }
}

extension StringExtension on String {
  /// Turns the first letter of this String to upper-case.
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
