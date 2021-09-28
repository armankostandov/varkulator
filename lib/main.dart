import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vark_calc/pages/duration_calc.dart';
import 'package:vark_calc/pages/loan_calc.dart';

void main() => runApp(const Varkulator());

class Varkulator extends StatelessWidget {
  const Varkulator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Վարկավորման հաշվիչ';
    return const MaterialApp(
      title: appTitle,
      debugShowCheckedModeBanner: false,
      home: VarkulatorStatefulWidget(),
    );
  }
}

class VarkulatorStatefulWidget extends StatefulWidget {
  const VarkulatorStatefulWidget({Key? key}) : super(key: key);

  @override
  State<VarkulatorStatefulWidget> createState() => _VarkulatorStatefulWidgetState();
}

class _VarkulatorStatefulWidgetState extends State<VarkulatorStatefulWidget> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    ConstrainedBox(constraints: const BoxConstraints(), child: const DurationCalcForm()),
    ConstrainedBox(constraints: const BoxConstraints(), child: const LoanCalcForm()),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Վարկավորման հաշվիչ';
    return MaterialApp(
      title: appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.deepOrange,
        primaryColor: Colors.deepOrange,
        fontFamily: 'Georgia',
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          bodyText2: TextStyle(fontSize: 16.0, fontFamily: 'Hind'),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
          leading: const Icon(
            Icons.calculate,
          ),
        ),
        body: SingleChildScrollView(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.timer),
              label: 'Վարկի ժամկետ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.monetization_on),
              label: 'Ամսական վճար',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.deepOrange,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
