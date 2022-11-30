import 'package:token_parser/src/token.dart';
import 'package:token_parser/src/match.dart';
import 'package:token_parser/src/pattern.dart';
import 'package:token_parser/src/navigation.dart';
import 'package:token_parser/src/tokens/reference.dart';
import 'package:token_parser/src/tokens/main.dart';
import 'package:token_parser/utils/iterable.dart';

class TokenParser {
  final Set<Token> tokens = {};
  TokenParser({ Map<String, Pattern>? tokens, Token? main }) {
    if (tokens != null) addAll(tokens);
    if (main != null) mainExpression = main;
  }

  TokenMatch? parse(String input, [ Token? main ]) {
    main ??= mainExpression;
    return main?.match(input);
  }
  
  void addMain(Token token) => addTokens([ token, MainToken(token) ]);

  Token? get mainExpression => token('(main)');

  set mainExpression(Token? token) {
    if (token != null) addMain(token);
  }

  /* Token Management */

  Token? token(String name) => tokens.firstWhereOrNull((token) => token.name == name);

  Token add(String name, Pattern token) {
    final resolved = token.token(name);
    addToken(resolved);
    return resolved;
  }

  Set<Token> addAll(Map<String, Pattern> tokens) {
    return tokens.entries.map((entry) => add(entry.key, entry.value.token())).toSet();
  }

  void addToken(Token token) {
    if (token.name == null) return;
    if (token is Navigable) {
      for (final reference in token.get<ReferenceToken>()) {
        reference.bind(this);
        if (reference.referenceName == '(self)') reference.referenceToken = token;
      }
    }

    tokens.add(token);
  }
  void addTokens(Iterable<Token> tokens) => tokens.forEach(addToken);
}
