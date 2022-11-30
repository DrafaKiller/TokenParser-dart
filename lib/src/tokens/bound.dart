import 'package:token_parser/src/tokens/parent.dart';

class BoundToken<LeftPattern extends Pattern, RightPattern extends Pattern> extends ParentToken {
  final LeftPattern left;
  final RightPattern right;

  BoundToken(this.left, this.right, { super.name }) : super([ left, right ]);

  @override
  String toString() => '(?:$left$right)';
}