import 'package:token_parser/src/internal/extension.dart';
import 'package:token_parser/src/lexemes/pattern.dart';
import 'package:token_parser/src/token.dart';

class RepeatLexeme extends PatternLexeme {
  final int min;
  final int? max;

  RepeatLexeme(super.pattern, this.min, { this.max, super.name, super.grammar });

  @override
  Token tokenize(String string, [ int start = 0 ]) {
    DebugGrammar.debug(this, string, start);

    final tokens = <Token>{};
    while (tokens.length < min || (max != null && tokens.length < max! && start < string.length)) {
      final token = pattern.tokenizeFrom(this, string, start);
      tokens.add(token);
      start = token.end;
    }
    return Token.matches(this, tokens);
  }

  @override String get regexString => '(?:${ pattern.lexeme().regexString }){$min,${ max ?? '' }}';
}
