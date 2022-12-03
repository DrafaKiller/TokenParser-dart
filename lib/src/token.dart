import 'package:token_parser/src/lexeme.dart';

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

  /// ## Analysis
  /// 
  /// You may use the parsed token to analyze the resulting tree,
  /// using the `.get({ Lexeme? lexeme, String? name })` method will get all the tokens that match the lexeme or name.
  /// 
  /// The reach of the search can be limited by using the `bool shallow` argument,
  /// the default is `false` when having a lexeme or name, and `true` when no search parameters are given.
  /// 
  /// ```dart
  /// final match = grammar.parse('two words');
  /// 
  /// final words = match?.get(lexeme: word);
  /// final letters = match?.get(name: 'letter');
  /// 
  /// print('Words: ${ words?.map((match) => match.value) }');
  /// print('Letters: ${ letters?.get(letter).map((match) => match.value) }');
  /// ```
  List<Token> get<T extends Lexeme>({ T? lexeme, String? name, bool? shallow }) {
    shallow ??= lexeme == null && name == null;
    return (shallow ? children : allChildren).whereType<Token>().where((child) {
      return child.lexeme is T &&
      (lexeme == null || child.lexeme == lexeme) &&
      (name == null || child.name == name);
    }
    ).toList();
  }
}
