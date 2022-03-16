import 'package:analyzer/dart/element/element.dart';
import 'package:modddels_annotations/modddels.dart';
import 'package:modddels_generator/src/core/class_info.dart';
import 'package:source_gen/source_gen.dart';

class MultiValueObjectGenerator {
  MultiValueObjectGenerator({
    required this.className,
    required this.factoryConstructor,
    required this.generateTester,
    required this.maxSutDescriptionLength,
    required this.stringifyMode,
  });

  final String className;
  final ConstructorElement factoryConstructor;

  /// See [ModddelAnnotation.generateTester]
  final bool generateTester;

  /// See [ModddelAnnotation.maxSutDescriptionLength]
  final int maxSutDescriptionLength;

  /// See [ModddelAnnotation.stringifyMode]
  final StringifyMode stringifyMode;

  String generate() {
    final parameters = factoryConstructor.parameters;

    final namedParameterElements =
        parameters.where((element) => element.isNamed).toList();

    if (namedParameterElements.isEmpty) {
      throw InvalidGenerationSourceError(
        'The factory constructor should contain at least one name parameter',
        element: factoryConstructor,
      );
    }

    final classInfo = MultiValueObjectClassInfo(
      className: className,
      namedParameterElements: namedParameterElements,
    );

    for (final param in classInfo.namedParameters) {
      if (param.type == 'dynamic') {
        throw InvalidGenerationSourceError(
          'The named parameters of the factory constructor should have valid types, and should not be dynamic. '
          'Consider using the @TypeName annotation to manually provide the type.',
          element: param.parameterElement,
        );
      }
    }

    for (final param in classInfo.namedParameters) {
      if (param.hasValidAnnotation ||
          param.hasInvalidAnnotation ||
          param.hasWithGetterAnnotation) {
        throw InvalidGenerationSourceError(
          'The @valid, @invalid and @withGetter annotations can\'t be used with '
          'a MultiValueObject.',
          element: param.parameterElement,
        );
      }
    }

    for (final param in classInfo.namedParameters) {
      if (param.hasNullFailureAnnotation && !param.isNullable) {
        throw InvalidGenerationSourceError(
          'The @NullFailure annotation can only be used with nullable parameters.',
          element: param.parameterElement,
        );
      }
    }

    final classBuffer = StringBuffer();

    makeMixin(classBuffer, classInfo);

    makeHolder(classBuffer, classInfo);

    makeValidValueObject(classBuffer, classInfo);

    makeInvalidValueObject(classBuffer, classInfo);

    if (generateTester) {
      makeTester(classBuffer, classInfo);

      makeModddelInput(classBuffer, classInfo);
    }

    return classBuffer.toString();
  }

  void makeMixin(
      StringBuffer classBuffer, MultiValueObjectClassInfo classInfo) {
    classBuffer.writeln('''
    mixin \$$className {

    ''');

    /// create method
    classBuffer.writeln('''
    static $className _create({
      ${classInfo.namedParameters.map((param) => 'required ${param.type} ${param.name},').join()}
    }) {
      /// 1. **Value Validation**
      return _verifyValue(${classInfo.holder}._(
        ${classInfo.namedParameters.map((param) => '${param.name} : ${param.name},').join()}
      )).match(
        (valueFailure) => ${classInfo.invalid}._(
          valueFailure: valueFailure,
          ${classInfo.namedParameters.map((param) => '${param.name} : ${param.name},').join()}
        ),

        /// 2. **→ Validations passed**
        (validValueObject) => validValueObject,
      );
    }

    ''');

    /// _verifyValue method
    classBuffer.writeln('''
    /// If the value is invalid, this holds the [ValueFailure] on the Left.
    /// Otherwise, holds the [ValidValueObject] on the Right.
    static Either<${classInfo.valueFailure}, ${classInfo.valid}> _verifyValue(
      ${classInfo.holder} valueObject) {
      final nullablesVerification = valueObject.verifyNullables();

      final valueVerification = nullablesVerification.flatMap(
          (validValueObject) => const $className._()
              .validateValue(validValueObject)
              .toEither(() => validValueObject)
              .swap());

      return valueVerification;
    }

    ''');

    /// toBroadEitherNullable method
    classBuffer.writeln('''
    /// If [nullableValueObject] is null, returns `right(null)`.
    /// Otherwise, returns `nullableValueObject.toBroadEither`.
    static Either<Failure, ${classInfo.valid}?> toBroadEitherNullable(
      $className? nullableValueObject) =>
        optionOf(nullableValueObject)
          .match((t) => t.toBroadEither, () => right(null));

    ''');

    classBuffer.writeln('''
    
    ''');

    /// map method
    classBuffer.writeln('''
    /// Same as [mapValidity] (because there is only one invalid union-case)
    TResult map<TResult extends Object?>({
      required TResult Function(${classInfo.valid} valid) valid,
      required TResult Function(${classInfo.invalid} invalid) invalid,
    }) {
      throw UnimplementedError();
    }
    
    ''');

    /// mapValidity method
    classBuffer.writeln('''
    /// Pattern matching for the two different union-cases of this ValueObject :
    /// valid and invalid.
    TResult mapValidity<TResult extends Object?>({
      required TResult Function(${classInfo.valid} valid) valid,
      required TResult Function(${classInfo.invalid} invalid) invalid,
    }) {
      return map(
        valid: valid,
        invalid: invalid,
      );
    }
    
    ''');

    /// props and stringifyMode getters
    classBuffer.writeln('''
    List<Object?> get props => throw UnimplementedError();

    StringifyMode get stringifyMode => ${stringifyMode.toString()};
    ''');

    /// End
    classBuffer.writeln('}');
  }

