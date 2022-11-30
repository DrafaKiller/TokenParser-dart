String escapeString(Pattern pattern) {
  if (pattern is! String) return pattern.toString();
  return RegExp.escape(pattern);
}