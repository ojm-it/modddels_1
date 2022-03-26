import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'src/modddel_generator.dart';

Builder generateModddel(BuilderOptions options) => PartBuilder(
      [ModddelGenerator()],
      '.modddel.dart',
      header: '''
      // coverage:ignore-file
      // GENERATED CODE - DO NOT MODIFY BY HAND
      // ignore_for_file: type=lint
      // ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, prefer_void_to_null
      ''',
      options: options,
    );
