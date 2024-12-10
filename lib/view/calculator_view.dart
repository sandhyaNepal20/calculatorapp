import 'package:flutter/material.dart';

class CalculatorView extends StatefulWidget {
  const CalculatorView({super.key});

  @override
  State<CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<CalculatorView> {
  final _textController = TextEditingController();
  List<String> lstSymbols = [
    "C",
    "/",
    "*",
    "<-",
    "7",
    "8",
    "9",
    "-",
    "4",
    "5",
    "6",
    "+",
    "1",
    "2",
    "3",
    "=",
    "%",
    "0",
    ".",
  ];

  String _input = "";
  bool _isReplacing = false; // Flag to replace input with new number

  void _onButtonPressed(String symbol) {
    setState(() {
      if (symbol == "C") {
        // Clear the input
        _input = "";
        _isReplacing = false;
      } else if (symbol == "<-") {
        // Backspace to remove the last character
        if (_input.isNotEmpty) {
          _input = _input.substring(0, _input.length - 1);
        }
      } else if (symbol == "=") {
        // Evaluate the expression
        try {
          _input = _evaluateExpression(_input);
          _isReplacing = true;
        } catch (e) {
          _input = "Error";
          _isReplacing = true;
        }
      } else {
        if (RegExp(r'^\d$').hasMatch(symbol)) {
          // If it's a number, replace or append as needed
          if (_isReplacing) {
            _input = symbol;
            _isReplacing = false;
          } else {
            _input += symbol;
          }
        } else {
          // Append operators and other symbols
          _input += symbol;
          _isReplacing = false;
        }
      }
      _textController.text = _input;
    });
  }

  String _evaluateExpression(String input) {
    final expression = input.replaceAll('%', '/100'); // Handle percentage
    final result = _calculate(expression);
    return result.toStringAsFixed(2).replaceAll(RegExp(r'\.00$'), '');
  }

  double _calculate(String expression) {
    final exp = RegExp(r'([\d\.]+|[-+*/%])');
    final tokens = exp.allMatches(expression).map((e) => e.group(0)!).toList();

    List<double> numbers = [];
    List<String> operators = [];
    for (var token in tokens) {
      if (RegExp(r'^[\d\.]+$').hasMatch(token)) {
        numbers.add(double.parse(token));
      } else {
        operators.add(token);
      }
    }

    while (operators.isNotEmpty) {
      final op = operators.removeAt(0);
      final num1 = numbers.removeAt(0);
      final num2 = numbers.removeAt(0);
      double result;
      switch (op) {
        case '+':
          result = num1 + num2;
          break;
        case '-':
          result = num1 - num2;
          break;
        case '*':
          result = num1 * num2;
          break;
        case '/':
          result = num1 / num2;
          break;
        default:
          result = 0;
      }
      numbers.insert(0, result);
    }

    return numbers.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              readOnly: true,
              controller: _textController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              textAlign: TextAlign.right, // Align text to the right
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: lstSymbols.length,
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // Black background
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: const BorderSide(
                          color: Colors.pink, // Pink border
                          width: 2,
                        ),
                      ),
                    ),
                    onPressed: () => _onButtonPressed(lstSymbols[index]),
                    child: Text(
                      lstSymbols[index],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // White text color
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
