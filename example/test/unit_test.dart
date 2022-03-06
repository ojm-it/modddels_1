import 'package:example/general_entities/fullname.dart';
import 'package:example/sized_list_general_entity/namelist4.dart';
import 'package:example/value_objects.dart/name.dart';
import 'package:example/value_objects.dart/name2.dart';
import 'package:kt_dart/collection.dart';
// import 'package:flutter_test/flutter_test.dart';
import 'package:modddels_annotations/modddels_annotations.dart';

const validName1 = 'John';
const validName2 = 'Avi';

final validNameList = NameList4(KtList.from([
  Name(validName1),
  Name(validName2),
]));

final invalidNameListGeneral = NameList4(KtList.from([
  Name('Bizarre'),
  Name('Bizarre'),
]));

final invalidNameListContent = NameList4(KtList.from([
  Name(''),
  Name(validName1),
  Name(validName2),
]));

final validFullName =
    FullName(firstName: Name(validName1), lastName: Name(validName2));

final invalidFullNameContent =
    FullName(firstName: Name(validName1), lastName: Name(''));

void main() {
  final nameTester = NameTester();

  nameTester.makeIsValidTestGroup(
    tests: [
      TestIsValidValue(validName1),
      TestIsValidValue(validName2),
    ],
  );

  nameTester.makeIsInvalidTestGroup(tests: [
    TestIsInvalidValue('', const NameValueFailure.empty(failedValue: '')),
  ]);

  final name2Tester = Name2Tester();

  name2Tester.makeIsNotSanitizedTestGroup(tests: [
    TestIsNotSanitized(null),
    TestIsNotSanitized(validName1),
  ]);

  name2Tester.makeIsInvalidTestGroup(tests: [
    TestIsInvalidValue(null, const Name2ValueFailure.none(failedValue: null)),
  ]);

  const nameList4Tester = NameList4Tester();

  nameList4Tester.makeIsValidTestGroup(tests: [
    TestIsValidEntity(validNameList),
    TestIsValidEntity(
      validNameList,
      customDescription: const CustomDescription.addSuffix('⚠️'),
    ),
  ]);

  nameList4Tester.makeIsInvalidSizeTestGroup(tests: [
    TestIsInvalidSize(
        NameList4(const KtList.empty()), const NameList4SizeFailure.empty()),
  ]);

  nameList4Tester.makeIsInvalidGeneralTestGroup(tests: [
    TestIsInvalidGeneral(
        invalidNameListGeneral, const NameList4GeneralFailure.bizarre()),
  ]);

  nameList4Tester.makeIsInvalidContentTestGroup(
      maxSutDescriptionLength: TesterUtils.noEllipsis,
      tests: [
        TestIsInvalidContent(invalidNameListContent,
            const NameValueFailure.empty(failedValue: '')),
      ]);

  const fullNameTester = FullNameTester();

  fullNameTester.makeIsValidTestGroup(
    tests: [
      TestIsValidEntity(validFullName),
    ],
  );

  fullNameTester.makeIsInvalidContentTestGroup(
    tests: [
      TestIsInvalidContent(
        invalidFullNameContent,
        const NameValueFailure.empty(failedValue: ''),
      ),
    ],
  );
}
