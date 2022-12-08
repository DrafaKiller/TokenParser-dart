import 'package:token_parser/src/error.dart';
import 'package:token_parser/src/internal/extension.dart';
import 'package:token_parser/src/lexemes/pattern.dart';
import 'package:token_parser/src/token.dart';

class CharacterLexeme extends PatternLexeme {
  CharacterLexeme(super.pattern, { super.name, super.grammar });
  CharacterLexeme.any({ super.name, super.grammar }) : super(empty());

  @override
  Token tokenize(String string, [ int start = 0 ]) {
    DebugGrammar.debug(this, string, start);

    if (start > string.length - 1) {
      throw LexicalSyntaxError(this, string, start);
    }
    pattern.tokenizeFrom(this, string, start);
    return Token(this, string, start, start + 1);
  }

  @override String get regexString => '(?=${ pattern.lexeme().regexString }).';
}
