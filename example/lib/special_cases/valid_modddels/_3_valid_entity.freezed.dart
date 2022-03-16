// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of '_3_valid_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$ValidPerson1TearOff {
  const _$ValidPerson1TearOff();

  _ValidPerson1 call(
      {required ValidFullName validFullName, required bool isOld}) {
    return _ValidPerson1(
      validFullName: validFullName,
      isOld: isOld,
    );
  }
}

/// @nodoc
const $ValidPerson1 = _$ValidPerson1TearOff();

/// @nodoc
mixin _$ValidPerson1 {
  ValidFullName get validFullName => throw _privateConstructorUsedError;
  bool get isOld => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ValidPerson1CopyWith<ValidPerson1> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ValidPerson1CopyWith<$Res> {
  factory $ValidPerson1CopyWith(
          ValidPerson1 value, $Res Function(ValidPerson1) then) =
      _$ValidPerson1CopyWithImpl<$Res>;
  $Res call({ValidFullName validFullName, bool isOld});
}

/// @nodoc
class _$ValidPerson1CopyWithImpl<$Res> implements $ValidPerson1CopyWith<$Res> {
  _$ValidPerson1CopyWithImpl(this._value, this._then);

  final ValidPerson1 _value;
  // ignore: unused_field
  final $Res Function(ValidPerson1) _then;

  @override
  $Res call({
    Object? validFullName = freezed,
    Object? isOld = freezed,
  }) {
    return _then(_value.copyWith(
      validFullName: validFullName == freezed
          ? _value.validFullName
          : validFullName // ignore: cast_nullable_to_non_nullable
              as ValidFullName,
      isOld: isOld == freezed
          ? _value.isOld
          : isOld // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$ValidPerson1CopyWith<$Res>
    implements $ValidPerson1CopyWith<$Res> {
  factory _$ValidPerson1CopyWith(
          _ValidPerson1 value, $Res Function(_ValidPerson1) then) =
      __$ValidPerson1CopyWithImpl<$Res>;
  @override
  $Res call({ValidFullName validFullName, bool isOld});
}

/// @nodoc
class __$ValidPerson1CopyWithImpl<$Res> extends _$ValidPerson1CopyWithImpl<$Res>
    implements _$ValidPerson1CopyWith<$Res> {
  __$ValidPerson1CopyWithImpl(
      _ValidPerson1 _value, $Res Function(_ValidPerson1) _then)
      : super(_value, (v) => _then(v as _ValidPerson1));

  @override
  _ValidPerson1 get _value => super._value as _ValidPerson1;

  @override
  $Res call({
    Object? validFullName = freezed,
    Object? isOld = freezed,
  }) {
    return _then(_ValidPerson1(
      validFullName: validFullName == freezed
          ? _value.validFullName
          : validFullName // ignore: cast_nullable_to_non_nullable
              as ValidFullName,
      isOld: isOld == freezed
          ? _value.isOld
          : isOld // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_ValidPerson1 implements _ValidPerson1 {
  const _$_ValidPerson1({required this.validFullName, required this.isOld});

  @override
  final ValidFullName validFullName;
  @override
  final bool isOld;

  @override
  String toString() {
    return 'ValidPerson1(validFullName: $validFullName, isOld: $isOld)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ValidPerson1 &&
            const DeepCollectionEquality()
                .equals(other.validFullName, validFullName) &&
            const DeepCollectionEquality().equals(other.isOld, isOld));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(validFullName),
      const DeepCollectionEquality().hash(isOld));

  @JsonKey(ignore: true)
  @override
  _$ValidPerson1CopyWith<_ValidPerson1> get copyWith =>
      __$ValidPerson1CopyWithImpl<_ValidPerson1>(this, _$identity);
}

abstract class _ValidPerson1 implements ValidPerson1 {
  const factory _ValidPerson1(
      {required ValidFullName validFullName,
      required bool isOld}) = _$_ValidPerson1;

  @override
  ValidFullName get validFullName;
  @override
  bool get isOld;
  @override
  @JsonKey(ignore: true)
  _$ValidPerson1CopyWith<_ValidPerson1> get copyWith =>
      throw _privateConstructorUsedError;
}
