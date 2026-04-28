import 'calculator_mode.dart';

class CalculatorSettings {
  final CalculatorMode mode;
  final AngleMode angleMode;
  final int decimalPrecision;
  final bool hapticFeedback;
  final bool soundEffects;
  final int historySize;

  CalculatorSettings({
    this.mode = CalculatorMode.basic,
    this.angleMode = AngleMode.degrees,
    this.decimalPrecision = 2,
    this.hapticFeedback = true,
    this.soundEffects = false,
    this.historySize = 50,
  });

  CalculatorSettings copyWith({
    CalculatorMode? mode,
    AngleMode? angleMode,
    int? decimalPrecision,
    bool? hapticFeedback,
    bool? soundEffects,
    int? historySize,
  }) {
    return CalculatorSettings(
      mode: mode ?? this.mode,
      angleMode: angleMode ?? this.angleMode,
      decimalPrecision: decimalPrecision ?? this.decimalPrecision,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
      soundEffects: soundEffects ?? this.soundEffects,
      historySize: historySize ?? this.historySize,
    );
  }
}
