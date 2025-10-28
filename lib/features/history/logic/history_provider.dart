import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../core/constants.dart';

/// Model for calculation history entries
class CalculationHistory {
  final String expression;
  final String result;
  final DateTime timestamp;
  
  CalculationHistory({
    required this.expression,
    required this.result,
    required this.timestamp,
  });
  
  /// Convert to JSON for storage
  Map<String, dynamic> toJson() => {
    'expression': expression,
    'result': result,
    'timestamp': timestamp.millisecondsSinceEpoch,
  };
  
  /// Create from JSON
  factory CalculationHistory.fromJson(Map<String, dynamic> json) => 
      CalculationHistory(
        expression: json['expression'] as String,
        result: json['result'] as String,
        timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int),
      );
}

/// Provider for managing calculation history
class HistoryProvider extends ChangeNotifier {
  List<CalculationHistory> _history = [];
  
  List<CalculationHistory> get history => List.unmodifiable(_history.reversed);
  
  /// Load history from SharedPreferences
  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList(AppConstants.historyKey) ?? [];
    
    _history = historyJson
        .map((json) => CalculationHistory.fromJson(jsonDecode(json)))
        .toList();
    
    notifyListeners();
  }
  
  /// Save history to SharedPreferences
  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = _history
        .map((item) => jsonEncode(item.toJson()))
        .toList();
    
    await prefs.setStringList(AppConstants.historyKey, historyJson);
  }
  
  /// Add calculation to history
  void addCalculation(String expression, String result) {
    final calculation = CalculationHistory(
      expression: expression,
      result: result,
      timestamp: DateTime.now(),
    );
    
    _history.add(calculation);
    
    // Limit history size
    if (_history.length > AppConstants.maxHistoryItems) {
      _history.removeAt(0);
    }
    
    notifyListeners();
    _saveHistory();
  }
  
  /// Remove calculation from history
  void removeCalculation(int index) {
    if (index >= 0 && index < _history.length) {
      // Convert reversed index to actual index
      final actualIndex = _history.length - 1 - index;
      _history.removeAt(actualIndex);
      notifyListeners();
      _saveHistory();
    }
  }
  
  /// Clear all history
  void clearHistory() {
    _history.clear();
    notifyListeners();
    _saveHistory();
  }
  
  /// Get calculation at index (for reuse)
  CalculationHistory? getCalculation(int index) {
    if (index >= 0 && index < _history.length) {
      final actualIndex = _history.length - 1 - index;
      return _history[actualIndex];
    }
    return null;
  }
}