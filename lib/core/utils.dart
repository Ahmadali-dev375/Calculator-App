// ignore_for_file: deprecated_member_use

import 'package:math_expressions/math_expressions.dart';

/// Utility class for mathematical operations and unit conversions
class CalculatorUtils {
  /// Evaluates a mathematical expression string
  static String evaluateExpression(String expression) {
    try {
      // Replace display symbols with parser-friendly symbols
      String parsed = expression
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('%', '/100*');

      Parser p = Parser();
      Expression exp = p.parse(parsed);
      ContextModel cm = ContextModel();
      double result = exp.evaluate(EvaluationType.REAL, cm);

      // Format result to remove unnecessary decimals
      if (result == result.roundToDouble()) {
        return result.round().toString();
      } else {
        return result.toString();
      }
    } catch (e) {
      return 'Error';
    }
  }

  /// Formats number for display
  static String formatNumber(double number) {
    if (number == number.roundToDouble()) {
      return number.round().toString();
    } else {
      return number
          .toStringAsFixed(6)
          .replaceAll(RegExp(r'0*$'), '')
          .replaceAll(RegExp(r'\.$'), '');
    }
  }
}

/// Length conversions
class LengthConverter {
  static double cmToM(double cm) => cm / 100;
  static double cmToKm(double cm) => cm / 100000;
  static double cmToIn(double cm) => cm / 2.54;
  static double cmToFt(double cm) => cm / 30.48;

  static double mToCm(double m) => m * 100;
  static double mToKm(double m) => m / 1000;
  static double mToIn(double m) => m * 39.3701;
  static double mToFt(double m) => m * 3.28084;

  static double kmToCm(double km) => km * 100000;
  static double kmToM(double km) => km * 1000;
  static double kmToMi(double km) => km * 0.621371;
}

/// Weight conversions
class WeightConverter {
  static double kgToLbs(double kg) => kg * 2.20462;
  static double kgToOz(double kg) => kg * 35.274;
  static double kgToG(double kg) => kg * 1000;

  static double lbsToKg(double lbs) => lbs / 2.20462;
  static double lbsToOz(double lbs) => lbs * 16;

  static double gToKg(double g) => g / 1000;
  static double gToLbs(double g) => g / 453.592;
}

/// Temperature conversions
class TemperatureConverter {
  static double celsiusToFahrenheit(double celsius) => (celsius * 9 / 5) + 32;
  static double celsiusToKelvin(double celsius) => celsius + 273.15;

  static double fahrenheitToCelsius(double fahrenheit) =>
      (fahrenheit - 32) * 5 / 9;
  static double fahrenheitToKelvin(double fahrenheit) =>
      (fahrenheit - 32) * 5 / 9 + 273.15;

  static double kelvinToCelsius(double kelvin) => kelvin - 273.15;
  static double kelvinToFahrenheit(double kelvin) =>
      (kelvin - 273.15) * 9 / 5 + 32;
}

/// Area conversions
class AreaConverter {
  static double sqmToSqkm(double sqm) => sqm / 1000000;
  static double sqmToSqft(double sqm) => sqm * 10.7639;
  static double sqmToAcre(double sqm) => sqm / 4047;
  static double sqmToHectare(double sqm) => sqm / 10000;

  static double sqkmToSqm(double sqkm) => sqkm * 1000000;
  static double sqkmToSqmi(double sqkm) => sqkm * 0.386102;

  static double sqftToSqm(double sqft) => sqft / 10.7639;
  static double acreToSqm(double acre) => acre * 4047;
  static double hectareToSqm(double hectare) => hectare * 10000;
}

/// Speed conversions
class SpeedConverter {
  static double msToKmh(double ms) => ms * 3.6;
  static double msToMph(double ms) => ms * 2.23694;

  static double kmhToMs(double kmh) => kmh / 3.6;
  static double kmhToMph(double kmh) => kmh * 0.621371;

  static double mphToMs(double mph) => mph / 2.23694;
  static double mphToKmh(double mph) => mph / 0.621371;
}

/// Time conversions
class TimeConverter {
  static double secondsToMinutes(double seconds) => seconds / 60;
  static double secondsToHours(double seconds) => seconds / 3600;
  static double secondsToDays(double seconds) => seconds / 86400;

  static double minutesToSeconds(double minutes) => minutes * 60;
  static double minutesToHours(double minutes) => minutes / 60;
  static double minutesToDays(double minutes) => minutes / 1440;

  static double hoursToSeconds(double hours) => hours * 3600;
  static double hoursToMinutes(double hours) => hours * 60;
  static double hoursToDays(double hours) => hours / 24;

  static double daysToSeconds(double days) => days * 86400;
  static double daysToMinutes(double days) => days * 1440;
  static double daysToHours(double days) => days * 24;
}

/// Digital storage conversions
class StorageConverter {
  static double bytesToKB(double bytes) => bytes / 1024;
  static double bytesToMB(double bytes) => bytes / (1024 * 1024);
  static double bytesToGB(double bytes) => bytes / (1024 * 1024 * 1024);
  static double bytesToTB(double bytes) => bytes / (1024 * 1024 * 1024 * 1024);

  static double kbToBytes(double kb) => kb * 1024;
  static double kbToMB(double kb) => kb / 1024;
  static double kbToGB(double kb) => kb / (1024 * 1024);

  static double mbToBytes(double mb) => mb * 1024 * 1024;
  static double mbToKB(double mb) => mb * 1024;
  static double mbToGB(double mb) => mb / 1024;

  static double gbToBytes(double gb) => gb * 1024 * 1024 * 1024;
  static double gbToKB(double gb) => gb * 1024 * 1024;
  static double gbToMB(double gb) => gb * 1024;
}

/// Energy conversions
class EnergyConverter {
  static double joulesToCalories(double joules) => joules / 4.184;
  static double joulesToKwh(double joules) => joules / 3600000;

  static double caloriesToJoules(double calories) => calories * 4.184;
  static double caloriesToKwh(double calories) => calories / 860421;

  static double kwhToJoules(double kwh) => kwh * 3600000;
  static double kwhToCalories(double kwh) => kwh * 860421;
}

/// Volume conversions
class VolumeConverter {
  static double litersToGallons(double liters) => liters * 0.264172;
  static double litersToMl(double liters) => liters * 1000;
  static double litersToCubicM(double liters) => liters / 1000;

  static double gallonsToLiters(double gallons) => gallons / 0.264172;
  static double mlToLiters(double ml) => ml / 1000;
  static double cubicMToLiters(double cubicM) => cubicM * 1000;
}

/// Pressure conversions
class PressureConverter {
  static double paToBar(double pa) => pa / 100000;
  static double paToAtm(double pa) => pa / 101325;
  static double paToPsi(double pa) => pa / 6895;

  static double barToPa(double bar) => bar * 100000;
  static double atmToPa(double atm) => atm * 101325;
  static double psiToPa(double psi) => psi * 6895;
}
