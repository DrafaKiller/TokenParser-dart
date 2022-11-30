import 'package:token_parser/src/lexical_analysis/extension.dart';
import 'package:token_parser/src/lexical_analysis/lexeme.dart';
import 'package:token_parser/src/lexical_analysis/lexemes/abstracts/parent.dart';
import 'package:token_parser/src/lexical_analysis/lexemes/main.dart';
import 'package:token_parser/src/lexical_analysis/lexemes/reference.dart';
import 'package:token_parser/src/lexical_analysis/token.dart';
import 'package:token_parser/utils/iterable.dart';

class Grammar {
  final Set<Lexeme> lexemes = {};

  Grammar({ Map<String, Pattern>? lexemes, Lexeme? main }) {
    if (lexemes != null) addAll(lexemes);
    if (main != null) this.main = main;
  }

  Token? parse(String input, [ Lexeme? main ]) {
    main ??= this.main;
    return main?.tokenize(input);
  }
  
  void addMain(Lexeme lexeme) => addLexemes([ lexeme, MainLexeme(lexeme) ]);

  Lexeme? get main => lexeme('(main)');

  set main(Lexeme? lexeme) {
    if (lexeme != null) addMain(lexeme);
  }

  /* -= Lexeme Management =- */

  Lexeme? lexeme(String name) => lexemes.firstWhereOrNull((token) => token.name == name);

  Lexeme add(String name, Pattern lemexe) {
    final resolved = lemexe.lexeme(name);
    addLexeme(resolved);
    return resolved;
  }

  Set<Lexeme> addAll(Map<String, Pattern> lexemes) {
    return lexemes.entries.map((entry) => add(entry.key, entry.value.lexeme())).toSet();
  }

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
  void addLexemes(Iterable<Lexeme> tokens) => tokens.forEach(addLexeme);
}