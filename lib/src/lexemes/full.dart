import 'package:token_parser/src/debug.dart';
import 'package:token_parser/src/extension.dart';
import 'package:token_parser/src/extensions/tokenize.dart';
import 'package:token_parser/src/lexemes/pattern.dart';
import 'package:token_parser/src/token.dart';

class FullLexeme extends PatternLexeme {
  FullLexeme(super.pattern, { super.name, super.grammar });
  
  @override
  Token tokenize(String string, [ int start = 0 ]) {
    DebugGrammar.debug(this, string, start);

    final token = pattern.tokenizeFrom(this, string, start);
    if (token.start != start || token.end != string.length) {
      return Token.mismatch(this, string, token.end);
    }
    return Token.match(this, token);
  }

  @override String get regexString => '^${ pattern.lexeme().regexString }\$';
}
