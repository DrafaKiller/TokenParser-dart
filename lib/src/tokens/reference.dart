import 'package:token_parser/src/token.dart';
import 'package:token_parser/src/match.dart';
import 'package:token_parser/src/parser.dart';

class ReferenceToken extends Token {
  Parser? parser;
  ReferenceToken(String name, { this.parser }) : super(name: '[$name]');

  String get referenceName => name!.substring(1, name!.length - 1);
  set referenceName(String name) => this.name = '[$name]';

  Token get referenceToken => (parser?.token(referenceName) ?? (throw ReferenceTokenNotFoundError(referenceName)));
  set referenceToken(Token token) => referenceName = token.name ?? (throw ReferenceTokenNotFoundError(referenceName));

  @override
  TokenMatch? match(String string, [ int start = 0 ]) {
    if (parser == null) throw ReferenceTokenUseError();
    return referenceToken.matchAsPrefix(string, start);
  }

  void bind(Parser parser) => this.parser = parser;

  @override
  String toString() => name!;

  static Match? matchOnce(Token token, Pattern pattern, String string, [ int start = 0 ]) {
    if (pattern is ReferenceToken && pattern.referenceToken == token) return null;
    return pattern.matchAsPrefix(string, start);
  }
}

class ReferenceTokenUseError extends Error {
  @override
  String toString() =>
    'ReferenceToken present in pattern, '
    'must be replaced with a concrete token before using it. '
    'Make sure to pass a parser to the reference, or append it to a parser.';
}

class ReferenceTokenNotFoundError extends Error {
  final String? name;
  ReferenceTokenNotFoundError(this.name);

  @override
  String toString() => 'Token reference ${ name == null ? 'null' : '"$name"' } not found in parser. ';
}