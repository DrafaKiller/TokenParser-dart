import 'package:token_parser/src/match.dart';
import 'package:token_parser/src/tokens/bound.dart';
import 'package:token_parser/src/tokens/reference.dart';
import 'package:token_parser/utils/string.dart';

class OrToken<LeftToken extends Pattern, RightToken extends Pattern> extends BoundToken<LeftToken, RightToken> {
  final bool rightPriority;

  OrToken(super.left, super.right, { super.name, this.rightPriority = false });

  @override
  TokenMatch<OrToken<LeftToken, RightToken>>? match(String string, [ int start = 0 ]) {
    if (!rightPriority) {
      final leftMatch = ReferenceToken.matchOnce(this, left, string, start);
      if (leftMatch != null) return TokenMatch(this, leftMatch);

      final rightMatch = ReferenceToken.matchOnce(this, right, string, start);
      if (rightMatch != null) return TokenMatch(this, rightMatch);
    } else {
      final rightMatch = ReferenceToken.matchOnce(this, right, string, start);
      if (rightMatch != null) return TokenMatch(this, rightMatch);
      
      final leftMatch = ReferenceToken.matchOnce(this, left, string, start);
      if (leftMatch != null) return TokenMatch(this, leftMatch);
    }
    return null;
  }

  @override
  String toString() => 
    !rightPriority
      ? '(?:${ escapeString(left) }|${ escapeString(right) })'
      : '(?:${ escapeString(right) }|${ escapeString(left) })';
}