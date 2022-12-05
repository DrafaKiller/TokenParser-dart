import 'package:token_parser/src/error.dart';
import 'package:token_parser/src/grammar.dart';
import 'package:token_parser/src/token.dart';

/* -= Lexeme Imports =- */

import 'package:token_parser/src/lexemes/pattern.dart';

import 'package:token_parser/src/lexemes/and.dart';
import 'package:token_parser/src/lexemes/or.dart';

import 'package:token_parser/src/lexemes/not.dart';
import 'package:token_parser/src/lexemes/optional.dart';
import 'package:token_parser/src/lexemes/multiple.dart';

import 'package:token_parser/src/lexemes/full.dart';
import 'package:token_parser/src/lexemes/empty.dart';

import 'package:token_parser/src/lexemes/start.dart';
import 'package:token_parser/src/lexemes/end.dart';

import 'package:token_parser/src/lexemes/reference.dart';
import 'package:token_parser/src/lexemes/self.dart';

/* -=-=-=-=-=-=-=-=-=- */

abstract class Lexeme extends Pattern {
  String? name;
  Grammar? grammar;

  Lexeme({ this.name, this.grammar });

  /* -= Pattern Methods =- */

  @override
  Set<Token> allMatches(String string, [int start = 0]) {
    final tokens = <Token>{};
    Token? token;
    while ((token = optionalTokenize(string, start)) != null) {
      tokens.add(token!);
      start = token.end;
    }
    return tokens;
  }

  @override
  Token matchAsPrefix(String string, [int start = 0]) => tokenize(string, start);

  /* -= Tokenization =- */

  Token tokenize(String string, [ int start = 0 ]);

  Token? optionalTokenize(String string, [ int start = 0 ]) {
    try {
      return tokenize(string, start);
    } on LexicalSyntaxError {
      return null;
    }
  }

  /* -= Grammar =- */

  void bind(Grammar grammar) => this.grammar = grammar;
  void unbind() => grammar = null;

  /* -= Identification =- */

  String get displayName => name ?? runtimeType.toString();

  /* -= Compararison =- */

  @override
  bool operator ==(Object other) =>
    other is Lexeme &&
    name == other.name;

  @override
  int get hashCode => name.hashCode;

  /* -= Analysis =- */

  List<Lexeme> get children => [];
  List<Lexeme> get allChildren => [
    ...children,
    ...children.expand((child) => child.allChildren)
  ];

  List<T> get<T extends Lexeme>({ T? lexeme, String? name, bool? shallow }) {
    shallow ??= lexeme == null && name == null;
    return (shallow ? children : allChildren).whereType<T>().where((child) =>
      (lexeme == null || child == lexeme) &&
      (name == null || child.name == name)
    ).toList();
  }

  /* -= Factory Methods =- */

  factory Lexeme.pattern(Pattern pattern, { String? name }) = PatternLexeme;
  factory Lexeme.string(String pattern, { String? name }) = PatternLexeme;
  factory Lexeme.regex(String pattern, { String? name }) => PatternLexeme(RegExp(pattern), name: name);

  factory Lexeme.and(Pattern left, Pattern right, { String? name }) = AndBoundLexeme;
  factory Lexeme.andAll(List<Lexeme> children, { String? name }) = AndLexeme;

  factory Lexeme.or(Pattern left, Pattern right, { String? name }) = OrBoundLexeme;
  factory Lexeme.orAll(List<Lexeme> children, { String? name }) = OrLexeme;

  factory Lexeme.not(Pattern pattern, { String? name }) = NotLexeme;
  factory Lexeme.optional(Pattern pattern, { String? name }) = OptionalLexeme;
  factory Lexeme.multiple(Pattern pattern, { String? name, bool orNone }) = MultipleLexeme;
  
  factory Lexeme.full(Pattern pattern, { String? name }) = FullLexeme;
  factory Lexeme.empty() = EmptyLexeme;

  factory Lexeme.start() = StartLexeme;
  factory Lexeme.end() = EndLexeme;

  factory Lexeme.reference(String name, { Grammar? grammar }) = ReferenceLexeme;
  factory Lexeme.ref(String name, { Grammar? grammar }) = ReferenceLexeme;
  factory Lexeme.self() = SelfLexeme;
}