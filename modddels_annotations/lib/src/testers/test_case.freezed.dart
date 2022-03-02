// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'test_case.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$CustomDescriptionTearOff {
  const _$CustomDescriptionTearOff();

  _ReplaceDescription replaceDescription(String newDescription) {
    return _ReplaceDescription(
      newDescription,
    );
  }

  _AddPrefix addPrefix(String prefix) {
    return _AddPrefix(
      prefix,
    );
  }

  _AddSuffix addSuffix(String suffix) {
    return _AddSuffix(
      suffix,
    );
  }

  _AddPrefixAndSuffix addPrefixAndSuffix(String prefix, String suffix) {
    return _AddPrefixAndSuffix(
      prefix,
      suffix,
    );
  }

  _ModifyDescription modifyDescription(
      String Function(String) modifyDescription) {
    return _ModifyDescription(
      modifyDescription,
    );
  }
}

/// @nodoc
const $CustomDescription = _$CustomDescriptionTearOff();

/// @nodoc
mixin _$CustomDescription {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String newDescription) replaceDescription,
    required TResult Function(String prefix) addPrefix,
    required TResult Function(String suffix) addSuffix,
    required TResult Function(String prefix, String suffix) addPrefixAndSuffix,
    required TResult Function(String Function(String) modifyDescription)
        modifyDescription,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String newDescription)? replaceDescription,
    TResult Function(String prefix)? addPrefix,
    TResult Function(String suffix)? addSuffix,
    TResult Function(String prefix, String suffix)? addPrefixAndSuffix,
    TResult Function(String Function(String) modifyDescription)?
        modifyDescription,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String newDescription)? replaceDescription,
    TResult Function(String prefix)? addPrefix,
    TResult Function(String suffix)? addSuffix,
    TResult Function(String prefix, String suffix)? addPrefixAndSuffix,
    TResult Function(String Function(String) modifyDescription)?
        modifyDescription,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ReplaceDescription value) replaceDescription,
    required TResult Function(_AddPrefix value) addPrefix,
    required TResult Function(_AddSuffix value) addSuffix,
    required TResult Function(_AddPrefixAndSuffix value) addPrefixAndSuffix,
    required TResult Function(_ModifyDescription value) modifyDescription,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_ReplaceDescription value)? replaceDescription,
    TResult Function(_AddPrefix value)? addPrefix,
    TResult Function(_AddSuffix value)? addSuffix,
    TResult Function(_AddPrefixAndSuffix value)? addPrefixAndSuffix,
    TResult Function(_ModifyDescription value)? modifyDescription,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ReplaceDescription value)? replaceDescription,
    TResult Function(_AddPrefix value)? addPrefix,
    TResult Function(_AddSuffix value)? addSuffix,
    TResult Function(_AddPrefixAndSuffix value)? addPrefixAndSuffix,
    TResult Function(_ModifyDescription value)? modifyDescription,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomDescriptionCopyWith<$Res> {
  factory $CustomDescriptionCopyWith(
          CustomDescription value, $Res Function(CustomDescription) then) =
      _$CustomDescriptionCopyWithImpl<$Res>;
}

/// @nodoc
class _$CustomDescriptionCopyWithImpl<$Res>
    implements $CustomDescriptionCopyWith<$Res> {
  _$CustomDescriptionCopyWithImpl(this._value, this._then);

  final CustomDescription _value;
  // ignore: unused_field
  final $Res Function(CustomDescription) _then;
}

/// @nodoc
abstract class _$ReplaceDescriptionCopyWith<$Res> {
  factory _$ReplaceDescriptionCopyWith(
          _ReplaceDescription value, $Res Function(_ReplaceDescription) then) =
      __$ReplaceDescriptionCopyWithImpl<$Res>;
  $Res call({String newDescription});
}

