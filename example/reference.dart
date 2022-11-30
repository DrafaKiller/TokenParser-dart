import 'package:token_parser/token_parser.dart';

void main() {
  final expression = 'a' & Token.reference('characterB').optional;
  final characterB = 'b'.token();

  final recursive = 'a' & Token.self().optional;

  final parser = TokenParser(
    main: expression,
    tokens: {
      'expression': expression,
      'characterB': characterB,
      
      'recursive': recursive,
    }
  );

  print(parser.parse('ab')?.get(characterB));
  print(parser.parse('aaa', recursive)?.get(recursive));
}