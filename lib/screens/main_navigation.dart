import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:async';
import 'package:f35_flight_compensation/core/emergency_null_safety.dart';

// Screens
import 'home_screen.dart';
import 'package:f35_flight_compensation/screens/enhanced_claim_dashboard_screen.dart';
import 'quick_claim_screen.dart';
import 'profile_screen.dart';

// Core
import 'package:f35_flight_compensation/core/services/service_initializer.dart';
import 'package:f35_flight_compensation/core/error/error_handler.dart';
import 'package:f35_flight_compensation/utils/translation_initializer.dart';
import 'package:f35_flight_compensation/services/notification_service.dart';
import 'package:f35_flight_compensation/services/donation_popup_service.dart';
import 'package:f35_flight_compensation/core/privacy/consent_banner.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  late final NotificationService _notificationService;
  late final ErrorHandler _errorHandler;
  StreamSubscription<String>? _notificationSubscription;
  StreamSubscription<AppError>? _errorSubscription;

  @override
  void initState() {
    super.initState();
    
    // Force reload Polish translations if needed
    TranslationInitializer.ensureAllTranslations();
    
    // Initialize services (minimal version)
    _initializeServices();
    
    // Show donation popup after app loads (skip in tests to avoid pending timers)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!ServiceInitializer.isTestMode && ServiceInitializer.donationsEnabled) {
        DonationPopupService.showPopupIfNeeded(context);
      }
    });
  }

  void _initializeServices() {
    try {
      // Initialize notifications
      _notificationService = ServiceInitializer.get<NotificationService>();
      
      // Initialize error handler
      _errorHandler = ServiceInitializer.get<ErrorHandler>();
    } catch (e) {
      debugPrint('Error initializing services: $e');
    }
  }

  @override
  void dispose() {
    // Cancel subscriptions
    _notificationSubscription?.cancel();
    _errorSubscription?.cancel();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Define screens inside build to pass the correct context for localization
    final List<Widget> screens = [
      HomeScreen(),
      const EnhancedClaimDashboardScreen(),
      const ProfileScreen(),
    ];

    final l10n = EmergencyNullSafety.safeLocalizations(context);
    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: EmergencyNullSafety.safeLocalizations(context).home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.description),
            label: EmergencyNullSafety.safeLocalizations(context).claims,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: EmergencyNullSafety.safeLocalizations(context).settings,
          ),
        ],
      ),
      persistentFooterButtons: kIsWeb
          ? [
              TextButton(
                onPressed: () => Navigator.of(context).pushNamed('/privacy'),
                child: Text(l10n.privacyPolicy),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pushNamed('/terms'),
                child: Text(l10n.termsOfService),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pushNamed('/cookies'),
                child: Text(l10n.cookiePolicy),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pushNamed('/legal'),
                child: Text(l10n.legalNoticeImprint),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pushNamed('/accessibility'),
                child: Text(l10n.accessibilityStatement),
              ),
              TextButton(
                onPressed: () => ConsentManager.openPreferences(context),
                child: Text(l10n.manageCookiePreferences),
              ),
            ]
          : null,
      floatingActionButton: _selectedIndex == 0 
        ? FloatingActionButton.extended(
            heroTag: 'main_navigation_fab',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => QuickClaimScreen(
                    flightNumber: '',
                    departureAirport: '',
                    arrivalAirport: '',
                    flightDate: DateTime.now(),
                  ),
                ),
              );
            },
            label: Text(EmergencyNullSafety.safeLocalizations(context).newClaim),
            icon: const Icon(Icons.add),
          )
        : null,
    );
  }
}
