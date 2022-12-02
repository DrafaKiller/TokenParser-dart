import 'package:token_parser/src/lexical_analysis/lexeme.dart';
import 'package:token_parser/src/lexical_analysis/token.dart';

class EmptyLexeme extends Lexeme {
  @override
  Token? tokenize(String string, [int start = 0]) => Token.emptyAt(this, string, start);
}