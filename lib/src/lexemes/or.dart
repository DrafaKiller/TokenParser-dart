import 'package:token_parser/src/lexeme.dart';
import 'package:token_parser/src/token.dart';
import 'package:token_parser/src/lexemes/abstracts/parent.dart';
import 'package:token_parser/src/lexemes/abstracts/bound.dart';

class OrLexeme extends ParentLexeme<Lexeme> {
  final bool priorityRight;
  OrLexeme(super.children, { super.name, this.priorityRight = false, super.grammar });

  @override
  Token? tokenize(String string, [ int start = 0 ]) {
    for (final child in (priorityRight ? children.reversed : children)) {
      final match = child.matchAsPrefix(string, start);
      if (match != null) return Token.match(this, match);
    }
    return null;
  }

  @override
  String toString() => children.isNotEmpty
    ? children.length == 1
      ? children.first.toString()
      : '(?:${children.join('|')})'
    : '';
}

class OrBoundLexeme<
  LeftPattern extends Pattern,
  RightPattern extends Pattern
> extends OrLexeme with BoundLexeme<LeftPattern, RightPattern> {
  @override final LeftPattern left;
  @override final RightPattern right;

  OrBoundLexeme(this.left, this.right, { super.name, super.priorityRight }) : super([ left, right ]);

  @override
  Token? tokenize(String string, [ int start = 0 ]) {
    if (!priorityRight) {
      final leftMatch = left.matchAsPrefix(string, start);
      if (leftMatch != null) return Token.match(this, leftMatch);

      final rightMatch = right.matchAsPrefix(string, start);
      if (rightMatch != null) return Token.match(this, rightMatch);
    } else {
      final rightMatch = right.matchAsPrefix(string, start);
      if (rightMatch != null) return Token.match(this, rightMatch);

      final leftMatch = left.matchAsPrefix(string, start);
      if (leftMatch != null) return Token.match(this, leftMatch);
    }
    return null;
  }
}