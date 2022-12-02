import 'package:token_parser/src/extension.dart';

final digit = '[0-9]'.regex;
final number = digit.multiple & ('.' & digit.multiple).optional;