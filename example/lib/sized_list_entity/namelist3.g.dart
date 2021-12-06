// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'namelist3.dart';

// **************************************************************************
// ModddelGenerator
// **************************************************************************

mixin $NameList3 {
  static NameList3 _create(
    KtList<Name> list,
  ) {
    return _verifySize(list).match(
      (sizeFailure) =>
          InvalidNameList3Size._(sizeFailure: sizeFailure, list: list),
      (validSize) => _verifyContent(validSize).match(
        (contentFailure) => InvalidNameList3Content._(
          contentFailure: contentFailure,
          list: validSize,
        ),
        (validContent) => ValidNameList3._(list: validContent),
      ),
    );
  }

  static Either<NameList3SizeFailure, KtList<Name>> _verifySize(
      KtList<Name> list) {
    final sizeVerification = const NameList3._().validateSize(list.size);
    return sizeVerification.toEither(() => list).swap();
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

  int get size => mapValidity(
        valid: (valid) => valid.list.size,
        invalid: (invalid) => invalid.list.size,
      );

  static Either<Failure, ValidNameList3?> toBroadEitherNullable(
          NameList3? nullableEntity) =>
      optionOf(nullableEntity).match((t) => t.toBroadEither, () => right(null));

  TResult map<TResult extends Object?>({
    required TResult Function(ValidNameList3 valid) valid,
    required TResult Function(InvalidNameList3Size invalidSize) invalidSize,
    required TResult Function(InvalidNameList3Content invalidContent)
        invalidContent,
  }) {
    return maybeMap(
      valid: valid,
      invalidSize: invalidSize,
      invalidContent: invalidContent,
      orElse: (invalid) => throw UnreachableError(),
    );
  }

  TResult maybeMap<TResult extends Object?>({
    required TResult Function(ValidNameList3 valid) valid,
    TResult Function(InvalidNameList3Size invalidSize)? invalidSize,
    TResult Function(InvalidNameList3Content invalidContent)? invalidContent,
    required TResult Function(InvalidNameList3 invalid) orElse,
  }) {
    throw UnimplementedError();
  }

  TResult mapValidity<TResult extends Object?>({
    required TResult Function(ValidNameList3 valid) valid,
    required TResult Function(InvalidNameList3 invalid) invalid,
  }) {
    return maybeMap(
      valid: valid,
      orElse: invalid,
    );
  }

  NameList3 copyWith(KtList<Name> Function(KtList<Name> list) callback) {
    return mapValidity(
      valid: (valid) => _create(callback(valid.list)),
      invalid: (invalid) => _create(callback(invalid.list)),
    );
  }
}

class ValidNameList3 extends NameList3 implements ValidEntity {
  const ValidNameList3._({
    required this.list,
  }) : super._();

  final KtList<ValidName> list;

  @override
  TResult maybeMap<TResult extends Object?>({
    required TResult Function(ValidNameList3 valid) valid,
    TResult Function(InvalidNameList3Size invalidSize)? invalidSize,
    TResult Function(InvalidNameList3Content invalidContent)? invalidContent,
    required TResult Function(InvalidNameList3 invalid) orElse,
  }) {
    return valid(this);
  }

  @override
  List<Object?> get allProps => [
        list,
      ];
}

abstract class InvalidNameList3 extends NameList3 implements InvalidEntity {
  const InvalidNameList3._() : super._();

  KtList<Name> get list;

  @override
  Failure get failure => whenInvalid(
        sizeFailure: (sizeFailure) => sizeFailure,
        contentFailure: (contentFailure) => contentFailure,
      );

  TResult mapInvalid<TResult extends Object?>({
    required TResult Function(InvalidNameList3Size invalidSize) invalidSize,
    required TResult Function(InvalidNameList3Content invalidContent)
        invalidContent,
  }) {
    return maybeMap(
      valid: (valid) => throw UnreachableError(),
      invalidSize: invalidSize,
      invalidContent: invalidContent,
      orElse: (invalid) => throw UnreachableError(),
    );
  }

  TResult whenInvalid<TResult extends Object?>({
    required TResult Function(NameList3SizeFailure sizeFailure) sizeFailure,
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

class InvalidNameList3Size extends InvalidNameList3
    implements InvalidEntitySize<NameList3SizeFailure> {
  const InvalidNameList3Size._({
    required this.sizeFailure,
    required this.list,
  }) : super._();

  @override
  final NameList3SizeFailure sizeFailure;

  @override
  final KtList<Name> list;

  @override
  TResult maybeMap<TResult extends Object?>({
    required TResult Function(ValidNameList3 valid) valid,
    TResult Function(InvalidNameList3Size invalidSize)? invalidSize,
    TResult Function(InvalidNameList3Content invalidContent)? invalidContent,
    required TResult Function(InvalidNameList3 invalid) orElse,
  }) {
    if (invalidSize != null) {
      return invalidSize(this);
    }
    return orElse(this);
  }

  @override
  List<Object?> get allProps => [
        sizeFailure,
        list,
      ];
}

class InvalidNameList3Content extends InvalidNameList3
    implements InvalidEntityContent {
  const InvalidNameList3Content._({
    required this.contentFailure,
    required this.list,
  }) : super._();

  @override
  final Failure contentFailure;

  @override
  final KtList<Name> list;

  @override
  TResult maybeMap<TResult extends Object?>({
    required TResult Function(ValidNameList3 valid) valid,
    TResult Function(InvalidNameList3Size invalidSize)? invalidSize,
    TResult Function(InvalidNameList3Content invalidContent)? invalidContent,
    required TResult Function(InvalidNameList3 invalid) orElse,
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