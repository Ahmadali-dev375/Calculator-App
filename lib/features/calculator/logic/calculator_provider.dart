// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';

import '../../history/logic/history_provider.dart';

/// Enhanced provider for calculator logic and state management
class CalculatorProvider extends ChangeNotifier {
  final HistoryProvider _historyProvider;

  String _display = '0';
  String _expression = '';
  String _lastOperator = '';
  String _lastOperand = '';
  bool _shouldResetDisplay = false;
  bool _hasError = false;
  bool _justCalculated = false;
  bool _waitingForOperand = false;
  double? _storedValue;

  CalculatorProvider(this._historyProvider);

  String get display => _display;
  String get expression => _expression;
  bool get hasError => _hasError;

  /// Handle number input
  void inputNumber(String number) {
    if (_hasError) {
      clear();
    }

    if (_justCalculated) {
      _display = number;
      _expression = '';
      _justCalculated = false;
      _waitingForOperand = false;
    } else if (_shouldResetDisplay) {
      _display = number;
      _shouldResetDisplay = false;
      _waitingForOperand = false;
    } else {
      if (_display == '0' && number != '0') {
        _display = number;
      } else if (_display != '0') {
        // Limit display length
        if (_display.replaceAll('.', '').replaceAll('-', '').length < 15) {
          _display += number;
        }
      }
    }

    notifyListeners();
  }

  /// Handle operator input - FIXED MINUS OPERATION
  void inputOperator(String operator) {
    if (_hasError && _display != 'Infinity' && _display != '-Infinity') {
      clear();
    }

    // Convert display operator symbols to internal operators
    String internalOperator = operator;
    if (operator == '×') internalOperator = '*';
    if (operator == '÷') internalOperator = '/';
    if (operator == '−') internalOperator = '-'; // This is the key fix!

    // Handle starting with minus for negative numbers
    if (internalOperator == '-' && _expression.isEmpty && _display == '0') {
      _display = '-';
      _shouldResetDisplay = false;
      _waitingForOperand = false;
      notifyListeners();
      return;
    }

    // Handle consecutive operators (replace the last operator)
    if (_waitingForOperand && _expression.isNotEmpty && !_justCalculated) {
      final parts = _expression.trim().split(' ');
      if (parts.length >= 2) {
        // Replace the operator in expression
        parts[parts.length - 2] = operator;
        _expression = parts.join(' ') + ' ';
        _lastOperator = internalOperator;
      }
      notifyListeners();
      return;
    }

    // If we just calculated, start new expression with result
    if (_justCalculated) {
      _expression = _display + ' ' + operator + ' ';
      _justCalculated = false;
    }
    // If we have a stored value and operator, calculate intermediate result
    else if (_storedValue != null &&
        !_shouldResetDisplay &&
        _lastOperator.isNotEmpty) {
      _performCalculation();
      if (!_hasError) {
        _expression = _display + ' ' + operator + ' ';
      }
    }
    // Start new expression or continue building
    else {
      if (_expression.isEmpty) {
        _expression = _display + ' ' + operator + ' ';
      } else if (!_waitingForOperand) {
        _expression = _expression + _display + ' ' + operator + ' ';
      }
    }

    _lastOperator = internalOperator;
    _shouldResetDisplay = true;
    _waitingForOperand = true;

    // Store current value for next calculation
    try {
      _storedValue = double.parse(_display);
    } catch (e) {
      if (_display == 'Infinity') {
        _storedValue = double.infinity;
      } else if (_display == '-Infinity') {
        _storedValue = double.negativeInfinity;
      } else {
        _storedValue = null;
      }
    }

    notifyListeners();
  }

  /// Perform intermediate calculation
  void _performCalculation() {
    if (_storedValue == null || _lastOperator.isEmpty) return;

    try {
      double currentValue;

      if (_display == 'Infinity') {
        currentValue = double.infinity;
      } else if (_display == '-Infinity') {
        currentValue = double.negativeInfinity;
      } else {
        currentValue = double.parse(_display);
      }

      double result;

      switch (_lastOperator) {
        case '+':
          result = _storedValue! + currentValue;
          break;
        case '-':
          result = _storedValue! - currentValue; // Fixed minus calculation
          break;
        case '*':
          result = _storedValue! * currentValue;
          break;
        case '/':
          if (currentValue == 0) {
            result = _storedValue! > 0
                ? double.infinity
                : _storedValue! < 0
                    ? double.negativeInfinity
                    : double.nan;
          } else {
            result = _storedValue! / currentValue;
          }
          break;
        default:
          return;
      }

      _display = _formatResult(result);
      _lastOperand = currentValue.toString();

      if (result.isNaN) {
        _hasError = true;
        _display = 'Error';
      }
    } catch (e) {
      _hasError = true;
      _display = 'Error';
    }
  }

