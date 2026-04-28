import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:may_tinh/providers/calculator_provider.dart';
import 'package:may_tinh/providers/history_provider.dart';
import 'package:may_tinh/utils/constants.dart';

class CalculatorButton extends StatefulWidget {
  final String text;
  final Color? color;
  final Color? textColor;
  final VoidCallback? onPressed;
  final bool isFunction;

  const CalculatorButton({
    super.key,
    required this.text,
    this.color,
    this.textColor,
    this.onPressed,
    this.isFunction = false,
  });

  @override
  State<CalculatorButton> createState() => _CalculatorButtonState();
}

class _CalculatorButtonState extends State<CalculatorButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppUI.animationDurationShort,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward().then((_) => _controller.reverse());
    if (widget.onPressed != null) {
      widget.onPressed!();
      return;
    }

    final calc = Provider.of<CalculatorProvider>(context, listen: false);
    final hist = Provider.of<HistoryProvider>(context, listen: false);

    switch (widget.text) {
      case 'C':
        calc.clear();
        break;
      case 'CE':
        calc.clearEntry();
        break;
      case '=':
        calc.calculate(hist);
        break;
      case '±':
        calc.toggleSign();
        break;
      case 'M+':
        calc.memoryAdd();
        break;
      case 'M-':
        calc.memorySubtract();
        break;
      case 'MR':
        calc.memoryRecall();
        break;
      case 'MC':
        calc.memoryClear();
        break;
      case 'sin':
      case 'cos':
      case 'tan':
      case 'ln':
      case 'log':
      case '√':
        calc.appendFunction(widget.text);
        break;
      case 'x²':
        calc.append('^2');
        break;
      case 'x^y':
        calc.append('^');
        break;
      case 'Π':
        calc.append('Π');
        break;
      default:
        calc.append(widget.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultBg = isDark ? AppColors.darkSecondary : AppColors.lightSecondary.withAlpha(20);
    final defaultText = isDark ? Colors.white : Colors.black;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTap: _handleTap,
        child: Container(
          decoration: BoxDecoration(
            color: widget.color ?? defaultBg,
            borderRadius: BorderRadius.circular(AppUI.borderRadiusButton),
            boxShadow: [
              if (!isDark)
                BoxShadow(
                  color: Colors.black.withAlpha(20),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: widget.textColor ?? defaultText,
            ),
          ),
        ),
      ),
    );
  }
}
