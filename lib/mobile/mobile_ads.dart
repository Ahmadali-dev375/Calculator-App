// ignore_for_file: sized_box_for_whitespace, avoid_print, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  bool _isLoading = true;
  String? _errorMessage;
  int _retryAttempts = 0;
  static const int _maxRetryAttempts = 3;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  String get _adUnitId {
    // IMPORTANT: Replace these with your actual ad unit IDs

    // Your production ad unit ID

    return 'ca-app-pub-8898966134256737/5933074562';
  }

  void _loadBannerAd() {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    _bannerAd?.dispose();
    _bannerAd = null;

    _bannerAd = BannerAd(
      adUnitId: _adUnitId,
      size: AdSize.banner,
      request: const AdRequest(
        // Add non-personalized ads flag if needed for GDPR compliance
        nonPersonalizedAds: false,
      ),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          print('✅ Banner ad loaded successfully');
          if (mounted) {
            setState(() {
              _isAdLoaded = true;
              _isLoading = false;
              _retryAttempts = 0; // Reset retry attempts on success
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          print('❌ Banner ad failed to load: ${error.message}');
          print('Error code: ${error.code}');
          print('Error domain: ${error.domain}');

          // Dispose the failed ad
          ad.dispose();
          _bannerAd = null;

          if (mounted) {
            setState(() {
              _isAdLoaded = false;
              _isLoading = false;
              _errorMessage = '${error.code}: ${error.message}';
            });

            // Retry loading with exponential backoff
            if (_retryAttempts < _maxRetryAttempts) {
              _retryAttempts++;
              final retryDelay = Duration(seconds: _retryAttempts * 5);
              print(
                  '🔄 Retrying ad load in ${retryDelay.inSeconds}s (attempt $_retryAttempts/$_maxRetryAttempts)');

              Future.delayed(retryDelay, () {
                if (mounted) {
                  _loadBannerAd();
                }
              });
            }
          }
        },
        onAdOpened: (ad) {
          print('📱 Banner ad opened');
        },
        onAdClosed: (ad) {
          print('🚪 Banner ad closed');
        },
        onAdClicked: (ad) {
          print('👆 Banner ad clicked');
        },
        onAdImpression: (ad) {
          print('👁️ Banner ad impression recorded');
        },
      ),
    );

    _bannerAd!.load();
  }

  Widget _buildLoadingWidget() {
    return Container(
      width: AdSize.banner.width.toDouble(),
      height: AdSize.banner.height.toDouble(),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Loading ad...',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: AdSize.banner.width.toDouble(),
      height: AdSize.banner.height.toDouble(),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.error.withOpacity(0.2),
        ),
      ),
      child: InkWell(
        onTap: () {
          _retryAttempts = 0; // Reset retry attempts on manual retry
          _loadBannerAd();
        },
        borderRadius: BorderRadius.circular(8),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.ads_click_outlined,
                    color: Theme.of(context).colorScheme.error.withOpacity(0.6),
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Ad unavailable',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptySpace() {
    // Return minimal space when ad fails to load
    return const SizedBox(height: 8);
  }

  @override
  Widget build(BuildContext context) {
    // If ad is loaded successfully, show it
    if (_bannerAd != null && _isAdLoaded) {
      return Container(
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: AdWidget(ad: _bannerAd!),
        ),
      );
    }

    // Show loading state
    if (_isLoading) {
      return _buildLoadingWidget();
    }

    // Show error state or empty space based on preference
    if (_errorMessage != null) {
      // In production, you might want to return _buildEmptySpace() instead
      return kDebugMode ? _buildErrorWidget() : _buildEmptySpace();
    }

    // Fallback to empty space
    return _buildEmptySpace();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }
}
