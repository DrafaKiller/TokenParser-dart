import 'package:token_parser/src/error.dart';
import 'package:token_parser/src/internal/extension.dart';
import 'package:token_parser/src/lexeme.dart';
import 'package:token_parser/src/lexemes/main.dart';
import 'package:token_parser/src/lexemes/reference.dart';
import 'package:token_parser/src/token.dart';
import 'package:token_parser/src/utils/iterable.dart';

class Grammar {
  final Set<Lexeme> rules = {};

  /// ## Token Parser - Grammar
  /// 
  /// Grammar is a collection of lexemes that can be used to tokenize a string.
  /// 
  /// It can parse a string and return a list of tokens.
  /// 
  /// Can be defined in two ways, using the constructor:
  /// 
  /// ```dart
  /// final grammar = Grammar(
  ///   main: phrase | number,
  ///   lexemes: {
  ///     'digit': digit,
  ///     'number': number,
  /// 
  ///     'letter': letter,
  ///     'word': word,
  ///     'phrase': phrase,
  /// 
  ///     'abc': 'a' | 'b' | 'c',
  ///     'def': 'd' | 'e' | 'f',
  ///   },
  /// );
  /// ```
  /// 
  /// Or using the `.add(String name, Pattern pattern)` method:
  /// 
  /// ```dart
  /// final grammar = Grammar();
  /// 
  /// grammar.addMain(phrase | number);
  /// 
  /// grammar.add('digit', digit);
  /// grammar.add( ... );
  /// ```
  Grammar({ Map<String, Pattern>? rules, Lexeme? main }) {
    if (rules != null) addAll(rules);
    if (main != null) this.main = main;
  }

  /// Parses the provided input and returns the resulting token.
  /// If the input is invalid, `LexicalSyntaxError` is thrown.
  /// 
  /// The main lexeme is used to tokenize the input, this can be changed by
  /// setting the `main` argument.
  Token parse(String input, [ Lexeme? main ]) {
    main ??= this.main ?? (throw MissingMainLexemeError());
    return main.tokenize(input);
  }

  /// Parses the provided input and returns the resulting token.
  /// If the input is invalid, `null` is returned.
  /// 
  /// The main lexeme is used to tokenize the input, this can be changed by
  /// setting the `main` argument.
  Token? optionalParse(String input, [ Lexeme? main ]) {
    try {
      return parse(input, main);
    } on LexicalSyntaxError {
      return null;
    }
  }

  /// The main lexeme is the lexeme that will be used to tokenize the input
  /// when parsing.
  Lexeme? get main => lexeme('(main)');
  set main(Lexeme? lexeme) {
    if (lexeme != null) addMain(lexeme);
  }


  /// Sets the main lexeme of the grammar.
  void addMain(Lexeme lexeme) => addLexemes([ lexeme, MainLexeme(lexeme) ]);

  /* -= Lexeme Management =- */

  /// Get a previously binded lexeme by its name, from the grammar.
  Lexeme? lexeme(String name) =>
    rules.firstWhereOrNull((token) => token.name == name);

  /// Add a lexeme to the grammar.
  /// This will bind the lexeme to the grammar, so it can be referenced.
  Lexeme add(String name, Pattern lemexe) {
    final resolved = lemexe.lexeme(name);
    addLexeme(resolved);
    return resolved;
  }

  /// Add a list of lexemes to the grammar.
  /// This will bind the lexemes to the grammar, so they can be referenced.
  Set<Lexeme> addAll(Map<String, Pattern> lexemes) =>
    lexemes.entries.map((entry) => add(entry.key, entry.value.lexeme())).toSet();

  /// Add a lexeme to the grammar.
  /// This will bind the lexeme to the grammar, so it can be referenced.
  void addLexeme(Lexeme lexeme) {
    if (lexeme.name == null) return;
    lexeme.bind(this);
    for (final child in lexeme.allChildren.whereType<Lexeme>()) {
      child.bind(this);
      if (child is ReferenceLexeme && child.lexemeName == '(self)') {
        child.lexeme = lexeme;
      }
    }
    rules.add(lexeme);
  }

  /// Add a list of lexemes to the grammar.
  /// This will bind the lexemes to the grammar, so they can be referenced.
  void addLexemes(Iterable<Lexeme> tokens) => tokens.forEach(addLexeme);
}
