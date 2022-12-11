import 'package:token_parser/src/debug.dart';
import 'package:token_parser/src/extension.dart';
import 'package:token_parser/src/extensions/tokenize.dart';
import 'package:token_parser/src/lexeme.dart';
import 'package:token_parser/src/lexemes/pattern.dart';
import 'package:token_parser/src/token.dart';

class GlobalLexeme extends PatternLexeme {
  final Lexeme matcher;

  GlobalLexeme(super.pattern, { super.name, super.grammar })
    : matcher = (pattern.lexeme() | any()).multiple;

  @override
  Set<Token> allMatches(String string, [ int start = 0 ]) =>
    tokenize(string, start).get(lexeme: pattern.lexeme());

  @override
  Token tokenize(String string, [ int start = 0 ]) {
    DebugGrammar.debug(this, string, start);

    final token = matcher.tokenizeFrom(this, string, start);
    return Token.match(this, token);
  }

  @override String get regexString => '(?:($pattern)|.)';
}
