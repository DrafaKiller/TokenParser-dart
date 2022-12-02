import 'package:token_parser/src/lexemes/full.dart';

class MainLexeme extends FullLexeme {
  MainLexeme(super.pattern, { super.grammar }) : super(name: '(main)');
}