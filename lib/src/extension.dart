import 'package:token_parser/src/lexeme.dart';

extension LexicalAnalysisPattern on Pattern {
  /// Transforms the current pattern into a Lexeme that can be used for lexical analysis.
  /// If the pattern is already a Lexeme, it is returned as is.
  /// 
  /// A name can be provided to replace the current name of the Lexeme.
  Lexeme lexeme([ String? name ]) {
    if (this is! Lexeme) return Lexeme.pattern(this, name: name);
    final lexeme = this as Lexeme;
    if (name == null) return lexeme;
    lexeme.name = name;
    return lexeme;
  }

  /* -= Lexeme Operations =- */

  Lexeme operator +(Pattern other) => this & other;
  Lexeme operator &(Pattern other) => Lexeme.and(this, other);
  Lexeme operator |(Pattern other) => Lexeme.or(this, other);
  
  /* -= Lexeme Modification =- */

  /// Allows the current pattern to be matched multiple times.
  /// The result of the match will be grouped into a single token.
  /// 
  /// This lexeme must be matched at least once.
  /// 
  /// Equivalent to `this+`.
  Lexeme get multiple => Lexeme.multiple(this);

  /// Allows the current pattern to be matched multiple times.
  /// The result of the match will be grouped into a single token.
  /// 
  /// This lexeme can be matched zero or more times.
  /// 
  /// Equivalent to `this*`.
  Lexeme get multipleOrNone => Lexeme.multiple(this, orNone: true);

  /// Ensures that the current pattern is not matched.
  Lexeme get not => Lexeme.not(this);
  
  /// Ensures that the current pattern is matched from the start of the input to the end.
  /// 
  /// Equivalent to `^this$`.
  Lexeme get full => Lexeme.full(this);
  
  /// Allows the current pattern to be matched zero or one time.
  /// 
  /// Equivalent to `this?`.
  Lexeme get optional => Lexeme.optional(this);

  /// Matches the next character with a pattern.
  /// 
  /// The pattern may be more than one character,
  /// but the resulting token will only be the first character.
  Lexeme get character => Lexeme.character(this);

  /// Matches the next character with the negative of a pattern.
  /// 
  /// The pattern may be more than one character,
  /// but the resulting token will only be the first character.
  Lexeme get notCharacter => Lexeme.character(this, not: true);

  /// Surrounds the current pattern with another pattern.
  /// The pattern is multiple and optional.
  /// 
  /// Equivalent to `pattern*-this-pattern*`.
  Lexeme pad(Pattern pattern) => Lexeme.andAll([ pattern.multiple.optional, this, pattern.multiple.optional ]);

  /// Transforms the current pattern into a RegExp lexeme.
  /// 
  /// Should only be used on string patterns,
  /// as this will destroy any other lexemes defined within the pattern.
  Lexeme get regex => Lexeme.regex(toString());

  Lexeme get asBefore => Lexeme.regex('(?<=$this)');
  Lexeme get asNotBefore => Lexeme.regex('(?<!$this)');
  
  Lexeme get asAfter => Lexeme.regex('(?=$this)');
  Lexeme get asNotAfter => Lexeme.regex('(?!$this)');
}

/* -= Top-level Referencing =- */

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

/* -= Top-level Lexemes =- */

/// Creates a lexeme that always matches, because it's an empty rule.
final empty = Lexeme.empty;