import 'package:token_parser/src/debug.dart';
import 'package:token_parser/src/extensions/tokenize.dart';
import 'package:token_parser/src/token.dart';
import 'package:token_parser/src/lexemes/abstract/parent.dart';
import 'package:token_parser/src/lexemes/abstract/bound.dart';

class OrLexeme extends ParentLexeme {
  final bool priorityRight;
  OrLexeme(super.children, { this.priorityRight = false, super.name, super.grammar });

  @override
  Token tokenize(String string, [ int start = 0 ]) {
    DebugGrammar.debug(this, string, start);
    
    for (final child in (priorityRight ? children.reversed : children)) {
      final token = child.optionalTokenizeFrom(this, string, start);
      if (token != null) return Token.match(this, token);
    }
    return Token.mismatch(this, string, start);
  }

  @override
  String get regexString => children.isNotEmpty
    ? children.length == 1
      ? children.first.toString()
      : '(?:${ children.map((token) => token.regexString).join('|') })'
    : '';
}

class OrBoundLexeme extends OrLexeme with BoundLexeme {
  OrBoundLexeme(Pattern left, Pattern right, {
    super.priorityRight,
    super.name,
    super.grammar
  }) : super([ left, right ]);

  @override
  Token tokenize(String string, [ int start = 0 ]) {
    DebugGrammar.debug(this, string, start);

    if (!priorityRight) {
      final leftMatch = left.optionalTokenizeFrom(this, string, start);
      if (leftMatch != null) return Token.match(this, leftMatch);

      final rightMatch = right.optionalTokenizeFrom(this, string, start);
      if (rightMatch != null) return Token.match(this, rightMatch);
    } else {
      final rightMatch = right.optionalTokenizeFrom(this, string, start);
      if (rightMatch != null) return Token.match(this, rightMatch);

      final leftMatch = left.optionalTokenizeFrom(this, string, start);
      if (leftMatch != null) return Token.match(this, leftMatch);
    }
    return Token.mismatch(this, string, start);
  }
}
