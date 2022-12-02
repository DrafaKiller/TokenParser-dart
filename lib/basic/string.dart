import 'package:token_parser/src/extension.dart';
import 'package:token_parser/basic_lexemes.dart';

final identifier = (letter | '_') & (letter | digit | '_').multiple.optional;

final string = '"' & '[^"]*'.regex & '"'
             | "'" & "[^']*".regex & "'";

final word = (letter | '_' | '-').multiple;
final phrase = ((word | specialCharacter) & whitespace.multiple.optional).multiple;
final sentence = (phrase | lineBreak).multiple;