/// @nodoc
class __$ReplaceDescriptionCopyWithImpl<$Res>
    extends _$CustomDescriptionCopyWithImpl<$Res>
    implements _$ReplaceDescriptionCopyWith<$Res> {
  __$ReplaceDescriptionCopyWithImpl(
      _ReplaceDescription _value, $Res Function(_ReplaceDescription) _then)
      : super(_value, (v) => _then(v as _ReplaceDescription));

  @override
  _ReplaceDescription get _value => super._value as _ReplaceDescription;

  @override
  $Res call({
    Object? newDescription = freezed,
  }) {
    return _then(_ReplaceDescription(
      newDescription == freezed
          ? _value.newDescription
          : newDescription // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_ReplaceDescription implements _ReplaceDescription {
  const _$_ReplaceDescription(this.newDescription);

  @override
  final String newDescription;

  @override
  String toString() {
    return 'CustomDescription.replaceDescription(newDescription: $newDescription)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ReplaceDescription &&
            const DeepCollectionEquality()
                .equals(other.newDescription, newDescription));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(newDescription));

  @JsonKey(ignore: true)
  @override
  _$ReplaceDescriptionCopyWith<_ReplaceDescription> get copyWith =>
      __$ReplaceDescriptionCopyWithImpl<_ReplaceDescription>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String newDescription) replaceDescription,
    required TResult Function(String prefix) addPrefix,
    required TResult Function(String suffix) addSuffix,
    required TResult Function(String prefix, String suffix) addPrefixAndSuffix,
    required TResult Function(String Function(String) modifyDescription)
        modifyDescription,
  }) {
    return replaceDescription(newDescription);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String newDescription)? replaceDescription,
    TResult Function(String prefix)? addPrefix,
    TResult Function(String suffix)? addSuffix,
    TResult Function(String prefix, String suffix)? addPrefixAndSuffix,
    TResult Function(String Function(String) modifyDescription)?
        modifyDescription,
  }) {
    return replaceDescription?.call(newDescription);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String newDescription)? replaceDescription,
    TResult Function(String prefix)? addPrefix,
    TResult Function(String suffix)? addSuffix,
    TResult Function(String prefix, String suffix)? addPrefixAndSuffix,
    TResult Function(String Function(String) modifyDescription)?
        modifyDescription,
    required TResult orElse(),
  }) {
    if (replaceDescription != null) {
      return replaceDescription(newDescription);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ReplaceDescription value) replaceDescription,
    required TResult Function(_AddPrefix value) addPrefix,
    required TResult Function(_AddSuffix value) addSuffix,
    required TResult Function(_AddPrefixAndSuffix value) addPrefixAndSuffix,
    required TResult Function(_ModifyDescription value) modifyDescription,
  }) {
    return replaceDescription(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_ReplaceDescription value)? replaceDescription,
    TResult Function(_AddPrefix value)? addPrefix,
    TResult Function(_AddSuffix value)? addSuffix,
    TResult Function(_AddPrefixAndSuffix value)? addPrefixAndSuffix,
    TResult Function(_ModifyDescription value)? modifyDescription,
  }) {
    return replaceDescription?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ReplaceDescription value)? replaceDescription,
    TResult Function(_AddPrefix value)? addPrefix,
    TResult Function(_AddSuffix value)? addSuffix,
    TResult Function(_AddPrefixAndSuffix value)? addPrefixAndSuffix,
    TResult Function(_ModifyDescription value)? modifyDescription,
    required TResult orElse(),
  }) {
    if (replaceDescription != null) {
      return replaceDescription(this);
    }
    return orElse();
  }
}

abstract class _ReplaceDescription implements CustomDescription {
  const factory _ReplaceDescription(String newDescription) =
      _$_ReplaceDescription;

