import 'package:modddels_annotations/modddels.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modddels_annotations/src/testers/common.dart';

/// This is a [TestCase] for testing that the [sut] (which is an entity) is
/// valid.
class TestIsValidEntity<E> extends TestCase {
  TestIsValidEntity(
    this.sut, {
    this.customDescription,
    this.testOn,
    this.timeout,
    this.skip,
    this.tags,
    this.onPlatform,
    this.retry,
  });

  final E sut;

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

/// This is a [TestCase] for testing that the [sut] (which is an entity) is
/// an [InvalidEntityContent] and holds the [contentFailure].
class TestIsInvalidContent<E> extends TestCase {
  TestIsInvalidContent(
    this.sut,
    this.contentFailure, {
    this.customDescription,
    this.testOn,
    this.timeout,
    this.skip,
    this.tags,
    this.onPlatform,
    this.retry,
  });

  final E sut;

  final Failure contentFailure;

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

/// This is a [TestCase] for testing that the [sut] (which is an entity) is
/// an [InvalidEntityGeneral] and holds the [generalFailure].
class TestIsInvalidGeneral<E, F extends GeneralFailure> extends TestCase {
  TestIsInvalidGeneral(
    this.sut,
    this.generalFailure, {
    this.customDescription,
    this.testOn,
    this.timeout,
    this.skip,
    this.tags,
    this.onPlatform,
    this.retry,
  });

  final E sut;

  final F generalFailure;

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

/// This is a [TestCase] for testing that the [sut] (which is an entity) is an
/// [InvalidEntitySize] and holds the [sizeFailure].
class TestIsInvalidSize<E, F extends SizeFailure> extends TestCase {
  TestIsInvalidSize(
    this.sut,
    this.sizeFailure, {
    this.customDescription,
    this.testOn,
    this.timeout,
    this.skip,
    this.tags,
    this.onPlatform,
    this.retry,
  });

  final E sut;

  final F sizeFailure;

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
