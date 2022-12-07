## 1.1.0

Changed:
- Shorter error messages, to be less descriptive

## 1.0.0

**BREAKING CHANGES:**
- Token Parser was refactored to be able to throw lexical syntax errors, using `LexicalSyntaxError`. This change means that tokenization is mandatory to return a token. If there's no match, it will throw an error suggesting where it went wrong. If you with to have optional tokenization, use the `grammar.optionalParse()` and `lexeme.optionalTokenize()` methods instead.
- Every lexeme type was reworked, so they might have different behavior than before.

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
