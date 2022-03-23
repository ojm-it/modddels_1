// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: prefer_void_to_null

part of 'contact_list.dart';

// **************************************************************************
// ModddelGenerator
// **************************************************************************

mixin $ContactList {
  static ContactList _create(
    KtList<Name> list,
  ) {
    /// 1. **Content validation**
    return _verifyContent(list).match(
      (contentFailure) => InvalidContactListContent._(
        contentFailure: contentFailure,
        list: list,
      ),

      /// 2. **→ Validations passed**
      (validContent) => ValidContactList._(list: validContent),
    );
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

  KtList<Name> get list => map(
        valid: (valid) => valid.list,
        invalidContent: (invalidContent) => invalidContent.list,
      );

  /// The size of the list
  int get size => list.size;

  /// If [nullableEntity] is null, returns `right(null)`.
  /// Otherwise, returns `nullableEntity.toBroadEither`.
  static Either<Failure, ValidContactList?> toBroadEitherNullable(
          ContactList? nullableEntity) =>
      optionOf(nullableEntity).match((t) => t.toBroadEither, () => right(null));

  /// Same as [mapValidity] (because there is only one invalid union-case)
  TResult map<TResult extends Object?>({
    required TResult Function(ValidContactList valid) valid,
    required TResult Function(InvalidContactListContent invalidContent)
        invalidContent,
  }) {
    throw UnimplementedError();
  }

  /// Pattern matching for the two different union-cases of this entity : valid
  /// and invalid.
  TResult mapValidity<TResult extends Object?>({
    required TResult Function(ValidContactList valid) valid,
    required TResult Function(InvalidContactListContent invalidContent) invalid,
  }) {
    return map(
      valid: valid,
      invalidContent: invalid,
    );
  }

  /// Creates a clone of this entity with the list returned from [callback].
  ///
  /// The resulting entity is totally independent from this entity. It is
  /// validated upon creation, and can be either valid or invalid.
  ContactList copyWith(KtList<Name> Function(KtList<Name> list) callback) {
    return _create(callback(list));
  }

  List<Object?> get props => throw UnimplementedError();

  StringifyMode get stringifyMode => StringifyMode.always;
}

class ValidContactList extends ContactList implements ValidEntity {
  const ValidContactList._({
    required this.list,
  }) : super._();

  @override
  final KtList<ValidName> list;

  @override
  TResult map<TResult extends Object?>({
    required TResult Function(ValidContactList valid) valid,
    required TResult Function(InvalidContactListContent invalidContent)
        invalidContent,
  }) {
    return valid(this);
  }

  @override
  List<Object?> get props => [
        list,
      ];
}

class InvalidContactListContent extends ContactList
    implements InvalidEntityContent {
  const InvalidContactListContent._({
    required this.contentFailure,
    required this.list,
  }) : super._();

  @override
  final Failure contentFailure;

  @override
  Failure get failure => contentFailure;

  @override
  final KtList<Name> list;

  @override
  TResult map<TResult extends Object?>({
    required TResult Function(ValidContactList valid) valid,
    required TResult Function(InvalidContactListContent invalidContent)
        invalidContent,
  }) {
    return invalidContent(this);
  }

  @override
  List<Object?> get props => [
        contentFailure,
        list,
      ];
}

class ContactListTester extends ListEntityTester<InvalidContactListContent,
    ValidContactList, ContactList, _ContactListInput> {
  const ContactListTester({
    int maxSutDescriptionLength = 100,
    String isSanitizedGroupDescription = 'Should be sanitized',
    String isNotSanitizedGroupDescription = 'Should not be sanitized',
    String isValidGroupDescription = 'Should be a ValidContactList',
    String isInvalidContentGroupDescription =
        'Should be an InvalidContactListContent and hold the proper contentFailure',
  }) : super(
          maxSutDescriptionLength: maxSutDescriptionLength,
          isSanitizedGroupDescription: isSanitizedGroupDescription,
          isNotSanitizedGroupDescription: isNotSanitizedGroupDescription,
          isValidGroupDescription: isValidGroupDescription,
          isInvalidContentGroupDescription: isInvalidContentGroupDescription,
        );

  final makeInput = _ContactListInput.new;
}

class _ContactListInput extends ModddelInput<ContactList> {
  const _ContactListInput(this.list);

  final KtList<Name> list;

  @override
  List<Object?> get props => [list];

  @override
  _ContactListInput get sanitizedInput {
    final modddel = ContactList(list);

    return _ContactListInput(modddel.list);
  }
}
