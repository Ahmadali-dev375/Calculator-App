// ignore_for_file: deprecated_member_use, sized_box_for_whitespace, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/converter_provider.dart';
import '../../../core/constants.dart';
import '../../../core/utils.dart';
import 'dart:math'; // add at top

/// Unit converter screen with multiple conversion categories
class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen>
    with SingleTickerProviderStateMixin {
  late TabController _categoryController;
  final TextEditingController _inputController = TextEditingController();

  final List<ConversionCategory> _categories = [
    ConversionCategory(
      name: 'Length',
      icon: Icons.straighten,
      units: ['cm', 'm', 'km', 'in', 'ft', 'mi'],
    ),
    ConversionCategory(
      name: 'Weight',
      icon: Icons.fitness_center,
      units: ['g', 'kg', 'lbs', 'oz'],
    ),
    ConversionCategory(
      name: 'Temperature',
      icon: Icons.thermostat,
      units: ['°C', '°F', 'K'],
    ),
    ConversionCategory(
      name: 'Area',
      icon: Icons.crop_free,
      units: ['m²', 'km²', 'ft²', 'acre', 'hectare'],
    ),
    ConversionCategory(
      name: 'Speed',
      icon: Icons.speed,
      units: ['m/s', 'km/h', 'mph'],
    ),
    ConversionCategory(
      name: 'Time',
      icon: Icons.access_time,
      units: ['sec', 'min', 'hours', 'days'],
    ),
    ConversionCategory(
      name: 'Storage',
      icon: Icons.storage,
      units: ['bytes', 'KB', 'MB', 'GB'],
    ),
    ConversionCategory(
      name: 'Energy',
      icon: Icons.flash_on,
      units: ['J', 'cal', 'kWh'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _categoryController = TabController(
      length: _categories.length,
      vsync: this,
    );
    _inputController.text = '1';
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ConverterProvider(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isLandscape = constraints.maxWidth > constraints.maxHeight;

// preferred height you had before
              final preferredTabBarHeight = isLandscape ? 60.0 : 70.0;

              final tabBarHeight =
                  min(preferredTabBarHeight, constraints.maxHeight * 0.2);
              return Column(
                children: [
                  // Category tabs
                  Container(
                    height: tabBarHeight,
                    child: TabBar(
                      controller: _categoryController,
                      isScrollable: true,
                      tabs: _categories
                          .map((category) => Tab(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(category.icon,
                                          size: isLandscape ? 18 : 20),
                                      const SizedBox(height: 2),
                                      Text(
                                        category.name,
                                        style: const TextStyle(fontSize: 12),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),

                  // Converter content
                  Expanded(
                    child: TabBarView(
                      controller: _categoryController,
                      children: _categories
                          .map((category) => _buildConverterTab(
                              context, category,
                              isLandscape: isLandscape))
                          .toList(),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// Build converter tab for a specific category
  Widget _buildConverterTab(BuildContext context, ConversionCategory category,
      {required bool isLandscape}) {
    return Consumer<ConverterProvider>(
      builder: (context, converter, child) {
        if (converter.fromUnit.isEmpty ||
            !category.units.contains(converter.fromUnit)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            converter.setFromUnit(category.units.first);
          });
        }

        final bottomInset = MediaQuery.of(context).viewInsets.bottom;

        return GestureDetector(
          // tap outside to dismiss keyboard (nice UX)
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            // add keyboard inset to bottom so content can move above the keyboard
            padding: EdgeInsets.fromLTRB(
              AppConstants.defaultPadding,
              AppConstants.defaultPadding,
              AppConstants.defaultPadding,
              AppConstants.defaultPadding + bottomInset,
            ),
            // allow drag to dismiss keyboard — helpful on mobile
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInputSection(context, converter, category),
                const SizedBox(height: AppConstants.largePadding),
                _buildScrollableResultsSection(
                  context,
                  converter,
                  category,
                  isLandscape,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build input section with value and unit selector
  Widget _buildInputSection(BuildContext context, ConverterProvider converter,
      ConversionCategory category) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Convert ${category.name}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            Row(
              children: [
                // Input field
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _inputController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Value',
                      border: OutlineInputBorder(),
                      filled: true,
                    ),
                    onChanged: (value) {
                      converter.setInputValue(value);
                    },
                    textInputAction: TextInputAction.done,
                  ),
                ),
                const SizedBox(width: AppConstants.defaultPadding),
                // From unit selector
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: category.units.contains(converter.fromUnit)
                        ? converter.fromUnit
                        : category.units.first,
                    decoration: const InputDecoration(
                      labelText: 'From',
                      border: OutlineInputBorder(),
                      filled: true,
                    ),
                    isExpanded: true,
                    items: category.units
                        .map((unit) => DropdownMenuItem(
                              value: unit,
                              child:
                                  Text(unit, overflow: TextOverflow.ellipsis),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        converter.setFromUnit(value);
                        // Dismiss keyboard when changing units
                        FocusScope.of(context).unfocus();
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build scrollable results section for both portrait and landscape
  Widget _buildScrollableResultsSection(
    BuildContext context,
    ConverterProvider converter,
    ConversionCategory category,
    bool isLandscape,
  ) {
    final inputValue = converter.inputValue;
    final fromUnit = category.units.contains(converter.fromUnit)
        ? converter.fromUnit
        : category.units.first;

    if (inputValue.isNaN || inputValue.isInfinite) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Text(
            'Enter a valid number to see conversions',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (isLandscape) {
      // Landscape: Grid layout (non-scrollable, shrink-wrapped)
      final screenWidth = MediaQuery.of(context).size.width;
      final crossAxisCount = screenWidth > 900 ? 4 : 3;

      return GridView.count(
        crossAxisCount: crossAxisCount,

        childAspectRatio: 3, // makes it slim
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        children: category.units.map((toUnit) {
          final result =
              _convertValue(inputValue, fromUnit, toUnit, category.name);
          final isFromUnit = fromUnit == toUnit;

          return Card(
            margin: const EdgeInsets.all(4.0),
            color: isFromUnit
                ? Theme.of(context).colorScheme.primaryContainer
                : null,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(toUnit, style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 8),
                      Text(result,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                )),
          );
        }).toList(),
      );
    } else {
      // Portrait: List layout (non-scrollable, shrink-wrapped)
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20),
        itemCount: category.units.length,
        itemBuilder: (context, index) {
          final toUnit = category.units[index];
          final result =
              _convertValue(inputValue, fromUnit, toUnit, category.name);
          final isFromUnit = fromUnit == toUnit;

          return Card(
            margin: const EdgeInsets.only(bottom: AppConstants.smallPadding),
            color: isFromUnit
                ? Theme.of(context).colorScheme.primaryContainer
                : null,
            child: ListTile(
              title: Text(
                toUnit,
                style: TextStyle(
                  fontWeight: isFromUnit ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              trailing: Text(
                result,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  color: isFromUnit
                      ? Theme.of(context).colorScheme.onPrimaryContainer
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$result $toUnit'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
          );
        },
      );
    }
  }

  /// Convert value between units
  String _convertValue(
      double value, String fromUnit, String toUnit, String category) {
    if (fromUnit == toUnit) {
      return CalculatorUtils.formatNumber(value);
    }

    try {
      double result;

      switch (category) {
        case 'Length':
          result = _convertLength(value, fromUnit, toUnit);
          break;
        case 'Weight':
          result = _convertWeight(value, fromUnit, toUnit);
          break;
        case 'Temperature':
          result = _convertTemperature(value, fromUnit, toUnit);
          break;
        case 'Area':
          result = _convertArea(value, fromUnit, toUnit);
          break;
        case 'Speed':
          result = _convertSpeed(value, fromUnit, toUnit);
          break;
        case 'Time':
          result = _convertTime(value, fromUnit, toUnit);
          break;
        case 'Storage':
          result = _convertStorage(value, fromUnit, toUnit);
          break;
        case 'Energy':
          result = _convertEnergy(value, fromUnit, toUnit);
          break;
        default:
          return 'Error';
      }

      return CalculatorUtils.formatNumber(result);
    } catch (e) {
      return 'Error';
    }
  }

  // Conversion helper methods (same as yours)...
  double _convertLength(double value, String from, String to) {
    double cm;
    switch (from) {
      case 'cm':
        cm = value;
        break;
      case 'm':
        cm = value * 100;
        break;
      case 'km':
        cm = value * 100000;
        break;
      case 'in':
        cm = value * 2.54;
        break;
      case 'ft':
        cm = value * 30.48;
        break;
      case 'mi':
        cm = value * 160934;
        break;
      default:
        throw Exception('Unknown unit');
    }
    switch (to) {
      case 'cm':
        return cm;
      case 'm':
        return LengthConverter.cmToM(cm);
      case 'km':
        return LengthConverter.cmToKm(cm);
      case 'in':
        return LengthConverter.cmToIn(cm);
      case 'ft':
        return LengthConverter.cmToFt(cm);
      case 'mi':
        return cm / 160934;
      default:
        throw Exception('Unknown unit');
    }
  }

  double _convertWeight(double value, String from, String to) {
    double g;
    switch (from) {
      case 'g':
        g = value;
        break;
      case 'kg':
        g = value * 1000;
        break;
      case 'lbs':
        g = value * 453.592;
        break;
      case 'oz':
        g = value * 28.3495;
        break;
      default:
        throw Exception('Unknown unit');
    }
    switch (to) {
      case 'g':
        return g;
      case 'kg':
        return WeightConverter.gToKg(g);
      case 'lbs':
        return WeightConverter.gToLbs(g);
      case 'oz':
        return g / 28.3495;
      default:
        throw Exception('Unknown unit');
    }
  }

  double _convertTemperature(double value, String from, String to) {
    switch (from + to) {
      case '°C°F':
        return TemperatureConverter.celsiusToFahrenheit(value);
      case '°CK':
        return TemperatureConverter.celsiusToKelvin(value);
      case '°F°C':
        return TemperatureConverter.fahrenheitToCelsius(value);
      case '°FK':
        return TemperatureConverter.fahrenheitToKelvin(value);
      case 'K°C':
        return TemperatureConverter.kelvinToCelsius(value);
      case 'K°F':
        return TemperatureConverter.kelvinToFahrenheit(value);
      default:
        return value;
    }
  }

  double _convertArea(double value, String from, String to) {
    double sqm;
    switch (from) {
      case 'm²':
        sqm = value;
        break;
      case 'km²':
        sqm = value * 1000000;
        break;
      case 'ft²':
        sqm = value / 10.7639;
        break;
      case 'acre':
        sqm = value * 4047;
        break;
      case 'hectare':
        sqm = value * 10000;
        break;
      default:
        throw Exception('Unknown unit');
    }
    switch (to) {
      case 'm²':
        return sqm;
      case 'km²':
        return AreaConverter.sqmToSqkm(sqm);
      case 'ft²':
        return AreaConverter.sqmToSqft(sqm);
      case 'acre':
        return AreaConverter.sqmToAcre(sqm);
      case 'hectare':
        return AreaConverter.sqmToHectare(sqm);
      default:
        throw Exception('Unknown unit');
    }
  }

  double _convertSpeed(double value, String from, String to) {
    double ms;
    switch (from) {
      case 'm/s':
        ms = value;
        break;
      case 'km/h':
        ms = SpeedConverter.kmhToMs(value);
        break;
      case 'mph':
        ms = SpeedConverter.mphToMs(value);
        break;
      default:
        throw Exception('Unknown unit');
    }
    switch (to) {
      case 'm/s':
        return ms;
      case 'km/h':
        return SpeedConverter.msToKmh(ms);
      case 'mph':
        return SpeedConverter.msToMph(ms);
      default:
        throw Exception('Unknown unit');
    }
  }

  double _convertTime(double value, String from, String to) {
    double sec;
    switch (from) {
      case 'sec':
        sec = value;
        break;
      case 'min':
        sec = TimeConverter.minutesToSeconds(value);
        break;
      case 'hours':
        sec = TimeConverter.hoursToSeconds(value);
        break;
      case 'days':
        sec = TimeConverter.daysToSeconds(value);
        break;
      default:
        throw Exception('Unknown unit');
    }
    switch (to) {
      case 'sec':
        return sec;
      case 'min':
        return TimeConverter.secondsToMinutes(sec);
      case 'hours':
        return TimeConverter.secondsToHours(sec);
      case 'days':
        return TimeConverter.secondsToDays(sec);
      default:
        throw Exception('Unknown unit');
    }
  }

  double _convertStorage(double value, String from, String to) {
    double bytes;
    switch (from) {
      case 'bytes':
        bytes = value;
        break;
      case 'KB':
        bytes = StorageConverter.kbToBytes(value);
        break;
      case 'MB':
        bytes = StorageConverter.mbToBytes(value);
        break;
      case 'GB':
        bytes = StorageConverter.gbToBytes(value);
        break;
      default:
        throw Exception('Unknown unit');
    }
    switch (to) {
      case 'bytes':
        return bytes;
      case 'KB':
        return StorageConverter.bytesToKB(bytes);
      case 'MB':
        return StorageConverter.bytesToMB(bytes);
      case 'GB':
        return StorageConverter.bytesToGB(bytes);
      default:
        throw Exception('Unknown unit');
    }
  }

  double _convertEnergy(double value, String from, String to) {
    // Convert to joules first
    double j;
    switch (from) {
      case 'J':
        j = value;
        break;
      case 'cal':
        j = EnergyConverter.caloriesToJoules(value);
        break;
      case 'kWh':
        j = EnergyConverter.kwhToJoules(value);
        break;
      default:
        throw Exception('Unknown unit');
    }

    switch (to) {
      case 'J':
        return j;
      case 'cal':
        return EnergyConverter.joulesToCalories(j);
      case 'kWh':
        return EnergyConverter.joulesToKwh(j);
      default:
        throw Exception('Unknown unit');
    }
  }
}

/// Model for conversion categories
class ConversionCategory {
  final String name;
  final IconData icon;
  final List<String> units;

  ConversionCategory({
    required this.name,
    required this.icon,
    required this.units,
  });
}
