import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:modddels_annotations/modddels.dart';
import 'package:modddels_generator/src/core/class_info/class_info.dart';
import 'package:modddels_generator/src/core/templates/parameters_template.dart';

class ListEntityGenerator {
  ListEntityGenerator._({
    required this.classInfo,
    required this.generateTester,
    required this.maxSutDescriptionLength,
    required this.stringifyMode,
  });

  final ListEntityClassInfo classInfo;

  /// See [ModddelAnnotation.generateTester]
  final bool generateTester;

  /// See [ModddelAnnotation.maxSutDescriptionLength]
  final int maxSutDescriptionLength;

  /// See [ModddelAnnotation.stringifyMode]
  final StringifyMode stringifyMode;

  String get className => classInfo.className;

  ParametersTemplate get parametersTemplate => classInfo.parametersTemplate;

  static Future<ListEntityGenerator> create({
    required BuildStep buildStep,
    required String className,
    required ConstructorElement factoryConstructor,
    required bool generateTester,
    required int maxSutDescriptionLength,
    required StringifyMode stringifyMode,
  }) async {
    final classInfo = await ListEntityClassInfo.create(
      buildStep: buildStep,
      className: className,
      factoryConstructor: factoryConstructor,
    );

    return ListEntityGenerator._(
      classInfo: classInfo,
      generateTester: generateTester,
      maxSutDescriptionLength: maxSutDescriptionLength,
      stringifyMode: stringifyMode,
    );
  }

  @override
  String toString() {
    final tester = generateTester
        ? '''
          $makeTester
          $makeModddelInput
          '''
        : '';

    return '''
    $makeMixin
    $makeValidEntity
    $makeInvalidEntityContent
    $tester
    ''';
  }

  String get makeMixin {
    final buffer = StringBuffer();

    buffer.writeln('mixin \$$className {');

    /// create method
    buffer.writeln('''
      static $className _create(
        KtList<${classInfo.ktListType}> list,
      ) {
        /// 1. **Content validation**
        return _verifyContent(list).match(
          (contentFailure) => ${classInfo.invalidContent}._(
            contentFailure: contentFailure,
            list: list,
          ),

          /// 2. **→ Validations passed**
          (validContent) => ${classInfo.valid}._(list: validContent),
        );
      }
      ''');

    /// verifyContent function
    buffer.writeln('''
    /// If any of the list elements is invalid, this holds its failure on the Left
    /// (the failure of the first invalid element encountered)
    ///
    /// Otherwise, holds the list of all the elements as valid modddels, on the
    /// Right.
    static Either<Failure, KtList<${classInfo.ktListTypeValid}>> _verifyContent(KtList<${classInfo.ktListType}> list) {
      final contentVerification = list
          .map((element) => element.toBroadEither)
          .fold<Either<Failure, KtList<${classInfo.ktListTypeValid}>>>(
            /// We start with an empty list of elements on the right
            right(const KtList<${classInfo.ktListTypeValid}>.empty()),
            (acc, element) => acc.fold(
              (l) => left(l),
              (r) => element.fold(
                (elementFailure) => left(elementFailure),

                /// If the element is valid and the "acc" (accumulation) holds a
                /// list of valid elements (on the right), we append this element
                /// to the list
                (validElement) =>
                    right(KtList.from([...r.asList(), validElement])),
              ),
            ),
          );
      return contentVerification;
    }
    
    ''');

    /// getter for the list
    buffer.writeln('''
    KtList<${classInfo.ktListType}> get list => map(
        valid: (valid) => valid.list,
        invalidContent: (invalidContent) => invalidContent.list,
      );
    
    ''');

    /// getter for the size of the list

    buffer.writeln('''
    /// The size of the list
    int get size => list.size;
    
    ''');

    /// toBroadEitherNullable method
    buffer.writeln('''
    /// If [nullableEntity] is null, returns `right(null)`.
    /// Otherwise, returns `nullableEntity.toBroadEither`.
    static Either<Failure, ${classInfo.valid}?> toBroadEitherNullable(
          $className? nullableEntity) =>
      optionOf(nullableEntity).match((t) => t.toBroadEither, () => right(null));
    
    ''');

    /// map method
    buffer.writeln('''
    /// Same as [mapValidity] (because there is only one invalid union-case)
    TResult map<TResult extends Object?>({
      required TResult Function(${classInfo.valid} valid) valid,
      required TResult Function(${classInfo.invalidContent} invalidContent)
          invalidContent,
    }) {
      throw UnimplementedError();
    }
    
    ''');

    /// mapValidity method
    buffer.writeln('''
    /// Pattern matching for the two different union-cases of this entity : valid
    /// and invalid.
    TResult mapValidity<TResult extends Object?>({
      required TResult Function(${classInfo.valid} valid) valid,
      required TResult Function(${classInfo.invalidContent} invalidContent) invalid,
    }) {
      return map(
        valid: valid,
        invalidContent: invalid,
      );
    }
    
    ''');

    /// copyWith method
    buffer.writeln('''
    /// Creates a clone of this entity with the list returned from [callback].
    ///
    /// The resulting entity is totally independent from this entity. It is
    /// validated upon creation, and can be either valid or invalid.
    $className copyWith(KtList<${classInfo.ktListType}> Function(KtList<${classInfo.ktListType}> list) callback) {
       return _create(callback(list));
    }
    
    ''');

    /// props and stringifyMode getters
    buffer.writeln('''
    List<Object?> get props => throw UnimplementedError();

    StringifyMode get stringifyMode => ${stringifyMode.toString()};
    ''');

    /// End
    buffer.writeln('}');

    return buffer.toString();
  }

