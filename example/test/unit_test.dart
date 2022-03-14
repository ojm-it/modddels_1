import 'package:example/general_entities/fullname.dart';
import 'package:example/sized_list_general_entity/namelist4.dart';
import 'package:example/value_objects.dart/name.dart';
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
  const nameTester = NameTester();
  final input = nameTester.makeInput;

  nameTester.makeIsValidTestGroup(
    tests: [
      TestIsValid(Name(validName1)),
      TestIsValid(Name(validName2)),
    ],
  );

  nameTester.makeIsInvalidValueTestGroup(
    tests: [
      TestIsInvalidValue(Name(''), const NameValueFailure.empty()),
    ],
  );

  nameTester.makeIsSanitizedTestGroup(
    tests: [
      TestIsSanitized(input(' Josh'), input('Josh')),
    ],
  );

  const nameList4Tester = NameList4Tester();

  nameList4Tester.makeIsValidTestGroup(tests: [
    TestIsValid(validNameList),
    TestIsValid(
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
        TestIsInvalidContent(
            invalidNameListContent, const NameValueFailure.empty()),
      ]);

  const fullNameTester = FullNameTester();

  fullNameTester.makeIsValidTestGroup(
    tests: [
      TestIsValid(validFullName),
    ],
  );

  fullNameTester.makeIsInvalidContentTestGroup(
    tests: [
      TestIsInvalidContent(
        invalidFullNameContent,
        const NameValueFailure.empty(),
      ),
    ],
  );
}
