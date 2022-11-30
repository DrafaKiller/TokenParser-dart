import 'package:token_parser/src/token.dart';
import 'package:token_parser/src/match.dart';
import 'package:token_parser/src/tokens/reference.dart';

extension TokenPattern on Pattern {
  /* -= Pattern Methods =- */

  TokenMatch? match(String string, [ int start = 0 ]) {
    final match = matchAsPrefix(string, start);
    if (match == null) return null;
    return TokenMatch(token(), match);
  }

  /* -= Token Build Methods =- */

  Token operator +(Pattern other) => this & other;
  Token operator &(Pattern other) => Token.and(this, other);
  Token operator |(Pattern other) => Token.or(this, other);

  Token operator >(Pattern other) => Token.and(this, other.token().asAfter);
  Token operator >=(Pattern other) => Token.and(this, other.token().asNotAfter);
  
  Token operator <(Pattern other) => Token.and(token().asBefore, other);
  Token operator <=(Pattern other) => Token.and(token().asNotBefore, other);

  Token get not => Token.not(this);
  Token get multiple => Token.multiple(this);
  Token get multipleOrNone => Token.multiple(this, orNone: true);
  Token get optional => Token.optional(this);
  
  Token get regex => Token.regex(toString());

  /* -= Token Binding =- */

  Token token([ String? name ]) {
    if (this is! Token || this is ReferenceToken) return Token.pattern(this, name: name);
    final token = this as Token;
    if (name == null) return token;
    token.name = name;
    return token;
  }

  Token bind(Token token) => this.token(token.name);
}
