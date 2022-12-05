import 'package:token_parser/src/lexeme.dart';
import 'package:token_parser/src/token.dart';

class EmptyLexeme extends Lexeme {
  @override
  Token tokenize(String string, [ int start = 0 ]) => Token.emptyAt(this, string, start);
}