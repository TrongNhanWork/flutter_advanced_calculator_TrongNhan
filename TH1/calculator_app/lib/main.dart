import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator App',
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0000';
  double _num1 = 0;
  String _operation = '';
  bool _isNewNumber = true;

  final List<String> _buttons = [
    'C', '()', '%', '÷',
    '7', '8', '9', '×',
    '4', '5', '6', '-',
    '1', '2', '3', '+',
    '+/-', '0', '.', '=',
  ];

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _display = '0000';
        _num1 = 0;
        _operation = '';
        _isNewNumber = true;
        return;
      }

      if (value == '()') {
        return;
      }

      if (value == '+/-') {
        if (_display != '0' &&
            _display != '0000' &&
            _display != 'Error') {
          if (_display.startsWith('-')) {
            _display = _display.substring(1);
          } else {
            _display = '-$_display';
          }
        }
        return;
      }

      if (value == '%') {
        final current = double.tryParse(_display);
        if (current != null) {
          _display = _formatNumber((current / 100).toString());
          _isNewNumber = true;
        }
        return;
      }

      if (value == '.') {
        if (_display == 'Error' || _display == '0000') {
          _display = '0.';
          _isNewNumber = false;
        } else if (_isNewNumber) {
          _display = '0.';
          _isNewNumber = false;
        } else if (!_display.contains('.')) {
          _display += '.';
        }
        return;
      }

      if (_isOperator(value)) {
        final currentValue = double.tryParse(_display) ?? 0;

        if (_operation.isEmpty) {
          _num1 = currentValue;
        } else {
          _num1 = _calculate(_num1, currentValue, _operation);
        }

        _display = _formatNumber(_num1.toString());
        _operation = value;
        _isNewNumber = true;
        return;
      }

      if (value == '=') {
        if (_operation.isNotEmpty) {
          final currentValue = double.tryParse(_display) ?? 0;
          final result = _calculate(_num1, currentValue, _operation);

          if (result.isNaN || result.isInfinite) {
            _display = 'Error';
          } else {
            _display = _formatNumber(result.toString());
            _num1 = result;
          }

          _operation = '';
          _isNewNumber = true;
        }
        return;
      }

      if (_display == 'Error' || _display == '0000' || _isNewNumber) {
        _display = value;
      } else {
        _display += value;
      }
      _isNewNumber = false;
    });
  }

  bool _isOperator(String value) {
    return value == '+' || value == '-' || value == '×' || value == '÷';
  }

  double _calculate(double a, double b, String op) {
    switch (op) {
      case '+':
        return a + b;
      case '-':
        return a - b;
      case '×':
        return a * b;
      case '÷':
        if (b == 0) {
          return double.nan;
        }
        return a / b;
      default:
        return b;
    }
  }

  String _formatNumber(String value) {
    if (value.endsWith('.0')) {
      return value.substring(0, value.length - 2);
    }
    return value;
  }

  Color _getButtonColor(String text) {
    if (text == 'C') {
      return const Color(0xFFB55252);
    }
    if (text == '=') {
      return const Color(0xFF0E8A6A);
    }
    if (text == '+' || text == '-' || text == '×' || text == '÷') {
      return const Color(0xFF465B3C);
    }
    return const Color(0xFF1F232B);
  }

  Widget _buildButton(String text) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => _onButtonPressed(text),
      child: Container(
        decoration: BoxDecoration(
          color: _getButtonColor(text),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E2E2E),
      body: SafeArea(
        child: Center(
          child: Container(
            width: 320,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1C),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 130,
                  width: double.infinity,
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  color: const Color(0xFF111111),
                  child: Text(
                    _display,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 360,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _buttons.length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      return _buildButton(_buttons[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}