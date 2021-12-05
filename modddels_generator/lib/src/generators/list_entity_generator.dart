import 'package:analyzer/dart/element/element.dart';
import 'package:modddels_generator/src/utils.dart';
import 'package:source_gen/source_gen.dart';

class ListEntityGenerator {
  ListEntityGenerator(
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

    final classInfo = ListEntityClassInfo(className, ktListType);

    final classBuffer = StringBuffer();

    makeMixin(classBuffer, classInfo);

    makeValidEntity(classBuffer, classInfo);

    makeInvalidEntityContent(classBuffer, classInfo);

    return classBuffer.toString();
  }

  void makeMixin(StringBuffer classBuffer, ListEntityClassInfo classInfo) {
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

          ///The content is valid => The entity is valid
          (validContent) => ${classInfo.validEntity}._(list: validContent),
        );
      }
      ''');

    ///getter for the list
    classBuffer.writeln('''
    KtList<${classInfo.ktListType}> get list => map(
        valid: (valid) => valid.list,
        invalidContent: (invalidContent) => invalidContent.list,
      );
    
    ''');

    ///getter for the size of the list

    classBuffer.writeln('''
    int get size => list.size;
    
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
    }) {
      throw UnimplementedError();
    }
    
    ''');

    ///mapValidity method
    classBuffer.writeln('''
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

    ///copyWith method
    classBuffer.writeln('''
    $className copyWith(KtList<${classInfo.ktListType}> Function(KtList<${classInfo.ktListType}> list) callback) {
      return map(
        valid: (valid) => _create(callback(valid.list)),
        invalidContent: (invalidContent) => _create(callback(invalidContent.list)),
      );
    }
    
    ''');

    //End
    classBuffer.writeln('}');
  }

  void makeValidEntity(
      StringBuffer classBuffer, ListEntityClassInfo classInfo) {
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
    @override
    final KtList<${classInfo.ktListTypeValid}> list;

    ''');

    ///map method
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

  void makeInvalidEntityContent(
      StringBuffer classBuffer, ListEntityClassInfo classInfo) {
    classBuffer.writeln('''
    class ${classInfo.invalidEntityContent} extends $className
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
    Failure get failure => contentFailure;

    @override
    final KtList<${classInfo.ktListType}> list;
    ''');

    ///map method
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
}
