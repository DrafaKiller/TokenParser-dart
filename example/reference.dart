import 'package:token_parser/token_parser.dart';

final expression = 'a' & Lexeme.reference('characterB').optional;
final characterB = 'b'.lexeme();

final recursive = 'a' & Lexeme.self().optional;

final grammar = Grammar(
  main: expression,
  definitions: {
    'expression': expression,
    'characterB': characterB,
    
    'recursive': recursive,
  }
);

void main() {
  print(grammar.parse('ab').get(lexeme: characterB));
  print(grammar.parse('aaa', recursive).get(lexeme: recursive).map);
}