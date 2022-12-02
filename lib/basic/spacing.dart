import 'package:token_parser/src/extension.dart';

final whitespace = ' ' | '\t';
final lineBreak = '\n' | '\r';
final space = (whitespace | lineBreak).multiple;