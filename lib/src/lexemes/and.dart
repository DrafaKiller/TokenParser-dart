import 'package:token_parser/src/internal/extension.dart';
import 'package:token_parser/src/token.dart';
import 'package:token_parser/src/lexemes/abstract/parent.dart';
import 'package:token_parser/src/lexemes/abstract/bound.dart';

class AndLexeme extends ParentLexeme {
  AndLexeme(super.children, { super.name, super.grammar });

  @override
  Token tokenize(String string, [ int start = 0 ]) {
    DebugGrammar.debug(this, string, start);
    
    final tokens = <Token>{};
    int index = start;
    for (final child in children) {
      final token = child.tokenizeFrom(this, string, index);
      tokens.add(token);
      index = token.end;
    }
    return Token.matches(this, tokens);
  }

  @override
  String get regexString => children.isNotEmpty
    ? children.length == 1
      ? children.first.toString()
      : '(?:${children.map((token) => token.regexString).join('')})'
    : '';
}

class AndBoundLexeme extends AndLexeme with BoundLexeme {
  AndBoundLexeme(Pattern left, Pattern right, { super.name, super.grammar }) :
    super([ left, right ]);

  @override
  Token tokenize(String string, [ int start = 0 ]) {
    DebugGrammar.debug(this, string, start);

    final leftToken = left.tokenizeFrom(this, string, start);
    final rightToken = right.tokenizeFrom(this, string, leftToken.end);
    return Token.matches(this, { leftToken, rightToken });
  }
}
