import 'package:token_parser/token_parser.dart';

/* -= Basic Definitions =- */

final letter = '[a-zA-Z]'.regex;
final decimalDigit = '[0-9]'.regex;

final concatenateSymbol = ','.lexeme();
final definingSymbol = '='.lexeme();
final definitionSeperatorSymbol = '|' | '/' | '!';

final startGroupSymbol = '('.lexeme();
final endGroupSymbol = ')'.lexeme();

final startCommentSymbol = '(*'.lexeme();
final endCommentSymbol = '*)'.lexeme();

final startOptionSymbol = '[' | '(/';
final endOptionSymbol = ']' | '/)';

final startRepeatSymbol = '{' | '(:';
final endRepeatSymbol = '}' | ':)';

final exceptSymbol = '-'.lexeme();
final repetitionSymbol = '*'.lexeme();
final specialSequenceSymbol = '?'.lexeme();

final firstQuoteSymbol = "'".lexeme();
final secondQuoteSymbol = '"'.lexeme();

final terminatorSymbol = ';' | '.';

final otherCharacter = ' ' | ':' | '+' | '_' | '%' | '@' | '&' | '#' | r'$' | '<' | '>' | r'\' | '^' | '~';
final spaceCharacter = ' '.lexeme();

final horizontalTabulationCharacter = '\t'.lexeme();
final verticalTabulationCharacter = '\v'.lexeme();

final newLine = '\n';
final formFeed = '\r';

/* -= Extended Definitions =- */

// Terminal Symbols

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

final firstTerminalCharacter = (firstQuoteSymbol & terminalCharacter).not;

final secondTerminalCharacter = (secondQuoteSymbol & terminalCharacter).not;

final terminalString = 
  (firstQuoteSymbol & firstTerminalCharacter & firstTerminalCharacter.multiple.optional & firstQuoteSymbol)
  | (secondQuoteSymbol & secondTerminalCharacter & secondTerminalCharacter.multiple.optional & secondQuoteSymbol);

// Gap Symbols

final gapFreeSymbol =
  ((firstQuoteSymbol | secondQuoteSymbol) & terminalCharacter).not
  | terminalString;

final gapSeperator = 
  spaceCharacter
  | horizontalTabulationCharacter
  | newLine
  | verticalTabulationCharacter
  | formFeed;

// Meta Identifier

final metaIdentifierCharacter = letter | decimalDigit;

final metaIdentifier = letter & metaIdentifierCharacter.multiple.optional;

// Integer

final integer = decimalDigit & decimalDigit.multiple.optional;

// Sequence Symbols

final specialSequenceCharacter = (specialSequenceSymbol & terminalCharacter).not;

final specialSequence = specialSequenceSymbol & specialSequenceCharacter.multiple.optional & specialSequenceSymbol;

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
    )
    & terminalCharacter
  ).not
  | metaIdentifier
  | integer
  | terminalString
  | specialSequence;

final bracketedTextualComment = startCommentSymbol & reference('commentSymbol') & endCommentSymbol;

final commentSymbol =
  bracketedTextualComment
  | otherCharacter
  | commentlessSymbol;

final optionalSequence = startOptionSymbol & reference('definitionsList') & endOptionSymbol;

final repeatedSequence = startRepeatSymbol & reference('definitionsList') & endRepeatSymbol;

final groupedSequence = startGroupSymbol & reference('definitionsList') & endGroupSymbol;

final emptySequence = empty();

// Syntax Definition

final syntaticPrimary =
  optionalSequence
  | repeatedSequence
  | groupedSequence
  | metaIdentifier
  | terminalString
  | specialSequence
  | emptySequence;

final syntaticFactor = (integer & repetitionSymbol).optional & syntaticPrimary;

final syntaticException = syntaticFactor;

final syntaticTerm = syntaticFactor & (exceptSymbol & syntaticException).optional;

final singleDefinition = syntaticTerm & (concatenateSymbol & syntaticTerm).multiple.optional;

final definitionsList = singleDefinition & (definitionSeperatorSymbol & singleDefinition).multiple;

final syntaxRule = metaIdentifier & definingSymbol & definitionsList & terminatorSymbol;

final syntax = syntaxRule & syntaxRule.multiple.optional;

/* -= Grammar =- */

final grammar = Grammar(
  main: syntax,
  definitions: {
    'letter': letter,
    'decimalDigit': decimalDigit,
    'concatenateSymbol': concatenateSymbol,
    'definingSymbol': definingSymbol,
    'definitionSeperatorSymbol': definitionSeperatorSymbol,
    'startCommentSymbol': startCommentSymbol,
    'startGroupSymbol': startGroupSymbol,
    'endCommentSymbol': endCommentSymbol,
    'endGroupSymbol': endGroupSymbol,
    'endOptionSymbol': endOptionSymbol,
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
    'gapSeperator': gapSeperator,
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
    'syntaticTerm': syntaticTerm,
    'syntaticException': syntaticException,
    'syntaticFactor': syntaticFactor,
    'syntaticPrimary': syntaticPrimary,
    'optionalSequence': optionalSequence,
    'repeatedSequence': repeatedSequence,
    'groupedSequence': groupedSequence,
    'emptySequence': emptySequence,
  }
);

void main() {
  final result = grammar.parse('letter="A";');

  print(result);
}