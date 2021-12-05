// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fullname_list.dart';

// **************************************************************************
// ModddelGenerator
// **************************************************************************

mixin $FullNameList {
  static FullNameList _create(
    KtList<FullName> list,
  ) {
    ///If any of the list elements is invalid, this holds its failure on the Left (the
    ///failure of the first invalid element encountered)
    ///
    ///Otherwise, holds all the elements as valid modddels, on the Right.
    final contentVerification = list
        .map((element) => element.toBroadEither)
        .fold<Either<Failure, KtList<ValidFullName>>>(
          //We start with an empty list of elements on the right
          right(const KtList<ValidFullName>.empty()),
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

    return contentVerification.match(
      ///The content is invalid
      (contentFailure) => InvalidFullNameListContent._(
        contentFailure: contentFailure,
        list: list,
      ),

      ///The content is valid => We check if there's a general failure
      (validContent) => const FullNameList._()
          .validateGeneral(ValidFullNameList._(list: validContent))
          .match(
            (generalFailure) => InvalidFullNameListGeneral._(
              generalEntityFailure: generalFailure,
              list: validContent,
            ),
            () => ValidFullNameList._(list: validContent),
          ),
    );
  }

  int get size => mapValidity(
        valid: (valid) => valid.list.size,
        invalid: (invalid) => invalid.list.size,
      );

  static Either<Failure, ValidFullNameList?> toBroadEitherNullable(
          FullNameList? nullableEntity) =>
      optionOf(nullableEntity).match((t) => t.toBroadEither, () => right(null));

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

  TResult maybeMap<TResult extends Object?>({
    required TResult Function(ValidFullNameList valid) valid,
    TResult Function(InvalidFullNameListContent invalidContent)? invalidContent,
    TResult Function(InvalidFullNameListGeneral invalidGeneral)? invalidGeneral,
    required TResult Function(InvalidFullNameList invalid) orElse,
  }) {
    throw UnimplementedError();
  }

  TResult mapValidity<TResult extends Object?>({
    required TResult Function(ValidFullNameList valid) valid,
    required TResult Function(InvalidFullNameList invalid) invalid,
  }) {
    return maybeMap(
      valid: valid,
      orElse: invalid,
    );
  }

  FullNameList copyWith(
      KtList<FullName> Function(KtList<FullName> list) callback) {
    return mapValidity(
      valid: (valid) => _create(callback(valid.list)),
      invalid: (invalid) => _create(callback(invalid.list)),
    );
  }
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
  List<Object?> get allProps => [
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
        generalEntityFailure: (generalEntityFailure) => generalEntityFailure,
      );

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

  TResult whenInvalid<TResult extends Object?>({
    required TResult Function(Failure contentFailure) contentFailure,
    required TResult Function(FullNameListEntityFailure generalEntityFailure)
        generalEntityFailure,
  }) {
    return maybeMap(
      valid: (valid) => throw UnreachableError(),
      invalidContent: (invalidContent) =>
          contentFailure(invalidContent.contentFailure),
      invalidGeneral: (invalidGeneral) =>
          generalEntityFailure(invalidGeneral.generalEntityFailure),
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
  List<Object?> get allProps => [
        contentFailure,
        list,
      ];
}

class InvalidFullNameListGeneral extends InvalidFullNameList
    implements InvalidEntityGeneral<FullNameListEntityFailure> {
  const InvalidFullNameListGeneral._({
    required this.generalEntityFailure,
    required this.list,
  }) : super._();

  @override
  final FullNameListEntityFailure generalEntityFailure;

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
  List<Object?> get allProps => [
        generalEntityFailure,
        list,
      ];
}
