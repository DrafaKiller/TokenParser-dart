import 'package:token_parser/token_parser.dart';

void main() {
  final expression = 'a' & Lexeme.reference('characterB').optional;
  final characterB = 'b'.lexeme();

  final recursive = 'a' & Lexeme.self().optional;

  final parser = Grammar(
    main: expression,
    lexemes: {
      'expression': expression,
      'characterB': characterB,
      
      'recursive': recursive,
    }
  );

  print(parser.parse('ab')?.get(lexeme: characterB));
  print(parser.parse('aaa', recursive)?.get(lexeme: recursive));
}