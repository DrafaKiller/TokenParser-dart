import 'package:token_parser/src/lexical_analysis/lexemes/pattern.dart';
import 'package:token_parser/src/lexical_analysis/token.dart';

class FullLexeme extends PatternLexeme {
  FullLexeme(super.pattern, { super.name, super.grammar });
  
  @override
  Token? tokenize(String string, [ int start = 0 ]) {
    final match = pattern.matchAsPrefix(string, start);
    if (match == null) return null;
    if (match.start != start) return null;
    if (match.end != string.length) return null;
    return Token.match(this, match);
  }

  @override String toString() => '^$pattern\$';
}