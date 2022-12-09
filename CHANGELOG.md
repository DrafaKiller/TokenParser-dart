## 1.5.0

Changed:
- Lexeme modifier `pattern.pad()` is now not optional, to have an optional pattern do `pattern.optional` before passing in
- Lexeme modifier `pattern.spaced` is now not optional, it wouldn't be called spaced otherwise. To have optional spacing, use `pattern.optionalSpaced`

Fixed:
- Debugging tokenization, no character error

## 1.4.0

**BREAKING CHANGES:**
- Added, changed and removed a few lexeme operators, to simplify the API and make it more consistent.

Added:
- Lexeme operator `*` to combine 2 lexemes with a space in between, multiple and optional

Changed:
- Lexeme operator `+` to combine 2 lexemes with a space in between, multiple 

Remove:
- Lexeme operators `>` and `>=`, are more probable to cause errors than to be useful, due to how Dart handles them
- Lexeme operator `>>`, does the same thing as `+`

## 1.3.1

Fixed:
- Multiple `>` and `>=` would prompt an error: "A comparison expression can't be an operand of another comparison expression.". Added `>>` and `*` to fix this issue, respectively.

## 1.3.0

Added:
- Lexeme operator extension `>` and `>=`, add spacing in between, and optionally
- Shield.io badges to README.md

## 1.2.0

Added:
- New `spacing` top-level lexeme, matches any conventional spacing, multiple space
- Lazy lexeme extension modifiers, `pattern.plus`, `pattern.star` and `pattern.question`. They do what you're expecting from a regex expression, and can be easier for translation and lazy debugging, but it's not 
recommended to use them because they are harder to read
- Lexeme extension `iterable.and` and `iterable.or`, transform a list of patterns into an and/or lexeme
- Lexeme extension `iterable.spaced` and `iterable.optionalSpaced`, transform a list of lexemes into an and lexeme with spaces in between, optionally

Changed:
- `spacing` moved to `space`, single space

## 1.1.0

TODO:

Added:
- `anyUntil(pattern)` top-level lexeme, matches any character until the pattern is matched
- `pattern.until(pattern)` lexeme extension, matches the current pattern until the target pattern is matched
- `pattern.repeat(min, [ max ])` lexeme extension, matches the pattern between `min` and `max` times
- `start`, `end` top-level lexemes, matches the start and end of the input
- `startLine`, `endLine` top-level lexemes, matches the start and end of the line

Fixed:
- Lexeme's Regex string, was using `'$pattern'` within itself instead of `'${ pattern.regexString }'`

Changed:
- Shorter error messages, to be less descriptive

## 1.0.0

**BREAKING CHANGES:**
- Token Parser was refactored to be able to throw lexical syntax errors, using `LexicalSyntaxError`. This change means that tokenization is mandatory to return a token. If there's no match, it will throw an error suggesting where it went wrong. If you must have optional tokenization, use the `grammar.optionalParse()` and `lexeme.optionalTokenize()` methods instead.
- Every lexeme type was reworked, so they might have different behavior than before.
- Grammar debugging is available, instantiating grammar using the `DebugGrammar` class. It will show you the tokenization process, and the path it took to get to the token. It's recommended to use it when you're debugging your grammar, and remove it when you're done.

Added:
- Tokenization error `LexicalSyntaxError`, is thrown when a token is not matched
- `CharacterLexeme` to match single characters
- Grammar debugging, using the grammar class `DebugGrammar`
- Grammar debugging methods, `grammar.tokenizing()`, called before lexemes start tokenizing
- `.length` property to token, which returns the length of value matched
- `empty()` top-level lexeme extension, same as `Lexeme.empty()`
- `spacing` top-level lexeme, matches any conventional spacing
- `pattern.pad()` method surrounds the lexeme with another lexeme, optionally
- `pattern.spaced` lexeme extension, same as `pattern.pad(spacing)`
- `-` operator to exclude patterns, same as `pattern.not.character`
- `~` operator to pad lexeme with spacing around it, same as `pattern.spaced`

Fixed:
- `Token` and `Lexeme` comparison hash code, now it has a much better performance

Changed:
- Reorganized the documentation
- Moved the utils directory inside the source directory
- Renamed `grammar.lemexes` to `grammar.rules`
- Moved `toString()` into `regexString` getter, `toString()` now displays similar to `displayName`

## 0.0.1

Initial release: Token Parser
