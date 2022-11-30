import 'package:token_parser/src/token.dart';
import 'package:token_parser/src/match.dart';
import 'package:token_parser/src/navigation.dart';

class PatternToken<PatternT extends Pattern> extends Token with Navigable {
  final PatternT pattern;

  PatternToken(this.pattern, { super.name });
  static PatternToken<RegExp> regex(String string, { String? name }) => PatternToken(RegExp(string), name: name);

  /* -= Relation Methods =- */
  
  @override
  bool operator ==(Object other) {
    if (other is PatternToken) {
      if (name != null || other.name != null) return name == other.name;
      return pattern == other.pattern;
    }

    if (other is Pattern) return other == pattern;
    return hashCode == other.hashCode;
  }
  
  @override
  int get hashCode => name.hashCode ^ pattern.hashCode;

  
  @override
  List<Pattern> get children => [ pattern ];

  /* -= Pattern Methods =- */
  
  @override
  TokenMatch<PatternToken<PatternT>>? match(String string, [ int start = 0 ]) {
    final match = pattern.matchAsPrefix(string, start);
    if (match == null) return null;
    
    return TokenMatch(this, match);
  }

  @override
  String toString() => 
    pattern is RegExp
      ? (pattern as RegExp).pattern
    : pattern is String
      ? RegExp.escape(pattern as String)
    : pattern.toString();
}