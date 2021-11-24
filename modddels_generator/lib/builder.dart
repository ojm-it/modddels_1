// 1
import 'package:build/build.dart';
// 2
import 'package:source_gen/source_gen.dart';

// 3
import 'src/modddel_generator.dart';

// 4
Builder generateModddel(BuilderOptions options) =>
    SharedPartBuilder([ModddelGenerator()], 'modddels_generator');
