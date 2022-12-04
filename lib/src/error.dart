import 'package:token_parser/src/lexeme.dart';

class LexicalSyntaxError extends Error {
  final String input;
  final int index;
  final List<Lexeme> path;

  LexicalSyntaxError(Lexeme lexeme, this.input, this.index) :
    path = [ lexeme ];

  @override
  String toString() => '''
LexicalSyntaxError: Unexpected character "${ input[index] }"
  at index $index
  with lexeme "${ path.last.displayName }"
  path
      ${ path.map((e) => e.displayName).join('\n    -> ') }
  ''';

  static Match? ignore(Function callback) {
    try {
      return callback();
    } on LexicalSyntaxError {
      return null;
    }
  }  
}