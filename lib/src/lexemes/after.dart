import 'package:token_parser/src/lexemes/pattern.dart';
import 'package:token_parser/src/token.dart';

class AfterLexeme extends PatternLexeme {
  final bool not;
  AfterLexeme(Pattern pattern, { String? name, this.not = false, super.grammar }) : super(pattern, name: name);

  @override
  Token? tokenize(String string, [int start = 0]) {
    final match = pattern.matchAsPrefix(string, start);

    if (not) {
      if (match != null) return null;
      return Token.emptyAt(this, string, start);
    }
    
    if (match == null) return null;
    return Token.emptyAt(this, string, match.end);
  }

  @override
  String toString() => '(?${ not ? '!' : '=' }$pattern)';
}