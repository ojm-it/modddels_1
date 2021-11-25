import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:modddels_generator/src/utils.dart';
import 'package:source_gen/source_gen.dart';

class EntityGenerator {
  EntityGenerator({required this.className, required this.factoryConstructor});

  final String className;
  final ConstructorElement factoryConstructor;

  String generate() {
    final parameters = factoryConstructor.parameters;

    final namedParameters =
        parameters.where((element) => element.isNamed).toList();

    if (namedParameters.isEmpty) {
      throw InvalidGenerationSourceError(
        'The factory constructor should contain at least one name parameter',
        element: factoryConstructor,
      );
    }

    for (final param in namedParameters) {
      if (param.type.toString() == 'dynamic') {
        throw InvalidGenerationSourceError(
          'The named parameters of the factory constructor should have valid types, and should not be dynamic',
          element: param,
        );
      }
    }

    final classInfo = EntityClassInfo(className, namedParameters);

    //TODO it should be possible to have nullable parameters, que ce soit an entity or a value object.
    //Only thing that should be generated correctly is the contentVerification.

    // for (final param in classInfo.namedParameters) {
    //   if (!param.hasValidAnnotation &&
    //       param.parameter.type.nullabilitySuffix != NullabilitySuffix.none) {
    //     throw InvalidGenerationSourceError(
    //       'Unless marked with @valid, the parameter should not be nullable',
    //       element: param.parameter,
    //     );
    //   }
    // }

    final classBuffer = StringBuffer();

    makeMixin(classBuffer, classInfo);

    makeValidEntity(classBuffer, classInfo);

    makeInvalidEntity(classBuffer, classInfo);

    makeInvalidEntityContent(classBuffer, classInfo);

    makeInvalidEntityGeneral(classBuffer, classInfo);

    return classBuffer.toString();
  }

  void makeMixin(StringBuffer classBuffer, EntityClassInfo classInfo) {
    classBuffer.writeln('mixin \$$className {');

    //create method
    classBuffer.writeln('static $className _create({');
    for (final param in classInfo.namedParameters) {
      classBuffer.writeln('required ${param.type} ${param.name},');
    }
    classBuffer.writeln('}) {');
    classBuffer.writeln(
        generateContentVerification(classInfo.namedParameters, classInfo));
    classBuffer.writeln('return contentVerification.match(');
    classBuffer.writeln('///The content is invalid');
    classBuffer
        .writeln('(contentFailure) => ${classInfo.invalidEntityContent}._(');
    classBuffer.writeln('contentFailure: contentFailure,');
    for (final param in classInfo.namedParameters) {
      classBuffer.writeln('${param.name} : ${param.name},');
    }
    classBuffer.writeln('),');
    classBuffer.writeln(
        '///The content is valid => We check if there\'s a general failure');
    classBuffer.writeln(
        '(validContent) => const $className._().validateGeneral(validContent).match(');
    classBuffer
        .writeln('(generalFailure) => ${classInfo.invalidEntityGeneral}._(');
    classBuffer.writeln('generalEntityFailure: generalFailure,');
    for (final param in classInfo.namedParameters) {
      classBuffer.writeln('${param.name} : validContent.${param.name},');
    }
    classBuffer.writeln('),');
    classBuffer.writeln('() => validContent,');
    classBuffer.writeln('),');
    classBuffer.writeln(');');

    classBuffer.writeln('}');

    ///toBroadEitherNullable method
    classBuffer.writeln(
        'static Either<Failure, ${classInfo.validEntity}?> toBroadEitherNullable(');
    classBuffer.writeln('$className? nullableEntity) =>');
    classBuffer.writeln(
        'optionOf(nullableEntity).match((t) => t.toBroadEither, () => right(null));');

    ///match method
    classBuffer.writeln('TResult match<TResult extends Object?>(');
    classBuffer.writeln(
        '{required TResult Function(${classInfo.validEntity} valid) valid,');
    classBuffer.writeln(
        'required TResult Function(${classInfo.invalidEntity} invalid) invalid}) {');
    classBuffer.writeln('throw UnimplementedError();');
    classBuffer.writeln('}');

    ///copyWith method
    classBuffer.writeln('$className copyWith({');
    for (final param in classInfo.namedParameters) {
      classBuffer.writeln('${param.optionalType} ${param.name},');
    }

    classBuffer.writeln('}) {');
    classBuffer.writeln('return match(');
    classBuffer.writeln('valid: (valid) => _create(');
    for (final param in classInfo.namedParameters) {
      final name = param.name;
      classBuffer.writeln('$name: $name ?? valid.$name,');
    }
    classBuffer.writeln('),');
    classBuffer.writeln('invalid: (invalid) => _create(');
    for (final param in classInfo.namedParameters) {
      final name = param.name;
      classBuffer.writeln('$name: $name ?? invalid.$name,');
    }
    classBuffer.writeln('),');
    classBuffer.writeln(');');
    classBuffer.writeln('}');

    //End
    classBuffer.writeln('}');
  }

