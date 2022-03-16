// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of '_2_multi_value_object.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$ValidUser1TearOff {
  const _$ValidUser1TearOff();

  _ValidUser1 call({required String name, required int age}) {
    return _ValidUser1(
      name: name,
      age: age,
    );
  }
}

/// @nodoc
const $ValidUser1 = _$ValidUser1TearOff();

/// @nodoc
mixin _$ValidUser1 {
  String get name => throw _privateConstructorUsedError;
  int get age => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ValidUser1CopyWith<ValidUser1> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ValidUser1CopyWith<$Res> {
  factory $ValidUser1CopyWith(
          ValidUser1 value, $Res Function(ValidUser1) then) =
      _$ValidUser1CopyWithImpl<$Res>;
  $Res call({String name, int age});
}

/// @nodoc
class _$ValidUser1CopyWithImpl<$Res> implements $ValidUser1CopyWith<$Res> {
  _$ValidUser1CopyWithImpl(this._value, this._then);

  final ValidUser1 _value;
  // ignore: unused_field
  final $Res Function(ValidUser1) _then;

  @override
  $Res call({
    Object? name = freezed,
    Object? age = freezed,
  }) {
    return _then(_value.copyWith(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      age: age == freezed
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
abstract class _$ValidUser1CopyWith<$Res> implements $ValidUser1CopyWith<$Res> {
  factory _$ValidUser1CopyWith(
          _ValidUser1 value, $Res Function(_ValidUser1) then) =
      __$ValidUser1CopyWithImpl<$Res>;
  @override
  $Res call({String name, int age});
}

/// @nodoc
class __$ValidUser1CopyWithImpl<$Res> extends _$ValidUser1CopyWithImpl<$Res>
    implements _$ValidUser1CopyWith<$Res> {
  __$ValidUser1CopyWithImpl(
      _ValidUser1 _value, $Res Function(_ValidUser1) _then)
      : super(_value, (v) => _then(v as _ValidUser1));

  @override
  _ValidUser1 get _value => super._value as _ValidUser1;

  @override
  $Res call({
    Object? name = freezed,
    Object? age = freezed,
  }) {
    return _then(_ValidUser1(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      age: age == freezed
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_ValidUser1 implements _ValidUser1 {
  const _$_ValidUser1({required this.name, required this.age});

  @override
  final String name;
  @override
  final int age;

  @override
  String toString() {
    return 'ValidUser1(name: $name, age: $age)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ValidUser1 &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality().equals(other.age, age));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(age));

  @JsonKey(ignore: true)
  @override
  _$ValidUser1CopyWith<_ValidUser1> get copyWith =>
      __$ValidUser1CopyWithImpl<_ValidUser1>(this, _$identity);
}

abstract class _ValidUser1 implements ValidUser1 {
  const factory _ValidUser1({required String name, required int age}) =
      _$_ValidUser1;

  @override
  String get name;
  @override
  int get age;
  @override
  @JsonKey(ignore: true)
  _$ValidUser1CopyWith<_ValidUser1> get copyWith =>
      throw _privateConstructorUsedError;
}
