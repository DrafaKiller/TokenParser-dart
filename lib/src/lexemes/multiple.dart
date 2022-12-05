import 'package:token_parser/src/error.dart';
import 'package:token_parser/src/extension.dart';
import 'package:token_parser/src/lexemes/pattern.dart';
import 'package:token_parser/src/token.dart';

class MultipleLexeme extends PatternLexeme {
  final bool orNone;

  MultipleLexeme(super.pattern, { this.orNone = false, super.name, super.grammar });

  @override
  Token tokenize(String string, [ int start = 0 ]) {
    final tokens = LexicalSyntaxError.enclose(this, () => pattern.lexeme().allMatches(string, start));
    if (tokens.isEmpty && !orNone) return Token.mismatch(this, string, start);
    return Token.matches(this, tokens);
  }

  @override String toString() => '(?:$pattern)*';
}