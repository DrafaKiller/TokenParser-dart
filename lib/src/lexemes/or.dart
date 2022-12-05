import 'package:token_parser/src/internal/extension.dart';
import 'package:token_parser/src/lexeme.dart';
import 'package:token_parser/src/token.dart';
import 'package:token_parser/src/lexemes/abstract/parent.dart';
import 'package:token_parser/src/lexemes/abstract/bound.dart';

class OrLexeme extends ParentLexeme {
  final bool priorityRight;
  OrLexeme(super.children, { this.priorityRight = false, super.name, super.grammar });

  @override
  Token tokenize(String string, [ int start = 0 ]) {
    for (final child in (priorityRight ? children.reversed : children)) {
      final token = child.optionalTokenizeFrom(this, string, start);
      if (token != null) return Token.match(this, token);
    }
    return Token.mismatch(this, string, start);
  }

  @override
  String toString() => children.isNotEmpty
    ? children.length == 1
      ? children.first.toString()
      : '(?:${ children.join('|') })'
    : '';
}

class OrBoundLexeme extends OrLexeme with BoundLexeme {
  @override late final Lexeme left;
  @override late final Lexeme right;

  OrBoundLexeme(Pattern left, Pattern right, { super.priorityRight, super.name, super.grammar }) :
    super([ left, right ])
  {
    this.left = children.first;
    this.right = children.last;
  }

  @override
  Token tokenize(String string, [ int start = 0 ]) {
    if (!priorityRight) {
      final leftMatch = left.optionalTokenizeFrom(this, string, start);
      if (leftMatch != null) return Token.match(this, leftMatch);

      final rightMatch = right.optionalTokenizeFrom(this, string, start);
      if (rightMatch != null) return Token.match(this, rightMatch);
    } else {
      final rightMatch = right.optionalTokenizeFrom(this, string, start);
      if (rightMatch != null) return Token.match(this, rightMatch);

      final leftMatch = left.optionalTokenizeFrom(this, string, start);
      if (leftMatch != null) return Token.match(this, leftMatch);
    }
    return Token.mismatch(this, string, start);
  }
}