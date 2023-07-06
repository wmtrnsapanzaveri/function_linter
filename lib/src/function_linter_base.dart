import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

// This is the entrypoint of our custom linter
class FunctionLinterException extends DartLintRule {
  const FunctionLinterException() : super(code: _code);

  /// Metadata about the warning that will show-up in the IDE.
  /// This is used for `// ignore: code` and enabling/disabling the lint
  static const _code = LintCode(
    errorSeverity: ErrorSeverity.WARNING,
    correctionMessage: "Please declare the function outside the build method",
    name: 'prefer-extracting-callbacks',
    problemMessage:
    'Prefer extracting the callback to a separate widget method.',
  );

  bool _isNotIgnored(Expression argument) {
    return !(argument is! NamedExpression);
  }
  
  
  bool _hasNotEmptyBlockBody(FunctionExpression expression) {
    final body = expression.body;
    if (body is! BlockFunctionBody) {
      return false;
    }

    return body.block.statements.isNotEmpty;
  }

  bool isWidgetOrSubclass(DartType? type) =>
      _isWidget(type) || _isSubclassOfWidget(type);

  bool _isWidget(DartType? type) =>
      type?.getDisplayString(withNullability: false) == 'Widget';

  bool _isSubclassOfWidget(DartType? type) =>
      type is InterfaceType && type.allSupertypes.any(_isWidget);

  bool _isFlutterBuilder(FunctionExpression expression) {
    if (!isWidgetOrSubclass(expression.declaredElement?.returnType)) {
      return false;
    }
    bool isBuildContext(DartType? type) =>
        type?.getDisplayString(withNullability: false) == 'BuildContext';
    final formalParameters = expression.parameters?.parameters;

    return formalParameters == null ||
        formalParameters.isNotEmpty &&
            isBuildContext(formalParameters.first.declaredElement?.type);
  }

  // bool _isLongEnough(Expression expression) {
  //   final allowedLineCount = 1;
  //   // if (allowedLineCount == null) {
  //   //   return true;
  //   // }
  //
  //   // final visitor = SourceCodeVisitor(_lineInfo);
  //   // expression.visitChildren(visitor);
  //
  //   return true;
  // }

  @override
  void run(
      CustomLintResolver resolver,
      ErrorReporter reporter,
      CustomLintContext context,
      ) {
    context.registry.addInstanceCreationExpression((node) {
      for (final argument in node.argumentList.arguments) {
        final expression =
        argument is NamedExpression ? argument.expression : argument;

        //
        // if (_isNotIgnored(argument) &&
        //     expression is FunctionExpression &&
        //     _hasNotEmptyBlockBody(expression) &&
        //     !_isFlutterBuilder(expression) &&
        //     _isLongEnough(expression)) {
        //   reporter.reportErrorForNode(code, node);
        // }

        if (_isNotIgnored(argument) &&
            expression is FunctionExpression &&
            _hasNotEmptyBlockBody(expression) &&
            !_isFlutterBuilder(expression)) {
          reporter.reportErrorForNode(code, node);
        }
      }
    });

    // Our lint will highlight all variable declarations with our custom warning.
    // context.registry.addVariableDeclaration((node) {
    //   // "node" exposes metadata about the variable declaration. We could
    //   // check "node" to show the lint only in some conditions.
    //   node.
    //   // This line tells custom_lint to render a waring at the location of "node".
    //   // And the warning shown will use our `code` variable defined above as description.
    //   reporter.reportErrorForNode(code, node);
    // });
  }


// @override
// List<Fix> getFixes() => [_MyCustomLintCodeFix()];
}


