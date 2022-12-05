import 'package:token_parser/token_parser.dart';

void main() {
  print(grammar.parse('letter = "A";'));
}

/* -= Basic Grammar =- */

final letter = '[a-zA-Z]'.regex;

final decimalDigit = '[0-9]'.regex;

final concatenateSymbol = ','.lexeme();

final definingSymbol = '='.lexeme();

final definitionSeperatorSymbol = '|' | '/' | '!';

final startCommentSymbol = '(*'.lexeme();

final startGroupSymbol = '('.lexeme();

final endCommentSymbol = '*)'.lexeme();

final endGroupSymbol = ')'.lexeme();

final endOptionSymbol = ']' | '/)';

final endRepeatSymbol = '}' | ':)';

final exceptSymbol = '-'.lexeme();

final firstQuoteSymbol = "'".lexeme();

final repetitionSymbol = '*'.lexeme();

final secondQuoteSymbol = '"'.lexeme();

final specialSequenceSymbol = '?'.lexeme();

final startOptionSymbol = '[' | '(/';

final startRepeatSymbol = '{' | '(:';

final terminatorSymbol = ';' | '.';

final otherCharacter =
  ' ' | ':' | '+' | '_' | '%' | '@' | '&' |
  '#' | r'$' | '<' | '>' | r'\' | '^' | '~';

final spaceCharacter = ' '.lexeme();

final horizontalTabulationCharacter = '\t'.lexeme();

final newLine = '\n'.lexeme();

final verticalTabulationCharacter = '\v'.lexeme();

final formFeed = '\r'.lexeme();

/* -= Extended Grammar =- */

final terminalCharacter = 
  letter
  | decimalDigit
  | concatenateSymbol
  | definingSymbol
  | definitionSeperatorSymbol
  | endCommentSymbol
  | endGroupSymbol
  | endOptionSymbol
  | endRepeatSymbol
  | exceptSymbol
  | firstQuoteSymbol
  | repetitionSymbol
  | secondQuoteSymbol
  | specialSequenceSymbol
  | startCommentSymbol
  | startGroupSymbol
  | startOptionSymbol
  | startRepeatSymbol
  | terminatorSymbol
  | otherCharacter;

final gapFreeSymbol =
  ((firstQuoteSymbol | secondQuoteSymbol) & terminalCharacter).not
  | terminalString;
  
final terminalString =
 (firstQuoteSymbol & firstTerminalCharacter & (firstTerminalCharacter).multiple.optional & firstQuoteSymbol)
  | (secondQuoteSymbol & secondTerminalCharacter & (secondTerminalCharacter).multiple.optional & secondQuoteSymbol);

final firstTerminalCharacter = (firstQuoteSymbol & terminalCharacter).not;

final secondTerminalCharacter = (secondQuoteSymbol & terminalCharacter).not;

final gapSeparator = 
  spaceCharacter
  | horizontalTabulationCharacter
  | newLine
  | verticalTabulationCharacter
  | formFeed;

final syntax = syntaxRule & (syntaxRule).multiple.optional;

final commentlessSymbol = 
  (
    (
      letter
      | decimalDigit
      | firstQuoteSymbol
      | secondQuoteSymbol
      | startCommentSymbol
      | endCommentSymbol
      | specialSequenceSymbol
      | otherCharacter
    ) & terminalCharacter
  ).not
  | metaIdentifier
  | integer
  | terminalString
  | specialSequence;

final integer = decimalDigit & (decimalDigit).multiple.optional;

final metaIdentifier = letter & metaIdentifierCharacter.multiple.optional;

final metaIdentifierCharacter = letter | decimalDigit;

final specialSequence = specialSequenceSymbol & specialSequenceCharacter.multiple.optional & specialSequenceSymbol;

final specialSequenceCharacter = (specialSequenceSymbol & terminalCharacter).not;

final commentSymbol =
  bracketedTextualComment
  | otherCharacter
  | commentlessSymbol;

final bracketedTextualComment = startCommentSymbol & reference('commentSymbol').multiple.optional & endCommentSymbol;

final syntaxRule = metaIdentifier & definingSymbol & definitionsList & terminatorSymbol;

final definitionsList = singleDefinition & (definitionSeperatorSymbol & singleDefinition).multiple.optional;

final singleDefinition = syntacticTerm & (concatenateSymbol & syntacticTerm).multiple.optional;

final syntacticTerm = syntacticFactor & (exceptSymbol & syntacticException).multiple.optional;

final syntacticException = syntacticFactor;

final syntacticFactor = (integer & repetitionSymbol).optional & syntacticPrimary;

final syntacticPrimary =
  optionalSequence
  | repeatedSequence
  | groupedSequence
  | metaIdentifier
  | terminalString
  | specialSequence
  | emptySequence;

final optionalSequence = startOptionSymbol & reference('definitionsList') & endOptionSymbol;

final repeatedSequence = startRepeatSymbol & reference('definitionsList') & endRepeatSymbol;

final groupedSequence = startGroupSymbol & reference('definitionsList') & endGroupSymbol;

final emptySequence = empty();

/* -= Grammar =- */

final grammar = Grammar(
  main: syntax,
  rules: {
    'letter': letter,
    'decimalDigit': decimalDigit,
    'concatenateSymbol': concatenateSymbol,
    'definingSymbol': definingSymbol,
    'definitionSeperatorSymbol': definitionSeperatorSymbol,
    'startCommentSymbol': startCommentSymbol,
    'startGroupSymbol': startGroupSymbol,
    'endCommentSymbol': endCommentSymbol,
    'endGroupSymbol': endGroupSymbol,
    'endOptionalSymbol': endOptionSymbol,
    'endRepeatSymbol': endRepeatSymbol,
    'exceptSymbol': exceptSymbol,
    'firstQuoteSymbol': firstQuoteSymbol,
    'repetitionSymbol': repetitionSymbol,
    'secondQuoteSymbol': secondQuoteSymbol,
    'specialSequenceSymbol': specialSequenceSymbol,
    'startOptionSymbol': startOptionSymbol,
    'startRepeatSymbol': startRepeatSymbol,
    'terminatorSymbol': terminatorSymbol,
    'otherCharacter': otherCharacter,
    'spaceCharacter': spaceCharacter,
    'horizontalTabulationCharacter': horizontalTabulationCharacter,
    'newLine': newLine,
    'verticalTabulationCharacter': verticalTabulationCharacter,
    'formFeed': formFeed,
    'terminalCharacter': terminalCharacter,
    'gapFreeSymbol': gapFreeSymbol,
    'terminalString': terminalString,
    'firstTerminalCharacter': firstTerminalCharacter,
    'secondTerminalCharacter': secondTerminalCharacter,
    'gapSeparator': gapSeparator,
    'syntax': syntax,
    'commentlessSymbol': commentlessSymbol,
    'integer': integer,
    'metaIdentifier': metaIdentifier,
    'metaIdentifierCharacter': metaIdentifierCharacter,
    'specialSequence': specialSequence,
    'specialSequenceCharacter': specialSequenceCharacter,
    'commentSymbol': commentSymbol,
    'bracketedTextualComment': bracketedTextualComment,
    'syntaxRule': syntaxRule,
    'definitionsList': definitionsList,
    'singleDefinition': singleDefinition,
    'syntacticTerm': syntacticTerm,
    'syntacticFactor': syntacticFactor,
    'syntacticPrimary': syntacticPrimary,
    'optionalSequence': optionalSequence,
    'repeatedSequence': repeatedSequence,
    'groupedSequence': groupedSequence,
    'emptySequence': emptySequence,
  }
);
