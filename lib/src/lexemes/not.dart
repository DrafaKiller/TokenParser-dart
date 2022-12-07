import 'package:token_parser/src/internal/extension.dart';
import 'package:token_parser/src/lexemes/pattern.dart';
import 'package:token_parser/src/token.dart';

class NotLexeme extends PatternLexeme {
  NotLexeme(super.pattern, { super.name, super.grammar });

  @override
  Token tokenize(String string, [ int start = 0 ]) {
    DebugGrammar.debug(this, string, start);

    final token = pattern.optionalTokenizeFrom(this, string, start);
    if (token != null) return Token.mismatch(this, string, start);
    return Token.emptyAt(this, string, start);
  }

  @override String get regexString => '(?!$pattern)';
}
