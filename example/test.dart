import 'package:token_parser/token_parser.dart';

final test = 'a' & lol & 'b';
final abc = 'a' & 'b' & 'c';
final def = 'd' & 'e' & 'f';
final lol = abc & def;

final grammar = Grammar(
  main: test,
  definitions: {
    'test': test,
    'abc': abc,
    'def': def,
    'lol': lol,
  }
);

void main() {
  print(grammar.parse('aabcdefb'));
}