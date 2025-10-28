// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/theme.dart';

/// Custom calculator button widget
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isOperator;
  final bool isWide;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isOperator = false,
    this.isWide = false,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: isWide
          ? (AppConstants.buttonWidth * 2) + AppConstants.buttonSpacing
          : AppConstants.buttonWidth,
      height: AppConstants.buttonHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: backgroundColor != null
            ? ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                foregroundColor: textColor ?? theme.colorScheme.onSurface,
                elevation: 4,
                shadowColor: theme.colorScheme.shadow.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppConstants.buttonBorderRadius),
                ),
              )
            : AppTheme.calculatorButtonStyle(context, isOperator: isOperator),
        child: Text(
          text,
          style: textColor != null
              ? TextStyle(
                  fontSize: AppConstants.buttonTextSize,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                )
              : AppTheme.buttonTextStyle(context, isOperator: isOperator),
        ),
      ),
    );
  }
}

/// Special button for operators with enhanced styling
class OperatorButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const OperatorButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      isOperator: true,
    );
  }
}

/// Special button for functions (clear, delete, etc.)
class FunctionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;

  const FunctionButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomButton(
      text: text,
      onPressed: onPressed,
      backgroundColor: color ?? theme.colorScheme.secondary,
      textColor: theme.colorScheme.onSecondary,
    );
  }
}
