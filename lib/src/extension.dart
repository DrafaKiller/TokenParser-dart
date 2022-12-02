import 'package:token_parser/src/lexeme.dart';
import 'package:token_parser/src/lexemes/and.dart';
import 'package:token_parser/src/lexemes/or.dart';

extension LexicalAnalysisPattern on Pattern {
  Lexeme lexeme([ String? name ]) {
    if (this is! Lexeme) return Lexeme.pattern(this, name: name);
    final lexeme = this as Lexeme;
    if (name == null) return lexeme;
    lexeme.name = name;
    return lexeme;
  }

  /* -= Lexeme Operations =- */

  Lexeme operator +(Pattern other) => this & other;
  Lexeme operator &(Pattern other) => this is AndLexeme
    ? Lexeme.andAll([ ...(this as AndLexeme).children, if (other is AndLexeme) ...other.children else other ])
    : Lexeme.and(this, other);

  Lexeme operator |(Pattern other) => this is OrLexeme
    ? Lexeme.orAll([ ...(this as OrLexeme).children, if (other is OrLexeme) ...other.children else other ])
    : Lexeme.or(this, other);
  
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

final reference = Lexeme.reference;
final ref = Lexeme.ref;
final self = Lexeme.self;