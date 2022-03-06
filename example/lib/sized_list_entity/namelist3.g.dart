// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'namelist3.dart';

// **************************************************************************
// ModddelGenerator
// **************************************************************************

mixin $NameList3 {
  static NameList3 _create(
    KtList<Name> list,
  ) {
    /// 1. **Size validation**
    return _verifySize(list).match(
      (sizeFailure) =>
          InvalidNameList3Size._(sizeFailure: sizeFailure, list: list),

      /// 2. **Content validation**
      (validSize) => _verifyContent(validSize).match(
        (contentFailure) => InvalidNameList3Content._(
          contentFailure: contentFailure,
          list: validSize,
        ),

        /// 3. **→ Validations passed**
        (validContent) => ValidNameList3._(list: validContent),
      ),
    );
  }

  /// If the size of the list is invalid, this holds the [SizeFailure] on the
  /// Left. Otherwise, holds the list on the Right.
  static Either<NameList3SizeFailure, KtList<Name>> _verifySize(
      KtList<Name> list) {
    final sizeVerification = const NameList3._().validateSize(list.size);
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
  static Either<Failure, ValidNameList3?> toBroadEitherNullable(
          NameList3? nullableEntity) =>
      optionOf(nullableEntity).match((t) => t.toBroadEither, () => right(null));

  /// Similar to [mapValidity], but the "base" invalid union-case is replaced by
  /// the "specific" invalid union-cases of this entity :
  /// - [InvalidEntitySize]
  /// - [InvalidEntityContent]
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

  /// Equivalent to [map], but only the [valid] callback is required. It also
  /// adds an extra orElse required parameter, for fallback behavior.
  TResult maybeMap<TResult extends Object?>({
    required TResult Function(ValidNameList3 valid) valid,
    TResult Function(InvalidNameList3Size invalidSize)? invalidSize,
    TResult Function(InvalidNameList3Content invalidContent)? invalidContent,
    required TResult Function(InvalidNameList3 invalid) orElse,
  }) {
    throw UnimplementedError();
  }

  /// Pattern matching for the two different union-cases of this entity : valid
  /// and invalid.
  TResult mapValidity<TResult extends Object?>({
    required TResult Function(ValidNameList3 valid) valid,
    required TResult Function(InvalidNameList3 invalid) invalid,
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
  NameList3 copyWith(KtList<Name> Function(KtList<Name> list) callback) {
    return mapValidity(
      valid: (valid) => _create(callback(valid.list)),
      invalid: (invalid) => _create(callback(invalid.list)),
    );
  }

  List<Object?> get props => throw UnimplementedError();

  StringifyMode get stringifyMode => StringifyMode.always;
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
  List<Object?> get props => [
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

  /// Pattern matching for the "specific" invalid union-cases of this "base"
  /// invalid union-case, which are :
  /// - [InvalidEntitySize]
  /// - [InvalidEntityContent]
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

  /// Similar to [mapInvalid], but the union-cases are replaced by the failures
  /// they hold.
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
  List<Object?> get props => [
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
  List<Object?> get props => [
        contentFailure,
        list,
      ];
}

class NameList3Tester extends SizedListEntityTester<
    NameList3SizeFailure,
    InvalidNameList3Size,
    InvalidNameList3Content,
    InvalidNameList3,
    ValidNameList3,
    NameList3> {
  const NameList3Tester({
    int maxSutDescriptionLength = 100,
    String isValidGroupDescription = 'Should be a ValidNameList3',
    String isInvalidSizeGroupDescription =
        'Should be an InvalidNameList3Size and hold the NameList3SizeFailure',
    String isInvalidContentGroupDescription =
        'Should be an InvalidNameList3Content and hold the proper contentFailure',
  }) : super(
          maxSutDescriptionLength: maxSutDescriptionLength,
          isValidGroupDescription: isValidGroupDescription,
          isInvalidSizeGroupDescription: isInvalidSizeGroupDescription,
          isInvalidContentGroupDescription: isInvalidContentGroupDescription,
        );
}
