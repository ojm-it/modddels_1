import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'src/modddel_generator.dart';

Builder generateModddel(BuilderOptions options) =>
    SharedPartBuilder([ModddelGenerator()], 'modddels_generator');
