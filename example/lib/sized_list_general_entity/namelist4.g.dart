// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'namelist4.dart';

// **************************************************************************
// ModddelGenerator
// **************************************************************************

mixin $NameList4 {
  static NameList4 _create(
    KtList<Name> list,
  ) {
    /// 1. **Size validation**
    return _verifySize(list).match(
      (sizeFailure) =>
          InvalidNameList4Size._(sizeFailure: sizeFailure, list: list),

      /// 2. **Content validation**
      (validSize) => _verifyContent(validSize).match(
        (contentFailure) => InvalidNameList4Content._(
          contentFailure: contentFailure,
          list: validSize,
        ),

        /// 3. **General validation**
        (validContent) => _verifyGeneral(validContent).match(
            (generalFailure) => InvalidNameList4General._(
                  generalFailure: generalFailure,
                  list: validContent,
                ),

            /// 4. **→ Validations passed**
            (validGeneral) => ValidNameList4._(list: validGeneral)),
      ),
    );
  }

  /// If the size of the list is invalid, this holds the [SizeFailure] on the
  /// Left. Otherwise, holds the list on the Right.
  static Either<NameList4SizeFailure, KtList<Name>> _verifySize(
      KtList<Name> list) {
    final sizeVerification = const NameList4._().validateSize(list.size);
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

  /// If the entity is invalid as a whole, this holds the [GeneralFailure] on
  /// the Left. Otherwise, holds the ValidEntity on the Right.
  static Either<NameList4GeneralFailure, KtList<ValidName>> _verifyGeneral(
      KtList<ValidName> validList) {
    final generalVerification =
        const NameList4._().validateGeneral(ValidNameList4._(list: validList));
    return generalVerification.toEither(() => validList).swap();
  }

  /// The size of the list
  int get size => mapValidity(
        valid: (valid) => valid.list.size,
        invalid: (invalid) => invalid.list.size,
      );

  /// If [nullableEntity] is null, returns `right(null)`.
  /// Otherwise, returns `nullableEntity.toBroadEither`
  static Either<Failure, ValidNameList4?> toBroadEitherNullable(
          NameList4? nullableEntity) =>
      optionOf(nullableEntity).match((t) => t.toBroadEither, () => right(null));

  /// Similar to [mapValidity], but the "base" invalid union-case is replaced by
  /// the "specific" invalid union-cases of this entity :
  /// - [InvalidEntitySize]
  /// - [InvalidEntityContent]
  /// - [InvalidEntityGeneral]
  TResult map<TResult extends Object?>({
    required TResult Function(ValidNameList4 valid) valid,
    required TResult Function(InvalidNameList4Size invalidSize) invalidSize,
    required TResult Function(InvalidNameList4Content invalidContent)
        invalidContent,
    required TResult Function(InvalidNameList4General invalidGeneral)
        invalidGeneral,
  }) {
    return maybeMap(
      valid: valid,
      invalidSize: invalidSize,
      invalidContent: invalidContent,
      invalidGeneral: invalidGeneral,
      orElse: (invalid) => throw UnreachableError(),
    );
  }

  /// Equivalent to [map], but only the [valid] callback is required. It also
  /// adds an extra orElse required parameter, for fallback behavior.
  TResult maybeMap<TResult extends Object?>({
    required TResult Function(ValidNameList4 valid) valid,
    TResult Function(InvalidNameList4Size invalidSize)? invalidSize,
    TResult Function(InvalidNameList4Content invalidContent)? invalidContent,
    TResult Function(InvalidNameList4General invalidGeneral)? invalidGeneral,
    required TResult Function(InvalidNameList4 invalid) orElse,
  }) {
    throw UnimplementedError();
  }

  /// Pattern matching for the two different union-cases of this entity : valid
  /// and invalid.
  TResult mapValidity<TResult extends Object?>({
    required TResult Function(ValidNameList4 valid) valid,
    required TResult Function(InvalidNameList4 invalid) invalid,
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
  NameList4 copyWith(KtList<Name> Function(KtList<Name> list) callback) {
    return mapValidity(
      valid: (valid) => _create(callback(valid.list)),
      invalid: (invalid) => _create(callback(invalid.list)),
    );
  }
}

class ValidNameList4 extends NameList4 implements ValidEntity {
  const ValidNameList4._({
    required this.list,
  }) : super._();

  final KtList<ValidName> list;

  @override
  TResult maybeMap<TResult extends Object?>({
    required TResult Function(ValidNameList4 valid) valid,
    TResult Function(InvalidNameList4Size invalidSize)? invalidSize,
    TResult Function(InvalidNameList4Content invalidContent)? invalidContent,
    TResult Function(InvalidNameList4General invalidGeneral)? invalidGeneral,
    required TResult Function(InvalidNameList4 invalid) orElse,
  }) {
    return valid(this);
  }

  @override
  List<Object?> get allProps => [
        list,
      ];
}

abstract class InvalidNameList4 extends NameList4 implements InvalidEntity {
  const InvalidNameList4._() : super._();

  KtList<Name> get list;

  @override
  Failure get failure => whenInvalid(
        sizeFailure: (sizeFailure) => sizeFailure,
        contentFailure: (contentFailure) => contentFailure,
        generalFailure: (generalFailure) => generalFailure,
      );

  /// Pattern matching for the "specific" invalid union-cases of this "base"
  /// invalid union-case, which are :
  /// - [InvalidEntitySize]
  /// - [InvalidEntityContent]
  /// - [InvalidEntityGeneral]
  TResult mapInvalid<TResult extends Object?>({
    required TResult Function(InvalidNameList4Size invalidSize) invalidSize,
    required TResult Function(InvalidNameList4Content invalidContent)
        invalidContent,
    required TResult Function(InvalidNameList4General invalidGeneral)
        invalidGeneral,
  }) {
    return maybeMap(
      valid: (valid) => throw UnreachableError(),
      invalidSize: invalidSize,
      invalidContent: invalidContent,
      invalidGeneral: invalidGeneral,
      orElse: (invalid) => throw UnreachableError(),
    );
  }

  /// Similar to [mapInvalid], but the union-cases are replaced by the failures
  /// they hold.
  TResult whenInvalid<TResult extends Object?>({
    required TResult Function(NameList4SizeFailure sizeFailure) sizeFailure,
    required TResult Function(Failure contentFailure) contentFailure,
    required TResult Function(NameList4GeneralFailure generalFailure)
        generalFailure,
  }) {
    return maybeMap(
      valid: (valid) => throw UnreachableError(),
      invalidSize: (invalidSize) => sizeFailure(invalidSize.sizeFailure),
      invalidContent: (invalidContent) =>
          contentFailure(invalidContent.contentFailure),
      invalidGeneral: (invalidGeneral) =>
          generalFailure(invalidGeneral.generalFailure),
      orElse: (invalid) => throw UnreachableError(),
    );
  }
}

class InvalidNameList4Size extends InvalidNameList4
    implements InvalidEntitySize<NameList4SizeFailure> {
  const InvalidNameList4Size._({
    required this.sizeFailure,
    required this.list,
  }) : super._();

  @override
  final NameList4SizeFailure sizeFailure;

  @override
  final KtList<Name> list;

  @override
  TResult maybeMap<TResult extends Object?>({
    required TResult Function(ValidNameList4 valid) valid,
    TResult Function(InvalidNameList4Size invalidSize)? invalidSize,
    TResult Function(InvalidNameList4Content invalidContent)? invalidContent,
    TResult Function(InvalidNameList4General invalidGeneral)? invalidGeneral,
    required TResult Function(InvalidNameList4 invalid) orElse,
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

class InvalidNameList4Content extends InvalidNameList4
    implements InvalidEntityContent {
  const InvalidNameList4Content._({
    required this.contentFailure,
    required this.list,
  }) : super._();

  @override
  final Failure contentFailure;

  @override
  final KtList<Name> list;

  @override
  TResult maybeMap<TResult extends Object?>({
    required TResult Function(ValidNameList4 valid) valid,
    TResult Function(InvalidNameList4Size invalidSize)? invalidSize,
    TResult Function(InvalidNameList4Content invalidContent)? invalidContent,
    TResult Function(InvalidNameList4General invalidGeneral)? invalidGeneral,
    required TResult Function(InvalidNameList4 invalid) orElse,
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

class InvalidNameList4General extends InvalidNameList4
    implements InvalidEntityGeneral<NameList4GeneralFailure> {
  const InvalidNameList4General._({
    required this.generalFailure,
    required this.list,
  }) : super._();

  @override
  final NameList4GeneralFailure generalFailure;

  @override
  final KtList<ValidName> list;

  @override
  TResult maybeMap<TResult extends Object?>({
    required TResult Function(ValidNameList4 valid) valid,
    TResult Function(InvalidNameList4Size invalidSize)? invalidSize,
    TResult Function(InvalidNameList4Content invalidContent)? invalidContent,
    TResult Function(InvalidNameList4General invalidGeneral)? invalidGeneral,
    required TResult Function(InvalidNameList4 invalid) orElse,
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
