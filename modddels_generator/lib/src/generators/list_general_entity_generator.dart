import 'package:analyzer/dart/element/element.dart';
import 'package:modddels_generator/src/utils.dart';
import 'package:source_gen/source_gen.dart';

class ListGeneralEntityGenerator {
  ListGeneralEntityGenerator(
      {required this.className, required this.factoryConstructor});

  final String className;
  final ConstructorElement factoryConstructor;

  String generate() {
    final parameters = factoryConstructor.parameters;

    final listParameter = parameters.firstWhere(
      (element) => element.isPositional && element.name == 'list',
      orElse: () => throw InvalidGenerationSourceError(
        'The factory constructor should have a positional argument named "list"',
        element: factoryConstructor,
      ),
    );

    final listParameterType = listParameter.type.toString();
    final regex = RegExp(r"^KtList<(.*)>$");
    final ktListType = regex.firstMatch(listParameterType)?.group(1);

    if (ktListType == null || ktListType.isEmpty || ktListType == 'dynamic') {
      throw InvalidGenerationSourceError(
        'The list argument should be of type KtList<_modeltype_>, where "model_type" is the type of your model',
        element: listParameter,
      );
    }

    if (ktListType.endsWith('?')) {
      throw InvalidGenerationSourceError(
        'The generic type of the KtList should not be nullable',
        element: listParameter,
      );
    }

    final classInfo = ListGeneralEntityClassInfo(className, ktListType);

    final classBuffer = StringBuffer();

    makeMixin(classBuffer, classInfo);

    makeValidEntity(classBuffer, classInfo);

    makeInvalidEntity(classBuffer, classInfo);

    makeInvalidEntityContent(classBuffer, classInfo);

    makeInvalidEntityGeneral(classBuffer, classInfo);

    return classBuffer.toString();
  }

  void makeMixin(
      StringBuffer classBuffer, ListGeneralEntityClassInfo classInfo) {
    classBuffer.writeln('mixin \$$className {');

    //create method
    classBuffer.writeln('''
      static $className _create(
        KtList<${classInfo.ktListType}> list,
      ) {
        ///If any of the list elements is invalid, this holds its failure on the Left (the
        ///failure of the first invalid element encountered)
        ///
        ///Otherwise, holds all the elements as valid modddels, on the Right.
        final contentVerification = list
            .map((element) => element.toBroadEither)
            .fold<Either<Failure, KtList<${classInfo.ktListTypeValid}>>>(
              //We start with an empty list of elements on the right
              right(const KtList<${classInfo.ktListTypeValid}>.empty()),
              (acc, element) => acc.fold(
                (l) => left(l),
                (r) => element.fold(
                  (elementFailure) => left(elementFailure),

                  ///If the element is valid and the "acc" (accumulation) holds a
                  ///list of valid elements (on the right), we append this element
                  ///to the list
                  (validElement) =>
                      right(KtList.from([...r.asList(), validElement])),
                ),
              ),
            );
        
        return contentVerification.match(
          ///The content is invalid
          (contentFailure) => ${classInfo.invalidEntityContent}._(
            contentFailure: contentFailure,
            list: list,
          ),

          ///The content is valid => We check if there's a general failure
          (validContent) => const $className._()
              .validateGeneral(${classInfo.validEntity}._(list: validContent))
              .match(
                (generalFailure) => ${classInfo.invalidEntityGeneral}._(
                  generalEntityFailure: generalFailure,
                  list: validContent,
                ),
                () => ${classInfo.validEntity}._(list: validContent),
              ),
        );
      }
      ''');

    ///getter for the size of the list

    classBuffer.writeln('''
    int get size => mapValidity(
        valid: (valid) => valid.list.size,
        invalid: (invalid)=> invalid.list.size,
      );
    
    ''');

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

    ///maybeMap method
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

    ///maybeMap method
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
    $className copyWith(KtList<${classInfo.ktListType}> Function(KtList<${classInfo.ktListType}> list) callback) {
      return mapValidity(
        valid: (valid) => _create(callback(valid.list)),
        invalid: (invalid) => _create(callback(invalid.list)),
      );
    }
    
    ''');

    //End
    classBuffer.writeln('}');
  }

  void makeValidEntity(
      StringBuffer classBuffer, ListGeneralEntityClassInfo classInfo) {
    classBuffer.writeln(
        'class ${classInfo.validEntity} extends $className implements ValidEntity {');

    ///private constructor
    classBuffer.writeln('''
    const ${classInfo.validEntity}._({
      required this.list,
    }) : super._();    
    
    ''');

    ///class members
    classBuffer.writeln('''
    final KtList<${classInfo.ktListTypeValid}> list;

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
      return valid(this);
    }

    ''');

    ///allProps method
    classBuffer.writeln('''
    @override
    List<Object?> get allProps => [
          list,
        ];

    ''');

    ///end
    classBuffer.writeln('}');
  }

  void makeInvalidEntity(
      StringBuffer classBuffer, ListGeneralEntityClassInfo classInfo) {
    classBuffer.writeln('''
    abstract class ${classInfo.invalidEntity} extends $className
    implements InvalidEntity {
    ''');

    ///private constructor
    classBuffer.writeln('''
    const ${classInfo.invalidEntity}._() : super._();
    
    ''');

    ///Fields getters
    classBuffer.writeln('''
    KtList<${classInfo.ktListType}> get list;

    ''');

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
      StringBuffer classBuffer, ListGeneralEntityClassInfo classInfo) {
    classBuffer.writeln('''
    class ${classInfo.invalidEntityContent} extends ${classInfo.invalidEntity}
      implements InvalidEntityContent {
    
    ''');

    ///private constructor
    classBuffer.writeln('''
    const ${classInfo.invalidEntityContent}._({
      required this.contentFailure,
      required this.list,
    }) : super._();
    ''');

    ///Class members
    classBuffer.writeln('''
    @override
    final Failure contentFailure;

    @override
    final KtList<${classInfo.ktListType}> list;
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
          list,
        ];
    ''');

    ///End
    classBuffer.writeln('}');
  }

  void makeInvalidEntityGeneral(
      StringBuffer classBuffer, ListGeneralEntityClassInfo classInfo) {
    classBuffer.writeln('''
    class ${classInfo.invalidEntityGeneral} extends ${classInfo.invalidEntity}
      implements InvalidEntityGeneral<${classInfo.generalEntityFailure}> {
    ''');

    ///private constructor
    classBuffer.writeln('''
    const ${classInfo.invalidEntityGeneral}._({
      required this.generalEntityFailure,
      required this.list,
    }) : super._();
    ''');

    ///Getters
    classBuffer.writeln('''
    @override
    final ${classInfo.generalEntityFailure} generalEntityFailure;

    @override
    final KtList<${classInfo.ktListTypeValid}> list;

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
          list,
        ];
    ''');

    ///End
    classBuffer.writeln('}');
  }
}
