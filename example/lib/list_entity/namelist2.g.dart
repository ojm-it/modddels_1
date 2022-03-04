// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'namelist2.dart';

// **************************************************************************
// ModddelGenerator
// **************************************************************************

mixin $NameList2 {
  static NameList2 _create(
    KtList<Name> list,
  ) {
    /// 1. **Content validation**
    return _verifyContent(list).match(
      (contentFailure) => InvalidNameList2Content._(
        contentFailure: contentFailure,
        list: list,
      ),

      /// 2. **→ Validations passed**
      (validContent) => ValidNameList2._(list: validContent),
    );
  }

  /// If any of the list elements is invalid, this holds its failure on the Left
  /// (the failure of the first invalid element encountered)
  ///
  /// Otherwise, holds the list of all the elements as valid modddels, on the
  /// Right.
  static Either<Failure, KtList<ValidName>> _verifyContent(KtList<Name> list) {
    final contentVerification = list
        .map((element) => element.toBroadEither)
        .fold<Either<Failure, KtList<ValidName>>>(
          /// We start with an empty list of elements on the right
          right(const KtList<ValidName>.empty()),
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

  KtList<Name> get list => map(
        valid: (valid) => valid.list,
        invalidContent: (invalidContent) => invalidContent.list,
      );

  /// The size of the list
  int get size => list.size;

  /// If [nullableEntity] is null, returns `right(null)`.
  /// Otherwise, returns `nullableEntity.toBroadEither`.
  static Either<Failure, ValidNameList2?> toBroadEitherNullable(
          NameList2? nullableEntity) =>
      optionOf(nullableEntity).match((t) => t.toBroadEither, () => right(null));

  /// Same as [mapValidity] (because there is only one invalid union-case)
  TResult map<TResult extends Object?>({
    required TResult Function(ValidNameList2 valid) valid,
    required TResult Function(InvalidNameList2Content invalidContent)
        invalidContent,
  }) {
    throw UnimplementedError();
  }

  /// Pattern matching for the two different union-cases of this entity : valid
  /// and invalid.
  TResult mapValidity<TResult extends Object?>({
    required TResult Function(ValidNameList2 valid) valid,
    required TResult Function(InvalidNameList2Content invalidContent) invalid,
  }) {
    return map(
      valid: valid,
      invalidContent: invalid,
    );
  }

  /// Creates a clone of this entity with the list returned from [callback].
  ///
  /// The resulting entity is totally independent from this entity. It is
  /// validated upon creation, and can be either valid or invalid.
  NameList2 copyWith(KtList<Name> Function(KtList<Name> list) callback) {
    return _create(callback(list));
  }
}

class ValidNameList2 extends NameList2 implements ValidEntity {
  const ValidNameList2._({
    required this.list,
  }) : super._();

  @override
  final KtList<ValidName> list;

  @override
  TResult map<TResult extends Object?>({
    required TResult Function(ValidNameList2 valid) valid,
    required TResult Function(InvalidNameList2Content invalidContent)
        invalidContent,
  }) {
    return valid(this);
  }

  @override
  List<Object?> get allProps => [
        list,
      ];
}

class InvalidNameList2Content extends NameList2
    implements InvalidEntityContent {
  const InvalidNameList2Content._({
    required this.contentFailure,
    required this.list,
  }) : super._();

  @override
  final Failure contentFailure;

  @override
  Failure get failure => contentFailure;

  @override
  final KtList<Name> list;

  @override
  TResult map<TResult extends Object?>({
    required TResult Function(ValidNameList2 valid) valid,
    required TResult Function(InvalidNameList2Content invalidContent)
        invalidContent,
  }) {
    return invalidContent(this);
  }

  @override
  List<Object?> get allProps => [
        contentFailure,
        list,
      ];
}

class NameList2Tester extends ListEntityTester<InvalidNameList2Content,
    ValidNameList2, NameList2> {
  const NameList2Tester({
    int maxSutDescriptionLength = 100,
    String isValidGroupDescription = 'Should be a ValidNameList2',
    String isInvalidContentGroupDescription =
        'Should be an InvalidNameList2Content and hold the proper contentFailure',
  }) : super(
          maxSutDescriptionLength: maxSutDescriptionLength,
          isValidGroupDescription: isValidGroupDescription,
          isInvalidContentGroupDescription: isInvalidContentGroupDescription,
        );
}
