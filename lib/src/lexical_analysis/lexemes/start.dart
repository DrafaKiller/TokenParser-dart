import 'package:token_parser/src/lexical_analysis/lexeme.dart';
import 'package:token_parser/src/lexical_analysis/token.dart';

class StartLexeme extends Lexeme {
  @override
  Token? tokenize(String string, [int start = 0]) {
    if (start != 0) return null;
    return Token.emptyAt(this, string, start);
  }

  @override String toString() => '^';
}