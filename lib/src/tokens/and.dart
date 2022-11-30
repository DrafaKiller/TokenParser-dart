import 'package:token_parser/src/tokens/bound.dart';

class AndToken<LeftToken extends Pattern, RightToken extends Pattern> extends BoundToken<LeftToken, RightToken> {
  AndToken(super.left, super.right, { super.name });

  @override
  String toString() => '(?:$left$right)';
}