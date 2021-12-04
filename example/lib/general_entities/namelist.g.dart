// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'namelist.dart';

// **************************************************************************
// ModddelGenerator
// **************************************************************************

mixin $NameList {
  static NameList _create(
    KtList<Name> list,
  ) {
    ///If any of the list elements is invalid, this holds its failure on the Left (the
    ///failure of the first invalid element encountered)
    ///
    ///Otherwise, holds all the elements as valid modddels, on the Right.
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

    return contentVerification.match(
      ///The content is invalid
      (contentFailure) => InvalidNameListContent._(
        contentFailure: contentFailure,
        list: list,
      ),

      ///The content is valid => We check if there's a general failure
      (validContent) => const NameList._()
          .validateGeneral(ValidNameList._(list: validContent))
          .match(
            (generalFailure) => InvalidNameListGeneral._(
              generalEntityFailure: generalFailure,
              list: validContent,
            ),
            () => ValidNameList._(list: validContent),
          ),
    );
  }

  int get size => match(
        valid: (valid) => valid.list.size,
        invalid: (invalid) => invalid.list.size,
      );

  static Either<Failure, ValidNameList?> toBroadEitherNullable(
          NameList? nullableEntity) =>
      optionOf(nullableEntity).match((t) => t.toBroadEither, () => right(null));

  TResult match<TResult extends Object?>(
      {required TResult Function(ValidNameList valid) valid,
      required TResult Function(InvalidNameList invalid) invalid}) {
    throw UnimplementedError();
  }
}

class ValidNameList extends NameList implements ValidEntity {
  const ValidNameList._({
    required this.list,
  }) : super._();

  final KtList<ValidName> list;

  @override
  TResult match<TResult extends Object?>(
      {required TResult Function(ValidNameList valid) valid,
      required TResult Function(InvalidNameList invalid) invalid}) {
    return valid(this);
  }

  @override
  List<Object?> get allProps => [
        list,
      ];
}

abstract class InvalidNameList extends NameList
    implements
        InvalidEntity<NameListEntityFailure, InvalidNameListGeneral,
            InvalidNameListContent> {
  const InvalidNameList._() : super._();

  KtList<Name> get list;

  @override
  TResult match<TResult extends Object?>(
      {required TResult Function(ValidNameList valid) valid,
      required TResult Function(InvalidNameList invalid) invalid}) {
    return invalid(this);
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
  TResult invalidMatch<TResult extends Object?>(
      {required TResult Function(InvalidNameListGeneral invalidEntityGeneral)
          invalidEntityGeneral,
      required TResult Function(InvalidNameListContent invalidEntityContent)
          invalidEntityContent}) {
    return invalidEntityContent(this);
  }

  @override
  TResult invalidWhen<TResult extends Object?>({
    required TResult Function(NameListEntityFailure generalEntityFailure)
        generalEntityFailure,
    required TResult Function(Failure contentFailure) contentFailure,
  }) {
    return contentFailure(this.contentFailure);
  }

  @override
  List<Object?> get allProps => [
        contentFailure,
        list,
      ];
}

class InvalidNameListGeneral extends InvalidNameList
    implements InvalidEntityGeneral<NameListEntityFailure> {
  const InvalidNameListGeneral._({
    required this.generalEntityFailure,
    required this.list,
  }) : super._();

  @override
  final NameListEntityFailure generalEntityFailure;

  @override
  final KtList<ValidName> list;

  @override
  TResult invalidMatch<TResult extends Object?>(
      {required TResult Function(InvalidNameListGeneral invalidEntityGeneral)
          invalidEntityGeneral,
      required TResult Function(InvalidNameListContent invalidEntityContent)
          invalidEntityContent}) {
    return invalidEntityGeneral(this);
  }

  @override
  TResult invalidWhen<TResult extends Object?>({
    required TResult Function(NameListEntityFailure generalEntityFailure)
        generalEntityFailure,
    required TResult Function(Failure contentFailure) contentFailure,
  }) {
    return generalEntityFailure(this.generalEntityFailure);
  }

  @override
  List<Object?> get allProps => [
        generalEntityFailure,
        list,
      ];
}
