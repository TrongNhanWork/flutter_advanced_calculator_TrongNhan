import 'package:flutter/material.dart';
import 'package:may_tinh/models/calculator_mode.dart';
import 'package:may_tinh/utils/calculator_logic.dart';
import 'package:may_tinh/models/calculation_history.dart';
import 'package:may_tinh/providers/history_provider.dart';

class CalculatorProvider extends ChangeNotifier {
  String _expression = '';
  String _result = '';
  String _programmerExpression = '';
  double _memory = 0.0;
  CalculatorMode _mode = CalculatorMode.basic;
  AngleMode _angleMode = AngleMode.degrees;
  int _precision = 2;
  bool _isError = false;

  String get expression => _expression;
  String get result => _result;
  String get programmerExpression => _programmerExpression;
  double get memory => _memory;
  CalculatorMode get mode => _mode;
  AngleMode get angleMode => _angleMode;
  bool get isError => _isError;

  void append(String text) {
    if (_isError) clear();
    _expression += text;
    _autoCalculate();
    notifyListeners();
  }

  void appendProgrammer(String value) {
    _programmerExpression += value;
    notifyListeners();
  }

  void appendFunction(String func) {
    if (_isError) clear();
    _expression += '$func(';
    notifyListeners();
  }

  void clear() {
    _expression = '';
    _result = '';
    _programmerExpression = '';
    _isError = false;
    notifyListeners();
  }

  void clearEntry() {
    clear();
  }

  void delete() {
    if (_expression.isNotEmpty) {
      _expression = _expression.substring(0, _expression.length - 1);
      _autoCalculate();
      notifyListeners();
    }
  }

  void toggleSign() {
    notifyListeners();
  }

  void setMode(CalculatorMode mode) {
    _mode = mode;
    notifyListeners();
  }

  void setAngleMode(AngleMode mode) {
    _angleMode = mode;
    _autoCalculate();
    notifyListeners();
  }

  void setPrecision(int p) {
    _precision = p;
    _autoCalculate();
    notifyListeners();
  }

  void _autoCalculate() {
    if (_expression.isEmpty) {
      _result = '';
      return;
    }
    String res = CalculatorLogic.calculate(_expression, angleMode: _angleMode, precision: _precision);
    if (res != 'Error') {
      _result = res;
    }
  }

  void calculate(HistoryProvider historyProvider) {
    if (_expression.isEmpty) return;
    
    String res = CalculatorLogic.calculate(_expression, angleMode: _angleMode, precision: _precision);
    if (res == 'Error') {
      _isError = true;
      _result = 'Error';
    } else {
      _result = res;
      historyProvider.addEntry(CalculationHistory(
        expression: _expression,
        result: _result,
        timestamp: DateTime.now(),
      ));
      _expression = _result;
      _result = '';
    }
    notifyListeners();
  }

  void calculateProgrammerMode() {
    String res = CalculatorLogic.calculateProgrammer(_programmerExpression);
    _programmerExpression = res;
    notifyListeners();
  }

  void memoryAdd() {
    double val = double.tryParse(_result.isNotEmpty ? _result : _expression) ?? 0;
    _memory += val;
    notifyListeners();
  }

  void memorySubtract() {
    double val = double.tryParse(_result.isNotEmpty ? _result : _expression) ?? 0;
    _memory -= val;
    notifyListeners();
  }

  void memoryRecall() {
    append(_memory.toString());
  }

  void memoryClear() {
    _memory = 0;
    notifyListeners();
  }
}
