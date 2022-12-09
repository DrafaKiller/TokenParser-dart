import 'package:token_parser/src/lexeme.dart';
import 'package:token_parser/src/extensions/top_level.dart';

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

  /// Lexical operator to negate the current pattern and comsume the next character.
  /// 
  /// Equivalent to `this.not.character`.
  Lexeme operator -() => not.character;

  /// Lexical operator to add spacing around the current pattern.
  /// The spacing is multiple and optional.
  /// 
  /// Equivalent to `this.spaced`.
  Lexeme operator ~() => spaced;

  /// Lexical operator to add spacing in between the current pattern and the next pattern.
  /// The spacing is multiple.
  /// 
  /// Equivalent to `this & spacing.multiple & pattern`.
  Lexeme operator >(Pattern other) => Lexeme.andAll([ this, spacing.multiple, other ]);

  /// Lexical operator to add spacing in between the current pattern and the next pattern.
  /// The spacing is multiple.
  /// 
  /// Equivalent to `this & spacing.multiple & pattern`. 
  Lexeme operator >>(Pattern other) => Lexeme.andAll([ this, spacing.multiple, other ]);

  /// Lexical operator to add spacing in between the current pattern and the next pattern.
  /// The spacing is multiple and optional.
  /// 
  /// Equivalent to `this & spacing.multiple.optional & pattern`.
  Lexeme operator >=(Pattern other) => Lexeme.andAll([ this, spacing.multiple.optional, other ]);

  /// Lexical operator to add spacing in between the current pattern and the next pattern.
  /// The spacing is multiple and optional.
  /// 
  /// Equivalent to `this & spacing.multiple.optional & pattern`.
  Lexeme operator *(Pattern other) => Lexeme.andAll([ this, spacing.multiple.optional, other ]);

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
  Lexeme get multipleOrNone => multiple.optional;

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
  
  /// Adds spacing to the surrounding of the current pattern.
  /// The spacing is multiple and optional.
  /// 
  /// Equivalent to `this.gap(spacing)`.
  Lexeme get spaced => pad(spacing);

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

  /// Match the current pattern until another pattern is matched.
  Lexeme until(Pattern pattern) => Lexeme.until(this, pattern);

  /// Repeat the current pattern a specific number of times.
  /// A maximum number of times can also be provided.
  /// 
  /// Equivalent to `this{min,max}`.
  Lexeme repeat(int min, [ int? max ]) => Lexeme.repeat(this, min, max: max);

  Lexeme get asBefore => Lexeme.regex('(?<=${ lexeme().regexString })');
  Lexeme get asNotBefore => Lexeme.regex('(?<!${ lexeme().regexString })');
  
  Lexeme get asAfter => Lexeme.regex('(?=${ lexeme().regexString })');
  Lexeme get asNotAfter => Lexeme.regex('(?!${ lexeme().regexString })');
  
  /* -= Lazy Lexeme Modification =- */

  Lexeme get plus => multiple;
  Lexeme get star => multiple.optional;
  Lexeme get question => optional;
}