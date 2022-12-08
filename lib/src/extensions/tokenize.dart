import 'package:token_parser/src/error.dart';
import 'package:token_parser/src/extension.dart';
import 'package:token_parser/src/lexeme.dart';
import 'package:token_parser/src/token.dart';

extension LexicalAnalysisTokenize on Pattern {
  /* -= Tokenization =- */

  Token tokenizeFrom(Lexeme lexeme, String string, [ int start = 0 ]) {
    return LexicalSyntaxError.enclose(lexeme, () => this.lexeme().tokenize(string, start));
  }

  Token? optionalTokenizeFrom(Lexeme lexeme, String string, [ int start = 0 ]) {
    try {
      return tokenizeFrom(lexeme, string, start);
    } on LexicalSyntaxError {
      Token.emptyAt(lexeme, string, start);
      return null;
    }
  }
}