  String generateContentVerification(
      List<EntityParameter> params, EntityClassInfo classInfo) {
    final paramsToVerify = params.where((p) => !p.hasValidAnnotation).toList();
    return '''final contentVerification = 
      ${_makeContentVerificationRecursive(paramsToVerify.length, paramsToVerify, classInfo)}
    ''';
  }

  String _makeContentVerificationRecursive(int totalParamsToVerify,
      List<EntityParameter> paramsToVerify, EntityClassInfo classInfo) {
    final comma = paramsToVerify.length == totalParamsToVerify ? ';' : ',';

    if (paramsToVerify.isNotEmpty) {
      final param = paramsToVerify.first;

      final toBroadEither = param.isNullable
          ? '\$${param.typeWithoutNullabilitySuffix}.toBroadEitherNullable(${param.name})'
          : '${param.name}.toBroadEither';

      return '''$toBroadEither.flatMap(
      (${param.validName}) => ${_makeContentVerificationRecursive(totalParamsToVerify, [
                ...paramsToVerify
              ]..removeAt(0), classInfo)}
      )$comma
      ''';
    }

    final constructorParams = classInfo.namedParameters.map(
        (p) => '${p.name}: ${p.hasValidAnnotation ? p.name : p.validName},');

    return '''right(${classInfo.validEntity}._(
        ${constructorParams.join('')}
      )),
      ''';
  }

  void makeValidEntity(StringBuffer classBuffer, EntityClassInfo classInfo) {
    classBuffer.writeln(
        'class ${classInfo.validEntity} extends $className implements ValidEntity {');

    ///private constructor
    classBuffer.writeln('const ${classInfo.validEntity}._({');
    for (final param in classInfo.namedParameters) {
      classBuffer.writeln('required this.${param.name},');
    }
    classBuffer.writeln('}) : super._();');
    classBuffer.writeln('');

    ///class members
    for (final param in classInfo.namedParameters) {
      final paramType =
          param.hasValidAnnotation ? param.type : 'Valid${param.type}';
      classBuffer.writeln('final $paramType ${param.name};');
    }
    classBuffer.writeln('');

    ///match method
    classBuffer.writeln('@override');
    classBuffer.writeln('TResult match<TResult extends Object?>(');
    classBuffer.writeln(
        '{required TResult Function(${classInfo.validEntity} valid) valid,');
    classBuffer.writeln(
        'required TResult Function(${classInfo.invalidEntity} invalid) invalid}) {');
    classBuffer.writeln('return valid(this);');
    classBuffer.writeln('}');
    classBuffer.writeln('');

    ///allProps method
    classBuffer.writeln('@override');
    classBuffer.writeln('List<Object?> get allProps => [');
    for (final param in classInfo.namedParameters) {
      classBuffer.writeln('${param.name},');
    }
    classBuffer.writeln('];');

    classBuffer.writeln('}');
  }

  void makeInvalidEntity(StringBuffer classBuffer, EntityClassInfo classInfo) {
    classBuffer.writeln(
        'abstract class ${classInfo.invalidEntity} extends $className');
    classBuffer.writeln('implements');
    classBuffer.writeln(
        'InvalidEntity<${classInfo.generalEntityFailure}, ${classInfo.invalidEntityGeneral},');
    classBuffer.writeln('${classInfo.invalidEntityContent}> {');

    ///private constructor
    classBuffer.writeln('const ${classInfo.invalidEntity}._() : super._();');
    classBuffer.writeln('');

    ///Fields getters
    for (final param in classInfo.namedParameters) {
      classBuffer.writeln('${param.type} get ${param.name};');
    }
    classBuffer.writeln('');

    ///match method
    classBuffer.writeln('@override');
    classBuffer.writeln('TResult match<TResult extends Object?>(');
    classBuffer.writeln(
        '{required TResult Function(${classInfo.validEntity} valid) valid,');
    classBuffer.writeln(
        'required TResult Function(${classInfo.invalidEntity} invalid) invalid}) {');
    classBuffer.writeln('return invalid(this);');
    classBuffer.writeln('}');

    ///end
    classBuffer.writeln('}');
  }