  String get newDescription;
  @JsonKey(ignore: true)
  _$ReplaceDescriptionCopyWith<_ReplaceDescription> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$AddPrefixCopyWith<$Res> {
  factory _$AddPrefixCopyWith(
          _AddPrefix value, $Res Function(_AddPrefix) then) =
      __$AddPrefixCopyWithImpl<$Res>;
  $Res call({String prefix});
}

/// @nodoc
class __$AddPrefixCopyWithImpl<$Res>
    extends _$CustomDescriptionCopyWithImpl<$Res>
    implements _$AddPrefixCopyWith<$Res> {
  __$AddPrefixCopyWithImpl(_AddPrefix _value, $Res Function(_AddPrefix) _then)
      : super(_value, (v) => _then(v as _AddPrefix));

  @override
  _AddPrefix get _value => super._value as _AddPrefix;

  @override
  $Res call({
    Object? prefix = freezed,
  }) {
    return _then(_AddPrefix(
      prefix == freezed
          ? _value.prefix
          : prefix // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_AddPrefix implements _AddPrefix {
  const _$_AddPrefix(this.prefix);

  @override
  final String prefix;

  @override
  String toString() {
    return 'CustomDescription.addPrefix(prefix: $prefix)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AddPrefix &&
            const DeepCollectionEquality().equals(other.prefix, prefix));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(prefix));

  @JsonKey(ignore: true)
  @override
  _$AddPrefixCopyWith<_AddPrefix> get copyWith =>
      __$AddPrefixCopyWithImpl<_AddPrefix>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String newDescription) replaceDescription,
    required TResult Function(String prefix) addPrefix,
    required TResult Function(String suffix) addSuffix,
    required TResult Function(String prefix, String suffix) addPrefixAndSuffix,
    required TResult Function(String Function(String) modifyDescription)
        modifyDescription,
  }) {
    return addPrefix(prefix);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String newDescription)? replaceDescription,
    TResult Function(String prefix)? addPrefix,
    TResult Function(String suffix)? addSuffix,
    TResult Function(String prefix, String suffix)? addPrefixAndSuffix,
    TResult Function(String Function(String) modifyDescription)?
        modifyDescription,
  }) {
    return addPrefix?.call(prefix);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String newDescription)? replaceDescription,
    TResult Function(String prefix)? addPrefix,
    TResult Function(String suffix)? addSuffix,
    TResult Function(String prefix, String suffix)? addPrefixAndSuffix,
    TResult Function(String Function(String) modifyDescription)?
        modifyDescription,
    required TResult orElse(),
  }) {
    if (addPrefix != null) {
      return addPrefix(prefix);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ReplaceDescription value) replaceDescription,
    required TResult Function(_AddPrefix value) addPrefix,
    required TResult Function(_AddSuffix value) addSuffix,
    required TResult Function(_AddPrefixAndSuffix value) addPrefixAndSuffix,
    required TResult Function(_ModifyDescription value) modifyDescription,
  }) {
    return addPrefix(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_ReplaceDescription value)? replaceDescription,
    TResult Function(_AddPrefix value)? addPrefix,
    TResult Function(_AddSuffix value)? addSuffix,
    TResult Function(_AddPrefixAndSuffix value)? addPrefixAndSuffix,
    TResult Function(_ModifyDescription value)? modifyDescription,
  }) {
    return addPrefix?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ReplaceDescription value)? replaceDescription,
    TResult Function(_AddPrefix value)? addPrefix,
    TResult Function(_AddSuffix value)? addSuffix,
    TResult Function(_AddPrefixAndSuffix value)? addPrefixAndSuffix,
    TResult Function(_ModifyDescription value)? modifyDescription,
    required TResult orElse(),
  }) {
    if (addPrefix != null) {
      return addPrefix(this);
    }
    return orElse();
  }
}

abstract class _AddPrefix implements CustomDescription {
  const factory _AddPrefix(String prefix) = _$_AddPrefix;

