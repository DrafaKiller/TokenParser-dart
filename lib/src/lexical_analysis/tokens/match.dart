import 'package:token_parser/src/lexical_analysis/lexeme.dart';

class TokenMatch extends TokenParent {
  final Match match;

  TokenMatch(Lexeme pattern, this.match) : super(pattern, [ match ]);

  @override String? operator [](int group) {
    if (group == 0) return value;
    return match[group];
  }
  
  @override String? group(int group) => match.group(group);
  @override List<String?> groups(List<int> groupIndices) => match.groups(groupIndices);
  @override int get groupCount => match.groupCount;
}
