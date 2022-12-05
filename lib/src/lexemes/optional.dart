import 'package:token_parser/src/internal/extension.dart';
import 'package:token_parser/src/lexemes/pattern.dart';
import 'package:token_parser/src/token.dart';

class OptionalLexeme extends PatternLexeme {
  OptionalLexeme(super.pattern, { super.name, super.grammar });

  @override
  Token tokenize(String string, [int start = 0]) {
    final token = pattern.optionalTokenizeFrom(this, string, start);
    if (token == null) return Token.emptyAt(this, string, start);
    return Token.match(this, token);
  }

  @override String toString() => '(?:$pattern)?';
}