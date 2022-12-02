import 'package:token_parser/src/lexical_analysis/lexemes/full.dart';

class MainLexeme extends FullLexeme {
  MainLexeme(super.pattern, { super.grammar }) : super(name: '(main)');
}