  void makeInvalidEntityContent(
      StringBuffer classBuffer, EntityClassInfo classInfo) {
    classBuffer.writeln(
        'class ${classInfo.invalidEntityContent} extends ${classInfo.invalidEntity}');
    classBuffer.writeln('implements InvalidEntityContent {');

    ///private constructor
    classBuffer.writeln('const ${classInfo.invalidEntityContent}._({');
    classBuffer.writeln('required this.contentFailure,');
    for (final param in classInfo.namedParameters) {
      classBuffer.writeln('required this.${param.name},');
    }
    classBuffer.writeln('}) : super._();');
    classBuffer.writeln('');

    ///Getters
    classBuffer.writeln('@override');
    classBuffer.writeln('final Failure contentFailure;');
    classBuffer.writeln('');

    for (final param in classInfo.namedParameters) {
      classBuffer.writeln('@override');
      classBuffer.writeln('final ${param.type} ${param.name};');
    }
    classBuffer.writeln('');

    ///invalidMatch method
    classBuffer.writeln('@override');
    classBuffer.writeln('TResult invalidMatch<TResult extends Object?>(');
    classBuffer.writeln(
        '{required TResult Function(${classInfo.invalidEntityGeneral} invalidEntityGeneral)');
    classBuffer.writeln('invalidEntityGeneral,');
    classBuffer.writeln(
        'required TResult Function(${classInfo.invalidEntityContent} invalidEntityContent)');
    classBuffer.writeln('invalidEntityContent}) {');
    classBuffer.writeln('return invalidEntityContent(this);');
    classBuffer.writeln('}');
    classBuffer.writeln('');

    ///invalidWhen method
    classBuffer.writeln('@override');
    classBuffer.writeln('TResult invalidWhen<TResult extends Object?>({');
    classBuffer.writeln(
        'required TResult Function(${classInfo.generalEntityFailure} generalEntityFailure)');
    classBuffer.writeln('generalEntityFailure,');
    classBuffer.writeln(
        'required TResult Function(Failure contentFailure) contentFailure,');
    classBuffer.writeln('}) {');
    classBuffer.writeln('return contentFailure(this.contentFailure);');
    classBuffer.writeln('}');
    classBuffer.writeln('');

    ///allProps method
    classBuffer.writeln('@override');
    classBuffer.writeln('List<Object?> get allProps => [');
    classBuffer.writeln('contentFailure,');
    for (final param in classInfo.namedParameters) {
      classBuffer.writeln('${param.name},');
    }
    classBuffer.writeln('];');

    ///End
    classBuffer.writeln('}');
  }

  void makeInvalidEntityGeneral(
      StringBuffer classBuffer, EntityClassInfo classInfo) {
    classBuffer.writeln(
        'class ${classInfo.invalidEntityGeneral} extends ${classInfo.invalidEntity}');
    classBuffer.writeln(
        'implements InvalidEntityGeneral<${classInfo.generalEntityFailure}> {');

    ///private constructor
    classBuffer.writeln('const ${classInfo.invalidEntityGeneral}._({');
    classBuffer.writeln('required this.generalEntityFailure,');
    for (final param in classInfo.namedParameters) {
      classBuffer.writeln('required this.${param.name},');
    }
    classBuffer.writeln('}) : super._();');
    classBuffer.writeln('');

    ///Getters
    classBuffer.writeln('@override');
    classBuffer.writeln(
        'final ${classInfo.generalEntityFailure} generalEntityFailure;');
    classBuffer.writeln('');
    for (final param in classInfo.namedParameters) {
      classBuffer.writeln('@override');
      final paramType =
          param.hasValidAnnotation ? param.type : 'Valid${param.type}';
      classBuffer.writeln('final $paramType ${param.name};');
    }
    classBuffer.writeln('');

    ///invalidMatch method
    classBuffer.writeln('@override');
    classBuffer.writeln('TResult invalidMatch<TResult extends Object?>(');
    classBuffer.writeln(
        '{required TResult Function(${classInfo.invalidEntityGeneral} invalidEntityGeneral)');
    classBuffer.writeln('invalidEntityGeneral,');
    classBuffer.writeln(
        'required TResult Function(${classInfo.invalidEntityContent} invalidEntityContent)');
    classBuffer.writeln('invalidEntityContent}) {');
    classBuffer.writeln('return invalidEntityGeneral(this);');
    classBuffer.writeln('}');
    classBuffer.writeln('');

    ///invalidWhen method
    classBuffer.writeln('@override');
    classBuffer.writeln('TResult invalidWhen<TResult extends Object?>({');
    classBuffer.writeln(
        'required TResult Function(${classInfo.generalEntityFailure} generalEntityFailure)');
    classBuffer.writeln('generalEntityFailure,');
    classBuffer.writeln(
        'required TResult Function(Failure contentFailure) contentFailure,');
    classBuffer.writeln('}) {');
    classBuffer
        .writeln('return generalEntityFailure(this.generalEntityFailure);');
    classBuffer.writeln('}');
    classBuffer.writeln('');

    ///allProps method
    classBuffer.writeln('@override');
    classBuffer.writeln('List<Object?> get allProps => [');
    classBuffer.writeln('generalEntityFailure,');
    for (final param in classInfo.namedParameters) {
      classBuffer.writeln('${param.name},');
    }
    classBuffer.writeln('];');

    ///End
    classBuffer.writeln('}');
  }
}
