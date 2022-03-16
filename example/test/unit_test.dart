import 'package:example/entities/4_general_entity/fullname.dart';
import 'package:example/entities/6_sized_list_general_entity/namelist2.dart';
import 'package:example/value_objects/1_single_value_object/name.dart';
import 'package:kt_dart/collection.dart';
import 'package:modddels_annotations/modddels_annotations.dart';

const validName1 = 'John';
const validName2 = 'Avi';

final validNameList = NameList2(KtList.from([
  Name(validName1),
  Name(validName2),
]));

final invalidNameListGeneral = NameList2(KtList.from([
  Name('anonymous'),
  Name('John'),
]));

final invalidNameListContent = NameList2(KtList.from([
  Name(''),
  Name(validName1),
  Name(validName2),
]));

final validFullName =
    FullName(firstName: Name(validName1), lastName: Name(validName2));

final invalidFullNameContent =
    FullName(firstName: Name(validName1), lastName: Name(''));

void main() {
  /* -------------------------------------------------------------------------- */
  /*                               Testing `Name`                               */
  /* -------------------------------------------------------------------------- */

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

  /* -------------------------------------------------------------------------- */
  /*                             Testing `NameList2`                            */
  /* -------------------------------------------------------------------------- */

  const nameList2Tester = NameList2Tester();

  nameList2Tester.makeIsValidTestGroup(tests: [
    TestIsValid(validNameList),
    TestIsValid(
      validNameList,
      customDescription: const CustomDescription.addSuffix('⚠️'),
    ),
  ]);

  nameList2Tester.makeIsInvalidSizeTestGroup(tests: [
    TestIsInvalidSize(
        NameList2(const KtList.empty()), const NameList2SizeFailure.empty()),
  ]);

  nameList2Tester.makeIsInvalidGeneralTestGroup(tests: [
    TestIsInvalidGeneral(
        invalidNameListGeneral, const NameList2GeneralFailure.compromised()),
  ]);

  nameList2Tester.makeIsInvalidContentTestGroup(
      maxSutDescriptionLength: TesterUtils.noEllipsis,
      tests: [
        TestIsInvalidContent(
            invalidNameListContent, const NameValueFailure.empty()),
      ]);

  /* -------------------------------------------------------------------------- */
  /*                             Testing `FullName`                             */
  /* -------------------------------------------------------------------------- */

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
