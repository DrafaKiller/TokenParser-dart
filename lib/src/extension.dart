import 'package:token_parser/src/lexeme.dart';

extension LexicalAnalysisPattern on Pattern {
  Lexeme lexeme([ String? name ]) {
    if (this is! Lexeme) return Lexeme.pattern(this, name: name);
    final lexeme = this as Lexeme;
    if (name == null) return lexeme;
    lexeme.name = name;
    return lexeme;
  }

  /* -= Lexeme Operations =- */

  Lexeme operator +(Pattern other) => Lexeme.and(this, other);
  Lexeme operator &(Pattern other) => Lexeme.and(this, other);
  Lexeme operator |(Pattern other) => Lexeme.or(this, other);
  
  /* -= Lexeme Modification =- */

  Lexeme get not => Lexeme.not(this);
  
  Lexeme get multiple => Lexeme.multiple(this);
  Lexeme get multipleOrNone => Lexeme.multiple(this, orNone: true);

  Lexeme get full => Lexeme.full(this);
  Lexeme get optional => Lexeme.optional(this);

  Lexeme get asBefore => Lexeme.regex('(?<=$this)');
  Lexeme get asNotBefore => Lexeme.regex('(?<!$this)');
  
  Lexeme get asAfter => Lexeme.regex('(?=$this)');
  Lexeme get asNotAfter => Lexeme.regex('(?!$this)');

  Lexeme get regex => Lexeme.regex(toString());
}