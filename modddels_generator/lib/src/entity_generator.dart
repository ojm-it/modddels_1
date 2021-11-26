import 'package:analyzer/dart/element/element.dart';
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

    final classBuffer = StringBuffer();

    makeMixin(classBuffer, classInfo);

    makeValidEntity(classBuffer, classInfo);

    makeInvalidEntity(classBuffer, classInfo);

    makeInvalidEntityContent(classBuffer, classInfo);

    makeInvalidEntityGeneral(classBuffer, classInfo);

    return classBuffer.toString();
  }

  void makeMixin(StringBuffer classBuffer, EntityClassInfo classInfo) {
    classBuffer.writeln('''
    mixin \$$className {
    
    ''');

    //create method
    classBuffer.writeln('''
    static $className _create({
      ${classInfo.namedParameters.map((param) => 'required ${param.type} ${param.name},').join()}
    }) {
      ${generateContentVerification(classInfo.namedParameters, classInfo)}

      return contentVerification.match(
        ///The content is invalid
        (contentFailure) => ${classInfo.invalidEntityContent}._(
          contentFailure: contentFailure,
          ${classInfo.namedParameters.map((param) => '${param.name} : ${param.name},').join()}
        ),

        ///The content is valid => We check if there's a general failure
        (validContent) => const $className._().validateGeneral(validContent).match(
          (generalFailure) => ${classInfo.invalidEntityGeneral}._(
            generalEntityFailure: generalFailure,
            ${classInfo.namedParameters.map((param) => '${param.name} : validContent.${param.name},').join()}
          ),
          () => validContent,
        ),
      );
    }
    ''');

    ///toBroadEitherNullable method
    classBuffer.writeln('''
    static Either<Failure, ${classInfo.validEntity}?> toBroadEitherNullable(
      $className? nullableEntity) =>
      optionOf(nullableEntity).match((t) => t.toBroadEither, () => right(null));

    ''');

    ///match method
    classBuffer.writeln('''
    TResult match<TResult extends Object?>(
      {required TResult Function(${classInfo.validEntity} valid) valid,
      required TResult Function(${classInfo.invalidEntity} invalid) invalid}) {
        throw UnimplementedError();
    }
    ''');

    ///copyWith method
    classBuffer.writeln('''
    $className copyWith({
      ${classInfo.namedParameters.map((param) => '${param.optionalType} ${param.name},').join()}
    }) {
      return match(
        valid: (valid) => _create(
          ${classInfo.namedParameters.map((param) => '${param.name}: ${param.name} ?? valid.${param.name},').join()}
        ),
        invalid: (invalid) => _create(
          ${classInfo.namedParameters.map((param) => '${param.name}: ${param.name} ?? invalid.${param.name},').join()}
        ),
      );
    }

    ''');

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
      ))$comma
      ''';
  }

  void makeValidEntity(StringBuffer classBuffer, EntityClassInfo classInfo) {
    classBuffer.writeln('''
    class ${classInfo.validEntity} extends $className implements ValidEntity {
      
    ''');

    ///private constructor
    classBuffer.writeln('''
    const ${classInfo.validEntity}._({
      ${classInfo.namedParameters.map((param) => 'required this.${param.name},').join()}
      }) : super._();

    ''');

    ///class members
    for (final param in classInfo.namedParameters) {
      final paramType =
          param.hasValidAnnotation ? param.type : 'Valid${param.type}';
      classBuffer.writeln('final $paramType ${param.name};');
    }
    classBuffer.writeln('');

    ///match method
    classBuffer.writeln('''
    @override
    TResult match<TResult extends Object?>(
      {required TResult Function(${classInfo.validEntity} valid) valid,
      required TResult Function(${classInfo.invalidEntity} invalid) invalid}) {
        return valid(this);
    }

    ''');

    ///allProps method
    classBuffer.writeln('''
    @override
    List<Object?> get allProps => [
        ${classInfo.namedParameters.map((param) => '${param.name},').join()}
      ];
    ''');

    ///end
    classBuffer.writeln('}');
  }

  void makeInvalidEntity(StringBuffer classBuffer, EntityClassInfo classInfo) {
    classBuffer.writeln('''
    abstract class ${classInfo.invalidEntity} extends $className
      implements
        InvalidEntity<${classInfo.generalEntityFailure}, ${classInfo.invalidEntityGeneral},
          ${classInfo.invalidEntityContent}> {
    ''');

    ///private constructor
    classBuffer.writeln('''
    const ${classInfo.invalidEntity}._() : super._();

    ''');

    ///Fields getters
    for (final param in classInfo.namedParameters) {
      classBuffer.writeln('${param.type} get ${param.name};');
    }
    classBuffer.writeln('');

    ///match method
    classBuffer.writeln('''
    @override
    TResult match<TResult extends Object?>(
      {required TResult Function(${classInfo.validEntity} valid) valid,
      required TResult Function(${classInfo.invalidEntity} invalid) invalid}) {
        return invalid(this);
    }
    ''');

    ///end
    classBuffer.writeln('}');
  }

  void makeInvalidEntityContent(
      StringBuffer classBuffer, EntityClassInfo classInfo) {
    classBuffer.writeln('''
    class ${classInfo.invalidEntityContent} extends ${classInfo.invalidEntity}
      implements InvalidEntityContent {        
    ''');

    ///private constructor
    classBuffer.writeln('''
    const ${classInfo.invalidEntityContent}._({
      required this.contentFailure,
      ${classInfo.namedParameters.map((param) => 'required this.${param.name},').join()}
    }) : super._();
    ''');

    ///Getters
    classBuffer.writeln('''
    @override
    final Failure contentFailure;

    ${classInfo.namedParameters.map((param) => '''
    @override
    final ${param.type} ${param.name};
    ''').join()}

    ''');

    ///invalidMatch method
    classBuffer.writeln('''
    @override
    TResult invalidMatch<TResult extends Object?>(
      {required TResult Function(${classInfo.invalidEntityGeneral} invalidEntityGeneral)
        invalidEntityGeneral,
      required TResult Function(${classInfo.invalidEntityContent} invalidEntityContent)
        invalidEntityContent}) {
          return invalidEntityContent(this);
    }
    ''');

    ///invalidWhen method
    classBuffer.writeln('''
    @override
    TResult invalidWhen<TResult extends Object?>({
      required TResult Function(${classInfo.generalEntityFailure} generalEntityFailure)
        generalEntityFailure,
      required TResult Function(Failure contentFailure) contentFailure,
    }) {
      return contentFailure(this.contentFailure);
    }
    ''');

    ///allProps method
    classBuffer.writeln('''
    @override
    List<Object?> get allProps => [
      contentFailure,
      ${classInfo.namedParameters.map((param) => '${param.name},').join()}
    ];

    ''');

    ///End
    classBuffer.writeln('}');
  }

  void makeInvalidEntityGeneral(
      StringBuffer classBuffer, EntityClassInfo classInfo) {
    classBuffer.writeln('''
    class ${classInfo.invalidEntityGeneral} extends ${classInfo.invalidEntity}
      implements InvalidEntityGeneral<${classInfo.generalEntityFailure}> {
    ''');

    ///private constructor
    classBuffer.writeln('''
    const ${classInfo.invalidEntityGeneral}._({
      required this.generalEntityFailure,
      ${classInfo.namedParameters.map((param) => 'required this.${param.name},').join()}
    }) : super._();

    ''');

    ///Getters
    classBuffer.writeln('''
    @override
    final ${classInfo.generalEntityFailure} generalEntityFailure;

    ${classInfo.namedParameters.map((param) => '''
    @override
    final ${param.hasValidAnnotation ? param.type : 'Valid${param.type}'} ${param.name};
    ''').join()}

    ''');

    ///invalidMatch method
    classBuffer.writeln('''
    @override
    TResult invalidMatch<TResult extends Object?>(
      {required TResult Function(${classInfo.invalidEntityGeneral} invalidEntityGeneral)
        invalidEntityGeneral,
      required TResult Function(${classInfo.invalidEntityContent} invalidEntityContent)
        invalidEntityContent}) {
          return invalidEntityGeneral(this);
    }
    ''');

    ///invalidWhen method
    classBuffer.writeln('''
    @override
    TResult invalidWhen<TResult extends Object?>({
      required TResult Function(${classInfo.generalEntityFailure} generalEntityFailure)
        generalEntityFailure,
      required TResult Function(Failure contentFailure) contentFailure,
    }) {
      return generalEntityFailure(this.generalEntityFailure);
    }

    ''');

    ///allProps method
    classBuffer.writeln('''
    @override
    List<Object?> get allProps => [
      generalEntityFailure,
      ${classInfo.namedParameters.map((param) => '${param.name},').join()}
    ];
    ''');

    ///End
    classBuffer.writeln('}');
  }
}
