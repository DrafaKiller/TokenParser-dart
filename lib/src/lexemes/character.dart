import 'package:token_parser/src/error.dart';
import 'package:token_parser/src/internal/extension.dart';
import 'package:token_parser/src/lexemes/pattern.dart';
import 'package:token_parser/src/token.dart';

class CharacterLexeme extends PatternLexeme {
  final bool not;
  CharacterLexeme(super.pattern, { this.not = false, super.name, super.grammar });

  @override
  Token tokenize(String string, [ int start = 0 ]) {
    if (start >= string.length - 1) throw LexicalSyntaxError(this, string, start);
    if (not) {
      final token = pattern.optionalTokenizeFrom(this, string, start);
      if (token != null) throw LexicalSyntaxError(this, string, start);
    } else {
      pattern.tokenizeFrom(this, string, start);
    }
    return Token(this, string, start, start + 1);
  }
}