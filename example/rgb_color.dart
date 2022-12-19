import 'package:token_parser/token_parser.dart';

void main() {
  final result = grammar.parse('rgb(255, 100, 0)');
  print('Red: ${ result.get(lexeme: red).first.value }');
  print('Green: ${ result.get(lexeme: green).first.value }');
  print('Blue: ${ result.get(lexeme: blue).first.value }');

  // [Output]
  // Red: 255
  // Green: 100
  // Blue: 0
}

final grammar = Grammar(
  main: rgb,
  rules: {
    'rgbNumber': rgbNumber,

    'red': red,
    'green': green,
    'blue': blue,

    'rgb': rgb,
  }
);

final rgbNumber = range(0, 255).lexeme();

final red = rgbNumber.copy();
final green = rgbNumber.copy();
final blue = rgbNumber.copy();

final rgb = [ 'rgb(', red, ',', green, ',', blue, ')' ].optionalSpaced;
