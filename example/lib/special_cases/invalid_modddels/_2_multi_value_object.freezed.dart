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
class _$InvalidBook1TearOff {
  const _$InvalidBook1TearOff();

  _InvalidBook1 call(
      {required BookValueFailure valueFailure,
      required String title,
      required String author,
      dynamic required}) {
    return _InvalidBook1(
      valueFailure: valueFailure,
      title: title,
      author: author,
      required: required,
    );
  }
}

/// @nodoc
const $InvalidBook1 = _$InvalidBook1TearOff();

/// @nodoc
mixin _$InvalidBook1 {
  BookValueFailure get valueFailure => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get author => throw _privateConstructorUsedError;
  dynamic get required => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $InvalidBook1CopyWith<InvalidBook1> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InvalidBook1CopyWith<$Res> {
  factory $InvalidBook1CopyWith(
          InvalidBook1 value, $Res Function(InvalidBook1) then) =
      _$InvalidBook1CopyWithImpl<$Res>;
  $Res call(
      {BookValueFailure valueFailure,
      String title,
      String author,
      dynamic required});

  $BookValueFailureCopyWith<$Res> get valueFailure;
}

/// @nodoc
class _$InvalidBook1CopyWithImpl<$Res> implements $InvalidBook1CopyWith<$Res> {
  _$InvalidBook1CopyWithImpl(this._value, this._then);

  final InvalidBook1 _value;
  // ignore: unused_field
  final $Res Function(InvalidBook1) _then;

  @override
  $Res call({
    Object? valueFailure = freezed,
    Object? title = freezed,
    Object? author = freezed,
    Object? required = freezed,
  }) {
    return _then(_value.copyWith(
      valueFailure: valueFailure == freezed
          ? _value.valueFailure
          : valueFailure // ignore: cast_nullable_to_non_nullable
              as BookValueFailure,
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      author: author == freezed
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String,
      required: required == freezed
          ? _value.required
          : required // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }

  @override
  $BookValueFailureCopyWith<$Res> get valueFailure {
    return $BookValueFailureCopyWith<$Res>(_value.valueFailure, (value) {
      return _then(_value.copyWith(valueFailure: value));
    });
  }
}

/// @nodoc
abstract class _$InvalidBook1CopyWith<$Res>
    implements $InvalidBook1CopyWith<$Res> {
  factory _$InvalidBook1CopyWith(
          _InvalidBook1 value, $Res Function(_InvalidBook1) then) =
      __$InvalidBook1CopyWithImpl<$Res>;
  @override
  $Res call(
      {BookValueFailure valueFailure,
      String title,
      String author,
      dynamic required});

  @override
  $BookValueFailureCopyWith<$Res> get valueFailure;
}

/// @nodoc
class __$InvalidBook1CopyWithImpl<$Res> extends _$InvalidBook1CopyWithImpl<$Res>
    implements _$InvalidBook1CopyWith<$Res> {
  __$InvalidBook1CopyWithImpl(
      _InvalidBook1 _value, $Res Function(_InvalidBook1) _then)
      : super(_value, (v) => _then(v as _InvalidBook1));

  @override
  _InvalidBook1 get _value => super._value as _InvalidBook1;

  @override
  $Res call({
    Object? valueFailure = freezed,
    Object? title = freezed,
    Object? author = freezed,
    Object? required = freezed,
  }) {
    return _then(_InvalidBook1(
      valueFailure: valueFailure == freezed
          ? _value.valueFailure
          : valueFailure // ignore: cast_nullable_to_non_nullable
              as BookValueFailure,
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      author: author == freezed
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String,
      required: required == freezed ? _value.required : required,
    ));
  }
}

/// @nodoc

class _$_InvalidBook1 extends _InvalidBook1 {
  const _$_InvalidBook1(
      {required this.valueFailure,
      required this.title,
      required this.author,
      this.required})
      : super._();

  @override
  final BookValueFailure valueFailure;
  @override
  final String title;
  @override
  final String author;
  @override
  final dynamic required;

  @override
  String toString() {
    return 'InvalidBook1(valueFailure: $valueFailure, title: $title, author: $author, required: $required)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _InvalidBook1 &&
            const DeepCollectionEquality()
                .equals(other.valueFailure, valueFailure) &&
            const DeepCollectionEquality().equals(other.title, title) &&
            const DeepCollectionEquality().equals(other.author, author) &&
            const DeepCollectionEquality().equals(other.required, required));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(valueFailure),
      const DeepCollectionEquality().hash(title),
      const DeepCollectionEquality().hash(author),
      const DeepCollectionEquality().hash(required));

  @JsonKey(ignore: true)
  @override
  _$InvalidBook1CopyWith<_InvalidBook1> get copyWith =>
      __$InvalidBook1CopyWithImpl<_InvalidBook1>(this, _$identity);
}

abstract class _InvalidBook1 extends InvalidBook1 {
  const factory _InvalidBook1(
      {required BookValueFailure valueFailure,
      required String title,
      required String author,
      dynamic required}) = _$_InvalidBook1;
  const _InvalidBook1._() : super._();

  @override
  BookValueFailure get valueFailure;
  @override
  String get title;
  @override
  String get author;
  @override
  dynamic get required;
  @override
  @JsonKey(ignore: true)
  _$InvalidBook1CopyWith<_InvalidBook1> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
class _$BookValueFailureTearOff {
  const _$BookValueFailureTearOff();

  _Invalid invalid() {
    return const _Invalid();
  }
}

/// @nodoc
const $BookValueFailure = _$BookValueFailureTearOff();

/// @nodoc
mixin _$BookValueFailure {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() invalid,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? invalid,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? invalid,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Invalid value) invalid,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_Invalid value)? invalid,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Invalid value)? invalid,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookValueFailureCopyWith<$Res> {
  factory $BookValueFailureCopyWith(
          BookValueFailure value, $Res Function(BookValueFailure) then) =
      _$BookValueFailureCopyWithImpl<$Res>;
}

/// @nodoc
class _$BookValueFailureCopyWithImpl<$Res>
    implements $BookValueFailureCopyWith<$Res> {
  _$BookValueFailureCopyWithImpl(this._value, this._then);

  final BookValueFailure _value;
  // ignore: unused_field
  final $Res Function(BookValueFailure) _then;
}

/// @nodoc
abstract class _$InvalidCopyWith<$Res> {
  factory _$InvalidCopyWith(_Invalid value, $Res Function(_Invalid) then) =
      __$InvalidCopyWithImpl<$Res>;
}

/// @nodoc
class __$InvalidCopyWithImpl<$Res> extends _$BookValueFailureCopyWithImpl<$Res>
    implements _$InvalidCopyWith<$Res> {
  __$InvalidCopyWithImpl(_Invalid _value, $Res Function(_Invalid) _then)
      : super(_value, (v) => _then(v as _Invalid));

  @override
  _Invalid get _value => super._value as _Invalid;
}

/// @nodoc

class _$_Invalid implements _Invalid {
  const _$_Invalid();

  @override
  String toString() {
    return 'BookValueFailure.invalid()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _Invalid);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() invalid,
  }) {
    return invalid();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? invalid,
  }) {
    return invalid?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? invalid,
    required TResult orElse(),
  }) {
    if (invalid != null) {
      return invalid();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Invalid value) invalid,
  }) {
    return invalid(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_Invalid value)? invalid,
  }) {
    return invalid?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Invalid value)? invalid,
    required TResult orElse(),
  }) {
    if (invalid != null) {
      return invalid(this);
    }
    return orElse();
  }
}

abstract class _Invalid implements BookValueFailure {
  const factory _Invalid() = _$_Invalid;
}
