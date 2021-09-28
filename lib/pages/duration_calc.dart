import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DurationCalcForm extends StatefulWidget {
  const DurationCalcForm({Key? key}) : super(key: key);

  @override
  _DurationCalcFormState createState() => _DurationCalcFormState();
}

class _DurationCalcFormState extends State<DurationCalcForm> {
  late TextEditingController amountController;
  late TextEditingController percentController;
  late TextEditingController eachMonthPaymentController;
  late TextEditingController incomeTaxController;

  @override
  void initState() {
    amountController = TextEditingController();
    percentController = TextEditingController();
    eachMonthPaymentController = TextEditingController();
    incomeTaxController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    amountController.dispose();
    percentController.dispose();
    eachMonthPaymentController.dispose();
    incomeTaxController.dispose();
    super.dispose();
  }

  int result = 0;
  double amount = 0;
  double percent = 0;
  double eachMonthPayment = 0;
  double incomeTax = 0;
  bool isIncomeTaxEnabled = false;

  double convertToDouble(String s) {
    return double.parse(
        s.replaceAll(",", '.').replaceAll("-", "replace").replaceAll(" ", ""));
  }

  int calculate(double amount, double percent, double eachMonthPayment,
      double incomeTax) {
    int counter = 0;
    double eachMonthBankBill;
    double diff;

    while (amount > 0) {
      eachMonthBankBill = amount * percent / 1200;
      if (eachMonthBankBill > incomeTax) {
        diff = eachMonthPayment - (eachMonthBankBill - incomeTax);
      } else {
        diff = eachMonthPayment;
      }
      amount -= diff;
      counter++;
    }

    return counter;
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
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r'[^0-9.]+')),
              FilteringTextInputFormatter.deny("..")
            ],
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Վարկի մնացորդը։',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            controller: percentController,
            keyboardType: const TextInputType.numberWithOptions(signed: true),
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r'[^0-9.]+')),
              FilteringTextInputFormatter.deny("..")
            ],
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Վարկավորման տոկոսադրույքը։',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            controller: eachMonthPaymentController,
            keyboardType: const TextInputType.numberWithOptions(signed: true),
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r'[^0-9.]+')),
              FilteringTextInputFormatter.deny("..")
            ],
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Որքան եք վճարելու ամսեկան։',
            ),
          ),
        ),
        CheckboxListTile(
          title: const Text("Գործում է եկամտահարկի օրենքը։ "),
          controlAffinity: ListTileControlAffinity.leading,
          value: isIncomeTaxEnabled,
          onChanged: (value) {
            setState(() {
              isIncomeTaxEnabled = value!;
            });
          },
        ),
        Visibility(
          visible: isIncomeTaxEnabled,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
              controller: incomeTaxController,
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'[^0-9.]+')),
                FilteringTextInputFormatter.deny("..")
              ],
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Եկամտահարկի գումարը։',
              ),
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
                amount = convertToDouble(amountController.text);
                percent = convertToDouble(percentController.text);
                eachMonthPayment =
                    convertToDouble(eachMonthPaymentController.text);
                incomeTax = isIncomeTaxEnabled ? convertToDouble(incomeTaxController.text) : 0;
                result =
                    calculate(amount, percent, eachMonthPayment, incomeTax);
              });
            },
            child: const Text('Հաշվել'),
          ),
        ),
        Text("Վարկը կմարվի ${result ~/ 12} տարի ${result % 12} ամիս անց")
      ],
    );
  }
}
