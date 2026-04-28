import 'package:flutter/material.dart';
import '../models/calculation_history.dart';
import '../services/storage_service.dart';

class HistoryProvider extends ChangeNotifier {
  List<CalculationHistory> _history = [];
  int _maxSize = 50;

  List<CalculationHistory> get history => List.unmodifiable(_history);

  HistoryProvider() {
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    _history = await StorageService.loadHistory();
    notifyListeners();
  }

  void addEntry(CalculationHistory entry) {
    _history.insert(0, entry);
    if (_history.length > _maxSize) {
      _history = _history.sublist(0, _maxSize);
    }
    StorageService.saveHistory(_history);
    notifyListeners();
  }

  void clearHistory() {
    _history.clear();
    StorageService.saveHistory(_history);
    notifyListeners();
  }

  void setMaxSize(int size) {
    _maxSize = size;
    if (_history.length > _maxSize) {
      _history = _history.sublist(0, _maxSize);
      StorageService.saveHistory(_history);
    }
    notifyListeners();
  }
}
