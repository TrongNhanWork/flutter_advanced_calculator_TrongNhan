import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:may_tinh/providers/calculator_provider.dart';
import 'package:may_tinh/utils/constants.dart';
import 'package:may_tinh/models/calculator_mode.dart';

class DisplayArea extends StatelessWidget {
  const DisplayArea({super.key});

  @override
  Widget build(BuildContext context) {
    final calc = Provider.of<CalculatorProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppUI.screenPadding),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(AppUI.borderRadiusDisplay),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _Indicator(
                    text: calc.angleMode == AngleMode.degrees ? 'DEG' : 'RAD',
                    isActive: true,
                  ),
                  const SizedBox(width: 8),
                  if (calc.memory != 0)
                    const _Indicator(text: 'M', isActive: true),
                ],
              ),
              Text(
                calc.mode.name.toUpperCase(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const Spacer(),
          SingleChildScrollView(
            reverse: true,
            scrollDirection: Axis.horizontal,
            child: Text(
              calc.expression.isEmpty ? '0' : calc.expression,
              style: TextStyle(
                fontSize: 32,
                color: isDark ? Colors.white70 : Colors.black54,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          const SizedBox(height: 8),
          AnimatedDefaultTextStyle(
            duration: AppUI.animationDurationShort,
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: calc.isError 
                  ? Colors.red 
                  : (isDark ? Colors.white : Colors.black),
            ),
            child: Text(calc.result),
          ),
        ],
      ),
    );
  }
}

class _Indicator extends StatelessWidget {
  final String text;
  final bool isActive;

  const _Indicator({required this.text, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: isActive ? AppColors.lightAccent : Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          color: isActive ? AppColors.lightAccent : Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
