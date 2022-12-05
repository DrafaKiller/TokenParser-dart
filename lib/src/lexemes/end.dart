import 'package:token_parser/src/lexeme.dart';
import 'package:token_parser/src/token.dart';

class EndLexeme extends Lexeme {
  @override
  Token tokenize(String string, [int start = 0]) {
    if (start != string.length) return Token.mismatch(this, string, start);
    return Token.emptyAt(this, string, start);
  }

  @override String toString() => '\$';
}