  void makeHolder(
      StringBuffer classBuffer, MultiValueObjectClassInfo classInfo) {
    classBuffer.writeln('''
    class ${classInfo.holder} {
      
    ''');

    /// private constructor
    classBuffer.writeln('''
    const ${classInfo.holder}._({
      ${classInfo.namedParameters.map((param) => 'required this.${param.name},').join()}
      });

    ''');

    /// class members
    for (final param in classInfo.namedParameters) {
      classBuffer.writeln('final ${param.type} ${param.name};');
    }
    classBuffer.writeln('');

    /// verifyNullables method
    classBuffer.writeln('''
    /// If one of the nullable fields marked with `@NullFailure` is null, this
    /// holds a [ValueFailure] on the Left. Otherwise, holds the
    /// [ValidValueObject] on the Right.
    Either<${classInfo.valueFailure}, ${classInfo.valid}> verifyNullables() {

      ${classInfo.namedParameters.where((p) => p.hasNullFailureAnnotation).map((param) => '''
      final ${param.name} = this.${param.name};
      if(${param.name} == null) {
        return left(${param.nullFailureString});
      }
      
      ''').join()}

      return right(${classInfo.valid}._(
        ${classInfo.namedParameters.map((param) => '${param.name} : ${param.name},').join()}
      ));
    }
    ''');

    /// end
    classBuffer.writeln('}');
  }

  void makeValidValueObject(
      StringBuffer classBuffer, MultiValueObjectClassInfo classInfo) {
    classBuffer.writeln('''
    class ${classInfo.valid} extends $className implements ValidValueObject {
    ''');

    /// private constructor
    classBuffer.writeln('''
    const ${classInfo.valid}._({
      ${classInfo.namedParameters.map((param) => 'required this.${param.name},').join()}
      }) : super._();

    ''');

    /// class members
    for (final param in classInfo.namedParameters) {
      final paramType =
          param.hasNullFailureAnnotation ? param.nonNullableType : param.type;

      classBuffer.writeln('final $paramType ${param.name};');
    }
    classBuffer.writeln('');

    /// map method
    classBuffer.writeln('''
    @override
    TResult map<TResult extends Object?>(
      {required TResult Function(${classInfo.valid} valid) valid,
      required TResult Function(${classInfo.invalid} invalid) invalid}) {
        return valid(this);
    }

    ''');

    /// props getter
    classBuffer.writeln('''
    @override
    List<Object?> get props => [
        ${classInfo.namedParameters.map((param) => '${param.name},').join()}
      ];
    ''');

    /// end
    classBuffer.writeln('}');
  }

