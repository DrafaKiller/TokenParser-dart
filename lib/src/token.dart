import 'package:token_parser/src/error.dart';
import 'package:token_parser/src/lexeme.dart';
import 'package:token_parser/src/tokens/match.dart';
import 'package:token_parser/src/tokens/parent.dart';

class Token<LexemeT extends Lexeme> extends Match {
  @override LexemeT pattern;
  
  @override String input;
  @override int start;
  @override int end;

  Token(this.pattern, this.input, this.start, this.end);
  
  factory Token.match(LexemeT pattern, Match match) = TokenMatch;
  factory Token.matches(LexemeT pattern, Set<Token> matches) = TokenParent;
  factory Token.emptyAt(LexemeT pattern, String string, int start) => Token(pattern, string, start, start);
  factory Token.mismatch(LexemeT pattern, String string, int start) =>
    throw LexicalSyntaxError(pattern, string, start);

  /* -= Match Methods =- */

  @override String? operator [](int group) => group == 0 ? value : null;
    
  @override String? group(int group) => this[group];
  @override List<String?> groups(List<int> groupIndices) => groupIndices.map(group).toList();
  @override int get groupCount => 0;

  /* -= Identification =- */

  LexemeT get lexeme => pattern;
  String? get name => lexeme.name;
  String get value => input.substring(start, end);
  int get length => end - start;

  /* -= Comparison =- */

  bool samePosition(Match other) =>
    start == other.start &&
    end == other.end;
    
  @override
  bool operator ==(Object other) =>
    other is Token &&
    lexeme == other.lexeme &&
    input == other.input &&
    samePosition(other);
    
  @override int get hashCode =>
    lexeme.hashCode ^
    input.hashCode ^
    start.hashCode ^
    end.hashCode;

  /* -= Analysis =- */

  Set<Token> get children => <Token>{};
  Set<Token> get allChildren => {
    ...children,
    ...children.expand((child) => child.allChildren)
  };

  Set<Token> get<T extends Lexeme>({ T? lexeme, String? name, bool? shallow }) {
    shallow ??= lexeme == null && name == null;
    return (shallow ? children : allChildren).whereType<Token>().where((child) {
      return child.lexeme is T &&
      (lexeme == null || child.lexeme == lexeme) &&
      (name == null || child.name == name);
    }
    ).toSet();
  }
}