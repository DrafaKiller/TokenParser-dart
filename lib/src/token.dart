import 'package:token_parser/tokens.dart';
import 'package:token_parser/src/match.dart';

abstract class Token extends Pattern {
  String? name;
  Token({ this.name });

  /* -= Relation Methods =- */

  @override
  bool operator ==(Object other) {
    if (other is Token) {
      if (name != null || other.name != null) return name == other.name;
    }
    return hashCode == other.hashCode;
  }
  
  @override
  int get hashCode => name.hashCode;

  /* -= Pattern Methods =- */
  
  @override
  Iterable<TokenMatch> allMatches(String string, [ int start = 0 ]) {
    final match = matchAsPrefix(string, start);
    return [ if (match != null) match ];
  }

  @override
  TokenMatch? matchAsPrefix(String string, [ int start = 0 ]) => match(string, start);
  TokenMatch? match(String string, [ int start = 0 ]);

  /* -= Alternative Tokens - Factories =- */

  factory Token.pattern(Pattern pattern, { String? name }) = PatternToken;
  factory Token.string(String string, { String? name }) = PatternToken;
  factory Token.regex(String string, { String? name }) => PatternToken.regex(string, name: name);
  
  factory Token.and(Pattern left, Pattern right, { String? name }) = AndToken;
  factory Token.or(Pattern left, Pattern right, { String? name }) = OrToken;
  factory Token.not(Pattern token, { String? name }) = NotToken;

  factory Token.multiple(Pattern token, { String? name, bool orNone }) = MultipleToken;
  factory Token.optional(Pattern token, { String? name }) = OptionalToken;

  factory Token.empty() = EmptyToken;
  factory Token.full(Pattern token, { String? name }) = FullToken;

  factory Token.start() = StartToken;
  factory Token.end() = EndToken;

  factory Token.reference(String name) = ReferenceToken;
  factory Token.ref(String name) = ReferenceToken;
  factory Token.self() = SelfToken;
  
  /* -= Alternative Tokens - Methods =- */

  Token and(Token token) => Token.and(this, token);
  Token or(Token token) => Token.or(this, token);
  Token get not => Token.not(this);

  Token get multiple => Token.multiple(this);
  Token get multipleOrNone => Token.multiple(this, orNone: true);

  Token get full => Token.full(this);
  Token get optional => Token.optional(this);

  Token get asBefore => Token.regex('(?<=$this)');
  Token get asNotBefore => Token.regex('(?<!$this)');
  
  Token get asAfter => Token.regex('(?=$this)');
  Token get asNotAfter => Token.regex('(?!$this)');
}

typedef TokenMatchCallback = void Function(TokenMatch match);