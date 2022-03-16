// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'whitelist.dart';

// **************************************************************************
// ModddelGenerator
// **************************************************************************

mixin $WhiteList {
  static WhiteList _create(
    KtList<Name> list,
  ) {
    /// 1. **Size validation**
    return _verifySize(list).match(
      (sizeFailure) =>
          InvalidWhiteListSize._(sizeFailure: sizeFailure, list: list),

      /// 2. **Content validation**
      (validSize) => _verifyContent(validSize).match(
        (contentFailure) => InvalidWhiteListContent._(
          contentFailure: contentFailure,
          list: validSize,
        ),

        /// 3. **→ Validations passed**
        (validContent) => ValidWhiteList._(list: validContent),
      ),
    );
  }

  /// If the size of the list is invalid, this holds the [SizeFailure] on the
  /// Left. Otherwise, holds the list on the Right.
  static Either<WhiteListSizeFailure, KtList<Name>> _verifySize(
      KtList<Name> list) {
    final sizeVerification = const WhiteList._().validateSize(list.size);
    return sizeVerification.toEither(() => list).swap();
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

  /// The size of the list
  int get size => mapValidity(
        valid: (valid) => valid.list.size,
        invalid: (invalid) => invalid.list.size,
      );

  /// If [nullableEntity] is null, returns `right(null)`.
  /// Otherwise, returns `nullableEntity.toBroadEither`.
  static Either<Failure, ValidWhiteList?> toBroadEitherNullable(
          WhiteList? nullableEntity) =>
      optionOf(nullableEntity).match((t) => t.toBroadEither, () => right(null));

  /// Similar to [mapValidity], but the "base" invalid union-case is replaced by
  /// the "specific" invalid union-cases of this entity :
  /// - [InvalidEntitySize]
  /// - [InvalidEntityContent]
  TResult map<TResult extends Object?>({
    required TResult Function(ValidWhiteList valid) valid,
    required TResult Function(InvalidWhiteListSize invalidSize) invalidSize,
    required TResult Function(InvalidWhiteListContent invalidContent)
        invalidContent,
  }) {
    return maybeMap(
      valid: valid,
      invalidSize: invalidSize,
      invalidContent: invalidContent,
      orElse: (invalid) => throw UnreachableError(),
    );
  }

  /// Equivalent to [map], but only the [valid] callback is required. It also
  /// adds an extra orElse required parameter, for fallback behavior.
  TResult maybeMap<TResult extends Object?>({
    required TResult Function(ValidWhiteList valid) valid,
    TResult Function(InvalidWhiteListSize invalidSize)? invalidSize,
    TResult Function(InvalidWhiteListContent invalidContent)? invalidContent,
    required TResult Function(InvalidWhiteList invalid) orElse,
  }) {
    throw UnimplementedError();
  }

  /// Pattern matching for the two different union-cases of this entity : valid
  /// and invalid.
  TResult mapValidity<TResult extends Object?>({
    required TResult Function(ValidWhiteList valid) valid,
    required TResult Function(InvalidWhiteList invalid) invalid,
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
  WhiteList copyWith(KtList<Name> Function(KtList<Name> list) callback) {
    return mapValidity(
      valid: (valid) => _create(callback(valid.list)),
      invalid: (invalid) => _create(callback(invalid.list)),
    );
  }

  List<Object?> get props => throw UnimplementedError();

  StringifyMode get stringifyMode => StringifyMode.always;
}

class ValidWhiteList extends WhiteList implements ValidEntity {
  const ValidWhiteList._({
    required this.list,
  }) : super._();

  final KtList<ValidName> list;

  @override
  TResult maybeMap<TResult extends Object?>({
    required TResult Function(ValidWhiteList valid) valid,
    TResult Function(InvalidWhiteListSize invalidSize)? invalidSize,
    TResult Function(InvalidWhiteListContent invalidContent)? invalidContent,
    required TResult Function(InvalidWhiteList invalid) orElse,
  }) {
    return valid(this);
  }

  @override
  List<Object?> get props => [
        list,
      ];
}

abstract class InvalidWhiteList extends WhiteList implements InvalidEntity {
  const InvalidWhiteList._() : super._();

  KtList<Name> get list;

  @override
  Failure get failure => whenInvalid(
        sizeFailure: (sizeFailure) => sizeFailure,
        contentFailure: (contentFailure) => contentFailure,
      );

  /// Pattern matching for the "specific" invalid union-cases of this "base"
  /// invalid union-case, which are :
  /// - [InvalidEntitySize]
  /// - [InvalidEntityContent]
  TResult mapInvalid<TResult extends Object?>({
    required TResult Function(InvalidWhiteListSize invalidSize) invalidSize,
    required TResult Function(InvalidWhiteListContent invalidContent)
        invalidContent,
  }) {
    return maybeMap(
      valid: (valid) => throw UnreachableError(),
      invalidSize: invalidSize,
      invalidContent: invalidContent,
      orElse: (invalid) => throw UnreachableError(),
    );
  }

  /// Similar to [mapInvalid], but the union-cases are replaced by the failures
  /// they hold.
  TResult whenInvalid<TResult extends Object?>({
    required TResult Function(WhiteListSizeFailure sizeFailure) sizeFailure,
    required TResult Function(Failure contentFailure) contentFailure,
  }) {
    return maybeMap(
      valid: (valid) => throw UnreachableError(),
      invalidSize: (invalidSize) => sizeFailure(invalidSize.sizeFailure),
      invalidContent: (invalidContent) =>
          contentFailure(invalidContent.contentFailure),
      orElse: (invalid) => throw UnreachableError(),
    );
  }
}

class InvalidWhiteListSize extends InvalidWhiteList
    implements InvalidEntitySize<WhiteListSizeFailure> {
  const InvalidWhiteListSize._({
    required this.sizeFailure,
    required this.list,
  }) : super._();

  @override
  final WhiteListSizeFailure sizeFailure;

  @override
  final KtList<Name> list;

  @override
  TResult maybeMap<TResult extends Object?>({
    required TResult Function(ValidWhiteList valid) valid,
    TResult Function(InvalidWhiteListSize invalidSize)? invalidSize,
    TResult Function(InvalidWhiteListContent invalidContent)? invalidContent,
    required TResult Function(InvalidWhiteList invalid) orElse,
  }) {
    if (invalidSize != null) {
      return invalidSize(this);
    }
    return orElse(this);
  }

  @override
  List<Object?> get props => [
        sizeFailure,
        list,
      ];
}

class InvalidWhiteListContent extends InvalidWhiteList
    implements InvalidEntityContent {
  const InvalidWhiteListContent._({
    required this.contentFailure,
    required this.list,
  }) : super._();

  @override
  final Failure contentFailure;

  @override
  final KtList<Name> list;

  @override
  TResult maybeMap<TResult extends Object?>({
    required TResult Function(ValidWhiteList valid) valid,
    TResult Function(InvalidWhiteListSize invalidSize)? invalidSize,
    TResult Function(InvalidWhiteListContent invalidContent)? invalidContent,
    required TResult Function(InvalidWhiteList invalid) orElse,
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

class WhiteListTester extends SizedListEntityTester<
    WhiteListSizeFailure,
    InvalidWhiteListSize,
    InvalidWhiteListContent,
    InvalidWhiteList,
    ValidWhiteList,
    WhiteList,
    _WhiteListInput> {
  const WhiteListTester({
    int maxSutDescriptionLength = 100,
    String isSanitizedGroupDescription = 'Should be sanitized',
    String isNotSanitizedGroupDescription = 'Should not be sanitized',
    String isValidGroupDescription = 'Should be a ValidWhiteList',
    String isInvalidSizeGroupDescription =
        'Should be an InvalidWhiteListSize and hold the WhiteListSizeFailure',
    String isInvalidContentGroupDescription =
        'Should be an InvalidWhiteListContent and hold the proper contentFailure',
  }) : super(
          maxSutDescriptionLength: maxSutDescriptionLength,
          isSanitizedGroupDescription: isSanitizedGroupDescription,
          isNotSanitizedGroupDescription: isNotSanitizedGroupDescription,
          isValidGroupDescription: isValidGroupDescription,
          isInvalidSizeGroupDescription: isInvalidSizeGroupDescription,
          isInvalidContentGroupDescription: isInvalidContentGroupDescription,
        );

  final makeInput = _WhiteListInput.new;
}

class _WhiteListInput extends ModddelInput<WhiteList> {
  const _WhiteListInput(this.list);

  final KtList<Name> list;

  @override
  List<Object?> get props => [list];

  @override
  _WhiteListInput get sanitizedInput {
    final modddel = WhiteList(list);
    final modddelList =
        modddel.mapValidity(valid: (v) => v.list, invalid: (i) => i.list);

    return _WhiteListInput(modddelList);
  }
}
