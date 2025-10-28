// ignore_for_file: deprecated_member_use, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants.dart';
import '../../../core/theme.dart';
import '../../../widgets/custom_button.dart';
import '../logic/calculator_provider.dart';

/// Calculator screen with display and button grid - supports both orientations
class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CalculatorProvider>(
      builder: (context, calculator, child) {
        return OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.landscape) {
              return _buildLandscapeLayout(context, calculator);
            } else {
              return _buildPortraitLayout(context, calculator);
            }
          },
        );
      },
    );
  }

  /// Portrait layout (vertical phone)
  Widget _buildPortraitLayout(
      BuildContext context, CalculatorProvider calculator) {
    return Column(
      children: [
        // Display area
        _buildDisplay(context, calculator),
        // Button grid
        Expanded(
          child: _buildButtonGrid(context, calculator),
        ),
      ],
    );
  }

  /// Landscape layout (horizontal phone) - FIXED
  Widget _buildLandscapeLayout(
      BuildContext context, CalculatorProvider calculator) {
    return Row(
      children: [
        // Display area - reduced flex and constrained height
        Expanded(
          flex: 1, // Reduced from 2 to 1
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            child: _buildDisplay(context, calculator),
          ),
        ),
        // Button grid - increased flex
        Expanded(
          flex: 2, // Reduced from 3 to 2 for better balance
          child: _buildButtonGrid(context, calculator),
        ),
      ],
    );
  }

  /// Build the calculator display - IMPROVED
  Widget _buildDisplay(BuildContext context, CalculatorProvider calculator) {
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        // Swipe left to delete
        if (details.primaryVelocity != null &&
            details.primaryVelocity! < -100) {
          calculator.deleteLast();
        }
      },
      onVerticalDragEnd: (details) {
        // Swipe down to clear
        if (details.primaryVelocity != null && details.primaryVelocity! > 100) {
          calculator.clear();
        }
      },
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          minHeight: isLandscape
              ? 120 // Fixed minimum height for landscape
              : AppConstants.displayHeight,
          maxHeight: isLandscape
              ? 180 // Reduced max height for landscape
              : AppConstants.displayHeight,
        ),
        padding: EdgeInsets.all(
          isLandscape
              ? AppConstants.displayPadding * 0.7 // Reduced padding
              : AppConstants.displayPadding,
        ),
        margin: EdgeInsets.all(
          isLandscape
              ? AppConstants.defaultPadding * 0.7 // Reduced margin
              : AppConstants.defaultPadding,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Expression display
            if (calculator.expression.isNotEmpty) ...[
              Flexible(
                child: Text(
                  calculator.expression,
                  style: TextStyle(
                    fontSize:
                        isLandscape ? 11 : 14, // Smaller text in landscape
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  maxLines:
                      isLandscape ? 2 : 1, // More lines allowed in landscape
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: isLandscape ? 2 : 4),
            ],
            // Main display
            Flexible(
              flex: 2,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text(
                  calculator.display,
                  style: AppTheme.displayTextStyle(context).copyWith(
                    color: calculator.hasError
                        ? Theme.of(context).colorScheme.error
                        : null,
                    fontSize: isLandscape ? 28 : null, // Smaller in landscape
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build the calculator button grid - IMPROVED
  Widget _buildButtonGrid(BuildContext context, CalculatorProvider calculator) {
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: isLandscape
              ? AppConstants.defaultPadding *
                  0.5 // Reduced padding in landscape
              : AppConstants.defaultPadding),
      child: Column(
        children: [
          // Row 1: Clear, Delete, %, ÷
          _buildButtonRow([
            FunctionButton(
              text: 'C',
              onPressed: calculator.clear,
              color: Theme.of(context).colorScheme.error,
            ),
            FunctionButton(
              text: '⌫',
              onPressed: calculator.deleteLast,
            ),
            OperatorButton(
              text: '%',
              onPressed: calculator.percentage,
            ),
            OperatorButton(
              text: '÷',
              onPressed: () => calculator.inputOperator('÷'),
            ),
          ], isLandscape),
          SizedBox(
              height: isLandscape
                  ? 4 // Fixed spacing for landscape
                  : AppConstants.buttonSpacing),

          // Row 2: 7, 8, 9, ×
          _buildButtonRow([
            CustomButton(
              text: '7',
              onPressed: () => calculator.inputNumber('7'),
            ),
            CustomButton(
              text: '8',
              onPressed: () => calculator.inputNumber('8'),
            ),
            CustomButton(
              text: '9',
              onPressed: () => calculator.inputNumber('9'),
            ),
            OperatorButton(
              text: '×',
              onPressed: () => calculator.inputOperator('×'),
            ),
          ], isLandscape),
          SizedBox(height: isLandscape ? 4 : AppConstants.buttonSpacing),

          // Row 3: 4, 5, 6, −
          _buildButtonRow([
            CustomButton(
              text: '4',
              onPressed: () => calculator.inputNumber('4'),
            ),
            CustomButton(
              text: '5',
              onPressed: () => calculator.inputNumber('5'),
            ),
            CustomButton(
              text: '6',
              onPressed: () => calculator.inputNumber('6'),
            ),
            OperatorButton(
              text: '−',
              onPressed: () => calculator.inputOperator('−'),
            ),
          ], isLandscape),
          SizedBox(height: isLandscape ? 4 : AppConstants.buttonSpacing),

          // Row 4: 1, 2, 3, +
          _buildButtonRow([
            CustomButton(
              text: '1',
              onPressed: () => calculator.inputNumber('1'),
            ),
            CustomButton(
              text: '2',
              onPressed: () => calculator.inputNumber('2'),
            ),
            CustomButton(
              text: '3',
              onPressed: () => calculator.inputNumber('3'),
            ),
            OperatorButton(
              text: '+',
              onPressed: () => calculator.inputOperator('+'),
            ),
          ], isLandscape),
          SizedBox(height: isLandscape ? 4 : AppConstants.buttonSpacing),

          // Row 5: 0 (wide), ., =
          _buildButtonRow([
            CustomButton(
              text: '0',
              onPressed: () => calculator.inputNumber('0'),
              isWide: true,
            ),
            CustomButton(
              text: '.',
              onPressed: calculator.inputDecimal,
            ),
            OperatorButton(
              text: '=',
              onPressed: calculator.calculate,
            ),
          ], isLandscape, isLastRow: true),
        ],
      ),
    );
  }

  /// Build a row of buttons - IMPROVED
  Widget _buildButtonRow(List<Widget> buttons, bool isLandscape,
      {bool isLastRow = false}) {
    return Expanded(
      child: Row(
        children: buttons
            .map((button) => button is CustomButton && button.isWide
                ? Expanded(
                    flex: 2,
                    child: button,
                  )
                : Expanded(child: button))
            .expand((widget) => [
                  widget,
                  if (widget != buttons.last)
                    SizedBox(
                        width: isLandscape
                            ? 4 // Fixed spacing for landscape
                            : AppConstants.buttonSpacing),
                ])
            .take(buttons.length * 2 - 1)
            .toList(),
      ),
    );
  }
}
