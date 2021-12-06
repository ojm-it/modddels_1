// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'namelist.dart';

// **************************************************************************
// ModddelGenerator
// **************************************************************************

mixin $NameList {
  static NameList _create(
    KtList<Name> list,
  ) {
    return _verifyContent(list).match(
      ///The content is invalid
      (contentFailure) => InvalidNameListContent._(
        contentFailure: contentFailure,
        list: list,
      ),

      ///The content is valid => We check if there's a general failure
      (validContent) => _verifyGeneral(validContent).match(
        (generalFailure) => InvalidNameListGeneral._(
          generalFailure: generalFailure,
          list: validContent,
        ),
        (validGeneral) => ValidNameList._(list: validGeneral),
      ),
    );
  }

  ///If any of the list elements is invalid, this holds its failure on the Left (the
  ///failure of the first invalid element encountered)
  ///
  ///Otherwise, holds all the elements as valid modddels, on the Right.
  static Either<Failure, KtList<ValidName>> _verifyContent(KtList<Name> list) {
    final contentVerification = list
        .map((element) => element.toBroadEither)
        .fold<Either<Failure, KtList<ValidName>>>(
          //We start with an empty list of elements on the right
          right(const KtList<ValidName>.empty()),
          (acc, element) => acc.fold(
            (l) => left(l),
            (r) => element.fold(
              (elementFailure) => left(elementFailure),

              ///If the element is valid and the "acc" (accumulation) holds a
              ///list of valid elements (on the right), we append this element
              ///to the list
              (validElement) =>
                  right(KtList.from([...r.asList(), validElement])),
            ),
          ),
        );
    return contentVerification;
  }

  static Either<NameListGeneralFailure, KtList<ValidName>> _verifyGeneral(
      KtList<ValidName> validList) {
    final generalVerification =
        const NameList._().validateGeneral(ValidNameList._(list: validList));
    return generalVerification.toEither(() => validList).swap();
  }

  int get size => mapValidity(
        valid: (valid) => valid.list.size,
        invalid: (invalid) => invalid.list.size,
      );

  static Either<Failure, ValidNameList?> toBroadEitherNullable(
          NameList? nullableEntity) =>
      optionOf(nullableEntity).match((t) => t.toBroadEither, () => right(null));

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

  TResult maybeMap<TResult extends Object?>({
    required TResult Function(ValidNameList valid) valid,
    TResult Function(InvalidNameListContent invalidContent)? invalidContent,
    TResult Function(InvalidNameListGeneral invalidGeneral)? invalidGeneral,
    required TResult Function(InvalidNameList invalid) orElse,
  }) {
    throw UnimplementedError();
  }

  TResult mapValidity<TResult extends Object?>({
    required TResult Function(ValidNameList valid) valid,
    required TResult Function(InvalidNameList invalid) invalid,
  }) {
    return maybeMap(
      valid: valid,
      orElse: invalid,
    );
  }

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
