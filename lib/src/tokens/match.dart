import 'package:token_parser/src/lexeme.dart';
import 'package:token_parser/src/token.dart';

class TokenMatch<LexemeT extends Lexeme> extends Token<LexemeT> {
  final Match match;

  TokenMatch(LexemeT pattern, this.match) : super(
    pattern,
    match.input,
    match.start,
    match.end,
    children: {
      if (match is Token) match,
    }
  );

  @override String? operator [](int group) {
    if (group == 0) return value;
    return match[group];
  }
  
  @override String? group(int group) => match.group(group);
  @override List<String?> groups(List<int> groupIndices) => match.groups(groupIndices);
  @override int get groupCount => match.groupCount;
}