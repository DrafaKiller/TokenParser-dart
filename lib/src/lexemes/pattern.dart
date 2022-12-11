import 'package:token_parser/src/debug.dart';
import 'package:token_parser/src/error.dart';
import 'package:token_parser/src/lexeme.dart';
import 'package:token_parser/src/lexemes/abstract/parent.dart';
import 'package:token_parser/src/token.dart';

class PatternLexeme<PatternT extends Pattern> extends ParentLexeme {
  final PatternT pattern;

  PatternLexeme(this.pattern, { super.name, super.grammar }) :
    super(pattern is Lexeme ? [ pattern ] : []);

  @override
  Token tokenize(String string, [ int start = 0 ]) {
    DebugGrammar.debug(this, string, start);
    
    final token = LexicalSyntaxError.enclose(this, () => pattern.matchAsPrefix(string, start));
    if (token == null) throw LexicalSyntaxError(this, string, start);
    return Token.match(this, token);
  }

  /* -= Identification =- */

  @override
  String get regexString => 
    pattern is RegExp
      ? (pattern as RegExp).pattern
    : pattern is String
      ? RegExp.escape(pattern as String)
    : pattern.toString();

  /* -= Compararison =- */

  @override
  bool operator ==(Object other) => 
    other is PatternLexeme &&
    other.name == name &&
    other.pattern == pattern;

  @override
  int get hashCode => Object.hash(name, pattern);
}
