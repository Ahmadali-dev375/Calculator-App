// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'features/settings/logic/settings_provider.dart';
import 'features/calculator/logic/calculator_provider.dart';
import 'features/history/logic/history_provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';

/// Entry point of the calculator application
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Mobile Ads SDK with error handling
  try {
    final initializationStatus = await MobileAds.instance.initialize();

    // Log initialization status for each adapter
    if (kDebugMode) {
      print('📱 AdMob initialization completed');
      initializationStatus.adapterStatuses.forEach((key, value) {
        print('Adapter: $key - Status: ${value.state}');
      });
    }
  } catch (e) {
    debugPrint('❌ AdMob initialization failed: $e');
  }

  // Configure test devices and request settings
  if (kDebugMode) {
    // Add your test device IDs here
    // To find your test device ID, run the app and check the logs
    RequestConfiguration requestConfiguration = RequestConfiguration(
      testDeviceIds: [
        // Add your actual test device IDs here
        // Example: '33BE2250B43518CCDA7DE426D04EE231'
        // You can find this ID in the debug console when running your app
      ],
    );
    MobileAds.instance.updateRequestConfiguration(requestConfiguration);
  }

  // Set up proper ad loading configuration for production
  MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(
      // Set max ad content rating (G, PG, T, MA)
      maxAdContentRating: MaxAdContentRating.g,

      // COPPA compliance - set based on your app's target audience
      tagForChildDirectedTreatment: TagForChildDirectedTreatment.unspecified,

      // GDPR compliance - set based on your app's requirements
      tagForUnderAgeOfConsent: TagForUnderAgeOfConsent.unspecified,

      // Test device IDs for testing (only in debug mode)
      testDeviceIds: kDebugMode
          ? [
              // Your test device IDs go here
            ]
          : null,
    ),
  );

  // Enable debugging for AdMob in debug mode
  if (kDebugMode) {
    ConsentDebugSettings debugSettings = ConsentDebugSettings(
      debugGeography: DebugGeography.debugGeographyEea,
    );

    ConsentRequestParameters params = ConsentRequestParameters(
      consentDebugSettings: debugSettings,
    );

    ConsentInformation.instance.requestConsentInfoUpdate(params, () {
      print('🔒 Consent info updated successfully');
    }, (error) {
      print('❌ Consent info update failed: ${error.message}');
    });
  }

  // Initialize providers
  final settingsProvider = SettingsProvider();
  final historyProvider = HistoryProvider();
  final calculatorProvider = CalculatorProvider(historyProvider);

  // Load saved settings and history
  try {
    await settingsProvider.loadSettings();
    await historyProvider.loadHistory();
  } catch (e) {
    debugPrint('Error loading app data: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => settingsProvider),
        ChangeNotifierProvider(create: (_) => historyProvider),
        ChangeNotifierProvider(create: (_) => calculatorProvider),
      ],
      child: const CalculatorApp(),
    ),
  );
}
