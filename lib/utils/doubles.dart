String minimizeDecimalPlaces(double value) {
  String strValue = value.toString();

  if (strValue.contains('.')) {
    List<String> parts = strValue.split('.');
    if (parts[1] == '0' || parts[1].isEmpty) {
      return parts[0];
    }
    String decimalPart = parts[1].replaceAll(RegExp(r'0*$'), '');
    if (decimalPart.isEmpty) {
      return parts[0];
    }
    return '${parts[0]}.$decimalPart';
  } else {
    return strValue;
  }
}
