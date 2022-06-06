
import 'package:calculate_app/Calculator/calculator-buttons.dart';
import 'package:calculate_app/Calculator/calculator.dart';
import 'package:calculate_app/Calculator/history.dart';
import 'package:calculate_app/Calculator/number-display.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isNewEquation = true;
  List<double> values = [];
  List<String> operations = [];
  List<String> calculations = [];
  String calculatorString = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.history_rounded),
            onPressed: () {
              _navigateAndDisplayHistory(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          NumberDisplay(value: calculatorString),
          CalculatorButtons(onTap: _onPressed),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }

  _navigateAndDisplayHistory(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => History(operations: calculations)));

    if (result != null) {
      setState(() {
        isNewEquation = false;
        calculatorString = Calculator.parseString(result);
      });
    }
  }

  void _onPressed({String? buttonText}) {
    // Standard mathematical operations
    if (Calculations.OPERATIONS.contains(buttonText)) {
      return setState(() {
        operations.add(buttonText!);
        calculatorString += " $buttonText ";
      });
    }

    // On CLEAR press
    if (buttonText == Calculations.CLEAR) {
      return setState(() {
        operations.add(Calculations.CLEAR);
        calculatorString = "";
      });
    }

    // On Equals press
    if (buttonText == Calculations.EQUAL) {
      String newCalculatorString = Calculator.parseString(calculatorString);

      return setState(() {
        if (newCalculatorString != calculatorString) {
          // only add evaluated strings to calculations array
          calculations.add(calculatorString);
        }

        operations.add(Calculations.EQUAL);
        calculatorString = newCalculatorString;
        isNewEquation = false;
      });
    }

    if (buttonText == Calculations.PERIOD) {
      return setState(() {
        calculatorString = Calculator.addPeriod(calculatorString);
      });
    }

    setState(() {
      if (!isNewEquation &&
          operations.length > 0 &&
          operations.last == Calculations.EQUAL) {
        calculatorString = buttonText!;
        isNewEquation = true;
      } else {
        calculatorString += buttonText!;
      }
    });
  }
}
