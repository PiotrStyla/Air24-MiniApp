import 'package:flutter/material.dart';
import 'dart:async';
import '../utils/translation_helper.dart';
import '../l10n2/app_localizations.dart';

// Screens
import 'home_screen.dart';
import 'claims_screen.dart';
import 'profile_screen.dart';
import 'claim_dashboard_screen.dart';
import 'quick_claim_screen.dart';

// Core
import '../core/services/service_initializer.dart';
import '../core/error/error_handler.dart';
import '../utils/translation_initializer.dart';
import '../services/notification_service.dart';

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
      const ClaimDashboardScreen(),
      const ProfileScreen(),
    ];

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
            label: AppLocalizations.of(context)!.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.description),
            label: AppLocalizations.of(context)!.claims,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: AppLocalizations.of(context)!.settings,
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0 
        ? FloatingActionButton.extended(
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
            label: Text(AppLocalizations.of(context)!.newClaim),
            icon: const Icon(Icons.add),
          )
        : null,
    );
  }
}
