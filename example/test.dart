import 'package:token_parser/token_parser.dart';

void main() {
  final lexeme = ('a' | 'b') & Lexeme.reference('lexeme').optional;

  final grammar = Grammar(
    main: lexeme,
    lexemes: {
      'lexeme': lexeme,
    }
  );

  print(grammar.parse('aabc'));
}