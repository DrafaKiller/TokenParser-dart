import 'package:token_parser/src/tokens/full.dart';

class MainToken<PatternT extends Pattern> extends FullToken<PatternT> {
  MainToken(super.pattern) : super(name: '(main)');
}