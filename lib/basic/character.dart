import 'package:token_parser/src/extension.dart';
import 'package:token_parser/basic_lexemes.dart';

final lowercaseLetter = '[a-z]'.regex;
final uppercaseLetter = '[A-Z]'.regex;
final letter = lowercaseLetter | uppercaseLetter;

final ponctuation = '.' | ',' | ';' | ':' | '!' | '?';
final brackets = '(' | ')' | '[' | ']' | '{' | '}' | '<' | '>';
final quotes = '"' | "'";
final operator = '+' | '-' | '*' | '/';
final cunracy = r'$' | '£' | '€' | '¥' | '₽';
final special = '_' | '#' | '@' | '~' | '`' | '´' | '^' | '&' | '|' | '=' | r'\' | '%' | 'º' | 'ª' | '«' | '»'; 

final specialCharacter = ponctuation | brackets | quotes | operator | special;
final character = letter | digit | specialCharacter;