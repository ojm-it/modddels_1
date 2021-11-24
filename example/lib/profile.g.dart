// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// ModddelGenerator
// **************************************************************************

mixin _$Name {
  static Name create(String input) {
    return const Name._().validateWithResult(input).match(
          (l) => InvalidName._(failure: l),
          (r) => ValidName._(value: r),
        );
  }

  TResult match<TResult extends Object?>(
      {required TResult Function(ValidName value) valid,
      required TResult Function(InvalidName value) invalid}) {
    throw UnimplementedError();
  }
}
