// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'namelist2.dart';

// **************************************************************************
// ModddelGenerator
// **************************************************************************

mixin $NameList2 {
  static NameList2 _create(
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
      (contentFailure) => InvalidNameList2Content._(
        contentFailure: contentFailure,
        list: list,
      ),

      ///The content is valid => The entity is valid
      (validContent) => ValidNameList2._(list: validContent),
    );
  }

  KtList<Name> get list => match(
        valid: (valid) => valid.list,
        invalid: (invalid) => invalid.list,
      );

  static Either<Failure, ValidNameList2?> toBroadEitherNullable(
          NameList2? nullableEntity) =>
      optionOf(nullableEntity).match((t) => t.toBroadEither, () => right(null));

  TResult match<TResult extends Object?>(
      {required TResult Function(ValidNameList2 valid) valid,
      required TResult Function(InvalidNameList2Content invalid) invalid}) {
    throw UnimplementedError();
  }
}

class ValidNameList2 extends NameList2 implements ValidEntity {
  const ValidNameList2._({
    required this.list,
  }) : super._();

  @override
  final KtList<ValidName> list;

  @override
  TResult match<TResult extends Object?>(
      {required TResult Function(ValidNameList2 valid) valid,
      required TResult Function(InvalidNameList2Content invalid) invalid}) {
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
  final KtList<Name> list;

  @override
  TResult match<TResult extends Object?>(
      {required TResult Function(ValidNameList2 valid) valid,
      required TResult Function(InvalidNameList2Content invalid) invalid}) {
    return invalid(this);
  }

  @override
  List<Object?> get allProps => [
        contentFailure,
        list,
      ];
}
