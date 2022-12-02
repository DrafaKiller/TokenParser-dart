import 'package:token_parser/src/lexical_analysis/lexemes/pattern.dart';
import 'package:token_parser/src/lexical_analysis/token.dart';

class OptionalLexeme extends PatternLexeme {
  OptionalLexeme(super.pattern, { super.name, super.grammar });

  @override
  Token? tokenize(String string, [int start = 0]) {
    final match = pattern.matchAsPrefix(string, start);
    if (match == null) return Token.emptyAt(this, string, start);
    return Token.match(this, match);
  }

  @override String toString() => '(?:$pattern)?';
}