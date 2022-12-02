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
  
  Lexeme({ this.name, this.grammar });

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

  @override
  Match? matchAsPrefix(String string, [int start = 0]) => tokenize(string, start);

  /* -= Tokanization =- */

  Token? tokenize(String string, [int start = 0]);

  /* -= Grammar =- */

  Grammar? grammar;
  
  void bind(Grammar grammar) => this.grammar = grammar;
  void unbind() => grammar = null;

  /* -= Children Anaylyzing =- */

  List<Pattern> get children => [];
  List<Pattern> get allChildren => [
    ...children,
    ...children.expand((child) => child is Lexeme ? child.allChildren : [])
  ];

  List<T> get<T extends Lexeme>({ T? lexeme, String? name, bool shallow = false }) {
    final lexemes = <T>[];
    for (final child in (shallow ? children : allChildren).whereType<T>()) {
      if (
        (lexeme == null || child == lexeme) &&
        (name == null || child.name == name)
      ) {
        lexemes.add(child);
      }
    }
    return lexemes;
  }

  /* -= Identification =- */
  
  @override
  bool operator ==(Object other) {
    if (other is! Lexeme) return false;
    if (name != null || other.name != null) {
      return name == other.name;
    }
    return hashCode == other.hashCode;
  }
  
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
