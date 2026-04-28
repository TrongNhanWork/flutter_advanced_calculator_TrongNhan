import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:may_tinh/widgets/display_area.dart';
import 'package:may_tinh/widgets/button_grid.dart';
import 'package:may_tinh/widgets/mode_selector.dart';
import 'package:may_tinh/providers/calculator_provider.dart';
import 'package:may_tinh/models/calculator_mode.dart';
import 'package:may_tinh/utils/constants.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CalculatorProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Advanced Calculator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.pushNamed(context, '/history'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const ModeSelector(),
            if (provider.mode == CalculatorMode.programmer)
              Expanded(
                child: Column(
                  children: [
                    // Hàng chuyển hệ số
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(onPressed: () {}, child: const Text("BIN")),
                        TextButton(onPressed: () {}, child: const Text("OCT")),
                        TextButton(onPressed: () {}, child: const Text("DEC")),
                        TextButton(onPressed: () {}, child: const Text("HEX")),
                      ],
                    ),
                    // Màn hình hiển thị kết quả Programmer
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        provider.programmerExpression,
                        style: const TextStyle(fontSize: 30),
                      ),
                    ),
                    const Spacer(),
                    // Grid nút bấm
                    GridView.count(
                      crossAxisCount: 4,
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(16),
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      children: [
                        '7', '8', '9', 'AND',
                        '4', '5', '6', 'OR',
                        '1', '2', '3', 'XOR',
                        '0', '<<', '>>', 'NOT',
                        '=', 'C'
                      ].map((text) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: text == '=' 
                                ? Colors.green 
                                : (text == 'C' ? Colors.redAccent : null),
                            foregroundColor: (text == '=' || text == 'C') ? Colors.white : null,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                            if (text == '=') {
                              provider.calculateProgrammerMode();
                            } else if (text == 'C') {
                              provider.clear();
                            } else {
                              // Thêm khoảng trắng cho các toán tử để logic split hoạt động
                              final isOperator = ['AND', 'OR', 'XOR', 'NOT', '<<', '>>'].contains(text);
                              provider.appendProgrammer(isOperator ? ' $text ' : text);
                            }
                          },
                          child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              )
            else ...[
              const Expanded(
                flex: 3,
                child: DisplayArea(),
              ),
              const Divider(height: 1),
              const Expanded(
                flex: 7,
                child: ButtonGrid(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