  String get prefix;
  @JsonKey(ignore: true)
  _$AddPrefixCopyWith<_AddPrefix> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$AddSuffixCopyWith<$Res> {
  factory _$AddSuffixCopyWith(
          _AddSuffix value, $Res Function(_AddSuffix) then) =
      __$AddSuffixCopyWithImpl<$Res>;
  $Res call({String suffix});
}

/// @nodoc
class __$AddSuffixCopyWithImpl<$Res>
    extends _$CustomDescriptionCopyWithImpl<$Res>
    implements _$AddSuffixCopyWith<$Res> {
  __$AddSuffixCopyWithImpl(_AddSuffix _value, $Res Function(_AddSuffix) _then)
      : super(_value, (v) => _then(v as _AddSuffix));

  @override
  _AddSuffix get _value => super._value as _AddSuffix;

  @override
  $Res call({
    Object? suffix = freezed,
  }) {
    return _then(_AddSuffix(
      suffix == freezed
          ? _value.suffix
          : suffix // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_AddSuffix implements _AddSuffix {
  const _$_AddSuffix(this.suffix);

  @override
  final String suffix;

  @override
  String toString() {
    return 'CustomDescription.addSuffix(suffix: $suffix)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AddSuffix &&
            const DeepCollectionEquality().equals(other.suffix, suffix));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(suffix));

  @JsonKey(ignore: true)
  @override
  _$AddSuffixCopyWith<_AddSuffix> get copyWith =>
      __$AddSuffixCopyWithImpl<_AddSuffix>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String newDescription) replaceDescription,
    required TResult Function(String prefix) addPrefix,
    required TResult Function(String suffix) addSuffix,
    required TResult Function(String prefix, String suffix) addPrefixAndSuffix,
    required TResult Function(String Function(String) modifyDescription)
        modifyDescription,
  }) {
    return addSuffix(suffix);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String newDescription)? replaceDescription,
    TResult Function(String prefix)? addPrefix,
    TResult Function(String suffix)? addSuffix,
    TResult Function(String prefix, String suffix)? addPrefixAndSuffix,
    TResult Function(String Function(String) modifyDescription)?
        modifyDescription,
  }) {
    return addSuffix?.call(suffix);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String newDescription)? replaceDescription,
    TResult Function(String prefix)? addPrefix,
    TResult Function(String suffix)? addSuffix,
    TResult Function(String prefix, String suffix)? addPrefixAndSuffix,
    TResult Function(String Function(String) modifyDescription)?
        modifyDescription,
    required TResult orElse(),
  }) {
    if (addSuffix != null) {
      return addSuffix(suffix);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ReplaceDescription value) replaceDescription,
    required TResult Function(_AddPrefix value) addPrefix,
    required TResult Function(_AddSuffix value) addSuffix,
    required TResult Function(_AddPrefixAndSuffix value) addPrefixAndSuffix,
    required TResult Function(_ModifyDescription value) modifyDescription,
  }) {
    return addSuffix(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_ReplaceDescription value)? replaceDescription,
    TResult Function(_AddPrefix value)? addPrefix,
    TResult Function(_AddSuffix value)? addSuffix,
    TResult Function(_AddPrefixAndSuffix value)? addPrefixAndSuffix,
    TResult Function(_ModifyDescription value)? modifyDescription,
  }) {
    return addSuffix?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ReplaceDescription value)? replaceDescription,
    TResult Function(_AddPrefix value)? addPrefix,
    TResult Function(_AddSuffix value)? addSuffix,
    TResult Function(_AddPrefixAndSuffix value)? addPrefixAndSuffix,
    TResult Function(_ModifyDescription value)? modifyDescription,
    required TResult orElse(),
  }) {
    if (addSuffix != null) {
      return addSuffix(this);
    }
    return orElse();
  }
}

abstract class _AddSuffix implements CustomDescription {
  const factory _AddSuffix(String suffix) = _$_AddSuffix;

