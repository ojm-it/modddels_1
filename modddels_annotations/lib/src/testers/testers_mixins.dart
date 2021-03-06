import 'package:flutter_test/flutter_test.dart';
import 'package:collection/collection.dart';
import 'package:modddels_annotations/src/modddels/entities/common.dart';
import 'package:modddels_annotations/src/modddels/modddel.dart';
import 'package:modddels_annotations/src/modddels/value_objects/value_object.dart';
import 'package:modddels_annotations/src/testers/core/modddel_input.dart';
import 'package:modddels_annotations/src/testers/core/tester.dart';
import 'package:modddels_annotations/src/testers/test_cases.dart';
import 'package:modddels_annotations/src/testers/core/testers_utils.dart';

/// This is a mixin for Testers that need to test that a modddel, when given
/// an input, either sanitizes it or not.
mixin SanitizationTesterMixin<M extends Modddel, P extends ModddelInput<M>>
    on Tester {
  // This is the description of the [group] generated by the
  /// [makeIsSanitizedTestGroup] method.
  String get isSanitizedGroupDescription;

  // This is the description of the [group] generated by the
  /// [makeIsNotSanitizedTestGroup] method.
  String get isNotSanitizedGroupDescription;

  /// The modddel should hold [sanitizedInput] when given [input].
  void expectIsSanitized({required P input, required P sanitizedInput}) {
    expect(input.sanitizedInput, sanitizedInput);
  }

  /// The modddel should hold the same [input] that was given to it.
  void expectIsNotSanitized({required P input}) {
    expect(input.sanitizedInput, input);
  }

  /// Generates a [group] that contains all the TestIsSanitized [tests].
  ///
  /// The [group]'s description is set to [isSanitizedGroupDescription], but you
  /// can override it by providing your own [description].
  ///
  /// If [maxSutDescriptionLength] is provided, then it overrides the value
  /// of this tester's [Tester.maxSutDescriptionLength].
  ///
  /// For documentation of [description] and [skip], see [group].
  void makeIsSanitizedTestGroup({
    required List<TestIsSanitized<M, P>> tests,
    int? maxSutDescriptionLength,
    Object? description,
    dynamic skip,
  }) {
    assert(maxSutDescriptionLength == null ||
        maxSutDescriptionLength > 0 ||
        maxSutDescriptionLength == TesterUtils.noEllipsis);

    group(
      description ?? isSanitizedGroupDescription,
      () {
        for (final _test in tests) {
          final input = _test.input;
          final sanitizedInput = _test.sanitizedInput;

          final maxLength =
              maxSutDescriptionLength ?? this.maxSutDescriptionLength;

          final description = '- "${TesterUtils.formatObject(
            input,
            maxLength: maxLength,
            maxLengthFactor: 0.5,
          )}" '
              '??? "${TesterUtils.formatObject(
            sanitizedInput,
            maxLength: maxLength,
            maxLengthFactor: 0.5,
          )}"';
          final finalDescription = _test.getFinalDescription(description);
          test(
            finalDescription,
            () {
              expectIsSanitized(input: input, sanitizedInput: sanitizedInput);
            },
            testOn: _test.testOn,
            timeout: _test.timeout,
            skip: _test.skip,
            tags: _test.tags,
            onPlatform: _test.onPlatform,
            retry: _test.retry,
          );
        }
      },
      skip: skip,
    );
  }

  /// Generates a [group] that contains all the TestIsNotSanitized [tests].
  ///
  /// The [group]'s description is set to [isNotSanitizedGroupDescription], but
  /// you can override it by providing your own [description].
  ///
  /// If [maxSutDescriptionLength] is provided, then it overrides the value
  /// of this tester's [Tester.maxSutDescriptionLength].
  ///
  /// For documentation of [description] and [skip], see [group].
  void makeIsNotSanitizedTestGroup({
    required List<TestIsNotSanitized<M, P>> tests,
    int? maxSutDescriptionLength,
    Object? description,
    dynamic skip,
  }) {
    assert(maxSutDescriptionLength == null ||
        maxSutDescriptionLength > 0 ||
        maxSutDescriptionLength == TesterUtils.noEllipsis);

    group(
      description ?? isNotSanitizedGroupDescription,
      () {
        for (final _test in tests) {
          final input = _test.input;

          final maxLength =
              maxSutDescriptionLength ?? this.maxSutDescriptionLength;

          final description = '- "${TesterUtils.formatObject(
            input,
            maxLength: maxLength,
          )}"';
          final finalDescription = _test.getFinalDescription(description);
          test(
            finalDescription,
            () {
              expectIsNotSanitized(input: input);
            },
            testOn: _test.testOn,
            timeout: _test.timeout,
            skip: _test.skip,
            tags: _test.tags,
            onPlatform: _test.onPlatform,
            retry: _test.retry,
          );
        }
      },
      skip: skip,
    );
  }
}

