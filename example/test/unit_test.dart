import 'package:example/entities/1_simple_entity/lord_name.dart';
import 'package:example/entities/4_general_entity/fullname.dart';
import 'package:example/entities/6_sized_list_general_entity/namelist2.dart';
import 'package:example/value_objects/1_single_value_object/name.dart';
import 'package:example/value_objects/2_multi_value_objects/name.dart' as multi;
import 'package:flutter_test/flutter_test.dart';
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
  group('copyWith is working with null values', () {
    test('- SimpleEntity', () {
      final lordName = LordName(
        parentName: Name('Lord'),
        firstName: Name('Serks'),
        isLord: true,
      );

      final nullLord = lordName.copyWith(
        parentName: Name('Null lord'),
        isLord: null,
      );

      expect(
          nullLord,
          LordName(
            parentName: Name('Null lord'),
            firstName: Name('Serks'),
            isLord: null,
          ));

      final nullLord2 = nullLord.copyWith(firstName: Name('Hey'));

      expect(
          nullLord2,
          LordName(
            parentName: Name('Null lord'),
            firstName: Name('Hey'),
            isLord: null,
          ));

      final notLord =
          nullLord.copyWith(isLord: false, parentName: Name('Not lord'));

      expect(
          notLord,
          LordName(
            parentName: Name('Not lord'),
            firstName: Name('Serks'),
            isLord: false,
          ));
    });

    test('- GeneralEntity', () {
      final fullName = FullName(
        firstName: Name('Avi'),
        lastName: Name('Kaplan'),
        hasMiddleName: true,
      );

      final fullName2 = fullName.copyWith(
        firstName: Name('Null name'),
        lastName: null,
      );

      expect(
          fullName2,
          FullName(
            firstName: Name('Null name'),
            lastName: null,
            hasMiddleName: true,
          ));

      final fullName3 = fullName2.copyWith(
        firstName: Name('Hey'),
      );

      expect(
          fullName3,
          FullName(
            firstName: Name('Hey'),
            lastName: null,
            hasMiddleName: true,
          ));

      final fullName4 = fullName2.copyWith(
        lastName: Name('Hepps'),
        firstName: Name('No middleName'),
        hasMiddleName: false,
      );

      expect(
          fullName4,
          FullName(
            firstName: Name('No middleName'),
            lastName: Name('Hepps'),
            hasMiddleName: false,
          ));
    });

    test('- MultiValueObject', () {
      final name = multi.Name(
        firstName: 'Avi',
        lastName: 'Kaplan',
        hasMiddleName: true,
      );

      final name1 = name.copyWith(
        firstName: 'Heps',
        hasMiddleName: null,
      );

      expect(
        name1,
        multi.Name(
          firstName: 'Heps',
          lastName: 'Kaplan',
          hasMiddleName: null,
        ),
      );

      final name2 = name1.copyWith(firstName: 'Hey');

      expect(
        name2,
        multi.Name(
          firstName: 'Hey',
          lastName: 'Kaplan',
          hasMiddleName: null,
        ),
      );

      final name3 = name1.copyWith(
        hasMiddleName: false,
        firstName: 'Foo',
      );

      expect(
        name3,
        multi.Name(
          firstName: 'Foo',
          lastName: 'Kaplan',
          hasMiddleName: false,
        ),
      );
    });
  });

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
