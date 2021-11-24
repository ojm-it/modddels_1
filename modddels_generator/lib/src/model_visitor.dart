import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';

class ModelVisitor extends SimpleElementVisitor<dynamic> {
  String? className;
  final fields = <String, dynamic>{};

  @override
  visitClassElement(ClassElement element) {
    className = element.name.replaceFirst('*', '');
  }

  @override
  void visitConstructorElement(ConstructorElement element) {
    final elementReturnType = element.type.returnType.toString();

    className = elementReturnType.replaceFirst('*', '');
  }

  @override
  void visitFieldElement(FieldElement element) {
    final elementType = element.type.toString();
    // 7
    fields[element.name] = elementType.replaceFirst('*', '');
  }
}
