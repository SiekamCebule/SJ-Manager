extension StringLastChars on String {
  String? lastNChars(int n) {
    if (length >= n) {
      return substring(length - n);
    } else {
      return null;
    }
  }
}
