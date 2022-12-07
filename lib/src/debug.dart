import 'dart:io';

import 'package:token_parser/token_parser.dart';

class _CombinedText {
  final String text;
  int repeat = 1;

  _CombinedText(this.text);

  void increment() => repeat++;

  @override
  String toString() => repeat <= 1 ? text : '$text (x$repeat)';
}

class DebugGrammar extends Grammar {
  final bool showAll;
  final bool showPath;
  final Duration delay;

  int debugIndex = 0;
  
  DebugGrammar({
    this.showAll = false,
    this.showPath = false,
    this.delay = Duration.zero,

    super.main,
    super.rules,
  });

  @override
  Token<Lexeme> parse(String input, [Lexeme? main]) {
    final timer = Stopwatch()..start();
    final result = super.parse(input, main);
    timer.stop();
    print('\n> Debugging Grammar parsed the input in ${ timer.elapsedMilliseconds } ms.\n');
    return result;
  }

  void tokenizing(Lexeme lexeme, String string, [ int start = 0 ]) {
    if (!showAll && lexeme.name == null) return;

    String character = string[start];
    if (character == '\n') character = r'\n';
    if (character == '\r') character = r'\r';  
    if (character == '\t') character = r'\t';

    final filteredPath = <List<_CombinedText>>[];
    if (showPath) {
      filteredPath.addAll(
        lexeme.path
          .where((lexeme) => showAll || lexeme.name != null)
          .fold<List<_CombinedText>>([], (value, lexeme) {
            if (value.isEmpty || value.last.text != lexeme.displayName) {
              value.add(_CombinedText(lexeme.displayName));
            } else {
              value.last.increment();
            }
            return value;
          })
          .fold<List<List<_CombinedText>>>([], (value, text) {
            if (value.isEmpty || value.last.length >= 5) value.add([]);
            value.last.add(text);
            return value;
          })
      );
    }

    print(
      ('${ debugIndex == 0 ? ' ' : '│' }  (#${ debugIndex + 1 })\n') +
      (debugIndex == 0 ? '┬► ' : '├► ') + 
      [
        'Tokenizing ${ lexeme.name != null ? 'named ${ lexeme.name }' : lexeme.displayName }',
        'at index $start${ start < string.length ? ', character "$character"' : '' }',
        if (showPath) 'on path: ${
          filteredPath
            .map((line) => line.join(' → '))
            .join(' → \n│           → ')
        }',
        ''
      ].join('\n│    ')
    );
    sleep(delay);
    debugIndex++;
  }

  static void debug(Lexeme lexeme, String string, [ int start = 0 ]) {
    if (lexeme.grammar is DebugGrammar) {
      (lexeme.grammar as DebugGrammar).tokenizing(lexeme, string, start);
    }
  }
}
