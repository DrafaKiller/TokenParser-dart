import 'package:token_parser/src/token.dart';
import 'package:token_parser/src/lexemes/abstracts/parent.dart';
import 'package:token_parser/src/lexemes/abstracts/bound.dart';

class AndLexeme extends ParentLexeme {
  AndLexeme(super.children, { super.name, super.grammar });

  @override
  Token? tokenize(String string, [ int start = 0 ]) {
    final matches = <Match>[];
    int index = start;
    for (final child in children) {
      final match = child.matchAsPrefix(string, index);
      if (match == null) return null;
      matches.add(match);
      index = match.end;
    }
    return Token.matches(this, matches);
  }

  @override
  String toString() => children.isNotEmpty
    ? children.length == 1
      ? children.first.toString()
      : '(?:${children.join('')})'
    : '';
}

class AndBoundLexeme<
  LeftPattern extends Pattern,
  RightPattern extends Pattern
> extends AndLexeme with BoundLexeme<LeftPattern, RightPattern> {
  @override final LeftPattern left;
  @override final RightPattern right;

  AndBoundLexeme(this.left, this.right, { super.name }) : super([ left, right ]);

  @override
  Token? tokenize(String string, [ int start = 0 ]) {
    final leftMatch = left.matchAsPrefix(string, start);
    if (leftMatch == null) return null;

    final rightMatch = right.matchAsPrefix(string, leftMatch.end);
    if (rightMatch == null) return null;
    
    return Token.matches(this, [ leftMatch, rightMatch ]);
  }
}