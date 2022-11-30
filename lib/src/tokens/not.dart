import 'package:token_parser/src/match.dart';
import 'package:token_parser/src/tokens/pattern.dart';

class NotToken extends PatternToken {
  NotToken(super.pattern, { super.name });

  @override
  TokenMatch? matchAsPrefix(String string, [ int start = 0 ]) {
    final match = pattern.matchAsPrefix(string, start);
    if (match == null) return TokenMatch.emptyAt(this, string, start);
    return null;
  }

  @override
  String toString() => '(?!$pattern)';
}