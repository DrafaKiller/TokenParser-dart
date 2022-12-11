import 'package:token_parser/src/error.dart';
import 'package:token_parser/src/extension.dart';
import 'package:token_parser/src/lexeme.dart';
import 'package:token_parser/src/lexemes/global.dart';
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
  Grammar({
    Pattern? main,
    Pattern? remove,
    Map<String, Pattern>? rules
  }) {
    if (remove != null) addRemover(remove.lexeme());
    if (rules != null) addAll(rules);
    if (main != null) this.main = main.lexeme();
  }

  /// Parses the provided input and returns the resulting token.
  /// If the input is invalid, `LexicalSyntaxError` is thrown.
  /// 
  /// The main lexeme is used to tokenize the input, this can be changed by
  /// setting the `main` argument.
  Token parse(String string, [ Lexeme? main ]) {
    main ??= this.main ?? (throw MissingMainLexemeError());

    final remove = remover;
    if (remove != null) string = string.replaceAll(GlobalLexeme(remove), '');
    
    return main.tokenize(string);
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

  /* -= Main Lexeme =- */

  /// The main lexeme is the lexeme that will be used to tokenize the input
  /// when parsing.
  Lexeme? get main => lexeme('(main)');
  set main(Lexeme? lexeme) {
    if (lexeme != null) addMain(lexeme);
  }

  /// Sets the main lexeme of the grammar.
  void addMain(Lexeme lexeme) => addLexemes([ lexeme, MainLexeme(lexeme) ]);

  /* -= Remover Lexeme =- */

  /// The remove lexeme is the lexeme that will be used to remove a pattern from the input
  /// when parsing.
  Lexeme? get remover => lexeme('(remover)');
  set remover(Lexeme? lexeme) {
    if (lexeme != null) addRemover(lexeme);
  }

  /// Sets the remover lexeme of the grammar.
  void addRemover(Lexeme lexeme) => add('(remover)', lexeme);

  /* -= Lexeme Management =- */

  /// Get a previously binded lexeme by its name, from the grammar.
  LexemeT? lexeme<LexemeT extends Lexeme>(String name) =>
    rules.whereType<LexemeT>().firstWhereOrNull((token) => token.name == name);

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
