import 'package:token_parser/src/lexical_analysis/lexemes/reference.dart';

class SelfLexeme extends ReferenceLexeme {
  SelfLexeme({ super.grammar }) : super('(self)');
}