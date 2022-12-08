import 'package:token_parser/src/internal/extension.dart';
import 'package:token_parser/src/lexeme.dart';
import 'package:token_parser/src/lexemes/abstract/parent.dart';
import 'package:token_parser/src/token.dart';

class UntilLexeme extends ParentLexeme {
  UntilLexeme(Pattern pattern, Pattern until, { super.name, super.grammar }) :
    super([ pattern, until ]);

  Lexeme get pattern => children[0];
  Lexeme get until => children[1];

  @override
  Token tokenize(String string, [ int start = 0 ]) {
    DebugGrammar.debug(this, string, start);

    final tokens = <Token>{};
    while (until.optionalTokenizeFrom(this, string, start) == null) {
      final token = pattern.tokenizeFrom(this, string, start);
      tokens.add(token);
      start = token.end;
    }
    if (tokens.isEmpty) return Token.mismatch(this, string, start);
    return Token.matches(this, tokens);
  }

  @override String get regexString => '${ pattern.regexString }[^${until.regexString}]*';
}
