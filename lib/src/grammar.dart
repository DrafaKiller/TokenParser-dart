import 'package:token_parser/src/extension.dart';
import 'package:token_parser/src/lexeme.dart';
import 'package:token_parser/src/lexemes/abstracts/parent.dart';
import 'package:token_parser/src/lexemes/main.dart';
import 'package:token_parser/src/lexemes/reference.dart';
import 'package:token_parser/src/token.dart';
import 'package:token_parser/utils/iterable.dart';

/// ## Grammar
///
/// An intuitive Token Parser that includes syntax/grammar definition,
/// tokenization and parsing.
/// 
/// Implementation based on Lexical Analysis.<br>
/// Read more about it on [Wikipedia](https://en.wikipedia.org/wiki/Lexical_analysis),
/// or with a [basic diagram](https://raw.githubusercontent.com/DrafaKiller/TokenParser-dart/main/doc/Lexical%20Analysis.png).
///
/// ### Usage
///
/// The syntax/grammar definition is done by defining what each token must have,
/// using Lexical Analysis.
/// 
/// A **lexeme** is a grammar definition that will be used to tokenize the input.
/// 
/// This tokenization will generate a **token** from this specific lexeme,
/// with the value and position of the input that matched the lexeme.
/// 
/// This composition of lexemes is what defines **grammar**.
/// Lexemes can contain other lexemes to form a more complex grammar.
/// 
/// Here is a brief example:
/// 
/// ```dart
/// import 'package:token_parser/token_parser.dart';
/// 
/// final whitespace = ' ' | '\t';
/// final lineBreak = '\n' | '\r';
/// final space = (whitespace | lineBreak).multiple;
/// 
/// final letter = '[a-zA-Z]'.regex;
/// final digit = '[0-9]'.regex;
/// 
/// final number = digit.multiple & '.' & digit.multiple;
/// final identifier = letter & (letter | digit).multiple.optional;
/// 
/// final grammar = Grammar(
///   main: identifier & space '=' & space & number,
///   lexemes: {
///     'whitespace': whitespace,
///     'lineBreak': lineBreak,
///     'space': space,
/// 
///     'letter': letter,
///     'digit': digit,
/// 
///     'number': number,
///     'identifier': identifier,
///   }
/// );
/// 
/// final result = grammar.parse('numberVariable = 1');
/// if (result != null) {
///   print(result.get(lexeme: identifier).first.value);
///   print(result.get(lexeme: number).first.value);
///   // Output: numberVariable
///   // Output: 1
/// }
/// ```
class Grammar {
  final Set<Lexeme> lexemes = {};

  /// ## Grammar
  ///
  /// An intuitive Token Parser that includes syntax/grammar definition,
  /// tokenization and parsing.
  /// 
  /// Implementation based on Lexical Analysis.<br>
  /// Read more about it on [Wikipedia](https://en.wikipedia.org/wiki/Lexical_analysis),
  /// or with a [basic diagram](https://raw.githubusercontent.com/DrafaKiller/TokenParser-dart/main/doc/Lexical%20Analysis.png).
  ///
  /// ### Usage
  ///
  /// The syntax/grammar definition is done by defining what each token must have,
  /// using Lexical Analysis.
  /// 
  /// A **lexeme** is a grammar definition that will be used to tokenize the input.
  /// 
  /// This tokenization will generate a **token** from this specific lexeme,
  /// with the value and position of the input that matched the lexeme.
  /// 
  /// This composition of lexemes is what defines **grammar**.
  /// Lexemes can contain other lexemes to form a more complex grammar.
  /// 
  /// Here is a brief example:
  /// 
  /// ```dart
  /// import 'package:token_parser/token_parser.dart';
  /// 
  /// final whitespace = ' ' | '\t';
  /// final lineBreak = '\n' | '\r';
  /// final space = (whitespace | lineBreak).multiple;
  /// 
  /// final letter = '[a-zA-Z]'.regex;
  /// final digit = '[0-9]'.regex;
  /// 
  /// final number = digit.multiple & '.' & digit.multiple;
  /// final identifier = letter & (letter | digit).multiple.optional;
  /// 
  /// final grammar = Grammar(
  ///   main: identifier & space '=' & space & number,
  ///   lexemes: {
  ///     'whitespace': whitespace,
  ///     'lineBreak': lineBreak,
  ///     'space': space,
  /// 
  ///     'letter': letter,
  ///     'digit': digit,
  /// 
  ///     'number': number,
  ///     'identifier': identifier,
  ///   }
  /// );
  /// 
  /// final result = grammar.parse('numberVariable = 1');
  /// if (result != null) {
  ///   print(result.get(lexeme: identifier).first.value);
  ///   print(result.get(lexeme: number).first.value);
  ///   // Output: numberVariable
  ///   // Output: 1
  /// }
  /// ```
  Grammar({ Map<String, Pattern>? lexemes, Lexeme? main }) {
    if (lexemes != null) addAll(lexemes);
    if (main != null) this.main = main;
  }

