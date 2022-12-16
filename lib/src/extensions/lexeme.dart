import 'package:token_parser/src/lexeme.dart';

extension LexicalAnalysisLexeme on Lexeme {
  /// Creates a copy of the lexeme, with the same properties.
  /// 
  /// This is useful to avoid having duplicate lexeme variable references.
  /// 
  /// ```dart
  /// final grammar = Grammar(
  ///   main: ...,
  ///   rules: {
  ///     'a': a,
  ///     'a2': a2,
  ///   },
  /// );
  /// 
  /// final a = 'a'.lexeme();
  /// final a2 = a.copy();
  /// ```
  Lexeme copy([ String? name ]) => Lexeme.pattern(this, name: name);
}