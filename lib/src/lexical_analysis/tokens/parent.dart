import 'package:token_parser/src/lexical_analysis/lexeme.dart';
import 'package:token_parser/src/lexical_analysis/token.dart';
import 'package:token_parser/utils/iterable.dart';

class TokenParent extends Token {
  @override final List<Match> children;

  TokenParent(Lexeme pattern, this.children) : super(
    pattern,
    children.firstOrNull?.input ?? '',
    children.firstOrNull?.start ?? 0,
    children.lastOrNull?.end ?? 0
  );

  @override String? operator [](int group) {
    if (group == 0) return value;
    for (final child in children) {
      if (group <= child.groupCount) return child.group(group);
      group -= child.groupCount;
    }
    return null;
  }

  @override int get groupCount => children.fold(0, (count, child) => count + child.groupCount);
}