/// This is a mixin for Testers that need to test that a modddel is a
/// [ValidModddel].
mixin ValidTesterMixin<I extends InvalidModddel, V extends ValidModddel,
    M extends Modddel<I, V>> on Tester {
  /// This is the description of the [group] generated by the
  /// [makeIsValidTestGroup] method.
  String get isValidGroupDescription;

  /// The [modddel] should be valid.
  void expectIsValid({required M modddel}) {
    expect(modddel, isA<V>());
    expect(modddel.isValid, true);
  }

  /// Generates a [group] that contains all the TestIsValid [tests].
  ///
  /// The [group]'s description is set to [isValidGroupDescription], but you can
  /// override it by providing your own [description].
  ///
  /// If [maxSutDescriptionLength] is provided, then it overrides the value
  /// of this tester's [Tester.maxSutDescriptionLength].
  ///
  /// For documentation of [description] and [skip], see [group].
  void makeIsValidTestGroup({
    required List<TestIsValid<M>> tests,
    int? maxSutDescriptionLength,
    Object? description,
    dynamic skip,
  }) {
    assert(maxSutDescriptionLength == null ||
        maxSutDescriptionLength > 0 ||
        maxSutDescriptionLength == TesterUtils.noEllipsis);

    group(
      description ?? isValidGroupDescription,
      () {
        for (final _test in tests) {
          final modddel = _test.modddel;

          final maxLength =
              maxSutDescriptionLength ?? this.maxSutDescriptionLength;

          final description = '- "${TesterUtils.formatObject(
            modddel,
            maxLength: maxLength,
          )}"';
          final finalDescription = _test.getFinalDescription(description);
          test(
            finalDescription,
            () {
              expectIsValid(modddel: modddel);
            },
            testOn: _test.testOn,
            timeout: _test.timeout,
            skip: _test.skip,
            tags: _test.tags,
            onPlatform: _test.onPlatform,
            retry: _test.retry,
          );
        }
      },
      skip: skip,
    );
  }
}

/// This is a mixin for ValueObjects Testers that need to test that a
/// valueObject is an [InvalidValueObject].
mixin ValueTesterMixin<F extends ValueFailure, I extends InvalidValueObject<F>,
    V extends ValidValueObject, M extends ValueObject<F, I, V>> on Tester {
  /// This is the description of the [group] generated by the
  /// [makeIsInvalidValueTestGroup] method.
  String get isInvalidValueGroupDescription;

  /// The [valueObject] should be an [InvalidValueObject] and hold the
  /// [valueFailure].
  void expectIsInvalidValue({required M valueObject, required F valueFailure}) {
    expect(valueObject, isA<I>());
    expect(valueObject.isValid, false);
    expect((valueObject as I).valueFailure, valueFailure);
  }

  /// Generates a [group] that contains all the TestIsInvalidValue [tests].
  ///
  /// The [group]'s description is set to [isInvalidValueGroupDescription],
  /// but you can override it by providing your own [description].
  ///
  /// If [maxSutDescriptionLength] is provided, then it overrides the value
  /// of this tester's [Tester.maxSutDescriptionLength].
  ///
  /// For documentation of [description] and [skip], see [group].
  void makeIsInvalidValueTestGroup({
    required List<TestIsInvalidValue<F, M>> tests,
    int? maxSutDescriptionLength,
    Object? description,
    dynamic skip,
  }) {
    assert(maxSutDescriptionLength == null ||
        maxSutDescriptionLength > 0 ||
        maxSutDescriptionLength == TesterUtils.noEllipsis);

    group(
      description ?? isInvalidValueGroupDescription,
      () {
        for (final _test in tests) {
          final valueObject = _test.valueObject;

          final maxLength =
              maxSutDescriptionLength ?? this.maxSutDescriptionLength;

          final description = '- "${TesterUtils.formatObject(
            valueObject,
            maxLength: maxLength,
          )}"';
          final finalDescription = _test.getFinalDescription(description);
          test(
            finalDescription,
            () {
              expectIsInvalidValue(
                  valueObject: valueObject, valueFailure: _test.valueFailure);
            },
            testOn: _test.testOn,
            timeout: _test.timeout,
            skip: _test.skip,
            tags: _test.tags,
            onPlatform: _test.onPlatform,
            retry: _test.retry,
          );
        }
      },
      skip: skip,
    );
  }
}

