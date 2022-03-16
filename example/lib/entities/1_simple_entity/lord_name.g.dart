// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lord_name.dart';

// **************************************************************************
// ModddelGenerator
// **************************************************************************

// ignore_for_file: prefer_void_to_null

mixin $LordName {
  static LordName _create({
    required Name parentName,
    required Name firstName,
    required bool isLord,
  }) {
    /// 1. **Content Validation**
    return _verifyContent(
      parentName: parentName,
      firstName: firstName,
      isLord: isLord,
    ).match(
      (contentFailure) => InvalidLordNameContent._(
        contentFailure: contentFailure,
        parentName: parentName,
        firstName: firstName,
        isLord: isLord,
      ),

      /// 2. **→ Validations passed**
      (validContent) => validContent,
    );
  }

  /// If any of the modddels is invalid, this holds its failure on the Left (the
  /// failure of the first invalid modddel encountered)
  ///
  /// Otherwise, holds all the modddels as valid modddels, wrapped inside a
  /// ValidEntity, on the Right.
  static Either<Failure, ValidLordName> _verifyContent({
    required Name parentName,
    required Name firstName,
    required bool isLord,
  }) {
    final contentVerification = parentName.toBroadEither.flatMap(
      (validParentName) => firstName.toBroadEither.flatMap(
        (validFirstName) => right<Failure, ValidLordName>(ValidLordName._(
          parentName: validParentName,
          firstName: validFirstName,
          isLord: isLord,
        )),
      ),
    );

    return contentVerification;
  }

  Name get parentName => map(
        valid: (valid) => valid.parentName,
        invalidContent: (invalidContent) => invalidContent.parentName,
      );

  Name get firstName => map(
        valid: (valid) => valid.firstName,
        invalidContent: (invalidContent) => invalidContent.firstName,
      );

  bool get isLord => map(
        valid: (valid) => valid.isLord,
        invalidContent: (invalidContent) => invalidContent.isLord,
      );

  /// If [nullableEntity] is null, returns `right(null)`.
  /// Otherwise, returns `nullableEntity.toBroadEither`
  static Either<Failure, ValidLordName?> toBroadEitherNullable(
          LordName? nullableEntity) =>
      optionOf(nullableEntity).match((t) => t.toBroadEither, () => right(null));

  /// Same as [mapValidity] (because there is only one invalid union-case)
  TResult map<TResult extends Object?>({
    required TResult Function(ValidLordName valid) valid,
    required TResult Function(InvalidLordNameContent invalidContent)
        invalidContent,
  }) {
    throw UnimplementedError();
  }

  /// Pattern matching for the two different union-cases of this entity : valid
  /// and invalid.
  TResult mapValidity<TResult extends Object?>({
    required TResult Function(ValidLordName valid) valid,
    required TResult Function(InvalidLordNameContent invalidContent) invalid,
  }) {
    return map(
      valid: valid,
      invalidContent: invalid,
    );
  }

  /// Creates a clone of this entity with the new specified values.
  ///
  /// The resulting entity is totally independent from this entity. It is
  /// validated upon creation, and can be either valid or invalid.
  LordName copyWith({
    Name? parentName,
    Name? firstName,
    bool? isLord,
  }) {
    return map(
      valid: (valid) => _create(
        parentName: parentName ?? valid.parentName,
        firstName: firstName ?? valid.firstName,
        isLord: isLord ?? valid.isLord,
      ),
      invalidContent: (invalidContent) => _create(
        parentName: parentName ?? invalidContent.parentName,
        firstName: firstName ?? invalidContent.firstName,
        isLord: isLord ?? invalidContent.isLord,
      ),
    );
  }

  List<Object?> get props => throw UnimplementedError();

  StringifyMode get stringifyMode => StringifyMode.always;
}

class ValidLordName extends LordName implements ValidEntity {
  const ValidLordName._({
    required this.parentName,
    required this.firstName,
    required this.isLord,
  }) : super._();

  @override
  final ValidName parentName;
  @override
  final ValidName firstName;
  @override
  final bool isLord;

  @override
  TResult map<TResult extends Object?>({
    required TResult Function(ValidLordName valid) valid,
    required TResult Function(InvalidLordNameContent invalidContent)
        invalidContent,
  }) {
    return valid(this);
  }

  @override
  List<Object?> get props => [
        parentName,
        firstName,
        isLord,
      ];
}

class InvalidLordNameContent extends LordName implements InvalidEntityContent {
  const InvalidLordNameContent._({
    required this.contentFailure,
    required this.parentName,
    required this.firstName,
    required this.isLord,
  }) : super._();

  @override
  final Failure contentFailure;

  @override
  Failure get failure => contentFailure;

  @override
  final Name parentName;
  @override
  final Name firstName;
  @override
  final bool isLord;

  @override
  TResult map<TResult extends Object?>({
    required TResult Function(ValidLordName valid) valid,
    required TResult Function(InvalidLordNameContent invalidContent)
        invalidContent,
  }) {
    return invalidContent(this);
  }

  @override
  List<Object?> get props => [
        contentFailure,
        parentName,
        firstName,
        isLord,
      ];
}

class LordNameTester extends SimpleEntityTester<InvalidLordNameContent,
    ValidLordName, LordName, _LordNameInput> {
  const LordNameTester({
    int maxSutDescriptionLength = 100,
    String isSanitizedGroupDescription = 'Should be sanitized',
    String isNotSanitizedGroupDescription = 'Should not be sanitized',
    String isValidGroupDescription = 'Should be a ValidLordName',
    String isInvalidContentGroupDescription =
        'Should be an InvalidLordNameContent and hold the proper contentFailure',
  }) : super(
          maxSutDescriptionLength: maxSutDescriptionLength,
          isSanitizedGroupDescription: isSanitizedGroupDescription,
          isNotSanitizedGroupDescription: isNotSanitizedGroupDescription,
          isValidGroupDescription: isValidGroupDescription,
          isInvalidContentGroupDescription: isInvalidContentGroupDescription,
        );

  final makeInput = _LordNameInput.new;
}

class _LordNameInput extends ModddelInput<LordName> {
  const _LordNameInput({
    required this.parentName,
    required this.firstName,
    this.isLord = true,
  });

  final Name parentName;
  final Name firstName;
  final bool isLord;
  @override
  List<Object?> get props => [
        parentName,
        firstName,
        isLord,
      ];

  @override
  _LordNameInput get sanitizedInput {
    final modddel = LordName(
      parentName: parentName,
      firstName: firstName,
      isLord: isLord,
    );

    return _LordNameInput(
      parentName: modddel.parentName,
      firstName: modddel.firstName,
      isLord: modddel.isLord,
    );
  }
}
