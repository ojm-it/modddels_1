// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'namelist.dart';

// **************************************************************************
// ModddelGenerator
// **************************************************************************

mixin $NameList {
  static NameList _create(
    KtList<Name> list,
  ) {
    /// 1. **Content validation**
    return _verifyContent(list).match(
      (contentFailure) => InvalidNameListContent._(
        contentFailure: contentFailure,
        list: list,
      ),

      /// 2. **General validation**
      (validContent) => _verifyGeneral(validContent).match(
        (generalFailure) => InvalidNameListGeneral._(
          generalFailure: generalFailure,
          list: validContent,
        ),

        /// 3. **→ Validations passed**
        (validGeneral) => ValidNameList._(list: validGeneral),
      ),
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

  /// If the entity is invalid as a whole, this holds the [GeneralFailure] on
  /// the Left. Otherwise, holds the ValidEntity on the Right.
  static Either<NameListGeneralFailure, KtList<ValidName>> _verifyGeneral(
      KtList<ValidName> validList) {
    final generalVerification =
        const NameList._().validateGeneral(ValidNameList._(list: validList));
    return generalVerification.toEither(() => validList).swap();
  }

  /// The size of the list
  int get size => mapValidity(
        valid: (valid) => valid.list.size,
        invalid: (invalid) => invalid.list.size,
      );

  /// If [nullableEntity] is null, returns `right(null)`.
  /// Otherwise, returns `nullableEntity.toBroadEither`
  static Either<Failure, ValidNameList?> toBroadEitherNullable(
          NameList? nullableEntity) =>
      optionOf(nullableEntity).match((t) => t.toBroadEither, () => right(null));

  /// Similar to [mapValidity], but the "base" invalid union-case is replaced by
  /// the "specific" invalid union-cases of this entity :
  /// - [InvalidEntityContent]
  /// - [InvalidEntityGeneral]
  TResult map<TResult extends Object?>({
    required TResult Function(ValidNameList valid) valid,
    required TResult Function(InvalidNameListContent invalidContent)
        invalidContent,
    required TResult Function(InvalidNameListGeneral invalidGeneral)
        invalidGeneral,
  }) {
    return maybeMap(
      valid: valid,
      invalidContent: invalidContent,
      invalidGeneral: invalidGeneral,
      orElse: (invalid) => throw UnreachableError(),
    );
  }

  /// Equivalent to [map], but only the [valid] callback is required. It also
  /// adds an extra orElse required parameter, for fallback behavior.
  TResult maybeMap<TResult extends Object?>({
    required TResult Function(ValidNameList valid) valid,
    TResult Function(InvalidNameListContent invalidContent)? invalidContent,
    TResult Function(InvalidNameListGeneral invalidGeneral)? invalidGeneral,
    required TResult Function(InvalidNameList invalid) orElse,
  }) {
    throw UnimplementedError();
  }

  /// Pattern matching for the two different union-cases of this entity : valid
  /// and invalid.
  TResult mapValidity<TResult extends Object?>({
    required TResult Function(ValidNameList valid) valid,
    required TResult Function(InvalidNameList invalid) invalid,
  }) {
    return maybeMap(
      valid: valid,
      orElse: invalid,
    );
  }

  /// Creates a clone of this entity with the list returned from [callback].
  ///
  /// The resulting entity is totally independent from this entity. It is
  /// validated upon creation, and can be either valid or invalid.
  NameList copyWith(KtList<Name> Function(KtList<Name> list) callback) {
    return mapValidity(
      valid: (valid) => _create(callback(valid.list)),
      invalid: (invalid) => _create(callback(invalid.list)),
    );
  }
}

class ValidNameList extends NameList implements ValidEntity {
  const ValidNameList._({
    required this.list,
  }) : super._();

  final KtList<ValidName> list;

  @override
  TResult maybeMap<TResult extends Object?>({
    required TResult Function(ValidNameList valid) valid,
    TResult Function(InvalidNameListContent invalidContent)? invalidContent,
    TResult Function(InvalidNameListGeneral invalidGeneral)? invalidGeneral,
    required TResult Function(InvalidNameList invalid) orElse,
  }) {
    return valid(this);
  }

  @override
  List<Object?> get allProps => [
        list,
      ];
}

abstract class InvalidNameList extends NameList implements InvalidEntity {
  const InvalidNameList._() : super._();

  KtList<Name> get list;

  @override
  Failure get failure => whenInvalid(
        contentFailure: (contentFailure) => contentFailure,
        generalFailure: (generalFailure) => generalFailure,
      );

  /// Pattern matching for the "specific" invalid union-cases of this "base"
  /// invalid union-case, which are :
  /// - [InvalidEntityContent]
  /// - [InvalidEntityGeneral]
  TResult mapInvalid<TResult extends Object?>({
    required TResult Function(InvalidNameListContent invalidContent)
        invalidContent,
    required TResult Function(InvalidNameListGeneral invalidGeneral)
        invalidGeneral,
  }) {
    return maybeMap(
      valid: (valid) => throw UnreachableError(),
      invalidContent: invalidContent,
      invalidGeneral: invalidGeneral,
      orElse: (invalid) => throw UnreachableError(),
    );
  }

  /// Similar to [mapInvalid], but the union-cases are replaced by the failures
  /// they hold.
  TResult whenInvalid<TResult extends Object?>({
    required TResult Function(Failure contentFailure) contentFailure,
    required TResult Function(NameListGeneralFailure generalFailure)
        generalFailure,
  }) {
    return maybeMap(
      valid: (valid) => throw UnreachableError(),
      invalidContent: (invalidContent) =>
          contentFailure(invalidContent.contentFailure),
      invalidGeneral: (invalidGeneral) =>
          generalFailure(invalidGeneral.generalFailure),
      orElse: (invalid) => throw UnreachableError(),
    );
  }
}

class InvalidNameListContent extends InvalidNameList
    implements InvalidEntityContent {
  const InvalidNameListContent._({
    required this.contentFailure,
    required this.list,
  }) : super._();

  @override
  final Failure contentFailure;

  @override
  final KtList<Name> list;

  @override
  TResult maybeMap<TResult extends Object?>({
    required TResult Function(ValidNameList valid) valid,
    TResult Function(InvalidNameListContent invalidContent)? invalidContent,
    TResult Function(InvalidNameListGeneral invalidGeneral)? invalidGeneral,
    required TResult Function(InvalidNameList invalid) orElse,
  }) {
    if (invalidContent != null) {
      return invalidContent(this);
    }
    return orElse(this);
  }

  @override
  List<Object?> get allProps => [
        contentFailure,
        list,
      ];
}

class InvalidNameListGeneral extends InvalidNameList
    implements InvalidEntityGeneral<NameListGeneralFailure> {
  const InvalidNameListGeneral._({
    required this.generalFailure,
    required this.list,
  }) : super._();

  @override
  final NameListGeneralFailure generalFailure;

  @override
  final KtList<ValidName> list;

  @override
  TResult maybeMap<TResult extends Object?>({
    required TResult Function(ValidNameList valid) valid,
    TResult Function(InvalidNameListContent invalidContent)? invalidContent,
    TResult Function(InvalidNameListGeneral invalidGeneral)? invalidGeneral,
    required TResult Function(InvalidNameList invalid) orElse,
  }) {
    if (invalidGeneral != null) {
      return invalidGeneral(this);
    }
    return orElse(this);
  }

  @override
  List<Object?> get allProps => [
        generalFailure,
        list,
      ];
}

class NameListTester extends ListGeneralEntityTester<
    NameListGeneralFailure,
    InvalidNameListContent,
    InvalidNameListGeneral,
    InvalidNameList,
    ValidNameList,
    NameList> {
  const NameListTester({
    int maxSutDescriptionLength = 100,
    String isValidGroupDescription = 'Should be a ValidNameList',
    String isInvalidContentGroupDescription =
        'Should be an InvalidNameListContent and hold the proper contentFailure',
    String isInvalidGeneralGroupDescription =
        'Should be an InvalidNameListGeneral and hold the NameListGeneralFailure',
  }) : super(
          maxSutDescriptionLength: maxSutDescriptionLength,
          isValidGroupDescription: isValidGroupDescription,
          isInvalidContentGroupDescription: isInvalidContentGroupDescription,
          isInvalidGeneralGroupDescription: isInvalidGeneralGroupDescription,
        );
}