  String get suffix;
  @JsonKey(ignore: true)
  _$AddSuffixCopyWith<_AddSuffix> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$AddPrefixAndSuffixCopyWith<$Res> {
  factory _$AddPrefixAndSuffixCopyWith(
          _AddPrefixAndSuffix value, $Res Function(_AddPrefixAndSuffix) then) =
      __$AddPrefixAndSuffixCopyWithImpl<$Res>;
  $Res call({String prefix, String suffix});
}

/// @nodoc
class __$AddPrefixAndSuffixCopyWithImpl<$Res>
    extends _$CustomDescriptionCopyWithImpl<$Res>
    implements _$AddPrefixAndSuffixCopyWith<$Res> {
  __$AddPrefixAndSuffixCopyWithImpl(
      _AddPrefixAndSuffix _value, $Res Function(_AddPrefixAndSuffix) _then)
      : super(_value, (v) => _then(v as _AddPrefixAndSuffix));

  @override
  _AddPrefixAndSuffix get _value => super._value as _AddPrefixAndSuffix;

  @override
  $Res call({
    Object? prefix = freezed,
    Object? suffix = freezed,
  }) {
    return _then(_AddPrefixAndSuffix(
      prefix == freezed
          ? _value.prefix
          : prefix // ignore: cast_nullable_to_non_nullable
              as String,
      suffix == freezed
          ? _value.suffix
          : suffix // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_AddPrefixAndSuffix implements _AddPrefixAndSuffix {
  const _$_AddPrefixAndSuffix(this.prefix, this.suffix);

  @override
  final String prefix;
  @override
  final String suffix;

  @override
  String toString() {
    return 'CustomDescription.addPrefixAndSuffix(prefix: $prefix, suffix: $suffix)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AddPrefixAndSuffix &&
            const DeepCollectionEquality().equals(other.prefix, prefix) &&
            const DeepCollectionEquality().equals(other.suffix, suffix));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(prefix),
      const DeepCollectionEquality().hash(suffix));

  @JsonKey(ignore: true)
  @override
  _$AddPrefixAndSuffixCopyWith<_AddPrefixAndSuffix> get copyWith =>
      __$AddPrefixAndSuffixCopyWithImpl<_AddPrefixAndSuffix>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String newDescription) replaceDescription,
    required TResult Function(String prefix) addPrefix,
    required TResult Function(String suffix) addSuffix,
    required TResult Function(String prefix, String suffix) addPrefixAndSuffix,
    required TResult Function(String Function(String) modifyDescription)
        modifyDescription,
  }) {
    return addPrefixAndSuffix(prefix, suffix);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String newDescription)? replaceDescription,
    TResult Function(String prefix)? addPrefix,
    TResult Function(String suffix)? addSuffix,
    TResult Function(String prefix, String suffix)? addPrefixAndSuffix,
    TResult Function(String Function(String) modifyDescription)?
        modifyDescription,
  }) {
    return addPrefixAndSuffix?.call(prefix, suffix);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String newDescription)? replaceDescription,
    TResult Function(String prefix)? addPrefix,
    TResult Function(String suffix)? addSuffix,
    TResult Function(String prefix, String suffix)? addPrefixAndSuffix,
    TResult Function(String Function(String) modifyDescription)?
        modifyDescription,
    required TResult orElse(),
  }) {
    if (addPrefixAndSuffix != null) {
      return addPrefixAndSuffix(prefix, suffix);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ReplaceDescription value) replaceDescription,
    required TResult Function(_AddPrefix value) addPrefix,
    required TResult Function(_AddSuffix value) addSuffix,
    required TResult Function(_AddPrefixAndSuffix value) addPrefixAndSuffix,
    required TResult Function(_ModifyDescription value) modifyDescription,
  }) {
    return addPrefixAndSuffix(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_ReplaceDescription value)? replaceDescription,
    TResult Function(_AddPrefix value)? addPrefix,
    TResult Function(_AddSuffix value)? addSuffix,
    TResult Function(_AddPrefixAndSuffix value)? addPrefixAndSuffix,
    TResult Function(_ModifyDescription value)? modifyDescription,
  }) {
    return addPrefixAndSuffix?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ReplaceDescription value)? replaceDescription,
    TResult Function(_AddPrefix value)? addPrefix,
    TResult Function(_AddSuffix value)? addSuffix,
    TResult Function(_AddPrefixAndSuffix value)? addPrefixAndSuffix,
    TResult Function(_ModifyDescription value)? modifyDescription,
    required TResult orElse(),
  }) {
    if (addPrefixAndSuffix != null) {
      return addPrefixAndSuffix(this);
    }
    return orElse();
  }
}

abstract class _AddPrefixAndSuffix implements CustomDescription {
  const factory _AddPrefixAndSuffix(String prefix, String suffix) =
      _$_AddPrefixAndSuffix;