/// This is a mixin for Entity Testers that need to test that an entity is an
/// [InvalidEntityContent].
mixin ContentTesterMixin<
    C extends InvalidEntityContent,
    I extends InvalidEntity,
    V extends ValidEntity,
    M extends Entity<I, V>> on Tester {
  /// This is the description of the [group] generated by the
  /// [makeIsInvalidContentTestGroup] method.
  String get isInvalidContentGroupDescription;

  /// The [entity] should be an [InvalidEntityContent] and hold the
  /// [contentFailure].
  void expectIsInvalidContent(
      {required M entity, required Failure contentFailure}) {
    expect(entity, isA<C>());
    expect(entity.isValid, false);
    expect((entity as C).contentFailure, contentFailure);
  }

  /// Generates a [group] that contains all the TestIsInvalidContent [tests].
  ///
  /// The [group]'s description is set to [isInvalidContentGroupDescription],
  /// but you can override it by providing your own [description].
  ///
  /// If [maxSutDescriptionLength] is provided, then it overrides the value
  /// of this tester's [Tester.maxSutDescriptionLength].
  ///
  /// For documentation of [description] and [skip], see [group].
  void makeIsInvalidContentTestGroup({
    required List<TestIsInvalidContent<M>> tests,
    int? maxSutDescriptionLength,
    Object? description,
    dynamic skip,
  }) {
    assert(maxSutDescriptionLength == null ||
        maxSutDescriptionLength > 0 ||
        maxSutDescriptionLength == TesterUtils.noEllipsis);

    group(
      description ?? isInvalidContentGroupDescription,
      () {
        for (final _test in tests) {
          final entity = _test.entity;

          final maxLength =
              maxSutDescriptionLength ?? this.maxSutDescriptionLength;

          final description = '- "${TesterUtils.formatObject(
            entity,
            maxLength: maxLength,
          )}"';
          final finalDescription = _test.getFinalDescription(description);
          test(
            finalDescription,
            () {
              expectIsInvalidContent(
                  entity: entity, contentFailure: _test.contentFailure);
            },
            testOn: _test.testOn,
            timeout: _test.timeout,
            skip: _test.skip,
            tags: _test.tags,
            onPlatform: _test.onPlatform,
            retry: _test.retry,
          );
        }
      },
      skip: skip,
    );
  }
}

/// This is a mixin for Entity Testers that need to test that an entity is an
/// [InvalidEntityGeneral].
mixin GeneralTesterMixin<
    F extends GeneralFailure,
    G extends InvalidEntityGeneral<F>,
    I extends InvalidEntity,
    V extends ValidEntity,
    M extends Entity<I, V>> on Tester {
  /// This is the description of the [group] generated by the
  /// [makeIsInvalidGeneralTestGroup] method.
  String get isInvalidGeneralGroupDescription;

  /// The [entity] should be an [InvalidEntityGeneral] and hold the
  /// [generalFailure].
  void expectIsInvalidGeneral({required M entity, required F generalFailure}) {
    expect(entity, isA<G>());
    expect(entity.isValid, false);
    expect((entity as G).generalFailure, generalFailure);
  }

  /// Generates a [group] that contains all the TestIsInvalidGeneral [tests].
  /// The tests that concern the same [GeneralFailure] union-case are grouped
  /// into the same subgroups.
  ///
  /// The [group]'s description is set to [isInvalidGeneralGroupDescription],
  /// but you can override it by providing your own [description]. Each
  /// subgroup's description is the formatted className of the [GeneralFailure]
  /// union-case.
  ///
  /// If [maxSutDescriptionLength] is provided, then it overrides the value
  /// of this tester's [Tester.maxSutDescriptionLength].
  ///
  /// For documentation of [description] and [skip], see [group].
  void makeIsInvalidGeneralTestGroup({
    required List<TestIsInvalidGeneral<F, M>> tests,
    int? maxSutDescriptionLength,
    Object? description,
    dynamic skip,
  }) {
    assert(maxSutDescriptionLength == null ||
        maxSutDescriptionLength > 0 ||
        maxSutDescriptionLength == TesterUtils.noEllipsis);

    group(
      description ?? isInvalidGeneralGroupDescription,
      () {
        /// The keys are the [GeneralFailure] union-cases classNames, and the
        /// values are the tests that concern each [GeneralFailure] union-case.
        final testGroups = groupBy<TestIsInvalidGeneral<F, M>, String>(
          tests,
          (test) => TesterUtils.formatFailure(test.generalFailure),
        );

        testGroups.forEach((key, value) {
          group(
            '"$key"',
            () {
              for (final _test in value) {
                final entity = _test.entity;

                final maxLength =
                    maxSutDescriptionLength ?? this.maxSutDescriptionLength;

                final description = '- "${TesterUtils.formatObject(
                  entity,
                  maxLength: maxLength,
                )}"';
                final finalDescription = _test.getFinalDescription(description);
                test(
                  finalDescription,
                  () {
                    expectIsInvalidGeneral(
                        entity: entity, generalFailure: _test.generalFailure);
                  },
                  testOn: _test.testOn,
                  timeout: _test.timeout,
                  skip: _test.skip,
                  tags: _test.tags,
                  onPlatform: _test.onPlatform,
                  retry: _test.retry,
                );
              }
            },
          );
        });
      },
      skip: skip,
    );
  }
}

