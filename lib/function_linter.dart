/// Support for doing something awesome.
///
/// More dartdocs go here.
library;

import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:function_linter/src/function_linter_base.dart';

export 'src/function_linter_base.dart';

// TODO: Export any libraries intended for clients of this package.
PluginBase createPlugin() => _MyLintsPlugin();

class _MyLintsPlugin extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs _) => [
        FunctionLinterException(),
      ];
}
