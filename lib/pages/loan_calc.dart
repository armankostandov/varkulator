import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:vark_calc/utils/formatters/percentage_formatter.dart';
import 'package:vark_calc/utils/converter.dart';

class LoanCalcForm extends StatefulWidget {
  const LoanCalcForm({Key? key}) : super(key: key);

  @override
  _LoanCalcFormState createState() => _LoanCalcFormState();
}

class _LoanCalcFormState extends State<LoanCalcForm> {
  late TextEditingController amountController;
  late TextEditingController percentController;
  late TextEditingController monthsController;

  @override
  void initState() {
    amountController = TextEditingController();
    percentController = TextEditingController();
    monthsController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    amountController.dispose();
    percentController.dispose();
    monthsController.dispose();
    super.dispose();
  }

  int result = 0;
  double amount = 0;
  double percent = 0;
  double months = 0;

  int calculate(double amount, double percent, double months) {
    double monthPercent = percent / 1200;
    double koef = monthPercent / (1 - pow(1 + monthPercent, -1 * months));
    return (amount * koef).round();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            controller: amountController,
            keyboardType: const TextInputType.numberWithOptions(signed: true),
            inputFormatters: [ThousandsFormatter()],
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Վարկի գումարը։',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            controller: percentController,
            keyboardType: const TextInputType.numberWithOptions(signed: true),
            inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[^0-9.]+')), FilteringTextInputFormatter.deny(".."), PercentageFormatter()],
            decoration: const InputDecoration(
              suffix: Text("%"),
              border: UnderlineInputBorder(),
              labelText: 'Վարկավորման տոկոսադրույքը։',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            controller: monthsController,
            keyboardType: const TextInputType.numberWithOptions(signed: true),
            maxLength: 3,
            inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[^0-9.]+')), FilteringTextInputFormatter.deny("..")],
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Քանի ամսում է մարվելու վարկը։',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(200, 40),
            ),
            onPressed: () {
              setState(() {
                amount = Converter.toDouble(amountController.text);
                percent = Converter.toDouble(percentController.text);
                months = Converter.toDouble(monthsController.text);

                result = calculate(amount, percent, months);
                FocusScope.of(context).unfocus();
              });
            },
            child: const Text('Հաշվել'),
          ),
        ),
        Text("Ամենամսյա գումարը։ ${NumberFormat.decimalPattern().format(result)}"),
      ],
    );
  }
}
