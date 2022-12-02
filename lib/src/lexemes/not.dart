import 'package:token_parser/src/lexemes/pattern.dart';
import 'package:token_parser/src/token.dart';

class NotLexeme extends PatternLexeme {
  NotLexeme(super.pattern, { super.name, super.grammar });

  @override
  Token? tokenize(String string, [ int start = 0 ]) {
    final match = pattern.matchAsPrefix(string, start);
    if (match != null) return null;
    return Token.emptyAt(this, string, start);
  }

  @override String toString() => '(?!$pattern)';
}