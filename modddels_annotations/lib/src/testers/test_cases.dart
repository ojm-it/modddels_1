import 'package:flutter_test/flutter_test.dart';
import 'package:modddels_annotations/src/modddels/entities/common.dart';
import 'package:modddels_annotations/src/modddels/modddel.dart';
import 'package:modddels_annotations/src/modddels/value_objects/value_object.dart';
import 'package:modddels_annotations/src/testers/core/custom_description.dart';
import 'package:modddels_annotations/src/testers/core/modddel_input.dart';
import 'package:modddels_annotations/src/testers/core/test_case.dart';

/// This is a [TestCase] for testing that given the [input], the modddel [M]
/// holds [sanitizedInput].
class TestIsSanitized<M extends Modddel, P extends ModddelInput<M>>
    extends TestCase {
  TestIsSanitized(
    this.input,
    this.sanitizedInput, {
    this.customDescription,
    this.testOn,
    this.timeout,
    this.skip,
    this.tags,
    this.onPlatform,
    this.retry,
  });

  final P input;

  final P sanitizedInput;

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

/// This is a [TestCase] for testing that given the [input], the modddel [M]
/// holds the same [input].
class TestIsNotSanitized<M extends Modddel, P extends ModddelInput<M>>
    extends TestCase {
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

  final P input;

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

/// This is a [TestCase] for testing that the [modddel] is valid.
class TestIsValid<M extends Modddel> extends TestCase {
  TestIsValid(
    this.modddel, {
    this.customDescription,
    this.testOn,
    this.timeout,
    this.skip,
    this.tags,
    this.onPlatform,
    this.retry,
  });

  final M modddel;

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

/// This is a [TestCase] for testing that the [valueObject] is an
/// [InvalidValueObject] and holds the [valueFailure].
class TestIsInvalidValue<F extends ValueFailure,
        M extends ValueObject<F, InvalidValueObject<F>, ValidValueObject>>
    extends TestCase {
  TestIsInvalidValue(
    this.valueObject,
    this.valueFailure, {
    this.customDescription,
    this.testOn,
    this.timeout,
    this.skip,
    this.tags,
    this.onPlatform,
    this.retry,
  });

  final M valueObject;

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

/// This is a [TestCase] for testing that the [entity] is an
/// [InvalidEntityContent] and holds the [contentFailure].
class TestIsInvalidContent<M extends Entity> extends TestCase {
  TestIsInvalidContent(
    this.entity,
    this.contentFailure, {
    this.customDescription,
    this.testOn,
    this.timeout,
    this.skip,
    this.tags,
    this.onPlatform,
    this.retry,
  });

  final M entity;

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

/// This is a [TestCase] for testing that the [entity] is an
/// [InvalidEntityGeneral] and holds the [generalFailure].
class TestIsInvalidGeneral<F extends GeneralFailure, M extends Entity>
    extends TestCase {
  TestIsInvalidGeneral(
    this.entity,
    this.generalFailure, {
    this.customDescription,
    this.testOn,
    this.timeout,
    this.skip,
    this.tags,
    this.onPlatform,
    this.retry,
  });

  final M entity;

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

/// This is a [TestCase] for testing that the [entity] is an [InvalidEntitySize]
/// and holds the [sizeFailure].
class TestIsInvalidSize<F extends SizeFailure, M extends Entity>
    extends TestCase {
  TestIsInvalidSize(
    this.entity,
    this.sizeFailure, {
    this.customDescription,
    this.testOn,
    this.timeout,
    this.skip,
    this.tags,
    this.onPlatform,
    this.retry,
  });

  final M entity;

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
