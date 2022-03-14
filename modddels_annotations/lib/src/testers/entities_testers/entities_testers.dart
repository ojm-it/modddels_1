import 'package:modddels_annotations/modddels.dart';
import 'package:modddels_annotations/src/testers/core/modddel_input.dart';
import 'package:modddels_annotations/src/testers/core/tester.dart';
import 'package:modddels_annotations/src/testers/testers_mixins.dart';

/// This is a Tester for unit testing a [SimpleEntity].
class SimpleEntityTester<C extends InvalidEntityContent, V extends ValidEntity,
        M extends SimpleEntity<C, V>, P extends ModddelInput<M>> extends Tester
    with
        SanitizationTesterMixin<M, P>,
        ValidTesterMixin<C, V, M>,
        ContentTesterMixin<C, C, V, M> {
  /// For [maxSutDescriptionLength], see [Tester.maxSutDescriptionLength].
  const SimpleEntityTester({
    required int maxSutDescriptionLength,
    required this.isSanitizedGroupDescription,
    required this.isNotSanitizedGroupDescription,
    required this.isValidGroupDescription,
    required this.isInvalidContentGroupDescription,
  }) : super(maxSutDescriptionLength: maxSutDescriptionLength);

  @override
  final String isInvalidContentGroupDescription;

  @override
  final String isNotSanitizedGroupDescription;

  @override
  final String isSanitizedGroupDescription;

  @override
  final String isValidGroupDescription;
}

/// This is a Tester for unit testing a [GeneralEntity].
class GeneralEntityTester<
        F extends GeneralFailure,
        C extends InvalidEntityContent,
        G extends InvalidEntityGeneral<F>,
        I extends InvalidEntity,
        V extends ValidEntity,
        M extends GeneralEntity<F, I, V>,
        P extends ModddelInput<M>> extends Tester
    with
        SanitizationTesterMixin<M, P>,
        ValidTesterMixin<I, V, M>,
        ContentTesterMixin<C, I, V, M>,
        GeneralTesterMixin<F, G, I, V, M> {
  /// For [maxSutDescriptionLength], see [Tester.maxSutDescriptionLength].
  const GeneralEntityTester({
    required int maxSutDescriptionLength,
    required this.isSanitizedGroupDescription,
    required this.isNotSanitizedGroupDescription,
    required this.isValidGroupDescription,
    required this.isInvalidGeneralGroupDescription,
    required this.isInvalidContentGroupDescription,
  }) : super(maxSutDescriptionLength: maxSutDescriptionLength);

  @override
  final String isInvalidContentGroupDescription;

  @override
  final String isInvalidGeneralGroupDescription;

  @override
  final String isNotSanitizedGroupDescription;

  @override
  final String isSanitizedGroupDescription;

  @override
  final String isValidGroupDescription;
}

/// This is a Tester for unit testing a [ListEntity].
class ListEntityTester<C extends InvalidEntityContent, V extends ValidEntity,
        M extends ListEntity<C, V>, P extends ModddelInput<M>> extends Tester
    with
        SanitizationTesterMixin<M, P>,
        ValidTesterMixin<C, V, M>,
        ContentTesterMixin<C, C, V, M> {
  /// For [maxSutDescriptionLength], see [Tester.maxSutDescriptionLength].
  const ListEntityTester({
    required int maxSutDescriptionLength,
    required this.isSanitizedGroupDescription,
    required this.isNotSanitizedGroupDescription,
    required this.isValidGroupDescription,
    required this.isInvalidContentGroupDescription,
  }) : super(maxSutDescriptionLength: maxSutDescriptionLength);

  @override
  final String isSanitizedGroupDescription;

  @override
  final String isNotSanitizedGroupDescription;

  @override
  final String isInvalidContentGroupDescription;

  @override
  final String isValidGroupDescription;
}

