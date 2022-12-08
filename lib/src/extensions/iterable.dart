import 'package:token_parser/src/lexeme.dart';
import 'package:token_parser/src/extensions/pattern.dart';
import 'package:token_parser/src/extensions/top_level.dart';

extension LexicalAnalysisIterablePattern on Iterable<Pattern> {
  /// Transforms the current iterable of patterns into an AndLexeme.
  Lexeme get and => Lexeme.andAll(toList());

  /// Transforms the current iterable of patterns into an OrLexeme.
  Lexeme get or => Lexeme.orAll(toList());

  /// Transforms the current iterable of patterns into an AndLexeme with spaces in between, one or more.
  Lexeme get spaced => expand((pattern) => [ spacing, pattern ]).skip(1).toList().and;

  /// Transforms the current iterable of patterns into an AndLexeme with spaces in between, zero or more.
  Lexeme get optionalSpaced => expand((pattern) => [ spacing.optional, pattern ]).skip(1).and;
}