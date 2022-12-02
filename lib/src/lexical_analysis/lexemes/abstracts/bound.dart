import 'package:token_parser/src/lexical_analysis/lexemes/abstracts/parent.dart';

mixin BoundLexeme<
  LeftPattern extends Pattern,
  RightPattern extends Pattern
> on ParentLexeme {
  LeftPattern get left;
  RightPattern get right;
}