/// This is a Tester for unit testing a [ListGeneralEntity].
class ListGeneralEntityTester<
        F extends GeneralFailure,
        C extends InvalidEntityContent,
        G extends InvalidEntityGeneral<F>,
        I extends InvalidEntity,
        V extends ValidEntity,
        M extends ListGeneralEntity<F, I, V>,
        P extends ModddelInput<M>> extends Tester
    with
        SanitizationTesterMixin<M, P>,
        ValidTesterMixin<I, V, M>,
        ContentTesterMixin<C, I, V, M>,
        GeneralTesterMixin<F, G, I, V, M> {
  /// For [maxSutDescriptionLength], see [Tester.maxSutDescriptionLength].
  const ListGeneralEntityTester({
    required int maxSutDescriptionLength,
    required this.isSanitizedGroupDescription,
    required this.isNotSanitizedGroupDescription,
    required this.isValidGroupDescription,
    required this.isInvalidGeneralGroupDescription,
    required this.isInvalidContentGroupDescription,
  }) : super(maxSutDescriptionLength: maxSutDescriptionLength);

  @override
  final String isSanitizedGroupDescription;

  @override
  final String isNotSanitizedGroupDescription;

  @override
  final String isInvalidContentGroupDescription;

  @override
  final String isInvalidGeneralGroupDescription;

  @override
  final String isValidGroupDescription;
}

/// This is a Tester for unit testing a [SizedListEntity].
class SizedListEntityTester<
        F extends SizeFailure,
        S extends InvalidEntitySize<F>,
        C extends InvalidEntityContent,
        I extends InvalidEntity,
        V extends ValidEntity,
        M extends SizedListEntity<F, I, V>,
        P extends ModddelInput<M>> extends Tester
    with
        SanitizationTesterMixin<M, P>,
        ValidTesterMixin<I, V, M>,
        SizeTesterMixin<F, S, I, V, M>,
        ContentTesterMixin<C, I, V, M> {
  /// For [maxSutDescriptionLength], see [Tester.maxSutDescriptionLength].
  const SizedListEntityTester({
    required int maxSutDescriptionLength,
    required this.isSanitizedGroupDescription,
    required this.isNotSanitizedGroupDescription,
    required this.isValidGroupDescription,
    required this.isInvalidSizeGroupDescription,
    required this.isInvalidContentGroupDescription,
  }) : super(maxSutDescriptionLength: maxSutDescriptionLength);

  @override
  final String isSanitizedGroupDescription;

  @override
  final String isNotSanitizedGroupDescription;

  @override
  final String isInvalidContentGroupDescription;

  @override
  final String isInvalidSizeGroupDescription;

  @override
  final String isValidGroupDescription;
}

/// This is a Tester for unit testing a [SizedListGeneralEntity].
class SizedListGeneralEntityTester<
        FS extends SizeFailure,
        FG extends GeneralFailure,
        S extends InvalidEntitySize<FS>,
        C extends InvalidEntityContent,
        G extends InvalidEntityGeneral<FG>,
        I extends InvalidEntity,
        V extends ValidEntity,
        M extends SizedListGeneralEntity<FS, FG, I, V>,
        P extends ModddelInput<M>> extends Tester
    with
        SanitizationTesterMixin<M, P>,
        ValidTesterMixin<I, V, M>,
        SizeTesterMixin<FS, S, I, V, M>,
        ContentTesterMixin<C, I, V, M>,
        GeneralTesterMixin<FG, G, I, V, M> {
  /// For [maxSutDescriptionLength], see [Tester.maxSutDescriptionLength].
  const SizedListGeneralEntityTester({
    required int maxSutDescriptionLength,
    required this.isSanitizedGroupDescription,
    required this.isNotSanitizedGroupDescription,
    required this.isValidGroupDescription,
    required this.isInvalidSizeGroupDescription,
    required this.isInvalidContentGroupDescription,
    required this.isInvalidGeneralGroupDescription,
  }) : super(maxSutDescriptionLength: maxSutDescriptionLength);

  @override
  final String isSanitizedGroupDescription;

  @override
  final String isNotSanitizedGroupDescription;

  @override
  final String isInvalidContentGroupDescription;

  @override
  final String isInvalidGeneralGroupDescription;

  @override
  final String isInvalidSizeGroupDescription;

  @override
  final String isValidGroupDescription;
}
