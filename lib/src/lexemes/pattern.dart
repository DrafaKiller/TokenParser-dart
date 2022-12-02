import 'package:token_parser/src/lexeme.dart';
import 'package:token_parser/src/token.dart';

class PatternLexeme<PatternT extends Pattern> extends Lexeme {
  final PatternT pattern;
  
  PatternLexeme(this.pattern, { super.name, super.grammar });
  
  @override
  Token? tokenize(String string, [int start = 0]) {
    final match = pattern.matchAsPrefix(string, start);
    if (match == null) return null;
    return Token.match(this, match);
  }

  @override
  List<PatternT> get children => [ pattern ];

  @override
  String toString() => 
    pattern is RegExp
      ? (pattern as RegExp).pattern
    : pattern is String
      ? RegExp.escape(pattern as String)
    : pattern.toString();
}