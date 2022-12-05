import 'package:token_parser/src/error.dart';
import 'package:token_parser/src/internal/extension.dart';
import 'package:token_parser/src/lexeme.dart';
import 'package:token_parser/src/lexemes/main.dart';
import 'package:token_parser/src/lexemes/reference.dart';
import 'package:token_parser/src/token.dart';
import 'package:token_parser/src/utils/iterable.dart';

class Grammar {
  final Set<Lexeme> definitions = {};

  Grammar({ Map<String, Pattern>? definitions, Lexeme? main }) {
    if (definitions != null) addAll(definitions);
    if (main != null) this.main = main;
  }

  Token parse(String input, [ Lexeme? main ]) {
    main ??= this.main ?? (throw MissingMainLexemeError());
    return main.tokenize(input);
  }


  Lexeme? get main => lexeme('(main)');
  set main(Lexeme? lexeme) {
    if (lexeme != null) addMain(lexeme);
  }

  void addMain(Lexeme lexeme) => addLexemes([ lexeme, MainLexeme(lexeme) ]);

  /* -= Lexeme Management =- */

  Lexeme? lexeme(String name) =>
    definitions.firstWhereOrNull((token) => token.name == name);

  Lexeme add(String name, Pattern lemexe) {
    final resolved = lemexe.lexeme(name);
    addLexeme(resolved);
    return resolved;
  }

  Set<Lexeme> addAll(Map<String, Pattern> lexemes) =>
    lexemes.entries.map((entry) => add(entry.key, entry.value.lexeme())).toSet();

  void addLexeme(Lexeme lexeme) {
    if (lexeme.name == null) return;
    lexeme.bind(this);
    for (final child in lexeme.allChildren.whereType<Lexeme>()) {
      child.bind(this);
      if (child is ReferenceLexeme && child.lexemeName == '(self)') {
        child.lexeme = lexeme;
      }
    }
    definitions.add(lexeme);
  }

  void addLexemes(Iterable<Lexeme> tokens) => tokens.forEach(addLexeme);
}