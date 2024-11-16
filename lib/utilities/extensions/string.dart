extension LastLettersString on String {
  String lastLetters(int n) {
    return substring(length - n);
  }
}
