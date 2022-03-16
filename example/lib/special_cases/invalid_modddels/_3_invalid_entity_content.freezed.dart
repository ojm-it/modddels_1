// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of '_3_invalid_entity_content.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$InvalidPersonContent1TearOff {
  const _$InvalidPersonContent1TearOff();

  _InvalidPersonContent1 call(
      {required Name firstName, required InvalidName invalidLastName}) {
    return _InvalidPersonContent1(
      firstName: firstName,
      invalidLastName: invalidLastName,
    );
  }
}

/// @nodoc
const $InvalidPersonContent1 = _$InvalidPersonContent1TearOff();

/// @nodoc
mixin _$InvalidPersonContent1 {
  Name get firstName => throw _privateConstructorUsedError;
  InvalidName get invalidLastName => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $InvalidPersonContent1CopyWith<InvalidPersonContent1> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InvalidPersonContent1CopyWith<$Res> {
  factory $InvalidPersonContent1CopyWith(InvalidPersonContent1 value,
          $Res Function(InvalidPersonContent1) then) =
      _$InvalidPersonContent1CopyWithImpl<$Res>;
  $Res call({Name firstName, InvalidName invalidLastName});
}

/// @nodoc
class _$InvalidPersonContent1CopyWithImpl<$Res>
    implements $InvalidPersonContent1CopyWith<$Res> {
  _$InvalidPersonContent1CopyWithImpl(this._value, this._then);

  final InvalidPersonContent1 _value;
  // ignore: unused_field
  final $Res Function(InvalidPersonContent1) _then;

  @override
  $Res call({
    Object? firstName = freezed,
    Object? invalidLastName = freezed,
  }) {
    return _then(_value.copyWith(
      firstName: firstName == freezed
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as Name,
      invalidLastName: invalidLastName == freezed
          ? _value.invalidLastName
          : invalidLastName // ignore: cast_nullable_to_non_nullable
              as InvalidName,
    ));
  }
}

/// @nodoc
abstract class _$InvalidPersonContent1CopyWith<$Res>
    implements $InvalidPersonContent1CopyWith<$Res> {
  factory _$InvalidPersonContent1CopyWith(_InvalidPersonContent1 value,
          $Res Function(_InvalidPersonContent1) then) =
      __$InvalidPersonContent1CopyWithImpl<$Res>;
  @override
  $Res call({Name firstName, InvalidName invalidLastName});
}

/// @nodoc
class __$InvalidPersonContent1CopyWithImpl<$Res>
    extends _$InvalidPersonContent1CopyWithImpl<$Res>
    implements _$InvalidPersonContent1CopyWith<$Res> {
  __$InvalidPersonContent1CopyWithImpl(_InvalidPersonContent1 _value,
      $Res Function(_InvalidPersonContent1) _then)
      : super(_value, (v) => _then(v as _InvalidPersonContent1));

  @override
  _InvalidPersonContent1 get _value => super._value as _InvalidPersonContent1;

  @override
  $Res call({
    Object? firstName = freezed,
    Object? invalidLastName = freezed,
  }) {
    return _then(_InvalidPersonContent1(
      firstName: firstName == freezed
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as Name,
      invalidLastName: invalidLastName == freezed
          ? _value.invalidLastName
          : invalidLastName // ignore: cast_nullable_to_non_nullable
              as InvalidName,
    ));
  }
}

/// @nodoc

class _$_InvalidPersonContent1 extends _InvalidPersonContent1 {
  const _$_InvalidPersonContent1(
      {required this.firstName, required this.invalidLastName})
      : super._();

  @override
  final Name firstName;
  @override
  final InvalidName invalidLastName;

  @override
  String toString() {
    return 'InvalidPersonContent1(firstName: $firstName, invalidLastName: $invalidLastName)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _InvalidPersonContent1 &&
            const DeepCollectionEquality().equals(other.firstName, firstName) &&
            const DeepCollectionEquality()
                .equals(other.invalidLastName, invalidLastName));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(firstName),
      const DeepCollectionEquality().hash(invalidLastName));

  @JsonKey(ignore: true)
  @override
  _$InvalidPersonContent1CopyWith<_InvalidPersonContent1> get copyWith =>
      __$InvalidPersonContent1CopyWithImpl<_InvalidPersonContent1>(
          this, _$identity);
}

abstract class _InvalidPersonContent1 extends InvalidPersonContent1 {
  const factory _InvalidPersonContent1(
      {required Name firstName,
      required InvalidName invalidLastName}) = _$_InvalidPersonContent1;
  const _InvalidPersonContent1._() : super._();

  @override
  Name get firstName;
  @override
  InvalidName get invalidLastName;
  @override
  @JsonKey(ignore: true)
  _$InvalidPersonContent1CopyWith<_InvalidPersonContent1> get copyWith =>
      throw _privateConstructorUsedError;
}
