import 'package:token_parser/src/extensions/pattern.dart';
import 'package:token_parser/src/lexeme.dart';

abstract class ParentLexeme extends Lexeme {
  @override final List<Lexeme> children;

  ParentLexeme(List<Pattern> children, { super.name, super.grammar })
    : children = children.map((child) => child.lexeme()).toList()
  {
    for (final child in this.children.whereType<Lexeme>()) {
      child.bindParent(this);
    }
  }

  @override
  bool operator ==(Object other) =>
    other is ParentLexeme &&
    super == other &&
    Object.hashAll(children) == Object.hashAll(other.children);

  @override
  int get hashCode => Object.hash(super.hashCode, Object.hashAll(children));
}
