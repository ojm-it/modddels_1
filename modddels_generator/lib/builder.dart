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
      // ignore_for_file: prefer_void_to_null
      ''',
      options: options,
    );
