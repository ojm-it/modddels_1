import 'package:modddels_annotations/src/modddels/value_objects/value_object.dart';
import 'package:modddels_annotations/src/testers/core/modddel_input.dart';
import 'package:modddels_annotations/src/testers/core/tester.dart';
import 'package:modddels_annotations/src/testers/testers_mixins.dart';

/// This is a Tester for unit testing a [ValueObject].
class ValueObjectTester<
        F extends ValueFailure,
        I extends InvalidValueObject<F>,
        V extends ValidValueObject,
        M extends ValueObject<F, I, V>,
        P extends ModddelInput<M>> extends Tester
    with
        SanitizationTesterMixin<M, P>,
        ValidTesterMixin<I, V, M>,
        ValueTesterMixin<F, I, V, M> {
  const ValueObjectTester({
    required int maxSutDescriptionLength,
    required this.isSanitizedGroupDescription,
    required this.isNotSanitizedGroupDescription,
    required this.isValidGroupDescription,
    required this.isInvalidValueGroupDescription,
  }) : super(maxSutDescriptionLength: maxSutDescriptionLength);

  @override
  final String isInvalidValueGroupDescription;

  @override
  final String isNotSanitizedGroupDescription;

  @override
  final String isSanitizedGroupDescription;

  @override
  final String isValidGroupDescription;
}
