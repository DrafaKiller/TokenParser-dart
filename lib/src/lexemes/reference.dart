import 'package:token_parser/src/debug.dart';
import 'package:token_parser/src/error.dart';
import 'package:token_parser/src/lexeme.dart';
import 'package:token_parser/src/token.dart';

class ReferenceLexeme extends Lexeme {
  ReferenceLexeme(String name, { super.grammar }) : super(name: '(#$name)');

  String get lexemeName => namePattern.firstMatch(name!)!.group(1)!;
  set lexemeName(String name) => this.name = '(#$name)';
  
  Lexeme get lexeme => grammar?.lexeme(lexemeName) ?? (throw ReferenceLexemeNotFoundError(lexemeName));
  set lexeme(Lexeme token) => lexemeName = token.name ?? (throw ReferenceLexemeNotFoundError(lexemeName));
  
  @override
  Token tokenize(String string, [ int start = 0 ]) {
    DebugGrammar.debug(this, string, start);
    
    if (grammar == null) throw ReferenceLexemeUseError(lexemeName);
    return lexeme.tokenize(string, start);
  }
  
  @override String get regexString => '[#$lexemeName]';

  static final namePattern = RegExp(r'^\(#(?<name>.*)\)$');
}
