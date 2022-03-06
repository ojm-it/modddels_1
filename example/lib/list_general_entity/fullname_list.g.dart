// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fullname_list.dart';

// **************************************************************************
// ModddelGenerator
// **************************************************************************

mixin $FullNameList {
  static FullNameList _create(
    KtList<FullName> list,
  ) {
    /// 1. **Content validation**
    return _verifyContent(list).match(
      (contentFailure) => InvalidFullNameListContent._(
        contentFailure: contentFailure,
        list: list,
      ),

      /// 2. **General validation**
      (validContent) => _verifyGeneral(validContent).match(
        (generalFailure) => InvalidFullNameListGeneral._(
          generalFailure: generalFailure,
          list: validContent,
        ),

        /// 3. **→ Validations passed**
        (validGeneral) => ValidFullNameList._(list: validGeneral),
      ),
    );
  }

  /// If any of the list elements is invalid, this holds its failure on the Left
  /// (the failure of the first invalid element encountered)
  ///
  /// Otherwise, holds the list of all the elements as valid modddels, on the
  /// Right.
  static Either<Failure, KtList<ValidFullName>> _verifyContent(
      KtList<FullName> list) {
    final contentVerification = list
        .map((element) => element.toBroadEither)
        .fold<Either<Failure, KtList<ValidFullName>>>(
          /// We start with an empty list of elements on the right
          right(const KtList<ValidFullName>.empty()),
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
  static Either<FullNameListGeneralFailure, KtList<ValidFullName>>
      _verifyGeneral(KtList<ValidFullName> validList) {
    final generalVerification = const FullNameList._()
        .validateGeneral(ValidFullNameList._(list: validList));
    return generalVerification.toEither(() => validList).swap();
  }

  /// The size of the list
  int get size => mapValidity(
        valid: (valid) => valid.list.size,
        invalid: (invalid) => invalid.list.size,
      );

  /// If [nullableEntity] is null, returns `right(null)`.
  /// Otherwise, returns `nullableEntity.toBroadEither`
  static Either<Failure, ValidFullNameList?> toBroadEitherNullable(
          FullNameList? nullableEntity) =>
      optionOf(nullableEntity).match((t) => t.toBroadEither, () => right(null));

  /// Similar to [mapValidity], but the "base" invalid union-case is replaced by
  /// the "specific" invalid union-cases of this entity :
  /// - [InvalidEntityContent]
  /// - [InvalidEntityGeneral]
  TResult map<TResult extends Object?>({
    required TResult Function(ValidFullNameList valid) valid,
    required TResult Function(InvalidFullNameListContent invalidContent)
        invalidContent,
    required TResult Function(InvalidFullNameListGeneral invalidGeneral)
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
    required TResult Function(ValidFullNameList valid) valid,
    TResult Function(InvalidFullNameListContent invalidContent)? invalidContent,
    TResult Function(InvalidFullNameListGeneral invalidGeneral)? invalidGeneral,
    required TResult Function(InvalidFullNameList invalid) orElse,
  }) {
    throw UnimplementedError();
  }

  /// Pattern matching for the two different union-cases of this entity : valid
  /// and invalid.
  TResult mapValidity<TResult extends Object?>({
    required TResult Function(ValidFullNameList valid) valid,
    required TResult Function(InvalidFullNameList invalid) invalid,
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
  FullNameList copyWith(
      KtList<FullName> Function(KtList<FullName> list) callback) {
    return mapValidity(
      valid: (valid) => _create(callback(valid.list)),
      invalid: (invalid) => _create(callback(invalid.list)),
    );
  }

  List<Object?> get props => throw UnimplementedError();

  StringifyMode get stringifyMode => StringifyMode.always;
}

class ValidFullNameList extends FullNameList implements ValidEntity {
  const ValidFullNameList._({
    required this.list,
  }) : super._();

  final KtList<ValidFullName> list;

  @override
  TResult maybeMap<TResult extends Object?>({
    required TResult Function(ValidFullNameList valid) valid,
    TResult Function(InvalidFullNameListContent invalidContent)? invalidContent,
    TResult Function(InvalidFullNameListGeneral invalidGeneral)? invalidGeneral,
    required TResult Function(InvalidFullNameList invalid) orElse,
  }) {
    return valid(this);
  }

  @override
  List<Object?> get props => [
        list,
      ];
}

abstract class InvalidFullNameList extends FullNameList
    implements InvalidEntity {
  const InvalidFullNameList._() : super._();

  KtList<FullName> get list;

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
    required TResult Function(InvalidFullNameListContent invalidContent)
        invalidContent,
    required TResult Function(InvalidFullNameListGeneral invalidGeneral)
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
    required TResult Function(FullNameListGeneralFailure generalFailure)
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

class InvalidFullNameListContent extends InvalidFullNameList
    implements InvalidEntityContent {
  const InvalidFullNameListContent._({
    required this.contentFailure,
    required this.list,
  }) : super._();

  @override
  final Failure contentFailure;

  @override
  final KtList<FullName> list;

  @override
  TResult maybeMap<TResult extends Object?>({
    required TResult Function(ValidFullNameList valid) valid,
    TResult Function(InvalidFullNameListContent invalidContent)? invalidContent,
    TResult Function(InvalidFullNameListGeneral invalidGeneral)? invalidGeneral,
    required TResult Function(InvalidFullNameList invalid) orElse,
  }) {
    if (invalidContent != null) {
      return invalidContent(this);
    }
    return orElse(this);
  }

  @override
  List<Object?> get props => [
        contentFailure,
        list,
      ];
}

class InvalidFullNameListGeneral extends InvalidFullNameList
    implements InvalidEntityGeneral<FullNameListGeneralFailure> {
  const InvalidFullNameListGeneral._({
    required this.generalFailure,
    required this.list,
  }) : super._();

  @override
  final FullNameListGeneralFailure generalFailure;

  @override
  final KtList<ValidFullName> list;

  @override
  TResult maybeMap<TResult extends Object?>({
    required TResult Function(ValidFullNameList valid) valid,
    TResult Function(InvalidFullNameListContent invalidContent)? invalidContent,
    TResult Function(InvalidFullNameListGeneral invalidGeneral)? invalidGeneral,
    required TResult Function(InvalidFullNameList invalid) orElse,
  }) {
    if (invalidGeneral != null) {
      return invalidGeneral(this);
    }
    return orElse(this);
  }

  @override
  List<Object?> get props => [
        generalFailure,
        list,
      ];
}

class FullNameListTester extends ListGeneralEntityTester<
    FullNameListGeneralFailure,
    InvalidFullNameListContent,
    InvalidFullNameListGeneral,
    InvalidFullNameList,
    ValidFullNameList,
    FullNameList> {
  const FullNameListTester({
    int maxSutDescriptionLength = 100,
    String isValidGroupDescription = 'Should be a ValidFullNameList',
    String isInvalidContentGroupDescription =
        'Should be an InvalidFullNameListContent and hold the proper contentFailure',
    String isInvalidGeneralGroupDescription =
        'Should be an InvalidFullNameListGeneral and hold the FullNameListGeneralFailure',
  }) : super(
          maxSutDescriptionLength: maxSutDescriptionLength,
          isValidGroupDescription: isValidGroupDescription,
          isInvalidContentGroupDescription: isInvalidContentGroupDescription,
          isInvalidGeneralGroupDescription: isInvalidGeneralGroupDescription,
        );
}