  void makeInvalidValueObject(
      StringBuffer classBuffer, MultiValueObjectClassInfo classInfo) {
    classBuffer.writeln('''
    class ${classInfo.invalid} extends $className implements InvalidValueObject<${classInfo.valueFailure}> {
    
    ''');

    /// private constructor
    classBuffer.writeln('''
    const ${classInfo.invalid}._({
      required this.valueFailure,
      ${classInfo.namedParameters.map((param) => 'required this.${param.name},').join()}
    }) : super._();
    ''');

    /// class members
    classBuffer.writeln('''
    @override
    final ${classInfo.valueFailure} valueFailure;

    @override
    ${classInfo.valueFailure} get failure => valueFailure; 

    ${classInfo.namedParameters.map((param) => 'final ${param.type} ${param.name};').join()}

    ''');

    /// map method
    classBuffer.writeln('''
    @override
    TResult map<TResult extends Object?>(
      {required TResult Function(${classInfo.valid} valid) valid,
      required TResult Function(${classInfo.invalid} invalid) invalid}) {
        return invalid(this);
    }
    ''');

    /// props getter
    classBuffer.writeln('''
    @override
    List<Object?> get props => [
        valueFailure,
        ${classInfo.namedParameters.map((param) => '${param.name},').join()}
      ];
    ''');

    /// end
    classBuffer.writeln('}');
  }

  void makeTester(
      StringBuffer classBuffer, MultiValueObjectClassInfo classInfo) {
    classBuffer.writeln('''
    class ${className}Tester extends ValueObjectTester<${classInfo.valueFailure}, ${classInfo.invalid},
    ${classInfo.valid}, $className, ${classInfo.modddelInput}> {
    ''');

    /// constructor
    classBuffer.writeln('''
    const ${className}Tester({
      int maxSutDescriptionLength = $maxSutDescriptionLength,
      String isSanitizedGroupDescription = 'Should be sanitized',
      String isNotSanitizedGroupDescription = 'Should not be sanitized',
      String isValidGroupDescription = 'Should be a ${classInfo.valid}',
      String isInvalidValueGroupDescription =
          'Should be an ${classInfo.invalid} and hold the ${classInfo.valueFailure}',
    }) : super(
            maxSutDescriptionLength: maxSutDescriptionLength,
            isSanitizedGroupDescription: isSanitizedGroupDescription,
            isNotSanitizedGroupDescription: isNotSanitizedGroupDescription,
            isValidGroupDescription: isValidGroupDescription,
            isInvalidValueGroupDescription: isInvalidValueGroupDescription,
          );
    ''');

    /// makeInput field
    classBuffer.writeln('''
    final makeInput = ${classInfo.modddelInput}.new;
    ''');

    /// end
    classBuffer.writeln('}');
  }

  void makeModddelInput(
      StringBuffer classBuffer, MultiValueObjectClassInfo classInfo) {
    classBuffer.writeln('''
    class ${classInfo.modddelInput} extends ModddelInput<$className> {
    ''');

    /// constructor
    final constructorParams = classInfo.namedParameters.map(
      (param) {
        final declaration = 'this.${param.name}';
        return param.isRequired
            ? 'required $declaration,'
            : param.hasDefaultValue
                ? '$declaration = ${param.defaultValue},'
                : '$declaration,';
      },
    );

    classBuffer.writeln('''
    const ${classInfo.modddelInput}({
      ${constructorParams.join()}
    });
    ''');

    /// class members
    for (final param in classInfo.namedParameters) {
      classBuffer.writeln('final ${param.type} ${param.name};');
    }

    /// props method
    classBuffer.writeln('''
    @override
    List<Object?> get props => [
          ${classInfo.namedParameters.map((p) => '${p.name},').join()}
        ];
    ''');

    /// sanitizedInput method
    final sanitizedConstructorParams = classInfo.namedParameters.map((param) {
      final paramName = param.name;
      return '$paramName: modddel.mapValidity('
          'valid: (v) => v.$paramName, invalid: (i) => i.$paramName),';
    });

    classBuffer.writeln('''
    @override
    ${classInfo.modddelInput} get sanitizedInput {
      final modddel = $className(
        ${classInfo.namedParameters.map((p) => '${p.name}: ${p.name},').join()}
      );

      return ${classInfo.modddelInput}(
        ${sanitizedConstructorParams.join()}
      );
    }
    ''');

    /// end
    classBuffer.writeln('}');
  }
}
