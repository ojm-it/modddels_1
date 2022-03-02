import 'package:modddels_annotations/modddels_annotations.dart';
import 'package:modddels_annotations/src/testers/value_objects_testers/base.dart';

/// This is a Tester for unit testing a [ValueObject].
class ValueObjectTester<
    T extends Object?,
    F extends ValueFailure<T>,
    I extends InvalidValueObject<T, F>,
    V extends ValidValueObject<T>> extends BaseValueObjectTester<T, F, I, V> {
  ValueObjectTester(
    this.sutConstructor, {
    required this.maxSutDescriptionLength,
    required this.isNotSanitizedGroupDescription,
    required this.isInvalidGroupDescription,
    required this.isSanitizedGroupDescription,
    required this.isValidGroupDescription,
  });

  @override
  final String isNotSanitizedGroupDescription;

  @override
  final String isInvalidGroupDescription;

  @override
  final int maxSutDescriptionLength;

  @override
  final String isSanitizedGroupDescription;

  @override
  final String isValidGroupDescription;

  @override
  final ValueObject<T, F, I, V> Function(T input) sutConstructor;
}

/// This is a Tester for unit testing a [NullableValueObject].
class NullableValueObjectTester<
    T extends Object,
    F extends ValueFailure<T?>,
    I extends InvalidValueObject<T?, F>,
    V extends ValidValueObject<T>> extends BaseValueObjectTester<T?, F, I, V> {
  NullableValueObjectTester(
    this.sutConstructor, {
    required this.maxSutDescriptionLength,
    required this.isNotSanitizedGroupDescription,
    required this.isInvalidGroupDescription,
    required this.isSanitizedGroupDescription,
    required this.isValidGroupDescription,
  });

  @override
  final String isNotSanitizedGroupDescription;

  @override
  final String isInvalidGroupDescription;

  @override
  final int maxSutDescriptionLength;

  @override
  final String isSanitizedGroupDescription;

  @override
  final String isValidGroupDescription;

  @override
  final NullableValueObject<T, F, I, V> Function(T? input) sutConstructor;
}
