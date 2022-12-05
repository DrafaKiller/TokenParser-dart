## 1.0.0

**BREAKING CHANGES:**
- Token Parser was refactored to be able to throw lexical syntax errors, using the `LexicalSyntaxError` error. This change means that tokenization is mandatory to return a token, if there's no match, it will throw an error suggesting where it went wrong. If tokenization is optional, use the `lexeme.optionalTokenize()` method or `grammar.optionalParse()` method instead.
- Every lexeme type was reworked, so they might have different behavior than before.

Added:
- Tokenization error, `LexicalSyntaxError`, is thrown when a token is not matched.
- `CharacterLexeme` to match single characters
- `lexeme.pad()` method surrounds the lexeme with another lexeme
- `.length` property to token, which returns the length of value matched
- `empty()` top-level extension lexeme, same as `Lexeme.empty()`

Changed:
- Reorganized the documentation
- Moved the utils directory inside the source directory
- Renamed `grammar.lemexes` to `grammar.rules`;

## 0.0.1

Initial release: Token Parser
