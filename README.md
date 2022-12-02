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

## Usage

The Tokenization process is divided into three steps:
  1) Syntax/Grammar Definition
  2) Tokenization
  3) Parsing

Below will be a brief explanation of each step.

### Syntax/Grammar Definition

The syntax/grammar definition is done by defining what each token must have.

A token represents an expression, which then can be used in other tokens to compose a grammar.

```dart
final abc = 'a' | 'b' | 'c';
final def = 'd' | 'e' | 'f';

final expression = abc & def;
```

Using the `&` operator to combine tokens as "and" and the `|` operator to combine tokens as "or",
we can define an expression that can take any combination of the tokens `abc` and `def`.

Tokens may be extended to have slightly different properties:

```dart
final abc = ('a' | 'b' | 'c').multiple;

final expression = abc & 'd'.optional;
```

For convenience, a token can be defined using a regular expression:

```dart
final digit = '[0-9]'.regex;
final number = digit.multiple & ('.' & digit.multiple).optional;

final letter = '[a-zA-Z]'.regex;
final word = letter.multiple;
final phrase = word & ((' ' & word).multiple).optional;
```

### Tokenization

Any token 

### Parsing

```dart
final abc = 'a' | 'b' | 'c' | reference('def');
final def = ('d' | 'e' | 'f') & self().optional;
```

```dart
final grammar = Grammar(
  main: phrase | number,
  lexemes: {
    'digit': digit,
    'number': number,

    'letter': letter,
    'word': word,
    'phrase': phrase,

    'abc': 'a' | 'b' | 'c',
    'def': 'd' | 'e' | 'f',
  },
);
```

```dart
final grammar = Grammar();

grammar.add('digit', digit);
grammar.add( ... );

grammar.addMain(phrase | number);
```

```dart
grammar.parse('123');
grammar.parse('123.456');

grammar.parse('word');
grammar.parse('two words');
```

```dart
final match = grammar.parse('two words');

final words = match?.get(word);
final letters = match?.get(letter);

print('Words: ${ words?.map((match) => match.value) }');
print('Letters: ${ letters?.get(letter).map((match) => match.value) }');
```

- `match.children`
- `match.get(token)`
- `match.getNamed('name')`


## Example

<details>
  <summary>
    Tokenization
    <a href="https://github.com/DrafaKiller/TokenParser-dart/blob/main/example/main.dart">
      <code>(/example/main.dart)</code>
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

    final parser = Grammar(
      main: (variableDeclaration | space).multiple,
      lexemes: {
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
    
    final numbers = match?.get(lexeme: number).map((match) => match.group(0));
    final identifiers = match?.get(lexeme: identifier).map((match) => '"${ match.group(0) }"');

    print('Numbers: $numbers');
    print('Identifiers: $identifiers');
  }
  ```
</details>

<details>
  <summary>
    Referencing
    <a href="https://github.com/DrafaKiller/TokenParser-dart/blob/main/example/reference.dart">
      <code>(/example/reference.dart)</code>
    </a>
  </summary>
    
  ```dart
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
  ```
</details>