  /// ### Parsing
  /// 
  /// The grammar is used for parsing any input, which will tokenize it,
  /// taking into account all the lexemes defined previously.
  /// 
  /// Parse an input using `.parse(String input)` method.
  /// 
  /// ```dart
  /// final grammar = Grammar(...);
  /// 
  /// grammar.parse('123');
  /// grammar.parse('123.456');
  /// 
  /// grammar.parse('word');
  /// grammar.parse('two words');
  /// ```
  /// 
  /// A grammar has an entry point, called the **main** lexeme.
  /// This lexeme is used to parse the input and will be the only one returned.
  /// 
  /// When parsing an input, it will return a parsed token,
  /// which can be used to get the value and position of the input that matched.
  /// It can also be used to get the children tokens.
  Token? parse(String input, [ Lexeme? main ]) {
    main ??= this.main;
    return main?.tokenize(input);
  }
  
  /// A grammar has an entry point, called the **main** lexeme.
  /// This lexeme is used to parse the input and will be the only one returned.
  void addMain(Lexeme lexeme) => addLexemes([ lexeme, MainLexeme(lexeme) ]);

  /// A grammar has an entry point, called the **main** lexeme.
  /// This lexeme is used to parse the input and will be the only one returned.
  Lexeme? get main => lexeme('(main)');

  set main(Lexeme? lexeme) {
    if (lexeme != null) addMain(lexeme);
  }

  /* -= Lexeme Management =- */

  /// Get a previously binded lexeme by its name, from the grammar.
  Lexeme? lexeme(String name) => lexemes.firstWhereOrNull((token) => token.name == name);

  /// Add a lexeme to the grammar.
  /// This will bind the lexeme to the grammar, so it can be referenced.
  Lexeme add(String name, Pattern lemexe) {
    final resolved = lemexe.lexeme(name);
    addLexeme(resolved);
    return resolved;
  }

  /// Add a lexeme to the grammar.
  /// This will bind the lexeme to the grammar, so it can be referenced.
  Set<Lexeme> addAll(Map<String, Pattern> lexemes) {
    return lexemes.entries.map((entry) => add(entry.key, entry.value.lexeme())).toSet();
  }

  /// Add a lexeme to the grammar.
  /// This will bind the lexeme to the grammar, so it can be referenced.
  void addLexeme(Lexeme lexeme) {
    if (lexeme.name == null) return;
    if (lexeme is ParentLexeme) {
      lexeme.bind(this);
      for (final child in lexeme.allChildren.whereType<Lexeme>()) {
        child.bind(this);
        if (child is ReferenceLexeme && child.lexemeName == '(self)') {
          child.lexeme = lexeme;
        }
      }
    }
    lexemes.add(lexeme);
  }

  /// Add a lexeme to the grammar.
  /// This will bind the lexeme to the grammar, so it can be referenced.
  void addLexemes(Iterable<Lexeme> tokens) => tokens.forEach(addLexeme);
}