  String get prefix;
  String get suffix;
  @JsonKey(ignore: true)
  _$AddPrefixAndSuffixCopyWith<_AddPrefixAndSuffix> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$ModifyDescriptionCopyWith<$Res> {
  factory _$ModifyDescriptionCopyWith(
          _ModifyDescription value, $Res Function(_ModifyDescription) then) =
      __$ModifyDescriptionCopyWithImpl<$Res>;
  $Res call({String Function(String) modifyDescription});
}

/// @nodoc
class __$ModifyDescriptionCopyWithImpl<$Res>
    extends _$CustomDescriptionCopyWithImpl<$Res>
    implements _$ModifyDescriptionCopyWith<$Res> {
  __$ModifyDescriptionCopyWithImpl(
      _ModifyDescription _value, $Res Function(_ModifyDescription) _then)
      : super(_value, (v) => _then(v as _ModifyDescription));

  @override
  _ModifyDescription get _value => super._value as _ModifyDescription;

  @override
  $Res call({
    Object? modifyDescription = freezed,
  }) {
    return _then(_ModifyDescription(
      modifyDescription == freezed
          ? _value.modifyDescription
          : modifyDescription // ignore: cast_nullable_to_non_nullable
              as String Function(String),
    ));
  }
}

/// @nodoc

class _$_ModifyDescription implements _ModifyDescription {
  const _$_ModifyDescription(this.modifyDescription);

  @override
  final String Function(String) modifyDescription;

  @override
  String toString() {
    return 'CustomDescription.modifyDescription(modifyDescription: $modifyDescription)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ModifyDescription &&
            (identical(other.modifyDescription, modifyDescription) ||
                other.modifyDescription == modifyDescription));
  }

  @override
  int get hashCode => Object.hash(runtimeType, modifyDescription);

  @JsonKey(ignore: true)
  @override
  _$ModifyDescriptionCopyWith<_ModifyDescription> get copyWith =>
      __$ModifyDescriptionCopyWithImpl<_ModifyDescription>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String newDescription) replaceDescription,
    required TResult Function(String prefix) addPrefix,
    required TResult Function(String suffix) addSuffix,
    required TResult Function(String prefix, String suffix) addPrefixAndSuffix,
    required TResult Function(String Function(String) modifyDescription)
        modifyDescription,
  }) {
    return modifyDescription(this.modifyDescription);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String newDescription)? replaceDescription,
    TResult Function(String prefix)? addPrefix,
    TResult Function(String suffix)? addSuffix,
    TResult Function(String prefix, String suffix)? addPrefixAndSuffix,
    TResult Function(String Function(String) modifyDescription)?
        modifyDescription,
  }) {
    return modifyDescription?.call(this.modifyDescription);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String newDescription)? replaceDescription,
    TResult Function(String prefix)? addPrefix,
    TResult Function(String suffix)? addSuffix,
    TResult Function(String prefix, String suffix)? addPrefixAndSuffix,
    TResult Function(String Function(String) modifyDescription)?
        modifyDescription,
    required TResult orElse(),
  }) {
    if (modifyDescription != null) {
      return modifyDescription(this.modifyDescription);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ReplaceDescription value) replaceDescription,
    required TResult Function(_AddPrefix value) addPrefix,
    required TResult Function(_AddSuffix value) addSuffix,
    required TResult Function(_AddPrefixAndSuffix value) addPrefixAndSuffix,
    required TResult Function(_ModifyDescription value) modifyDescription,
  }) {
    return modifyDescription(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_ReplaceDescription value)? replaceDescription,
    TResult Function(_AddPrefix value)? addPrefix,
    TResult Function(_AddSuffix value)? addSuffix,
    TResult Function(_AddPrefixAndSuffix value)? addPrefixAndSuffix,
    TResult Function(_ModifyDescription value)? modifyDescription,
  }) {
    return modifyDescription?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ReplaceDescription value)? replaceDescription,
    TResult Function(_AddPrefix value)? addPrefix,
    TResult Function(_AddSuffix value)? addSuffix,
    TResult Function(_AddPrefixAndSuffix value)? addPrefixAndSuffix,
    TResult Function(_ModifyDescription value)? modifyDescription,
    required TResult orElse(),
  }) {
    if (modifyDescription != null) {
      return modifyDescription(this);
    }
    return orElse();
  }
}

abstract class _ModifyDescription implements CustomDescription {
  const factory _ModifyDescription(String Function(String) modifyDescription) =
      _$_ModifyDescription;

  String Function(String) get modifyDescription;
  @JsonKey(ignore: true)
  _$ModifyDescriptionCopyWith<_ModifyDescription> get copyWith =>
      throw _privateConstructorUsedError;
}
