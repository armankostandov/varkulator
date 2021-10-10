class Converter {
  static double toDouble(String s) {
    return double.parse(s.replaceAll("-", "").replaceAll(" ", "").replaceAll(",", ""));
  }
}