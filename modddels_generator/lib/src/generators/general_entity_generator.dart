import 'package:analyzer/dart/element/element.dart';
import 'package:modddels_generator/src/utils.dart';
import 'package:source_gen/source_gen.dart';

class GeneralEntityGenerator {
  GeneralEntityGenerator(
      {required this.className, required this.factoryConstructor});

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

    final classInfo = GeneralEntityClassInfo(className, namedParameters);

    final classBuffer = StringBuffer();

    makeMixin(classBuffer, classInfo);

    makeValidEntity(classBuffer, classInfo);

    makeInvalidEntity(classBuffer, classInfo);

    makeInvalidEntityContent(classBuffer, classInfo);

    makeInvalidEntityGeneral(classBuffer, classInfo);

    return classBuffer.toString();
  }

  void makeMixin(StringBuffer classBuffer, GeneralEntityClassInfo classInfo) {
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

    ///Getters for fields marked with '@withGetter' (or with '@validWithGetter')

    final getterParameters = classInfo.namedParameters
        .where((e) => e.hasWithGetterAnnotation == true);

    for (final param in getterParameters) {
      classBuffer.writeln('''
      ${param.type} get ${param.name} => mapValidity(
        valid: (valid) => valid.${param.name},
        invalid: (invalid) => invalid.${param.name},
      );
    
      ''');
    }

    ///toBroadEitherNullable method
    classBuffer.writeln('''
    static Either<Failure, ${classInfo.validEntity}?> toBroadEitherNullable(
      $className? nullableEntity) =>
      optionOf(nullableEntity).match((t) => t.toBroadEither, () => right(null));

    ''');

    ///map method
    classBuffer.writeln('''
    TResult map<TResult extends Object?>({
      required TResult Function(${classInfo.validEntity} valid) valid,
      required TResult Function(${classInfo.invalidEntityContent} invalidContent)
          invalidContent,
      required TResult Function(${classInfo.invalidEntityGeneral} invalidGeneral)
          invalidGeneral,
    }) {
      return maybeMap(
        valid: valid,
        invalidContent: invalidContent,
        invalidGeneral: invalidGeneral,
        orElse: (invalid) => throw UnreachableError(),
      );
    }

    ''');

    ///maybe map method
    classBuffer.writeln('''
    TResult maybeMap<TResult extends Object?>({
      required TResult Function(${classInfo.validEntity} valid) valid,
      TResult Function(${classInfo.invalidEntityContent} invalidContent)? invalidContent,
      TResult Function(${classInfo.invalidEntityGeneral} invalidGeneral)? invalidGeneral,
      required TResult Function(${classInfo.invalidEntity} invalid) orElse,
    }) {
      throw UnimplementedError();
    }

    ''');

    ///mapValidity method
    classBuffer.writeln('''
    TResult mapValidity<TResult extends Object?>({
      required TResult Function(${classInfo.validEntity} valid) valid,
      required TResult Function(${classInfo.invalidEntity} invalid) invalid,
    }) {
      return maybeMap(
        valid: valid,
        orElse: invalid,
      );
    }

    ''');

    ///copyWith method
    classBuffer.writeln('''
    $className copyWith({
      ${classInfo.namedParameters.map((param) => '${param.optionalType} ${param.name},').join()}
    }) {
      return mapValidity(
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
      List<EntityParameter> params, GeneralEntityClassInfo classInfo) {
    final paramsToVerify = params.where((p) => !p.hasValidAnnotation).toList();
    return '''final contentVerification = 
      ${_makeContentVerificationRecursive(paramsToVerify.length, paramsToVerify, classInfo)}
    ''';
  }

  String _makeContentVerificationRecursive(int totalParamsToVerify,
      List<EntityParameter> paramsToVerify, GeneralEntityClassInfo classInfo) {
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

  void makeValidEntity(
      StringBuffer classBuffer, GeneralEntityClassInfo classInfo) {
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
      if (param.hasWithGetterAnnotation == true) {
        classBuffer.writeln('@override');
      }
      final paramType =
          param.hasValidAnnotation ? param.type : 'Valid${param.type}';
      classBuffer.writeln('final $paramType ${param.name};');
    }
    classBuffer.writeln('');

    ///maybeMap method
    classBuffer.writeln('''
    @override
    TResult maybeMap<TResult extends Object?>({
      required TResult Function(${classInfo.validEntity} valid) valid,
      TResult Function(${classInfo.invalidEntityContent} invalidContent)? invalidContent,
      TResult Function(${classInfo.invalidEntityGeneral} invalidGeneral)? invalidGeneral,
      required TResult Function(${classInfo.invalidEntity} invalid) orElse,
    }) {
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

  void makeInvalidEntity(
      StringBuffer classBuffer, GeneralEntityClassInfo classInfo) {
    classBuffer.writeln('''
    abstract class ${classInfo.invalidEntity} extends $className
      implements InvalidEntity {
    ''');

    ///private constructor
    classBuffer.writeln('''
    const ${classInfo.invalidEntity}._() : super._();

    ''');

    ///Fields Getters
    for (final param in classInfo.namedParameters) {
      if (param.hasWithGetterAnnotation == true) {
        classBuffer.writeln('@override');
      }
      classBuffer.writeln('${param.type} get ${param.name};');
    }
    classBuffer.writeln('');

    ///Failure getter
    classBuffer.writeln('''
    @override
    Failure get failure => whenInvalid(
          contentFailure: (contentFailure) => contentFailure,
          generalEntityFailure: (generalEntityFailure) => generalEntityFailure,
        );

    ''');

    ///mapInvalid method
    classBuffer.writeln('''
    TResult mapInvalid<TResult extends Object?>({
      required TResult Function(${classInfo.invalidEntityContent} invalidContent)
          invalidContent,
      required TResult Function(${classInfo.invalidEntityGeneral} invalidGeneral)
          invalidGeneral,
    }) {
      return maybeMap(
        valid: (valid) => throw UnreachableError(),
        invalidContent: invalidContent,
        invalidGeneral: invalidGeneral,
        orElse: (invalid) => throw UnreachableError(),
      );
    }
    ''');

    ///whenInvalid method
    classBuffer.writeln('''
    TResult whenInvalid<TResult extends Object?>({
      required TResult Function(Failure contentFailure) contentFailure,
      required TResult Function(${classInfo.generalEntityFailure} generalEntityFailure)
          generalEntityFailure,
    }) {
      return maybeMap(
        valid: (valid) => throw UnreachableError(),
        invalidContent: (invalidContent) =>
            contentFailure(invalidContent.contentFailure),
        invalidGeneral: (invalidGeneral) =>
            generalEntityFailure(invalidGeneral.generalEntityFailure),
        orElse: (invalid) => throw UnreachableError(),
      );
    }
    ''');

    ///end
    classBuffer.writeln('}');
  }

  void makeInvalidEntityContent(
      StringBuffer classBuffer, GeneralEntityClassInfo classInfo) {
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

    ///maybeMap method
    classBuffer.writeln('''
    @override
    TResult maybeMap<TResult extends Object?>({
      required TResult Function(${classInfo.validEntity} valid) valid,
      TResult Function(${classInfo.invalidEntityContent} invalidContent)? invalidContent,
      TResult Function(${classInfo.invalidEntityGeneral} invalidGeneral)? invalidGeneral,
      required TResult Function(${classInfo.invalidEntity} invalid) orElse,
    }) {
      if (invalidContent != null) {
        return invalidContent(this);
      }
      return orElse(this);
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
      StringBuffer classBuffer, GeneralEntityClassInfo classInfo) {
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

    ///maybeMap method
    classBuffer.writeln('''
    @override
    TResult invalidMatch<TResult extends Object?>(
      {required TResult Function(${classInfo.invalidEntityGeneral} invalidGeneral)
        invalidGeneral,
      required TResult Function(${classInfo.invalidEntityContent} invalidContent)
        invalidContent}) {
          return invalidGeneral(this);
    }

    @override
    TResult maybeMap<TResult extends Object?>({
      required TResult Function(${classInfo.validEntity} valid) valid,
      TResult Function(${classInfo.invalidEntityContent} invalidContent)? invalidContent,
      TResult Function(${classInfo.invalidEntityGeneral} invalidGeneral)? invalidGeneral,
      required TResult Function(${classInfo.invalidEntity} invalid) orElse,
    }) {
      if (invalidGeneral != null) {
        return invalidGeneral(this);
      }
      return orElse(this);
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
