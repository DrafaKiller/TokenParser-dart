import 'package:token_parser/src/grammar.dart';
import 'package:token_parser/src/token.dart';

export 'package:token_parser/src/tokens/match.dart';
export 'package:token_parser/src/tokens/parent.dart';

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
abstract class Lexeme implements Pattern {
  String? name;

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

  /// Matches the current lexeme against the provided input.
  /// 
  /// The lexeme is matched multiple times until the input is exhausted.
  ///
  /// **Caution:** Avoid using this method, use `.tokenize` instead.
  @override
  Set<Token> allMatches(String string, [int start = 0]) {
    final tokens = <Token>{};
    Token? token;
    while ((token = tokenize(string, start)) != null) {
      tokens.add(token!);
      start = token.end;
    }
    return tokens;
  }

  /// **Caution:** Avoid using this method, use `.tokenize` instead.
  @override
  Match? matchAsPrefix(String string, [int start = 0]) => tokenize(string, start);

  /* -= Grammar =- */

  Grammar? grammar;
  
  /// Binding a lexeme to a grammar will set the grammar as the lexeme's parent.
  /// Allowing the lexeme to access the grammar's lexemes, useful when tokenizing.
  void bind(Grammar grammar) => this.grammar = grammar;
  void unbind() => grammar = null;

  /* -= Tokanization =- */

  /// Generates the resulting token from an input.
  /// 
  /// If the input doesn't match the lexeme, it will return `null`.
  Token? tokenize(String string, [int start = 0]);

  /* -= Children Anaylyzing =- */

  List<Pattern> get children => [];
  List<Pattern> get allChildren => [
    ...children,
    ...children.expand((child) => child is Lexeme ? child.allChildren : [])
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

  /* -= Identification =- */

  String get displayName => name ?? runtimeType.toString();
  
  @override
  bool operator ==(Object other) =>
    other is Lexeme &&
    name == other.name;

  @override
  int get hashCode => name.hashCode;

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
  factory Lexeme.multiple(Pattern pattern, { String? name, bool orNone }) = MultipleLexeme;
  
  factory Lexeme.full(Pattern pattern, { String? name }) = FullLexeme;
  factory Lexeme.empty() = EmptyLexeme;

  factory Lexeme.start() = StartLexeme;
  factory Lexeme.end() = EndLexeme;

  factory Lexeme.reference(String name, { Grammar? grammar }) = ReferenceLexeme;
  factory Lexeme.ref(String name, { Grammar? grammar }) = ReferenceLexeme;
  factory Lexeme.self() = SelfLexeme;
}
