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

  String result = "Վարկը կմարվի 0 տարի 0 ամիս անց";
  double amount = 0;
  double percent = 0;
  double eachMonthPayment = 0;
  double incomeTax = 0;
  bool isIncomeTaxEnabled = false;

  String info = "Հաշվարկը դեռ կատարված չէ";

  double convertToDouble(String s) {
    return double.parse(s.replaceAll(",", '.').replaceAll("-", "replace").replaceAll(" ", ""));
  }

  void calculate(double amount, double percent, double eachMonthPayment, double incomeTax) {
    if (eachMonthPayment <= amount * percent / 1200) {
      setState(() {
        result = "\t Տվյալ ամսեվճարով վարկը հնարավոր չէ մարել";
        info = "\t Ամսեվճարը պետք է գերազանցի ամսվա բանկային տոկոսների վճարը";
      });
      return;
    }

    int counter = 0;
    double eachMonthBankBill;
    double diff;

    double sumBankBill = 0;
    double userPayedBankBill = 0;

    while (amount > 0) {
      eachMonthBankBill = amount * percent / 1200;
      sumBankBill += eachMonthBankBill;
      if (eachMonthBankBill > incomeTax) {
        diff = eachMonthPayment - (eachMonthBankBill - incomeTax);
        userPayedBankBill += eachMonthBankBill - incomeTax;
      } else {
        diff = eachMonthPayment;
      }
      amount -= diff;
      counter++;
    }

    setState(() => {
          result = "Վարկը կմարվի ${counter ~/ 12} տարի ${counter % 12} ամիս անց",
          info = "\t Ամսեկան $eachMonthPayment վճարելով վարկը կմարվի ${counter ~/ 12} տարի, ${counter % 12} ամիս անց \t\n\n",
          info += "\t Ընդհանուր տոկոսների համար վճարվելու է: $sumBankBill \t\n",
          info += "\t Որից դուք վճարելու եք: $userPayedBankBill \t\n",
          info += "\t Որից պետությունը կվճարի: ${sumBankBill - userPayedBankBill} \t"
        });
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
            inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[^0-9.]+')), FilteringTextInputFormatter.deny("..")],
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
            inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[^0-9.]+')), FilteringTextInputFormatter.deny("..")],
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
            inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[^0-9.]+')), FilteringTextInputFormatter.deny("..")],
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
              inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[^0-9.]+')), FilteringTextInputFormatter.deny("..")],
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
                eachMonthPayment = convertToDouble(eachMonthPaymentController.text);
                incomeTax = isIncomeTaxEnabled ? convertToDouble(incomeTaxController.text) : 0;
                calculate(amount, percent, eachMonthPayment, incomeTax);
                FocusScope.of(context).unfocus();
              });
            },
            child: const Text('Հաշվել'),
          ),
        ),
        Text(result),
        Padding(
          padding: const EdgeInsets.all(40),
          child: IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => SimpleDialog(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(info),
                )
              ]),
            ),
          ),
        ),
      ],
    );
  }
}
