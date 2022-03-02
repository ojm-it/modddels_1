import 'package:modddels_annotations/modddels_annotations.dart';
import 'package:modddels_annotations/src/testers/entities_testers/mixins.dart';

/// This is a Tester for unit testing a [SimpleEntity].
class SimpleEntityTester<C extends InvalidEntityContent, V extends ValidEntity>
    with
        ValidTesterMixin<C, V, SimpleEntity<C, V>>,
        ContentTesterMixin<C, C, V, SimpleEntity<C, V>> {
  SimpleEntityTester({
    required this.maxSutDescriptionLength,
    required this.isValidGroupDescription,
    required this.isInvalidContentGroupDescription,
  });

  @override
  final String isInvalidContentGroupDescription;

  @override
  final String isValidGroupDescription;

  @override
  final int maxSutDescriptionLength;
}

/// This is a Tester for unit testing a [GeneralEntity].
class GeneralEntityTester<
        F extends GeneralFailure,
        C extends InvalidEntityContent,
        G extends InvalidEntityGeneral<F>,
        I extends InvalidEntity,
        V extends ValidEntity>
    with
        ValidTesterMixin<I, V, GeneralEntity<F, I, V>>,
        ContentTesterMixin<C, I, V, GeneralEntity<F, I, V>>,
        GeneralTesterMixin<F, G, I, V, GeneralEntity<F, I, V>> {
  GeneralEntityTester({
    required this.maxSutDescriptionLength,
    required this.isValidGroupDescription,
    required this.isInvalidGeneralGroupDescription,
    required this.isInvalidContentGroupDescription,
  });

  @override
  final String isInvalidContentGroupDescription;

  @override
  final String isInvalidGeneralGroupDescription;

  @override
  final String isValidGroupDescription;

  @override
  final int maxSutDescriptionLength;
}

/// This is a Tester for unit testing a [ListEntity].
class ListEntityTester<C extends InvalidEntityContent, V extends ValidEntity>
    with
        ValidTesterMixin<C, V, SimpleEntity<C, V>>,
        ContentTesterMixin<C, C, V, SimpleEntity<C, V>> {
  ListEntityTester({
    required this.maxSutDescriptionLength,
    required this.isValidGroupDescription,
    required this.isInvalidContentGroupDescription,
  });

  @override
  final String isInvalidContentGroupDescription;

  @override
  final String isValidGroupDescription;

  @override
  final int maxSutDescriptionLength;
}

/// This is a Tester for unit testing a [ListGeneralEntity].
class ListGeneralEntityTester<
        F extends GeneralFailure,
        C extends InvalidEntityContent,
        G extends InvalidEntityGeneral<F>,
        I extends InvalidEntity,
        V extends ValidEntity>
    with
        ValidTesterMixin<I, V, ListGeneralEntity<F, I, V>>,
        ContentTesterMixin<C, I, V, ListGeneralEntity<F, I, V>>,
        GeneralTesterMixin<F, G, I, V, ListGeneralEntity<F, I, V>> {
  ListGeneralEntityTester({
    required this.maxSutDescriptionLength,
    required this.isValidGroupDescription,
    required this.isInvalidGeneralGroupDescription,
    required this.isInvalidContentGroupDescription,
  });

  @override
  final String isInvalidContentGroupDescription;

  @override
  final String isInvalidGeneralGroupDescription;

  @override
  final String isValidGroupDescription;

  @override
  final int maxSutDescriptionLength;
}

/// This is a Tester for unit testing a [SizedListEntity].
class SizedListEntityTester<
        F extends SizeFailure,
        S extends InvalidEntitySize<F>,
        C extends InvalidEntityContent,
        I extends InvalidEntity,
        V extends ValidEntity>
    with
        ValidTesterMixin<I, V, SizedListEntity<F, I, V>>,
        SizeTesterMixin<F, S, I, V, SizedListEntity<F, I, V>>,
        ContentTesterMixin<C, I, V, SizedListEntity<F, I, V>> {
  SizedListEntityTester({
    required this.maxSutDescriptionLength,
    required this.isValidGroupDescription,
    required this.isInvalidSizeGroupDescription,
    required this.isInvalidContentGroupDescription,
  });

  @override
  final String isInvalidContentGroupDescription;

  @override
  final String isInvalidSizeGroupDescription;

  @override
  final String isValidGroupDescription;

  @override
  final int maxSutDescriptionLength;
}

/// This is a Tester for unit testing a [SizedListGeneralEntity].
class SizedListGeneralEntityTester<
        FS extends SizeFailure,
        FG extends GeneralFailure,
        S extends InvalidEntitySize<FS>,
        C extends InvalidEntityContent,
        G extends InvalidEntityGeneral<FG>,
        I extends InvalidEntity,
        V extends ValidEntity>
    with
        ValidTesterMixin<I, V, SizedListGeneralEntity<FS, FG, I, V>>,
        SizeTesterMixin<FS, S, I, V, SizedListGeneralEntity<FS, FG, I, V>>,
        ContentTesterMixin<C, I, V, SizedListGeneralEntity<FS, FG, I, V>>,
        GeneralTesterMixin<FG, G, I, V, SizedListGeneralEntity<FS, FG, I, V>> {
  SizedListGeneralEntityTester({
    required this.maxSutDescriptionLength,
    required this.isValidGroupDescription,
    required this.isInvalidSizeGroupDescription,
    required this.isInvalidContentGroupDescription,
    required this.isInvalidGeneralGroupDescription,
  });

  @override
  final String isInvalidContentGroupDescription;

  @override
  final String isInvalidGeneralGroupDescription;

  @override
  final String isInvalidSizeGroupDescription;

  @override
  final String isValidGroupDescription;

  @override
  final int maxSutDescriptionLength;
}
