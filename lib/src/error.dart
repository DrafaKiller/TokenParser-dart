import 'package:token_parser/src/lexeme.dart';

/* -= Syntax Errors =- */

class LexicalSyntaxError extends Error {
  final String input;
  final int index;
  final List<Lexeme> path;
  final bool showUnnamed = false;

  LexicalSyntaxError(Lexeme lexeme, this.input, this.index) :
    path = [ lexeme ];

  @override
  String toString() => [
    if (input.length - 1 >= index)
      'LexicalSyntaxError: Unexpected character "${ input[index] }"'
    else
      'LexicalSyntaxError: Unexpected end of input'
    ,
    'at index $index',
    if (filteredPath.isNotEmpty) 'with lexeme "${ filteredPath.last.displayName }"',
    if (filteredPath.length > 1) 'on path:\n\t  → ${
      filteredPath
        .reversed
        .map((lexeme) => lexeme.displayName)
        .join('\n\t  ↑ ')
    }',
    ''
  ].join('\n\t');

  List<Lexeme> get filteredPath =>
    path.where((lexeme) => showUnnamed ? true : lexeme.name != null).toList();

  static ResultT enclose<ResultT>(Lexeme lexeme, ResultT Function() execute) {
    try {
      return execute();
    } on LexicalSyntaxError catch (error) {
      error.path.insert(0, lexeme);
      rethrow;
    }
  }
}

/* -= Reference Errors =- */

class ReferenceLexemeUseError extends Error {
  final String? name;
  ReferenceLexemeUseError([ this.name ]);

  @override
  String toString() =>
    'Reference lexeme${ name != null ? ' "#$name"' : '' } present in pattern, '
    'must be replaced with a concrete token before using it.\n'
    'Make sure to pass a grammar to the reference, or append it.';
}

class ReferenceLexemeNotFoundError extends Error {
  final String? name;
  ReferenceLexemeNotFoundError(this.name);

  @override
  String toString() => 'Lexeme reference ${ name == null ? 'null' : '"$name"' } not found in grammar. ';
}

/* -= Token Errors =- */

class MissingMainLexemeError extends Error {
  @override
  String toString() => 'Missing main lexeme in grammar, lexeme named "(main)".\n'
    'Make sure to pass a main lexeme to the grammar, or append it.';
}
