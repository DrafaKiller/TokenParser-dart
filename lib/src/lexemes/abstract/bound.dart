import 'package:token_parser/src/lexeme.dart';
import 'package:token_parser/src/lexemes/abstract/parent.dart';

mixin BoundLexeme on ParentLexeme {
  Lexeme get left => children.first;
  Lexeme get right => children.last;
}
