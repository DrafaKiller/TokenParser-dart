/* -= Referencing =- */

import 'package:token_parser/src/lexeme.dart';
import 'package:token_parser/src/extensions/pattern.dart';

/// Creates a reference to a lexeme, that binded to a grammar,
/// will be replaced by the lexeme with the same name when tokenized.
/// 
/// Short version: `.ref`
final reference = Lexeme.reference;

/// Creates a reference to a lexeme, that binded to a grammar,
/// will be replaced by the lexeme with the same name when tokenized.
/// 
/// Original version: `.reference`
final ref = Lexeme.ref;

/// Creates a reference to a lexeme, that binded to a grammar,
/// will be replaced by the lexeme with the same name when tokenized.
/// 
/// This reference takes the name of the parent lexeme added to the grammar.
final self = Lexeme.self;

/* -= Lexemes =- */

/// Creates a lexeme that always matches, because it's an empty rule.
final empty = Lexeme.empty;

/* -= Lexemes - Spacing =- */

final whitespace = (' ' | '\t').lexeme('whitespace');
final newLine = ('\n' | '\r' | '\f').lexeme('newLine');

/// **Top-level Lexeme:**<br>
/// Matches a space character.
final space = (whitespace | newLine).lexeme('space');

/// **Top-level Lexeme:**<br>
/// Matches multiple space character.
final spacing = space.multiple.lexeme('spacing');

/* -= Top-level Lexemes - Start & End =- */

/// **Top-level Lexeme:**<br>
/// Ensures the start of the input is matched.
final start = Lexeme.start();

/// **Top-level Lexeme:**<br>
/// Ensures the end of the input is matched.
final end = Lexeme.end();

/// **Top-level Lexeme:**<br>
/// Ensures the start of a line is matched, before.
final startLine = newLine.asBefore;

/// **Top-level Lexeme:**<br>
/// Ensures the end of a line is matched, after.
final endLine = newLine.asAfter;

/* -= Lexeme Factories =- */

/// Creates a lexeme that matches any character, once.
Lexeme any({ Pattern? not }) {
  if (not != null) return -not;
  return Lexeme.any();
}

/// Matches any character until a pattern is matched.
/// This lexeme is optional.
Lexeme anyUntil(Pattern pattern) => any().until(pattern).optional;