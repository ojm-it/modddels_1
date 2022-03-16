// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of '_1_single_value_object.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$ValidId1TearOff {
  const _$ValidId1TearOff();

  _ValidId1 call(String value) {
    return _ValidId1(
      value,
    );
  }
}

/// @nodoc
const $ValidId1 = _$ValidId1TearOff();

/// @nodoc
mixin _$ValidId1 {
  String get value => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ValidId1CopyWith<ValidId1> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ValidId1CopyWith<$Res> {
  factory $ValidId1CopyWith(ValidId1 value, $Res Function(ValidId1) then) =
      _$ValidId1CopyWithImpl<$Res>;
  $Res call({String value});
}

/// @nodoc
class _$ValidId1CopyWithImpl<$Res> implements $ValidId1CopyWith<$Res> {
  _$ValidId1CopyWithImpl(this._value, this._then);

  final ValidId1 _value;
  // ignore: unused_field
  final $Res Function(ValidId1) _then;

  @override
  $Res call({
    Object? value = freezed,
  }) {
    return _then(_value.copyWith(
      value: value == freezed
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$ValidId1CopyWith<$Res> implements $ValidId1CopyWith<$Res> {
  factory _$ValidId1CopyWith(_ValidId1 value, $Res Function(_ValidId1) then) =
      __$ValidId1CopyWithImpl<$Res>;
  @override
  $Res call({String value});
}

/// @nodoc
class __$ValidId1CopyWithImpl<$Res> extends _$ValidId1CopyWithImpl<$Res>
    implements _$ValidId1CopyWith<$Res> {
  __$ValidId1CopyWithImpl(_ValidId1 _value, $Res Function(_ValidId1) _then)
      : super(_value, (v) => _then(v as _ValidId1));

  @override
  _ValidId1 get _value => super._value as _ValidId1;

  @override
  $Res call({
    Object? value = freezed,
  }) {
    return _then(_ValidId1(
      value == freezed
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_ValidId1 implements _ValidId1 {
  const _$_ValidId1(this.value);

  @override
  final String value;

  @override
  String toString() {
    return 'ValidId1(value: $value)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ValidId1 &&
            const DeepCollectionEquality().equals(other.value, value));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(value));

  @JsonKey(ignore: true)
  @override
  _$ValidId1CopyWith<_ValidId1> get copyWith =>
      __$ValidId1CopyWithImpl<_ValidId1>(this, _$identity);
}

abstract class _ValidId1 implements ValidId1 {
  const factory _ValidId1(String value) = _$_ValidId1;

  @override
  String get value;
  @override
  @JsonKey(ignore: true)
  _$ValidId1CopyWith<_ValidId1> get copyWith =>
      throw _privateConstructorUsedError;
}
