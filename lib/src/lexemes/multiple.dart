import 'package:token_parser/src/extension.dart';
import 'package:token_parser/src/lexemes/pattern.dart';
import 'package:token_parser/src/token.dart';

class MultipleLexeme extends PatternLexeme {
  final bool orNone;

  MultipleLexeme(super.pattern, { super.name, this.orNone = false, super.grammar });

  @override
  Token? tokenize(String string, [int start = 0]) {
    final matches = pattern.lexeme().allMatches(string, start);
    if (matches.isEmpty && !orNone) return null;
    return Token.matches(this, matches.toList());
  }

  @override String toString() => '(?:$pattern)*';
}