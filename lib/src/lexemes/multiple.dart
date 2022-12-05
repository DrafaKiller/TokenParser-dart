import 'package:token_parser/src/debug.dart';
import 'package:token_parser/src/error.dart';
import 'package:token_parser/src/extension.dart';
import 'package:token_parser/src/lexemes/optional.dart';
import 'package:token_parser/src/lexemes/pattern.dart';
import 'package:token_parser/src/token.dart';

class MultipleLexeme extends PatternLexeme {
  MultipleLexeme(super.pattern, { super.name, super.grammar });

  @override
  Token tokenize(String string, [ int start = 0 ]) {
    DebugGrammar.debug(this, string, start);

    final tokens = LexicalSyntaxError.enclose(this, () => pattern.lexeme().allMatches(string, start));
    if (tokens.isEmpty) return Token.mismatch(this, string, start);
    return Token.matches(this, tokens);
  }

  @override String get regexString => 
    '(?:$pattern)${ parent is OptionalLexeme ? '*' : '+' }';
}
