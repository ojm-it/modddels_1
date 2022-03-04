import 'package:modddels_annotations/modddels.dart';
import 'package:modddels_annotations/src/testers/common.dart';
import 'package:modddels_annotations/src/testers/value_objects_testers/base.dart';

/// This is a Tester for unit testing a [ValueObject].
class ValueObjectTester<
        T extends Object?,
        F extends ValueFailure<T>,
        I extends InvalidValueObject<T, F>,
        V extends ValidValueObject<T>,
        E extends ValueObject<T, F, I, V>>
    extends BaseValueObjectTester<T, F, I, V, E> {
  /// For [maxSutDescriptionLength], see [Tester.maxSutDescriptionLength].
  const ValueObjectTester(
    this.sutConstructor, {
    required int maxSutDescriptionLength,
    required this.isNotSanitizedGroupDescription,
    required this.isInvalidGroupDescription,
    required this.isSanitizedGroupDescription,
    required this.isValidGroupDescription,
  }) : super(maxSutDescriptionLength: maxSutDescriptionLength);

  @override
  final String isNotSanitizedGroupDescription;

  @override
  final String isInvalidGroupDescription;

  @override
  final String isSanitizedGroupDescription;

  @override
  final String isValidGroupDescription;

  @override
  final E Function(T input) sutConstructor;
}

/// This is a Tester for unit testing a [NullableValueObject].
class NullableValueObjectTester<
        T extends Object,
        F extends ValueFailure<T?>,
        I extends InvalidValueObject<T?, F>,
        V extends ValidValueObject<T>,
        E extends NullableValueObject<T, F, I, V>>
    extends BaseValueObjectTester<T?, F, I, V, E> {
  /// For [maxSutDescriptionLength], see [Tester.maxSutDescriptionLength].
  const NullableValueObjectTester(
    this.sutConstructor, {
    required int maxSutDescriptionLength,
    required this.isNotSanitizedGroupDescription,
    required this.isInvalidGroupDescription,
    required this.isSanitizedGroupDescription,
    required this.isValidGroupDescription,
  }) : super(maxSutDescriptionLength: maxSutDescriptionLength);

  @override
  final String isNotSanitizedGroupDescription;

  @override
  final String isInvalidGroupDescription;

  @override
  final String isSanitizedGroupDescription;

  @override
  final String isValidGroupDescription;

  @override
  final E Function(T? input) sutConstructor;
}
