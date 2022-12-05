import 'package:token_parser/src/internal/extension.dart';
import 'package:token_parser/src/lexeme.dart';

abstract class ParentLexeme extends Lexeme {
  @override final List<Lexeme> children;

  ParentLexeme(List<Pattern> children, { super.name, super.grammar })
    : children = children.map((child) => child.lexeme()).toList();

  @override
  bool operator ==(Object other) =>
    other is ParentLexeme &&
    super == other &&
    children.length == other.children.length &&
    children.fold(true, (value, child) => value && other.children.contains(child));

  @override
  int get hashCode => super.hashCode ^ children.hashCode;
}