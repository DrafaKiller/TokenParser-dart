import 'package:token_parser/token_parser.dart';

final whitespace = ' ' | '\t';
final lineBreak = '\n' | '\r';
final space = (whitespace | lineBreak).multiple;

final letter = '[a-zA-Z]'.regex;
final digit = '[0-9]'.regex;

final identifier = letter & (letter | digit).multiple.optional;

final number = digit.multiple & ('.' & digit.multiple).optional;
final string = '"' & '[^"]*'.regex & '"'
              | "'" & "[^']*".regex & "'";

final variableDeclaration =
  'var' & space & identifier & space.optional & '=' & space.optional & (number | string) & space.optional & (';' | space);

final grammar = Grammar(
  main: (variableDeclaration | space).multiple,
  definitions: {
    'whitespace': whitespace,
    'lineBreak': lineBreak,
    'space': space,

    'letter': letter,
    'digit': digit,

    'identifier': identifier,

    'number': number,
    'string': string,

    'variableDeclaration': variableDeclaration,
  },
);

void main() {
  final result = grammar.parse('''
    var hello = "world";
    var foo = 123;
    var bar = 123.456;
  ''');

  final numbers = result.get(lexeme: number).map((match) => match.group(0));
  final identifiers = result.get(lexeme: identifier).map((match) => '"${ match.group(0) }"');

  print('Numbers: $numbers');
  print('Identifiers: $identifiers');
}
