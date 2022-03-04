import 'package:modddels_annotations/modddels.dart';
import 'package:modddels_annotations/src/testers/common.dart';
import 'package:modddels_annotations/src/testers/entities_testers/mixins.dart';

/// This is a Tester for unit testing a [SimpleEntity].
class SimpleEntityTester<C extends InvalidEntityContent, V extends ValidEntity,
        E extends SimpleEntity<C, V>> extends Tester
    with ValidTesterMixin<C, V, E>, ContentTesterMixin<C, C, V, E> {
  /// For [maxSutDescriptionLength], see [Tester.maxSutDescriptionLength].
  const SimpleEntityTester({
    required int maxSutDescriptionLength,
    required this.isValidGroupDescription,
    required this.isInvalidContentGroupDescription,
  }) : super(maxSutDescriptionLength: maxSutDescriptionLength);

  @override
  final String isInvalidContentGroupDescription;

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
        E extends GeneralEntity<F, I, V>> extends Tester
    with
        ValidTesterMixin<I, V, E>,
        ContentTesterMixin<C, I, V, E>,
        GeneralTesterMixin<F, G, I, V, E> {
  /// For [maxSutDescriptionLength], see [Tester.maxSutDescriptionLength].
  const GeneralEntityTester({
    required int maxSutDescriptionLength,
    required this.isValidGroupDescription,
    required this.isInvalidGeneralGroupDescription,
    required this.isInvalidContentGroupDescription,
  }) : super(maxSutDescriptionLength: maxSutDescriptionLength);

  @override
  final String isInvalidContentGroupDescription;

  @override
  final String isInvalidGeneralGroupDescription;

  @override
  final String isValidGroupDescription;
}

/// This is a Tester for unit testing a [ListEntity].
class ListEntityTester<C extends InvalidEntityContent, V extends ValidEntity,
        E extends ListEntity<C, V>> extends Tester
    with ValidTesterMixin<C, V, E>, ContentTesterMixin<C, C, V, E> {
  /// For [maxSutDescriptionLength], see [Tester.maxSutDescriptionLength].
  const ListEntityTester({
    required int maxSutDescriptionLength,
    required this.isValidGroupDescription,
    required this.isInvalidContentGroupDescription,
  }) : super(maxSutDescriptionLength: maxSutDescriptionLength);

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
        E extends ListGeneralEntity<F, I, V>> extends Tester
    with
        ValidTesterMixin<I, V, E>,
        ContentTesterMixin<C, I, V, E>,
        GeneralTesterMixin<F, G, I, V, E> {
  /// For [maxSutDescriptionLength], see [Tester.maxSutDescriptionLength].
  const ListGeneralEntityTester({
    required int maxSutDescriptionLength,
    required this.isValidGroupDescription,
    required this.isInvalidGeneralGroupDescription,
    required this.isInvalidContentGroupDescription,
  }) : super(maxSutDescriptionLength: maxSutDescriptionLength);

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
        E extends SizedListEntity<F, I, V>> extends Tester
    with
        ValidTesterMixin<I, V, E>,
        SizeTesterMixin<F, S, I, V, E>,
        ContentTesterMixin<C, I, V, E> {
  /// For [maxSutDescriptionLength], see [Tester.maxSutDescriptionLength].
  const SizedListEntityTester({
    required int maxSutDescriptionLength,
    required this.isValidGroupDescription,
    required this.isInvalidSizeGroupDescription,
    required this.isInvalidContentGroupDescription,
  }) : super(maxSutDescriptionLength: maxSutDescriptionLength);

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
        E extends SizedListGeneralEntity<FS, FG, I, V>> extends Tester
    with
        ValidTesterMixin<I, V, E>,
        SizeTesterMixin<FS, S, I, V, E>,
        ContentTesterMixin<C, I, V, E>,
        GeneralTesterMixin<FG, G, I, V, E> {
  /// For [maxSutDescriptionLength], see [Tester.maxSutDescriptionLength].
  const SizedListGeneralEntityTester({
    required int maxSutDescriptionLength,
    required this.isValidGroupDescription,
    required this.isInvalidSizeGroupDescription,
    required this.isInvalidContentGroupDescription,
    required this.isInvalidGeneralGroupDescription,
  }) : super(maxSutDescriptionLength: maxSutDescriptionLength);

  @override
  final String isInvalidContentGroupDescription;

  @override
  final String isInvalidGeneralGroupDescription;

  @override
  final String isInvalidSizeGroupDescription;

  @override
  final String isValidGroupDescription;
}
