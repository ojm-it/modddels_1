// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:example/general_entities/fullname.dart';
import 'package:example/general_entities/fullname_list.dart';
import 'package:example/general_entities/namelist.dart';
import 'package:example/normal_entities/fullname2.dart';
import 'package:example/normal_entities/namelist2.dart';
import 'package:example/value_objects.dart/name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:example/main.dart';
import 'package:kt_dart/collection.dart';

void main() {
  // testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  //   // Build our app and trigger a frame.
  //   await tester.pumpWidget(const MyApp());

  //   // Verify that our counter starts at 0.
  //   expect(find.text('0'), findsOneWidget);
  //   expect(find.text('1'), findsNothing);

  //   // Tap the '+' icon and trigger a frame.
  //   await tester.tap(find.byIcon(Icons.add));
  //   await tester.pump();

  //   // Verify that our counter has incremented.
  //   expect(find.text('0'), findsNothing);
  //   expect(find.text('1'), findsOneWidget);
  // });

  final name1 = Name('Maman');
  final name1bis = Name('Maman');

  final name2 = Name('');
  final name2bis = Name('Omar');

  final name3 = Name('Younes');
  final name3bis = Name('Younes');

  final nameList1 = NameList2(KtList.of(name1, name2, name3));
  final nameList2 = NameList2(KtList.of(name1bis, name2bis, name3bis));

  print(nameList1);

  print(nameList2);

  print(nameList1 == nameList2);

  print('------------------');

  final nameListEmpty = NameList2(const KtList.empty());

  print(nameListEmpty);

  print(nameListEmpty.isValid);

  print('------------------');

  final lastName = Name('J.');

  final fullName1 = FullName2(firstName: name2, lastName: lastName);

  final fullName2 = FullName2(firstName: name3, lastName: lastName);

  print(fullName1);

  print(fullName2);
}