/// This is a mixin for Entity Testers that need to test that an entity is an
/// [InvalidEntitySize].
mixin SizeTesterMixin<
    F extends SizeFailure,
    S extends InvalidEntitySize<F>,
    I extends InvalidEntity,
    V extends ValidEntity,
    M extends Entity<I, V>> on Tester {
  /// This is the description of the [group] generated by the
  /// [makeIsInvalidSizeTestGroup] method.
  String get isInvalidSizeGroupDescription;

  /// The [entity] should be an [InvalidEntitySize] and hold the [sizeFailure].
  void expectIsInvalidSize({required M entity, required F sizeFailure}) {
    expect(entity, isA<S>());
    expect(entity.isValid, false);
    expect((entity as S).sizeFailure, sizeFailure);
  }

  /// Generates a [group] that contains all the TestIsInvalidSize [tests]. The
  /// tests that concern the same [SizeFailure] union-case are grouped into the
  /// same subgroups.
  ///
  /// The [group]'s description is set to [isInvalidSizeGroupDescription], but
  /// you can override it by providing your own [description]. Each subgroup's
  /// description is the formatted className of the [SizeFailure] union-case.
  ///
  /// If [maxSutDescriptionLength] is provided, then it overrides the value
  /// of this tester's [Tester.maxSutDescriptionLength].
  ///
  /// For documentation of [description] and [skip], see [group].
  void makeIsInvalidSizeTestGroup({
    required List<TestIsInvalidSize<F, M>> tests,
    int? maxSutDescriptionLength,
    Object? description,
    dynamic skip,
  }) {
    assert(maxSutDescriptionLength == null ||
        maxSutDescriptionLength > 0 ||
        maxSutDescriptionLength == TesterUtils.noEllipsis);

    group(
      description ?? isInvalidSizeGroupDescription,
      () {
        final testGroups = groupBy<TestIsInvalidSize<F, M>, String>(
          tests,
          (test) => TesterUtils.formatFailure(test.sizeFailure),
        );

        testGroups.forEach((key, value) {
          group(
            '"$key"',
            () {
              for (final _test in value) {
                final entity = _test.entity;

                final maxLength =
                    maxSutDescriptionLength ?? this.maxSutDescriptionLength;

                final description = '- "${TesterUtils.formatObject(
                  entity,
                  maxLength: maxLength,
                )}"';
                final finalDescription = _test.getFinalDescription(description);
                test(
                  finalDescription,
                  () {
                    expectIsInvalidSize(
                        entity: entity, sizeFailure: _test.sizeFailure);
                  },
                  testOn: _test.testOn,
                  timeout: _test.timeout,
                  skip: _test.skip,
                  tags: _test.tags,
                  onPlatform: _test.onPlatform,
                  retry: _test.retry,
                );
              }
            },
          );
        });
      },
      skip: skip,
    );
  }
}