  /// Handle decimal point
  void inputDecimal() {
    if (_hasError) {
      clear();
    }

    if (_justCalculated) {
      _display = '0.';
      _expression = '';
      _justCalculated = false;
      _waitingForOperand = false;
    } else if (_shouldResetDisplay) {
      _display = '0.';
      _shouldResetDisplay = false;
      _waitingForOperand = false;
    } else if (!_display.contains('.') &&
        !_display.contains('Infinity') &&
        !_display.contains('Error')) {
      _display += '.';
    }

    notifyListeners();
  }

  /// Handle equals (=) - FIXED FOR REPEATED CALCULATIONS
  void calculate() {
    if (_hasError) return;

    // Handle repeated equals (use last operator + operand)
    if (_justCalculated &&
        _lastOperator.isNotEmpty &&
        _lastOperand.isNotEmpty) {
      try {
        double currentValue = double.tryParse(_display) ?? 0;
        double operandValue = double.tryParse(_lastOperand) ?? 0;

        double result;
        switch (_lastOperator) {
          case '+':
            result = currentValue + operandValue;
            break;
          case '-':
            result = currentValue - operandValue; // Fixed repeated minus
            break;
          case '*':
            result = currentValue * operandValue;
            break;
          case '/':
            result = operandValue == 0
                ? (currentValue > 0
                    ? double.infinity
                    : currentValue < 0
                        ? double.negativeInfinity
                        : double.nan)
                : currentValue / operandValue;
            break;
          default:
            return;
        }

        _display = _formatResult(result);
        if (result.isNaN) {
          _hasError = true;
          _display = 'Error';
        }

        notifyListeners();
        return;
      } catch (e) {
        _hasError = true;
        _display = 'Error';
        notifyListeners();
        return;
      }
    }

    // Perform calculation if we have stored value and operator
    if (_storedValue != null && _lastOperator.isNotEmpty) {
      final fullExpression = _expression + _display;
      _performCalculation();

      if (!_hasError) {
        _historyProvider.addCalculation(fullExpression, _display);
        _expression = '';
        _shouldResetDisplay = true;
        _justCalculated = true;
        _waitingForOperand = false;
        _storedValue = null;
      }
    }

    notifyListeners();
  }

  /// Format result for display
  String _formatResult(double result) {
    if (result.isNaN) return 'Error';
    if (result.isInfinite) return result.isNegative ? '-Infinity' : 'Infinity';
    if (result.abs() > 1e15) return result.toStringAsExponential(6);
    if (result.abs() < 1e-10 && result != 0) {
      return result.toStringAsExponential(6);
    }
    if (result == result.roundToDouble()) return result.toInt().toString();

    String formatted = result.toStringAsFixed(10);
    formatted = formatted.replaceAll(RegExp(r'0*$'), '');
    formatted = formatted.replaceAll(RegExp(r'\.$'), '');
    return formatted;
  }

  /// Clear all
  void clear() {
    _display = '0';
    _expression = '';
    _lastOperator = '';
    _lastOperand = '';
    _shouldResetDisplay = false;
    _hasError = false;
    _justCalculated = false;
    _waitingForOperand = false;
    _storedValue = null;
    notifyListeners();
  }

  /// Delete last character
  void deleteLast() {
    if (_hasError) {
      clear();
      return;
    }
    if (_justCalculated || _shouldResetDisplay) {
      clear();
      return;
    }
    if (_display == 'Infinity' || _display == '-Infinity') {
      _display = '0';
    } else if (_display.length > 1) {
      _display = _display.substring(0, _display.length - 1);
    } else {
      _display = '0';
    }
    notifyListeners();
  }

  /// Handle percentage
  void percentage() {
    if (_hasError) return;
    try {
      double value = double.tryParse(_display) ?? 0;
      _display = _formatResult(value / 100);
      if (_storedValue != null && _lastOperator.isNotEmpty) {
        _shouldResetDisplay = true;
      }
      notifyListeners();
    } catch (e) {
      _hasError = true;
      _display = 'Error';
      notifyListeners();
    }
  }

  /// Set display value (for history reuse)
  void setDisplay(String value) {
    _display = value;
    _expression = '';
    _lastOperator = '';
    _lastOperand = '';
    _shouldResetDisplay = true;
    _hasError = false;
    _justCalculated = false;
    _waitingForOperand = false;
    _storedValue = null;
    notifyListeners();
  }
}
