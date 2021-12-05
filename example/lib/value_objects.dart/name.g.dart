// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'name.dart';

// **************************************************************************
// ModddelGenerator
// **************************************************************************

mixin $Name {
  static Name _create(String input) {
    return const Name._().validateWithResult(input).match(
          (l) => InvalidName._(failure: l),
          (r) => ValidName._(value: r),
        );
  }

  static Either<Failure, ValidName?> toBroadEitherNullable(
          Name? nullableValueObject) =>
      optionOf(nullableValueObject)
          .match((t) => t.toBroadEither, () => right(null));

  TResult map<TResult extends Object?>({
    required TResult Function(ValidName valid) valid,
    required TResult Function(InvalidName invalid) invalid,
  }) {
    throw UnimplementedError();
  }

  TResult mapValidity<TResult extends Object?>({
    required TResult Function(ValidName valid) valid,
    required TResult Function(InvalidName invalid) invalid,
  }) {
    return map(
      valid: valid,
      invalid: invalid,
    );
  }
}

class ValidName extends Name implements ValidValueObject<String> {
  const ValidName._({required this.value}) : super._();

  @override
  final String value;

  @override
  TResult map<TResult extends Object?>(
      {required TResult Function(ValidName valid) valid,
      required TResult Function(InvalidName invalid) invalid}) {
    return valid(this);
  }

  @override
  List<Object?> get allProps => [value];
}

class InvalidName extends Name
    implements InvalidValueObject<String, NameValueFailure> {
  const InvalidName._({
    required this.failure,
  }) : super._();

  @override
  final NameValueFailure failure;

  @override
  TResult map<TResult extends Object?>(
      {required TResult Function(ValidName valid) valid,
      required TResult Function(InvalidName invalid) invalid}) {
    return invalid(this);
  }

  @override
  List<Object?> get allProps => [failure];
}
