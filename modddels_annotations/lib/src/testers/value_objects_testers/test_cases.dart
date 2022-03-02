import 'package:modddels_annotations/modddels_annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modddels_annotations/src/testers/test_case.dart';

/// This is a [TestCase] for testing that given the [input], the [ValueObject]
/// holds as a value [sanitizedValue].
class TestIsSanitized<T> extends TestCase {
  TestIsSanitized(
    this.input,
    this.sanitizedValue, {
    this.customDescription,
    this.testOn,
    this.timeout,
    this.skip,
    this.tags,
    this.onPlatform,
    this.retry,
  });

  final T input;

  final T sanitizedValue;

  @override
  final CustomDescription? customDescription;

  @override
  final Map<String, dynamic>? onPlatform;

  @override
  final int? retry;

  @override
  final dynamic skip;

  @override
  final dynamic tags;

  @override
  final String? testOn;

  @override
  final Timeout? timeout;
}

/// This is a [TestCase] for testing that given the [input], the [ValueObject]
/// holds the same [input] as a value.
class TestIsNotSanitized<T> extends TestCase {
  TestIsNotSanitized(
    this.input, {
    this.customDescription,
    this.testOn,
    this.timeout,
    this.skip,
    this.tags,
    this.onPlatform,
    this.retry,
  });

  final T input;

  @override
  final CustomDescription? customDescription;

  @override
  final Map<String, dynamic>? onPlatform;

  @override
  final int? retry;

  @override
  final dynamic skip;

  @override
  final dynamic tags;

  @override
  final String? testOn;

  @override
  final Timeout? timeout;
}

/// This is a [TestCase] for testing that given the [input], the [ValueObject]
/// is valid.
class TestIsValidValue<T> extends TestCase {
  TestIsValidValue(
    this.input, {
    this.customDescription,
    this.testOn,
    this.timeout,
    this.skip,
    this.tags,
    this.onPlatform,
    this.retry,
  });

  final T input;

  @override
  final CustomDescription? customDescription;

  @override
  final Map<String, dynamic>? onPlatform;

  @override
  final int? retry;

  @override
  final dynamic skip;

  @override
  final dynamic tags;

  @override
  final String? testOn;

  @override
  final Timeout? timeout;
}

/// This is a [TestCase] for testing that given the [input], the [ValueObject]
/// is invalid and holds the [valueFailure].
class TestIsInvalidValue<T, F extends ValueFailure<T>> extends TestCase {
  TestIsInvalidValue(
    this.input,
    this.valueFailure, {
    this.customDescription,
    this.testOn,
    this.timeout,
    this.skip,
    this.tags,
    this.onPlatform,
    this.retry,
  });

  final T input;

  final F valueFailure;

  @override
  final CustomDescription? customDescription;

  @override
  final Map<String, dynamic>? onPlatform;

  @override
  final int? retry;

  @override
  final dynamic skip;

  @override
  final dynamic tags;

  @override
  final String? testOn;

  @override
  final Timeout? timeout;
}
