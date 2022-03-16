// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'namelist2.dart';

// **************************************************************************
// ModddelGenerator
// **************************************************************************

mixin $NameList2 {
  static NameList2 _create(
    KtList<Name> list,
  ) {
    /// 1. **Size validation**
    return _verifySize(list).match(
      (sizeFailure) =>
          InvalidNameList2Size._(sizeFailure: sizeFailure, list: list),

      /// 2. **Content validation**
      (validSize) => _verifyContent(validSize).match(
        (contentFailure) => InvalidNameList2Content._(
          contentFailure: contentFailure,
          list: validSize,
        ),

        /// 3. **General validation**
        (validContent) => _verifyGeneral(validContent).match(
            (generalFailure) => InvalidNameList2General._(
                  generalFailure: generalFailure,
                  list: validContent,
                ),

            /// 4. **→ Validations passed**
            (validGeneral) => ValidNameList2._(list: validGeneral)),
      ),
    );
  }

  /// If the size of the list is invalid, this holds the [SizeFailure] on the
  /// Left. Otherwise, holds the list on the Right.
  static Either<NameList2SizeFailure, KtList<Name>> _verifySize(
      KtList<Name> list) {
    final sizeVerification = const NameList2._().validateSize(list.size);
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
  static Either<NameList2GeneralFailure, KtList<ValidName>> _verifyGeneral(
      KtList<ValidName> validList) {
    final generalVerification =
        const NameList2._().validateGeneral(ValidNameList2._(list: validList));
    return generalVerification.toEither(() => validList).swap();
  }

  /// The size of the list
  int get size => mapValidity(
        valid: (valid) => valid.list.size,
        invalid: (invalid) => invalid.list.size,
      );

  /// If [nullableEntity] is null, returns `right(null)`.
  /// Otherwise, returns `nullableEntity.toBroadEither`
  static Either<Failure, ValidNameList2?> toBroadEitherNullable(
          NameList2? nullableEntity) =>
      optionOf(nullableEntity).match((t) => t.toBroadEither, () => right(null));

  /// Similar to [mapValidity], but the "base" invalid union-case is replaced by
  /// the "specific" invalid union-cases of this entity :
  /// - [InvalidEntitySize]
  /// - [InvalidEntityContent]
  /// - [InvalidEntityGeneral]
  TResult map<TResult extends Object?>({
    required TResult Function(ValidNameList2 valid) valid,
    required TResult Function(InvalidNameList2Size invalidSize) invalidSize,
    required TResult Function(InvalidNameList2Content invalidContent)
        invalidContent,
    required TResult Function(InvalidNameList2General invalidGeneral)
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
    required TResult Function(ValidNameList2 valid) valid,
    TResult Function(InvalidNameList2Size invalidSize)? invalidSize,
    TResult Function(InvalidNameList2Content invalidContent)? invalidContent,
    TResult Function(InvalidNameList2General invalidGeneral)? invalidGeneral,
    required TResult Function(InvalidNameList2 invalid) orElse,
  }) {
    throw UnimplementedError();
  }

  /// Pattern matching for the two different union-cases of this entity : valid
  /// and invalid.
  TResult mapValidity<TResult extends Object?>({
    required TResult Function(ValidNameList2 valid) valid,
    required TResult Function(InvalidNameList2 invalid) invalid,
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
  NameList2 copyWith(KtList<Name> Function(KtList<Name> list) callback) {
    return mapValidity(
      valid: (valid) => _create(callback(valid.list)),
      invalid: (invalid) => _create(callback(invalid.list)),
    );
  }

  List<Object?> get props => throw UnimplementedError();

  StringifyMode get stringifyMode => StringifyMode.always;
}

class ValidNameList2 extends NameList2 implements ValidEntity {
  const ValidNameList2._({
    required this.list,
  }) : super._();

  final KtList<ValidName> list;

  @override
  TResult maybeMap<TResult extends Object?>({
    required TResult Function(ValidNameList2 valid) valid,
    TResult Function(InvalidNameList2Size invalidSize)? invalidSize,
    TResult Function(InvalidNameList2Content invalidContent)? invalidContent,
    TResult Function(InvalidNameList2General invalidGeneral)? invalidGeneral,
    required TResult Function(InvalidNameList2 invalid) orElse,
  }) {
    return valid(this);
  }

  @override
  List<Object?> get props => [
        list,
      ];
}

abstract class InvalidNameList2 extends NameList2 implements InvalidEntity {
  const InvalidNameList2._() : super._();

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
    required TResult Function(InvalidNameList2Size invalidSize) invalidSize,
    required TResult Function(InvalidNameList2Content invalidContent)
        invalidContent,
    required TResult Function(InvalidNameList2General invalidGeneral)
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
    required TResult Function(NameList2SizeFailure sizeFailure) sizeFailure,
    required TResult Function(Failure contentFailure) contentFailure,
    required TResult Function(NameList2GeneralFailure generalFailure)
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

class InvalidNameList2Size extends InvalidNameList2
    implements InvalidEntitySize<NameList2SizeFailure> {
  const InvalidNameList2Size._({
    required this.sizeFailure,
    required this.list,
  }) : super._();

  @override
  final NameList2SizeFailure sizeFailure;

  @override
  final KtList<Name> list;

  @override
  TResult maybeMap<TResult extends Object?>({
    required TResult Function(ValidNameList2 valid) valid,
    TResult Function(InvalidNameList2Size invalidSize)? invalidSize,
    TResult Function(InvalidNameList2Content invalidContent)? invalidContent,
    TResult Function(InvalidNameList2General invalidGeneral)? invalidGeneral,
    required TResult Function(InvalidNameList2 invalid) orElse,
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

class InvalidNameList2Content extends InvalidNameList2
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
  TResult maybeMap<TResult extends Object?>({
    required TResult Function(ValidNameList2 valid) valid,
    TResult Function(InvalidNameList2Size invalidSize)? invalidSize,
    TResult Function(InvalidNameList2Content invalidContent)? invalidContent,
    TResult Function(InvalidNameList2General invalidGeneral)? invalidGeneral,
    required TResult Function(InvalidNameList2 invalid) orElse,
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

class InvalidNameList2General extends InvalidNameList2
    implements InvalidEntityGeneral<NameList2GeneralFailure> {
  const InvalidNameList2General._({
    required this.generalFailure,
    required this.list,
  }) : super._();

  @override
  final NameList2GeneralFailure generalFailure;

  @override
  final KtList<ValidName> list;

  @override
  TResult maybeMap<TResult extends Object?>({
    required TResult Function(ValidNameList2 valid) valid,
    TResult Function(InvalidNameList2Size invalidSize)? invalidSize,
    TResult Function(InvalidNameList2Content invalidContent)? invalidContent,
    TResult Function(InvalidNameList2General invalidGeneral)? invalidGeneral,
    required TResult Function(InvalidNameList2 invalid) orElse,
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

class NameList2Tester extends SizedListGeneralEntityTester<
    NameList2SizeFailure,
    NameList2GeneralFailure,
    InvalidNameList2Size,
    InvalidNameList2Content,
    InvalidNameList2General,
    InvalidNameList2,
    ValidNameList2,
    NameList2,
    _NameList2Input> {
  const NameList2Tester({
    int maxSutDescriptionLength = 100,
    String isSanitizedGroupDescription = 'Should be sanitized',
    String isNotSanitizedGroupDescription = 'Should not be sanitized',
    String isValidGroupDescription = 'Should be a ValidNameList2',
    String isInvalidSizeGroupDescription =
        'Should be an InvalidNameList2Size and hold the NameList2SizeFailure',
    String isInvalidContentGroupDescription =
        'Should be an InvalidNameList2Content and hold the proper contentFailure',
    String isInvalidGeneralGroupDescription =
        'Should be an InvalidNameList2General and hold the NameList2GeneralFailure',
  }) : super(
          maxSutDescriptionLength: maxSutDescriptionLength,
          isSanitizedGroupDescription: isSanitizedGroupDescription,
          isNotSanitizedGroupDescription: isNotSanitizedGroupDescription,
          isValidGroupDescription: isValidGroupDescription,
          isInvalidSizeGroupDescription: isInvalidSizeGroupDescription,
          isInvalidContentGroupDescription: isInvalidContentGroupDescription,
          isInvalidGeneralGroupDescription: isInvalidGeneralGroupDescription,
        );

  final makeInput = _NameList2Input.new;
}

class _NameList2Input extends ModddelInput<NameList2> {
  const _NameList2Input(this.list);

  final KtList<Name> list;

  @override
  List<Object?> get props => [list];

  @override
  _NameList2Input get sanitizedInput {
    final modddel = NameList2(list);
    final modddelList =
        modddel.mapValidity(valid: (v) => v.list, invalid: (i) => i.list);

    return _NameList2Input(modddelList);
  }
}
