import 'package:token_parser/src/lexeme.dart';

abstract class ParentLexeme<PatternT extends Pattern> extends Lexeme {
  @override
  final List<PatternT> children;

  ParentLexeme(this.children, { super.name, super.grammar });
}