  String get makeValidEntity {
    final buffer = StringBuffer();

    buffer.writeln(
        'class ${classInfo.valid} extends $className implements ValidEntity {');

    /// private constructor
    buffer.writeln('''
    const ${classInfo.valid}._({
      required this.list,
    }) : super._();    
    
    ''');

    /// class members
    buffer.writeln('''
    @override
    final KtList<${classInfo.ktListTypeValid}> list;

    ''');

    /// map method
    buffer.writeln('''
    @override
    TResult map<TResult extends Object?>({
      required TResult Function(${classInfo.valid} valid) valid,
      required TResult Function(${classInfo.invalidContent} invalidContent)
          invalidContent,
    }) {
      return valid(this);
    }

    ''');

    /// props getter
    buffer.writeln('''
    @override
    List<Object?> get props => [
          list,
        ];

    ''');

    /// end
    buffer.writeln('}');

    return buffer.toString();
  }

  String get makeInvalidEntityContent {
    final buffer = StringBuffer();

    buffer.writeln('''
    class ${classInfo.invalidContent} extends $className
      implements InvalidEntityContent {
    
    ''');

    /// private constructor
    buffer.writeln('''
    const ${classInfo.invalidContent}._({
      required this.contentFailure,
      required this.list,
    }) : super._();
    ''');

    /// Class members
    buffer.writeln('''
    @override
    final Failure contentFailure;

    @override
    Failure get failure => contentFailure;

    @override
    final KtList<${classInfo.ktListType}> list;
    ''');

    /// map method
    buffer.writeln('''
    @override
    TResult map<TResult extends Object?>({
      required TResult Function(${classInfo.valid} valid) valid,
      required TResult Function(${classInfo.invalidContent} invalidContent)
          invalidContent,
    }) {
      return invalidContent(this);
    }  

    ''');

    /// props getter
    buffer.writeln('''
    @override
    List<Object?> get props => [
          contentFailure,
          list,
        ];
    ''');

    /// End
    buffer.writeln('}');

    return buffer.toString();
  }

  String get makeTester {
    final buffer = StringBuffer();

    buffer.writeln('''
    class ${className}Tester extends ListEntityTester<${classInfo.invalidContent},
      ${classInfo.valid}, $className, ${classInfo.modddelInput}> {
    ''');

    /// constructor
    buffer.writeln('''
    const ${className}Tester({
      int maxSutDescriptionLength = $maxSutDescriptionLength,
      String isSanitizedGroupDescription = 'Should be sanitized',
      String isNotSanitizedGroupDescription = 'Should not be sanitized',
      String isValidGroupDescription = 'Should be a ${classInfo.valid}',
      String isInvalidContentGroupDescription =
          'Should be an ${classInfo.invalidContent} and hold the proper contentFailure',
    }) : super(
            maxSutDescriptionLength: maxSutDescriptionLength,
            isSanitizedGroupDescription: isSanitizedGroupDescription,
            isNotSanitizedGroupDescription: isNotSanitizedGroupDescription,
            isValidGroupDescription: isValidGroupDescription,
            isInvalidContentGroupDescription: isInvalidContentGroupDescription,
          );
    ''');

    /// makeInput field
    buffer.writeln('''
    final makeInput = ${classInfo.modddelInput}.new;
    ''');

    /// end
    buffer.writeln('}');

    return buffer.toString();
  }

  String get makeModddelInput {
    final buffer = StringBuffer();

    buffer.writeln('''
    class ${classInfo.modddelInput} extends ModddelInput<$className> {
    ''');

    /// constructor
    buffer.writeln('''
    const ${classInfo.modddelInput}(this.list);
    ''');

    /// class members
    buffer.writeln('''
    final KtList<${classInfo.ktListType}> list;
    ''');

    /// props method
    buffer.writeln('''
    @override
    List<Object?> get props => [list];
    ''');

    /// sanitizedInput method
    buffer.writeln('''
    @override
    ${classInfo.modddelInput} get sanitizedInput {
      final modddel = $className(list);

      return ${classInfo.modddelInput}(modddel.list);
    }
    ''');

    /// end
    buffer.writeln('}');

    return buffer.toString();
  }
}
