import 'package:token_parser/src/lexemes/abstracts/parent.dart';
import 'package:token_parser/src/token.dart';

class PatternLexeme<PatternT extends Pattern> extends ParentLexeme {
  final PatternT pattern;
  
  PatternLexeme(this.pattern, { super.name, super.grammar }) : super([ pattern ]);
  
  @override
  Token? tokenize(String string, [int start = 0]) {
    final match = pattern.matchAsPrefix(string, start);
    if (match == null) return null;
    return Token.match(this, match);
  }

  @override
  String toString() => 
    pattern is RegExp
      ? (pattern as RegExp).pattern
    : pattern is String
      ? RegExp.escape(pattern as String)
    : pattern.toString();
}