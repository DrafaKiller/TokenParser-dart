import 'package:token_parser/src/token.dart';
import 'package:token_parser/src/match.dart';

class EmptyToken extends Token {
  EmptyToken();

  @override
  TokenMatch<EmptyToken>? match(String string, [ int start = 0 ]) => TokenMatch.emptyAt(this, string, start);
}