import 'package:token_parser/src/tokens/reference.dart';

class SelfToken extends ReferenceToken {
  SelfToken({ super.parser }) : super('(self)');
}