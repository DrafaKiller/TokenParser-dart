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
import 'package:token_parser/src/lexemes/main.dart';

import 'package:token_parser/src/lexemes/start.dart';
import 'package:token_parser/src/lexemes/end.dart';

import 'package:token_parser/src/lexemes/character.dart';

import 'package:token_parser/src/lexemes/reference.dart';
import 'package:token_parser/src/lexemes/self.dart';

/* -=-=-=-=-=-=-=-=-=- */

abstract class Lexeme extends Pattern {
  String? name;
  Grammar? grammar;

  /// ## Token Parser - Lexeme
  /// 
  /// A lexeme is a grammar definition that will be used to tokenize the input.
  /// 
  /// It's a pattern that must be matched in order to tokenize the input.
  /// 
  /// ```dart
  /// final abc = 'a' | 'b' | 'c';
  /// final def = 'd' | 'e' | 'f';
  /// final expression = abc & def;
  /// ```
  /// 
  /// ### Example
  /// 
  /// Here's an example of how to compose lexemes:
  /// 
  /// ```dart
  /// final whitespace = ' ' | '\t';
  /// final lineBreak = '\n' | '\r';
  /// final space = (whitespace | lineBreak).multiple;
  /// 
  /// final letter = '[a-zA-Z]'.regex;
  /// final digit = '[0-9]'.regex;
  /// 
  /// final identifier = letter & (letter | digit).multiple.optional;
  /// 
  /// final number = digit.multiple & ('.' & digit.multiple).optional;
  /// final string = '"' & '[^"]*'.regex & '"'
  ///              | "'" & "[^']*".regex & "'";
  /// ```
  Lexeme({ this.name, this.grammar });

  /* -= Pattern Methods =- */

  /// Matches the current lexeme against the provided input.
  /// 
  /// The lexeme is matched multiple times until the input is exhausted.
  ///
  /// **Caution:** Avoid using this method, use `.tokenize` instead.
  @override
  Set<Token> allMatches(String string, [ int start = 0 ]) {
    final tokens = <Token>{};
    Token? token;
    while ((token = optionalTokenize(string, start)) != null) {
      tokens.add(token!);
      start = token.end;
    }
    return tokens;
  }

  /// **Caution:** Avoid using this method, use `.tokenize` instead.
  @override
  Token matchAsPrefix(String string, [ int start = 0 ]) => tokenize(string, start);

  /* -= Tokenization =- */

  /// Generates the resulting token from an input.
  /// 
  /// If the input doesn't match the lexeme, it will throw a `LexicalSyntaxError`.
  Token tokenize(String string, [ int start = 0 ]);

  /// Generates the resulting token from an input.
  /// 
  /// If the input doesn't match the lexeme, it will return `null`.
  Token? optionalTokenize(String string, [ int start = 0 ]) {
    try {
      return tokenize(string, start);
    } on LexicalSyntaxError {
      return null;
    }
  }

  /* -= Grammar =- */

  /// Binding a lexeme to a grammar will set the grammar as the lexeme's parent.
  /// Allowing the lexeme to access the grammar's lexemes, useful when tokenizing.
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

  /// Get all the lexemes that match the lexeme type or name, allows to analyze the lexical tree.
  /// 
  /// The reach of the search can be limited by using the `bool shallow` argument,
  /// the default is `false` when having a lexeme or name, and `true` when no search parameters are given.
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
  factory Lexeme.andAll(List<Pattern> children, { String? name }) = AndLexeme;

  factory Lexeme.or(Pattern left, Pattern right, { String? name }) = OrBoundLexeme;
  factory Lexeme.orAll(List<Pattern> children, { String? name }) = OrLexeme;

  factory Lexeme.not(Pattern pattern, { String? name }) = NotLexeme;
  factory Lexeme.optional(Pattern pattern, { String? name }) = OptionalLexeme;
  factory Lexeme.multiple(Pattern pattern, { bool orNone, String? name }) = MultipleLexeme;
  
  factory Lexeme.full(Pattern pattern, { String? name }) = FullLexeme;
  factory Lexeme.empty() = EmptyLexeme;
  factory Lexeme.main(Pattern pattern) = MainLexeme;

  factory Lexeme.start() = StartLexeme;
  factory Lexeme.end() = EndLexeme;

  factory Lexeme.character(Pattern pattern, {
    bool not, String? name
  }) = CharacterLexeme;

  factory Lexeme.reference(String name, { Grammar? grammar }) = ReferenceLexeme;
  factory Lexeme.ref(String name, { Grammar? grammar }) = ReferenceLexeme;
  factory Lexeme.self() = SelfLexeme;
}