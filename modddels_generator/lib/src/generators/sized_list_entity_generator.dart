import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:modddels_annotations/modddels.dart';
import 'package:modddels_generator/src/core/class_info/class_info.dart';
import 'package:modddels_generator/src/core/templates/parameters_template.dart';

class SizedListEntityGenerator {
  SizedListEntityGenerator._({
    required this.classInfo,
    required this.generateTester,
    required this.maxSutDescriptionLength,
    required this.stringifyMode,
  });

  final SizedListEntityClassInfo classInfo;

  /// See [ModddelAnnotation.generateTester]
  final bool generateTester;

  /// See [ModddelAnnotation.maxSutDescriptionLength]
  final int maxSutDescriptionLength;

  /// See [ModddelAnnotation.stringifyMode]
  final StringifyMode stringifyMode;

  String get className => classInfo.className;

  ParametersTemplate get parametersTemplate => classInfo.parametersTemplate;

  static Future<SizedListEntityGenerator> create({
    required BuildStep buildStep,
    required String className,
    required ConstructorElement factoryConstructor,
    required bool generateTester,
    required int maxSutDescriptionLength,
    required StringifyMode stringifyMode,
  }) async {
    final classInfo = await SizedListEntityClassInfo.create(
      buildStep: buildStep,
      className: className,
      factoryConstructor: factoryConstructor,
    );

    return SizedListEntityGenerator._(
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
    $makeInvalidEntity
    $makeInvalidEntitySize
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
      /// 1. **Size validation**
      return _verifySize(list).match(
        (sizeFailure) =>
            ${classInfo.invalidSize}._(sizeFailure: sizeFailure, list: list),
        
        /// 2. **Content validation**
        (validSize) => _verifyContent(validSize).match(
          (contentFailure) => ${classInfo.invalidContent}._(
            contentFailure: contentFailure,
            list: validSize,
          ),

          /// 3. **→ Validations passed**
          (validContent) =>${classInfo.valid}._(list: validContent),
        ),
      );
    }
      ''');

    /// _verifySize function
    buffer.writeln('''
    /// If the size of the list is invalid, this holds the [SizeFailure] on the
    /// Left. Otherwise, holds the list on the Right.
    static Either<${classInfo.sizeFailure}, KtList<${classInfo.ktListType}>> _verifySize(
        KtList<${classInfo.ktListType}> list) {
      final sizeVerification = const $className._().validateSize(list.size);
      return sizeVerification.toEither(() => list).swap();
    }
    
    ''');

    /// _verifyContent function
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

    /// getter for the size of the list

    buffer.writeln('''
    /// The size of the list
    int get size => mapValidity(
        valid: (valid) => valid.list.size,
        invalid: (invalid)=> invalid.list.size,
      );
    
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
    /// Similar to [mapValidity], but the "base" invalid union-case is replaced by
    /// the "specific" invalid union-cases of this entity :
    /// - [InvalidEntitySize]
    /// - [InvalidEntityContent]
    TResult map<TResult extends Object?>({
      required TResult Function(${classInfo.valid} valid) valid,
      required TResult Function(${classInfo.invalidSize} invalidSize)
          invalidSize,
      required TResult Function(${classInfo.invalidContent} invalidContent)
          invalidContent,      
    }) {
      return maybeMap(
        valid: valid,
        invalidSize: invalidSize,
        invalidContent: invalidContent,        
        orElse: (invalid) => throw UnreachableError(),
      );
    }
    
    ''');

    /// maybeMap method
    buffer.writeln('''
    /// Equivalent to [map], but only the [valid] callback is required. It also
    /// adds an extra orElse required parameter, for fallback behavior.
    TResult maybeMap<TResult extends Object?>({
      required TResult Function(${classInfo.valid} valid) valid,
      TResult Function(${classInfo.invalidSize} invalidSize)? invalidSize,
      TResult Function(${classInfo.invalidContent} invalidContent)? invalidContent,
      required TResult Function(${classInfo.invalid} invalid) orElse,
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
      required TResult Function(${classInfo.invalid} invalid) invalid,
    }) {
      return maybeMap(
        valid: valid,
        orElse: invalid,
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
      return mapValidity(
        valid: (valid) => _create(callback(valid.list)),
        invalid: (invalid) => _create(callback(invalid.list)),
      );
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
    final KtList<${classInfo.ktListTypeValid}> list;

    ''');

    /// maybeMap method
    buffer.writeln('''
    @override
    TResult maybeMap<TResult extends Object?>({
      required TResult Function(${classInfo.valid} valid) valid,
      TResult Function(${classInfo.invalidSize} invalidSize)? invalidSize,
      TResult Function(${classInfo.invalidContent} invalidContent)? invalidContent,
      required TResult Function(${classInfo.invalid} invalid) orElse,
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

  String get makeInvalidEntity {
    final buffer = StringBuffer();

    buffer.writeln('''
    abstract class ${classInfo.invalid} extends $className
    implements InvalidEntity {
    ''');

    /// private constructor
    buffer.writeln('''
    const ${classInfo.invalid}._() : super._();
    
    ''');

    /// Fields getters
    buffer.writeln('''
    KtList<${classInfo.ktListType}> get list;

    ''');

    /// Failure getter
    buffer.writeln('''
    @override
    Failure get failure => whenInvalid(
          sizeFailure: (sizeFailure) => sizeFailure,
          contentFailure: (contentFailure) => contentFailure,
        );

    ''');

    /// mapInvalid method
    buffer.writeln('''
    /// Pattern matching for the "specific" invalid union-cases of this "base"
    /// invalid union-case, which are :
    /// - [InvalidEntitySize]
    /// - [InvalidEntityContent]
    TResult mapInvalid<TResult extends Object?>({
      required TResult Function(${classInfo.invalidSize} invalidSize)
          invalidSize,
      required TResult Function(${classInfo.invalidContent} invalidContent)
          invalidContent,
    }) {
      return maybeMap(
        valid: (valid) => throw UnreachableError(),
        invalidSize: invalidSize,
        invalidContent: invalidContent,
        orElse: (invalid) => throw UnreachableError(),
      );
    }

    ''');

    /// whenInvalid method
    buffer.writeln('''
    /// Similar to [mapInvalid], but the union-cases are replaced by the failures
    /// they hold.
    TResult whenInvalid<TResult extends Object?>({
      required TResult Function(${classInfo.sizeFailure} sizeFailure)
          sizeFailure,
      required TResult Function(Failure contentFailure) contentFailure,
    }) {
      return maybeMap(
        valid: (valid) => throw UnreachableError(),
        invalidSize: (invalidSize) =>
            sizeFailure(invalidSize.sizeFailure),
        invalidContent: (invalidContent) =>
            contentFailure(invalidContent.contentFailure),
        orElse: (invalid) => throw UnreachableError(),
      );
    }

    ''');

    /// end
    buffer.writeln('}');

    return buffer.toString();
  }

  String get makeInvalidEntitySize {
    final buffer = StringBuffer();

    buffer.writeln('''
    class ${classInfo.invalidSize} extends ${classInfo.invalid}
      implements InvalidEntitySize<${classInfo.sizeFailure}> {
    ''');

    /// private constructor
    buffer.writeln('''
    const ${classInfo.invalidSize}._({
      required this.sizeFailure,
      required this.list,
    }) : super._();
    ''');

    /// Getters
    buffer.writeln('''
    @override
    final ${classInfo.sizeFailure} sizeFailure;

    @override
    final KtList<${classInfo.ktListType}> list;

    ''');

    /// maybeMap method
    buffer.writeln('''
    @override
    TResult maybeMap<TResult extends Object?>({
      required TResult Function(${classInfo.valid} valid) valid,
      TResult Function(${classInfo.invalidSize} invalidSize)? invalidSize,
      TResult Function(${classInfo.invalidContent} invalidContent)? invalidContent,
      required TResult Function(${classInfo.invalid} invalid) orElse,
    }) {
      if (invalidSize != null) {
        return invalidSize(this);
      }
      return orElse(this);
    }

    ''');

    /// props getter
    buffer.writeln('''
    @override
    List<Object?> get props => [
          sizeFailure,
          list,
        ];
    ''');

    /// End
    buffer.writeln('}');

    return buffer.toString();
  }

  String get makeInvalidEntityContent {
    final buffer = StringBuffer();

    buffer.writeln('''
    class ${classInfo.invalidContent} extends ${classInfo.invalid}
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
    final KtList<${classInfo.ktListType}> list;
    ''');

    /// maybeMap method
    buffer.writeln('''
    @override
    TResult maybeMap<TResult extends Object?>({
      required TResult Function(${classInfo.valid} valid) valid,
      TResult Function(${classInfo.invalidSize} invalidSize)? invalidSize,
      TResult Function(${classInfo.invalidContent} invalidContent)? invalidContent,
      required TResult Function(${classInfo.invalid} invalid) orElse,
    }) {
      if (invalidContent != null) {
        return invalidContent(this);
      }
      return orElse(this);
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
    class ${className}Tester extends SizedListEntityTester<
      ${classInfo.sizeFailure},
      ${classInfo.invalidSize},
      ${classInfo.invalidContent},
      ${classInfo.invalid},
      ${classInfo.valid},
      $className,
      ${classInfo.modddelInput}> {
    ''');

    /// constructor
    buffer.writeln('''
    const ${className}Tester({
      int maxSutDescriptionLength = $maxSutDescriptionLength,
      String isSanitizedGroupDescription = 'Should be sanitized',
      String isNotSanitizedGroupDescription = 'Should not be sanitized',
      String isValidGroupDescription = 'Should be a ${classInfo.valid}',
      String isInvalidSizeGroupDescription =
          'Should be an ${classInfo.invalidSize} and hold the ${classInfo.sizeFailure}',
      String isInvalidContentGroupDescription =
          'Should be an ${classInfo.invalidContent} and hold the proper contentFailure',
    }) : super(
            maxSutDescriptionLength: maxSutDescriptionLength,
            isSanitizedGroupDescription: isSanitizedGroupDescription,
            isNotSanitizedGroupDescription: isNotSanitizedGroupDescription,
            isValidGroupDescription: isValidGroupDescription,
            isInvalidSizeGroupDescription: isInvalidSizeGroupDescription,
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
      final modddelList = modddel.mapValidity(
          valid: (v) => v.list, invalid: (i) => i.list);

      return ${classInfo.modddelInput}(modddelList);
    }
    ''');

    /// end
    buffer.writeln('}');

    return buffer.toString();
  }
}
