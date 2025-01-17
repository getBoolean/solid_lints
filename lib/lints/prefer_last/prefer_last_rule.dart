import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:solid_lints/lints/prefer_last/prefer_last_fix.dart';
import 'package:solid_lints/lints/prefer_last/prefer_last_visitor.dart';
import 'package:solid_lints/models/rule_config.dart';
import 'package:solid_lints/models/solid_lint_rule.dart';

/// A `prefer_last` rule which warns about
/// usage of iterable[length-1] or iterable.elementAt(length-1)
class PreferLastRule extends SolidLintRule {
  /// The [LintCode] of this lint rule that represents the error if iterable
  /// access can be simplified.
  static const lintName = 'prefer_last';

  PreferLastRule._(super.config);

  /// Creates a new instance of [PreferLastRule]
  /// based on the lint configuration.
  factory PreferLastRule.createRule(CustomLintConfigs configs) {
    final config = RuleConfig(
      configs: configs,
      name: lintName,
      problemMessage: (value) =>
          'Use last instead of accessing the last element by index.',
    );

    return PreferLastRule._(config);
  }

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addCompilationUnit((node) {
      final visitor = PreferLastVisitor();
      node.accept(visitor);

      for (final element in visitor.expressions) {
        reporter.reportErrorForNode(code, element);
      }
    });
  }

  @override
  List<Fix> getFixes() => [PreferLastFix()];
}
