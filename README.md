# Token Parser

An intuitive Token Parser that includes syntax/grammar definition, tokenization and parsing.

Implementation based on Lexical Analysis.<br>
Read more about it on [Wikipedia](https://en.wikipedia.org/wiki/Lexical_analysis), or with a [basic diagram](https://raw.githubusercontent.com/DrafaKiller/TokenParser-dart/main/docs/Lexical%20Analysis.png).

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

The syntax/grammar definition is done by defining what each token must have, using Lexical Analysis.

A **lexeme** is a grammar definition that will be used to tokenize the input.

This tokenization will generate a **token** from this specific lexeme, with the value and position of the input that matched the lexeme.

This composition of lexemes is what defines **grammar**. Lexemes can contain other lexemes to form a more complex grammar.

```dart
final abc = 'a' | 'b' | 'c';
final def = 'd' | 'e' | 'f';

final expression = abc & def;
```

Using the `&` operator to combine tokens with an "and" operation, and the `|` operator to combine tokens with an "or" operation.
We can define an expression that can take any combination of the lexemes `abc` and `def`.

Lexemes may be extended to have slightly different properties.

```dart
final abc = ('a' | 'b' | 'c').multiple;

final expression = abc & 'd'.optional;
```

For convenience, a lexeme can be defined using a regular expression.<br>
Lexeme modification methods available:
  - `.not`
  - `.multiple` / `.multipleOrNone`
  - `.full`
  - `.optional`
  - `.regex`

```dart
final digit = '[0-9]'.regex;
final number = digit.multiple & ('.' & digit.multiple).optional;

final letter = '[a-zA-Z]'.regex;
final word = letter.multiple;
final phrase = word & ((' ' & word).multiple).optional;
```

Lexemes can be referenced using the functions `reference(String name)` and `self()`, or `ref(String name)` for short.

```dart
final abc = 'a' | 'b' | 'c' | reference('def');
final def = ('d' | 'e' | 'f') & self().optional;
```

A **reference** expects the lexeme name attributed when adding to a grammar.
It only has an effect when tokenizing. If the parent and referenced lexeme were not added to the grammar, it will throw an error when tokenizing.




### Tokenization

Lexemes can tokenize an input by themselves, generating the corresponding token.

For more consistent tokenization, it is recommended to group the lexemes in a **grammar**.
That way allowing the use of **references and main lexeme**. Adding any lexeme to a grammar will effectively bind them together, along with a name, resolving any **self-references**.

Grammar can be defined in two ways, using the constructor:

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

Or using the `.add(String name, Pattern pattern)` method:

```dart
final grammar = Grammar();

grammar.addMain(phrase | number);

grammar.add('digit', digit);
grammar.add( ... );
```

### Parsing

The grammar is used for parsing any input, which will tokenize it, taking into account all the lexemes defined previously.

Parse an input using `.parse(String input)` method.

```dart
final grammar = Grammar(...);

grammar.parse('123');
grammar.parse('123.456');

grammar.parse('word');
grammar.parse('two words');
```

A grammar has an entry point, called the **main** lexeme. This lexeme is used to parse the input and will be the only one returned.

When parsing an input, it will return a parsed token, which can be used to get the value and position of the input that matched. It can also be used to get the children tokens.

## Analysis

You may use the parsed token to analyze the resulting tree, using the `.get({ Lexeme? lexeme, String? name })` method will get all the tokens that match the lexeme or name.

The reach of the search can be limited by using the `bool shallow` argument, the default is `false` when having a lexeme or name, and `true` when no search parameters are given.

```dart
final match = grammar.parse('two words');

final words = match?.get(lexeme: word);
final letters = match?.get(name: 'letter');

print('Words: ${ words?.map((match) => match.value) }');
print('Letters: ${ letters?.get(letter).map((match) => match.value) }');
```

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

    final grammar = Grammar(
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

    final result = grammar.parse('''
      var hello = "world";
      var foo = 123;
      var bar = 123.456;
    ''');
    
    final numbers = result?.get(lexeme: number).map((match) => match.group(0));
    final identifiers = result?.get(lexeme: identifier).map((match) => '"${ match.group(0) }"');

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

    final grammar = Grammar(
      main: expression,
      lexemes: {
        'expression': expression,
        'characterB': characterB,
        
        'recursive': recursive,
      }
    );

    print(grammar.parse('ab')?.get(lexeme: characterB));
    print(grammar.parse('aaa', recursive)?.get(lexeme: recursive));
  }
  ```
</details>
