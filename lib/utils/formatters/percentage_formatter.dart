import 'package:flutter/services.dart';

class PercentageFormatter extends TextInputFormatter {

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue,TextEditingValue newValue,) {
    if (newValue.text == '') {
      return newValue;
    } else if(newValue.text == '0') {
      return oldValue;
    } else if (newValue.text == '.') {
      return oldValue;
    } else if(double.parse(newValue.text) < 0) {
      return const TextEditingValue().copyWith(text: '0');
    } else if (double.parse(newValue.text) > 100) {
      return oldValue;
    } else {
      return newValue;
    }
  }
}