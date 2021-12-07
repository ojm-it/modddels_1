import 'package:analyzer/dart/element/element.dart';
import 'package:modddels_generator/src/utils.dart';
import 'package:source_gen/source_gen.dart';

class SimpleEntityGenerator {
  SimpleEntityGenerator(
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

    final classInfo = SimpleEntityClassInfo(className, namedParameters);

    for (final param in classInfo.namedParameters) {
      if (param.hasWithGetterAnnotation) {
        throw InvalidGenerationSourceError(
          'The @withGetter annotation is reserved for General Entities, and is useless for Simple Entities.',
          element: param.parameter,
        );
      }
    }

    final classBuffer = StringBuffer();

    makeMixin(classBuffer, classInfo);

    makeValidEntity(classBuffer, classInfo);

    makeInvalidEntityContent(classBuffer, classInfo);

    return classBuffer.toString();
  }

  void makeMixin(StringBuffer classBuffer, SimpleEntityClassInfo classInfo) {
    classBuffer.writeln('''
    mixin \$$className {
    
    ''');

    /// create method
    classBuffer.writeln('''
    static $className _create({
      ${classInfo.namedParameters.map((param) => 'required ${param.type} ${param.name},').join()}
    }) {
      /// 1. **Content Validation**
      return _verifyContent(
        ${classInfo.namedParameters.map((param) => '${param.name} : ${param.name},').join()}
      ).match(
        (contentFailure) => ${classInfo.invalidEntityContent}._(
          contentFailure: contentFailure,
           ${classInfo.namedParameters.map((param) => '${param.name} : ${param.name},').join()}
        ),

        /// 2. **→ Validations passed**
        (validContent) => validContent,
      );
    }
    ''');

    /// verifyContent function
    classBuffer.writeln('''
    /// If any of the modddels is invalid, this holds its failure on the Left (the
    /// failure of the first invalid modddel encountered)
    ///
    /// Otherwise, holds all the modddels as valid modddels, wrapped inside a
    /// ValidEntity, on the Right.
    static Either<Failure, ${classInfo.validEntity}> _verifyContent({
     ${classInfo.namedParameters.map((param) => 'required ${param.type} ${param.name},').join()}
    }) {
      ${generateContentVerification(classInfo.namedParameters, classInfo)}
      return contentVerification;
    }
    ''');

    /// Getters for all the fields

    for (final param in classInfo.namedParameters) {
      classBuffer.writeln('''
      ${param.type} get ${param.name} => map(
        valid: (valid) => valid.${param.name},
        invalidContent: (invalidContent) => invalidContent.${param.name},
      );
    
      ''');
    }

    /// toBroadEitherNullable method
    classBuffer.writeln('''
    /// If [nullableEntity] is null, returns `right(null)`.
    /// Otherwise, returns `nullableEntity.toBroadEither`
    static Either<Failure, ${classInfo.validEntity}?> toBroadEitherNullable(
      $className? nullableEntity) =>
      optionOf(nullableEntity).match((t) => t.toBroadEither, () => right(null));

    ''');

    /// map method
    classBuffer.writeln('''
    /// Same as [mapValidity] (because there is only one invalid union-case)
    TResult map<TResult extends Object?>({
      required TResult Function(${classInfo.validEntity} valid) valid,
      required TResult Function(${classInfo.invalidEntityContent} invalidContent)
          invalidContent,
    }) {
      throw UnimplementedError();
    }

    ''');

    /// map validity method
    classBuffer.writeln('''
    /// Pattern matching for the two different union-cases of this entity : valid
    /// and invalid.
    TResult mapValidity<TResult extends Object?>({
      required TResult Function(${classInfo.validEntity} valid) valid,
      required TResult Function(${classInfo.invalidEntityContent} invalidContent) invalid,
    }) {
      return map(
        valid: valid,
        invalidContent: invalid,
      );
    }

    ''');

    /// copyWith method
    classBuffer.writeln('''
    /// Creates a clone of this entity with the new specified values.
    ///
    /// The resulting entity is totally independent from this entity. It is
    /// validated upon creation, and can be either valid or invalid.
    $className copyWith({
      ${classInfo.namedParameters.map((param) => '${param.optionalType} ${param.name},').join()}
    }) {
      return map(
        valid: (valid) => _create(
          ${classInfo.namedParameters.map((param) => '${param.name}: ${param.name} ?? valid.${param.name},').join()}
        ),
        invalidContent: (invalidContent) => _create(
          ${classInfo.namedParameters.map((param) => '${param.name}: ${param.name} ?? invalidContent.${param.name},').join()}
        ),
      );
    }

    ''');

    /// End
    classBuffer.writeln('}');
  }

