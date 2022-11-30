# Token Parser

An intuitive Token Parser that includes syntax/grammar definition, tokenization and parsing.

## Features

- Tokenization
- Parsing
- Syntax/grammar definition

## Getting Started 

```
dart pub add token_parser
```

And import the package:

```dart
import 'package:token_parser/token_parser.dart';
```

## Example

<details>
  <summary>
    Tokenization
    <a href="https://github.com/DrafaKiller/TokenParser-dart/blob/dev/example/main.dart">
      <code>(example/main.dart)</code>
    </a>
  </summary>
    
  ```dart
  import 'package:token_parser/token_parser.dart';

  void main() {
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

    final parser = Parser(
      main: (variableDeclaration | space).multiple,
      tokens: {
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

    final match = parser.parse('''
      var hello = "world";
      var foo = 123;
      var bar = 123.456;
    ''');
    
    final numbers = match?.get(number).map((match) => match.group(0));
    final identifiers = match?.get(identifier).map((match) => '"${ match.group(0) }"');

    print('Numbers: $numbers');
    print('Identifiers: $identifiers');
  }
  ```
</details>
