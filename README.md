<!--
[![Pub.dev package](https://img.shields.io/badge/pub.dev-token__parser-blue)](https://pub.dev/packages/token_parser)
[![GitHub repository](https://img.shields.io/badge/GitHub-TokenParser--dart-blue?logo=github)](https://github.com/DrafaKiller/TokenParser-dart)
-->

# Token Parser

An intuitive Token Parser that includes syntax/grammar definition, tokenization and parsing.

Implementation based on Lexical Analysis.<br>
Read more about it on [Wikipedia](https://en.wikipedia.org/wiki/Lexical_analysis), or with a [Basic Diagram](https://raw.githubusercontent.com/DrafaKiller/TokenParser-dart/main/doc/Lexical%20Analysis.png).

## Features

- Syntax/grammar definition
- Tokenization
- Parsing
- Referencing, and self-referencing

## In progress

- [x] Reorganize documentation
- [ ] Implement EBNF grammar
- [ ] Parse grammar from a file

## Getting Started 

```
dart pub add token_parser
```

And import the package:

```dart
import 'package:token_parser/token_parser.dart';
```

## Usage

This package is based on a syntax/grammar definition, which is a list of lexemes that define the grammar. Here is a brief example:

```dart
final whitespace = ' ' | '\t';
final lineBreak = '\n' | '\r';
final space = (whitespace | lineBreak).multiple;

final letter = '[a-zA-Z]'.regex;
final digit = '[0-9]'.regex;

final number = digit.multiple & ('.' & digit.multiple).optional;
final identifier = letter & (letter | digit).multiple.optional;

final grammar = Grammar(
  main: identifier & space & '=' & space & number,
  definitions: {
    'whitespace': whitespace,
    'lineBreak': lineBreak,
    'space': space,

    'letter': letter,
    'digit': digit,

    'number': number,
    'identifier': identifier,
  }
);

final result = grammar.parse('myNumber = 12.3');
print(result);
if (result != null) {
  print('Identifier: ${ result.get(lexeme: identifier).first.value }');
  print('Number: ${ result.get(lexeme: number).first.value }');
  // [Output]
  // Identifier: myNumber
  // Number: 12.3
}
```

## Lexeme

A **lexeme** is a grammar definition that will be used to tokenize an input.
It's a pattern that must be matched, essentially a grammar rule.

The syntax/grammar definition is done by defining what each token must have, using Lexical Analysis.

This composition of lexemes is what will define the grammar.
Lexemes can contain other lexemes to form a more complex lexical grammar.

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
final phrase = word & (' ' & word).multiple.optional;
```

### Reference, and self-reference

Reference lexemes are placeholders,
that when requested to tokenize an input will find the lexeme in the grammar bound to it,
associated with a name.

Lexemes can be referenced using the functions `reference(String name)` and `self()`, or `ref(String name)` for short.

```dart
final abc = 'a' | 'b' | 'c' | reference('def');
final def = ('d' | 'e' | 'f') & self().optional;
```

For a reference to have an effect, it must be bound to the grammar,
and the referenced lexeme must be present in the same grammar.
If referenced lexeme is not present, it will throw an error when tokenizing.

## Grammar

A grammar is a list of lexemes that will be used to parse an input,
essentially a list of rules that define the language.

A grammar has an entry point, called the **main** lexeme.
This lexeme is used to parse the input and will be the only one returned.

Grammar can be defined in two ways, using the constructor:

```dart
final grammar = Grammar(
  main: phrase | number,
  definitions: {
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

Lexemes can tokenize an input by themselves,
but it's often more consistent to group the lexemes in a grammar.

That way allowing the use of **references and main lexeme**.
Adding any lexeme to a grammar will effectively bind them together,
along with a name, and resolves any **self-references**.

### Parsing an input

The grammar is used for parsing any input, which will tokenize it,
taking into account all the lexemes previously added.

Parse an input using `.parse(String input, { Lexeme? main })` method.

```dart
final grammar = Grammar(...);

grammar.parse('123');
grammar.parse('123.456');

grammar.parse('word');
grammar.parse('two words');
```

You can override the main lexeme used for parsing the input,
by passing it as a parameter.

When parsing an input, it will return a resulting token,
which can be used to get the value and position of the lexemes that matched.
It can also be used to get the children tokens.

## Token

A token is a result of matching a lexeme to an input.
It contains the value of the lexeme that matched and the position of the token.

The process of generating this token is called **tokenization**.

```dart
final grammar = Grammar(...);
final token = grammar.parse('123');

print('''
  Value: ${ token.value }
  Lexeme: ${ token.lexeme.name }

  Start: ${ token.start }
  End: ${ token.end }
  Length: ${ token.length }
''');
```

### Lexical Syntax Error

When tokenizing, if the input doesn't match any lexeme,
it will throw a `LexicalSyntaxError` error.

This error displays the position of the error,
and the lexemes that were expected to match the input.
Additionally, it will display the list of the lexemes that were
traversed, as the path to the error.

This error will skip any lexeme that is not named.

### Analysing the Token Tree

You may use this token to analyze the resulting tree. Using the `.get({ Lexeme? lexeme, String? name })` method will get all the tokens that match the lexeme or name.

The reach of the search can be limited by using the `bool shallow` parameter, the default is `false` when having a lexeme or name, and `true` when no search parameters are given.

```dart
final result = grammar.parse('two words');

final words = result.get(lexeme: word);
final letters = result.get(name: 'letter');

print('Words: ${ words.map((token) => token.value) }');
print('Letters: ${ letters.get(letter).map((token) => token.value) }');
```

You may also use the `.children` and `.allChildren` for a more direct approach.
Although the children are not guaranteed to be tokens,
they may also be basic matching values, such as of Match type.

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
  ```
</details>
