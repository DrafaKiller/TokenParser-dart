import 'package:token_parser/src/lexeme.dart';
import 'package:token_parser/src/token.dart';

class ReferenceLexeme extends Lexeme {
  ReferenceLexeme(String name, { super.grammar }) : super(name: '(#$name)');

  String get lexemeName => namePattern.firstMatch(name!)!.group(1)!;
  set lexemeName(String name) => this.name = '(#$name)';
  
  Lexeme get lexeme => (grammar?.lexeme(lexemeName) ?? (throw ReferenceLexemeNotFoundError(lexemeName)));
  set lexeme(Lexeme token) => lexemeName = token.name ?? (throw ReferenceLexemeNotFoundError(lexemeName));
  
  @override
  Token? tokenize(String string, [int start = 0]) {
    if (grammar == null) throw ReferenceLexemeUseError(lexemeName);
    return lexeme.tokenize(string, start);
  }
  
  @override String toString() => '[#$lexemeName]';

  static final namePattern = RegExp(r'^\(#(?<name>.*)\)$');
}

class ReferenceLexemeUseError extends Error {
  final String? name;
  ReferenceLexemeUseError([ this.name ]);

  @override
  String toString() =>
    'Reference lexeme${ name != null ? ' "#$name"' : '' } present in pattern, '
    'must be replaced with a concrete token before using it.\n'
    'Make sure to pass a grammar to the reference, or append it to a grammar.';
}

class ReferenceLexemeNotFoundError extends Error {
  final String? name;
  ReferenceLexemeNotFoundError(this.name);

  @override
  String toString() => 'Lexeme reference ${ name == null ? 'null' : '"$name"' } not found in grammar. ';
}