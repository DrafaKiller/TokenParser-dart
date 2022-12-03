import 'package:token_parser/src/lexeme.dart';
import 'package:token_parser/src/lexemes/pattern.dart';
import 'package:token_parser/src/utils/type.dart';

abstract class ParentLexeme<PatternT extends Pattern> extends Lexeme {
  @override
  final List<PatternT> children;

  ParentLexeme(List<Pattern> children, { super.name, super.grammar }) :
    children = isSubType<PatternT, Lexeme>()
      ? children.map((child) => PatternLexeme(child) as PatternT).toList()
      : children.cast<PatternT>();

  @override
  bool operator ==(Object other) =>
    other is ParentLexeme &&
    super == other &&
    children.length == other.children.length &&
    children.fold(true, (value, child) => value && other.children.contains(child));

  @override
  int get hashCode => super.hashCode ^ children.hashCode;
}