import 'package:token_parser/src/lexical_analysis/lexeme.dart';

abstract class Token implements Match {
  @override Lexeme pattern;

  @override final String input;
  @override final int start;
  @override final int end;

  Token(this.pattern, this.input, this.start, this.end);
  factory Token.match(Lexeme pattern, Match match) = TokenMatch;
  factory Token.matches(Lexeme pattern, List<Match> matches) = TokenParent;
  factory Token.emptyAt(Lexeme pattern, String input, int index) => Token.match(pattern, ''.matchAsPrefix(input, index)!);

  @override String? operator [](int group) => this.group(group);
    
  @override String? group(int group) => this[group];
  @override List<String?> groups(List<int> groupIndices) => groupIndices.map(group).toList();
  @override int get groupCount => 0;

  /* -= Identification =- */

  Lexeme get lexeme => pattern;

  String? get name => lexeme.name;

  String get value => input.substring(start, end);

  @override
  bool operator ==(Object other) =>
    other is Token &&
    lexeme == other.lexeme &&
    input == other.input &&
    samePosition(other);
    
  @override int get hashCode => lexeme.hashCode ^ input.hashCode ^ start.hashCode ^ end.hashCode;

  bool samePosition(Match other) =>
    start == other.start &&
    end == other.end;

  /* -= Children Anaylyzing =- */

  List<Match> get children => [];
  List<Match> get allChildren => [
    ...children,
    ...children.expand((child) => child is Token ? child.allChildren : [])
  ];

  List<Token> get<T extends Lexeme>({ T? lexeme, String? name, bool shallow = false }) {
    final tokens = <Token>[];
    for (final child in (shallow ? children : allChildren).whereType<Token>()) {
      if (
        child.lexeme is T &&
        (lexeme == null || child.lexeme == lexeme) &&
        (name == null || child.name == name)
      ) {
        tokens.add(child);
      }
    }
    return tokens;
  }
}
