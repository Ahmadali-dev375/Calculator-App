import 'package:flutter/material.dart';

/// Provider for unit converter state management
class ConverterProvider extends ChangeNotifier {
  double _inputValue = 1.0;
  String _fromUnit = '';
  
  double get inputValue => _inputValue;
  String get fromUnit => _fromUnit;
  
  /// Set input value for conversion
  void setInputValue(String value) {
    try {
      _inputValue = double.parse(value);
      if (_inputValue.isNaN || _inputValue.isInfinite) {
        _inputValue = 0.0;
      }
    } catch (e) {
      _inputValue = 0.0;
    }
    notifyListeners();
  }
  
  /// Set the 'from' unit
  void setFromUnit(String unit) {
    _fromUnit = unit;
    notifyListeners();
  }
  
  /// Reset converter state
  void reset() {
    _inputValue = 1.0;
    _fromUnit = '';
    notifyListeners();
  }
}