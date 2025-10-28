// ignore_for_file: prefer_const_literals_to_create_immutables, sized_box_for_whitespace, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'features/settings/logic/settings_provider.dart';
import 'features/calculator/view/calculator_screen.dart';
import 'features/converter/view/converter_screen.dart';
import 'features/history/view/history_screen.dart';
import 'features/settings/view/settings_screen.dart';
import 'mobile/mobile_ads.dart';

/// Main app widget with theming and navigation
class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return MaterialApp(
          title: 'Calculator Pro',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme(settings.accentColor),
          darkTheme: AppTheme.darkTheme(settings.accentColor),
          themeMode: settings.themeMode,
          home: const MainScreen(),
          routes: {
            '/history': (context) => const HistoryScreen(),
            '/settings': (context) => const SettingsScreen(),
          },
        );
      },
    );
  }
}

/// Main screen with bottom navigation
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  Widget _buildLeadingButtons(BuildContext context) {
    return SizedBox(
      width: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 32,
            height: 32,
            child: IconButton(
              icon: const Icon(Icons.receipt_outlined, size: 16),
              tooltip: 'Calculation History',
              onPressed: () => Navigator.pushNamed(context, '/history'),
              padding: EdgeInsets.zero,
            ),
          ),
          SizedBox(
            width: 32,
            height: 32,
            child: IconButton(
              icon: const Icon(Icons.settings, size: 16),
              tooltip: 'Settings',
              onPressed: () => Navigator.pushNamed(context, '/settings'),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    // Use minimal, fixed heights that adapt slightly to screen size
    // These heights are just enough for functionality without being excessive
    final appBarHeight = isLandscape ? 44.0 : 56.0; // Standard Material heights
    final tabBarHeight = isLandscape ? 36.0 : 48.0; // Compact in landscape

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(appBarHeight + tabBarHeight),
          child: AppBar(
            toolbarHeight: appBarHeight,
            centerTitle: !isLandscape,
            title: Text(
              _currentIndex == 0 ? 'Calculator' : 'Converter',
              style: TextStyle(
                fontSize: isLandscape ? 16 : 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            automaticallyImplyLeading: false,
            leading: isLandscape
                ? _buildLeadingButtons(context)
                : SizedBox(
                    width: 40,
                    height: 40,
                    child: IconButton(
                      icon: const Icon(Icons.receipt_outlined, size: 20),
                      tooltip: 'Calculation History',
                      onPressed: () => Navigator.pushNamed(context, '/history'),
                      padding: EdgeInsets.zero,
                    ),
                  ),
            leadingWidth: isLandscape ? 80 : 48,
            actions: [
              if (!isLandscape)
                SizedBox(
                  width: 40,
                  height: 40,
                  child: IconButton(
                    icon: const Icon(Icons.settings, size: 20),
                    onPressed: () => Navigator.pushNamed(context, '/settings'),
                    padding: EdgeInsets.zero,
                  ),
                ),
              // Show banner ad in AppBar actions only in landscape mode
              if (isLandscape) ...[
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: double.infinity, // max horizontal space
                    maxHeight: 35, // max vertical space
                  ),
                  child: const BannerAdWidget(),
                ),
                const SizedBox(width: 16),
              ],
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(tabBarHeight),
              child: SizedBox(
                height: tabBarHeight,
                child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 2.0,
                  labelPadding: EdgeInsets.symmetric(
                    horizontal: isLandscape ? 12 : 16,
                    vertical: 0,
                  ),
                  tabs: [
                    Tab(
                      height: tabBarHeight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calculate,
                            size: isLandscape ? 16 : 20,
                          ),
                          SizedBox(width: isLandscape ? 4 : 8),
                          Flexible(
                            child: Text(
                              'Calculator',
                              style: TextStyle(
                                fontSize: isLandscape ? 12 : 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      height: tabBarHeight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.swap_horiz,
                            size: isLandscape ? 16 : 20,
                          ),
                          SizedBox(width: isLandscape ? 4 : 8),
                          Flexible(
                            child: Text(
                              'Converter',
                              style: TextStyle(
                                fontSize: isLandscape ? 12 : 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            // Show banner ad below AppBar only in portrait mode with optimal height
            if (!isLandscape)
              SizedBox(
                height: 60, // Fixed height instead of percentage
                child: const BannerAdWidget(),
              ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  const CalculatorScreen(),
                  const ConverterScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
