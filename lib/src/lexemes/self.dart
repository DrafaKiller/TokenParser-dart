import 'package:token_parser/src/lexemes/reference.dart';

class SelfLexeme extends ReferenceLexeme {
  SelfLexeme({ super.grammar }) : super('(self)');
}