  String generateContentVerification(
      List<EntityParameter> params, SimpleEntityClassInfo classInfo) {
    final paramsToVerify = params.where((p) => !p.hasValidAnnotation).toList();
    return '''final contentVerification = 
      ${_makeContentVerificationRecursive(paramsToVerify.length, paramsToVerify, classInfo)}
    ''';
  }

  String _makeContentVerificationRecursive(int totalParamsToVerify,
      List<EntityParameter> paramsToVerify, SimpleEntityClassInfo classInfo) {
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
      StringBuffer classBuffer, SimpleEntityClassInfo classInfo) {
    classBuffer.writeln('''
    class ${classInfo.validEntity} extends $className implements ValidEntity {
      
    ''');

    /// private constructor
    classBuffer.writeln('''
    const ${classInfo.validEntity}._({
      ${classInfo.namedParameters.map((param) => 'required this.${param.name},').join()}
      }) : super._();

    ''');

    /// class members
    for (final param in classInfo.namedParameters) {
      classBuffer.writeln('@override');
      final paramType =
          param.hasValidAnnotation ? param.type : 'Valid${param.type}';
      classBuffer.writeln('final $paramType ${param.name};');
    }
    classBuffer.writeln('');

    /// map method
    classBuffer.writeln('''
    @override
    TResult map<TResult extends Object?>({
      required TResult Function(${classInfo.validEntity} valid) valid,
      required TResult Function(${classInfo.invalidEntityContent} invalidContent)
          invalidContent,
    }) {
      return valid(this);
    }

    ''');

    /// allProps method
    classBuffer.writeln('''
    @override
    List<Object?> get allProps => [
        ${classInfo.namedParameters.map((param) => '${param.name},').join()}
      ];
    ''');

    /// end
    classBuffer.writeln('}');
  }

  void makeInvalidEntityContent(
      StringBuffer classBuffer, SimpleEntityClassInfo classInfo) {
    classBuffer.writeln('''
    class ${classInfo.invalidEntityContent} extends $className
      implements InvalidEntityContent {        
    ''');

    /// private constructor
    classBuffer.writeln('''
    const ${classInfo.invalidEntityContent}._({
      required this.contentFailure,
      ${classInfo.namedParameters.map((param) => 'required this.${param.name},').join()}
    }) : super._();
    ''');

    /// Getters
    classBuffer.writeln('''
    @override
    final Failure contentFailure;

    @override
    Failure get failure => contentFailure;

    ${classInfo.namedParameters.map((param) => '''
    @override
    final ${param.type} ${param.name};
    ''').join()}

    ''');

    /// map method
    classBuffer.writeln('''
    @override
    TResult map<TResult extends Object?>({
      required TResult Function(${classInfo.validEntity} valid) valid,
      required TResult Function(${classInfo.invalidEntityContent} invalidContent)
          invalidContent,
    }) {
      return invalidContent(this);
    }

    ''');

    /// allProps method
    classBuffer.writeln('''
    @override
    List<Object?> get allProps => [
      contentFailure,
      ${classInfo.namedParameters.map((param) => '${param.name},').join()}
    ];

    ''');

    /// End
    classBuffer.writeln('}');
  }
}