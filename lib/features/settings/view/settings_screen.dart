// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/settings_provider.dart';
import '../../../core/theme.dart';
import '../../../core/constants.dart';

/// Settings screen for theme and accent color configuration
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return ListView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            children: [
              // Theme section
              _buildSection(
                context,
                title: 'Appearance',
                children: [
                  _buildThemeSelector(context, settings),
                  const SizedBox(height: AppConstants.defaultPadding),
                  _buildAccentColorSelector(context, settings),
                ],
              ),

              const SizedBox(height: AppConstants.largePadding),

              // About section
              _buildSection(
                context,
                title: 'About',
                children: [
                  _buildAboutTile(context),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  /// Build a settings section
  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        ...children,
      ],
    );
  }

  /// Build theme mode selector
  Widget _buildThemeSelector(BuildContext context, SettingsProvider settings) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme Mode',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Row(
              children: [
                Expanded(
                  child: _buildThemeOption(
                    context,
                    'Light',
                    ThemeMode.light,
                    Icons.light_mode,
                    settings,
                  ),
                ),
                const SizedBox(width: AppConstants.smallPadding),
                Expanded(
                  child: _buildThemeOption(
                    context,
                    'Dark',
                    ThemeMode.dark,
                    Icons.dark_mode,
                    settings,
                  ),
                ),
                const SizedBox(width: AppConstants.smallPadding),
                Expanded(
                  child: _buildThemeOption(
                    context,
                    'System',
                    ThemeMode.system,
                    Icons.brightness_auto,
                    settings,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build individual theme option
  Widget _buildThemeOption(
    BuildContext context,
    String label,
    ThemeMode mode,
    IconData icon,
    SettingsProvider settings,
  ) {
    final isSelected = settings.themeMode == mode;

    return GestureDetector(
      onTap: () => settings.setThemeMode(mode),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppConstants.smallPadding,
          horizontal: AppConstants.smallPadding,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
              : null,
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build accent color selector
  Widget _buildAccentColorSelector(
      BuildContext context, SettingsProvider settings) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Accent Color',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            Wrap(
              spacing: AppConstants.smallPadding,
              runSpacing: AppConstants.smallPadding,
              children: AppTheme.accentColors.map((color) {
                final isSelected = settings.accentColor == color;
                return GestureDetector(
                  onTap: () => settings.setAccentColor(color),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.onSurface
                            : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check,
                            color: color.computeLuminance() > 0.5
                                ? Colors.black
                                : Colors.white,
                            size: 20,
                          )
                        : null,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  /// Build about tile
  Widget _buildAboutTile(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.info_outline),
        title: const Text('About Calculator Pro'),
        subtitle:
            const Text('A modern calculator with unit conversion features'),
        onTap: () {
          showAboutDialog(
            context: context,
            applicationName: 'Calculator Pro',
            applicationIcon: const Icon(Icons.calculate, size: 48),
            children: [
              const Text('A powerful calculator app with:\n\n'
                  '• Basic arithmetic operations\n'
                  '• Calculation history\n'
                  '• Unit conversions\n'
                  '• Customizable themes\n'
                  '• Gesture support'),
            ],
          );
        },
      ),
    );
  }
}
