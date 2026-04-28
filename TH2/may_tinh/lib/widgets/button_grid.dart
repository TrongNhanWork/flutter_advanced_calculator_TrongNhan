import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:may_tinh/providers/calculator_provider.dart';
import 'package:may_tinh/models/calculator_mode.dart';
import 'package:may_tinh/widgets/calculator_button.dart';
import 'package:may_tinh/utils/constants.dart';

class ButtonGrid extends StatelessWidget {
  const ButtonGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final mode = context.watch<CalculatorProvider>().mode;

    switch (mode) {
      case CalculatorMode.scientific:
        return _buildScientificGrid();
      case CalculatorMode.programmer:
        return _buildProgrammerGrid();
      case CalculatorMode.basic:
      default:
        return _buildBasicGrid();
    }
  }

  Widget _buildBasicGrid() {
    return GridView.count(
      crossAxisCount: 4,
      padding: const EdgeInsets.symmetric(horizontal: AppUI.buttonSpacing, vertical: 8),
      mainAxisSpacing: AppUI.buttonSpacing,
      crossAxisSpacing: AppUI.buttonSpacing,
      childAspectRatio: 1.1, // Làm nút hơi dẹt lại để tiết kiệm chiều cao
      children: const [
        CalculatorButton(text: 'C', color: AppColors.lightAccent, textColor: Colors.white),
        CalculatorButton(text: 'CE'),
        CalculatorButton(text: '%'),
        CalculatorButton(text: '÷', color: Colors.orange),
        CalculatorButton(text: '7'),
        CalculatorButton(text: '8'),
        CalculatorButton(text: '9'),
        CalculatorButton(text: '×', color: Colors.orange),
        CalculatorButton(text: '4'),
        CalculatorButton(text: '5'),
        CalculatorButton(text: '6'),
        CalculatorButton(text: '-', color: Colors.orange),
        CalculatorButton(text: '1'),
        CalculatorButton(text: '2'),
        CalculatorButton(text: '3'),
        CalculatorButton(text: '+', color: Colors.orange),
        CalculatorButton(text: '±'),
        CalculatorButton(text: '0'),
        CalculatorButton(text: '.'),
        CalculatorButton(text: '=', color: Colors.green, textColor: Colors.white),
      ],
    );
  }

  Widget _buildScientificGrid() {
    return GridView.count(
      crossAxisCount: 6,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      mainAxisSpacing: 6,
      crossAxisSpacing: 6,
      childAspectRatio: 0.9, // Điều chỉnh cho Scientific mode
      children: const [
        CalculatorButton(text: '2nd'),
        CalculatorButton(text: 'sin'),
        CalculatorButton(text: 'cos'),
        CalculatorButton(text: 'tan'),
        CalculatorButton(text: 'ln'),
        CalculatorButton(text: 'log'),
        CalculatorButton(text: 'x²'),
        CalculatorButton(text: '√'),
        CalculatorButton(text: 'x^y'),
        CalculatorButton(text: '('),
        CalculatorButton(text: ')'),
        CalculatorButton(text: '÷', color: Colors.orange),
        CalculatorButton(text: 'MC'),
        CalculatorButton(text: '7'),
        CalculatorButton(text: '8'),
        CalculatorButton(text: '9'),
        CalculatorButton(text: 'C', color: AppColors.lightAccent, textColor: Colors.white),
        CalculatorButton(text: '×', color: Colors.orange),
        CalculatorButton(text: 'MR'),
        CalculatorButton(text: '4'),
        CalculatorButton(text: '5'),
        CalculatorButton(text: '6'),
        CalculatorButton(text: 'CE'),
        CalculatorButton(text: '-', color: Colors.orange),
        CalculatorButton(text: 'M+'),
        CalculatorButton(text: '1'),
        CalculatorButton(text: '2'),
        CalculatorButton(text: '3'),
        CalculatorButton(text: '%'),
        CalculatorButton(text: '+', color: Colors.orange),
        CalculatorButton(text: 'M-'),
        CalculatorButton(text: '±'),
        CalculatorButton(text: '0'),
        CalculatorButton(text: '.'),
        CalculatorButton(text: 'Π'),
        CalculatorButton(text: '=', color: Colors.green, textColor: Colors.white),
      ],
    );
  }

  Widget _buildProgrammerGrid() {
    return const Center(child: Text("Programmer Mode UI"));
  }
}
