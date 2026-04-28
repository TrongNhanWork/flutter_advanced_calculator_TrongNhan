import 'package:math_expressions/math_expressions.dart';
import '../models/calculator_mode.dart';

class CalculatorLogic {
  static String calculate(String expression, {AngleMode angleMode = AngleMode.degrees, int precision = 2}) {
    try {
      if (expression.isEmpty) return '';

      // Clean expression for math_expressions
      String finalExpression = expression
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('Π', '3.1415926535897932')
          .replaceAll('e', '2.718281828459045');

      // Handle implied multiplication like 2(3) -> 2*(3) or 2π -> 2*π
      finalExpression = finalExpression.replaceAllMapped(RegExp(r'(\d)(\()'), (Match m) => '${m[1]}*${m[2]}');
      finalExpression = finalExpression.replaceAllMapped(RegExp(r'(\))(\d)'), (Match m) => '${m[1]}*${m[2]}');

      Parser p = Parser();
      
      if (angleMode == AngleMode.degrees) {
        finalExpression = finalExpression.replaceAllMapped(
            RegExp(r'(sin|cos|tan)\(([^)]+)\)'),
            (Match m) => '${m[1]}((${m[2]}) * 3.1415926535897932 / 180)');
      }

      Expression exp = p.parse(finalExpression);
      ContextModel cm = ContextModel();

      double eval = exp.evaluate(EvaluationType.REAL, cm);
      
      if (eval.isInfinite || eval.isNaN) return 'Error';

      if (eval == eval.toInt()) {
        return eval.toInt().toString();
      }
      
      String result = eval.toStringAsFixed(precision);
      if (result.contains('.')) {
        result = result.replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');
      }
      return result;
    } catch (e) {
      return 'Error';
    }
  }

  static String calculateProgrammer(String expression) {
    try {
      List<String> parts = expression.trim().split(' ');
      if (parts.length < 3) return expression;

      int a = int.parse(parts[0]);
      String op = parts[1];
      int b = int.parse(parts[2]);

      int result;

      switch (op) {
        case 'AND':
          result = a & b;
          break;
        case 'OR':
          result = a | b;
          break;
        case 'XOR':
          result = a ^ b;
          break;
        case '<<':
          result = a << b;
          break;
        case '>>':
          result = a >> b;
          break;
        default:
          return 'Error';
      }

      return result.toString();
    } catch (e) {
      return 'Error';
    }
  }
}
