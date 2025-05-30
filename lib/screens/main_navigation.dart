import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

// Screens
import 'home_screen.dart';
import 'claims_screen.dart';
import 'profile_screen.dart';
import 'faq_screen.dart';
import 'confirmed_flights_screen.dart';
import 'quick_claim_screen.dart';
import 'claim_submission_screen.dart';
import 'document_management_screen.dart';
import 'claim_detail_screen.dart';
import 'claim_dashboard_screen.dart';

// Services
import '../services/airport_utils.dart';
import '../services/confirmed_flight_storage.dart';
import '../services/opensky_service.dart';
import '../services/location_history_manager.dart';
import '../services/notification_service.dart';

// Models
import '../models/confirmed_flight.dart';

// Core
import '../core/services/service_initializer.dart';
import '../core/error/error_handler.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  Timer? _locationTimer;
  final LocationHistoryManager _historyManager = LocationHistoryManager();
  late final NotificationService _notificationService;
  late final ErrorHandler _errorHandler;
  StreamSubscription<String>? _notificationSubscription;
  StreamSubscription<AppError>? _errorSubscription;

  static final List<Widget> _screens = [
    HomeScreen(),
    const ClaimDashboardScreen(),
    // Wrap ProfileScreen with action buttons
    Builder(
      builder: (context) => Stack(
        children: [
          ProfileScreen(),
          Positioned(
            right: 16,
            top: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.flight_takeoff),
                      label: const Text('My Flights'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ConfirmedFlightsScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    Tooltip(
                      message: 'FAQ & Help',
                      child: IconButton(
                        icon: const Icon(Icons.help_outline, color: Colors.blue),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => FAQScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  icon: const Icon(Icons.description),
                  label: const Text('My Documents'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const DocumentManagementScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    
    // Initialize location tracking
    _startLocationSampling();
    
    // Initialize notifications
    _initializeNotifications();
    
    // Initialize error handling
    _initializeErrorHandling();
  }
  
  /// Initialize push notifications
  Future<void> _initializeNotifications() async {
    try {
      // Get notification service from DI container
      _notificationService = ServiceInitializer.get<NotificationService>();
      
      // Initialize notifications
      await _notificationService.initialize();
      
      // Register device token
      await _notificationService.saveDeviceToken();
      
      // Listen for notification taps
      _notificationSubscription = _notificationService.notificationTaps.listen(_handleNotificationTap);
    } catch (e) {
      debugPrint('Error initializing notifications: $e');
    }
  }
  
  /// Handle notification tap events
  void _handleNotificationTap(String claimId) {
    if (claimId.isNotEmpty) {
      // Navigate to claim details
      _navigateToClaimDetail(claimId);
      
      // Switch to dashboard tab
      setState(() {
        _selectedIndex = 1; // Index of dashboard tab
      });
    }
  }
  
  /// Navigate to claim detail screen
  void _navigateToClaimDetail(String claimId) {
    // Use a small delay to ensure state is updated
    Future.delayed(const Duration(milliseconds: 300), () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ClaimDetailScreen(claimId: claimId),
        ),
      );
    });
  }
  
  /// Initialize centralized error handling
  void _initializeErrorHandling() {
    try {
      // Get error handler from DI container
      _errorHandler = ServiceInitializer.get<ErrorHandler>();
      
      // Listen to app-wide errors
      _errorSubscription = _errorHandler.errorStream.listen(_handleErrorNotification);
    } catch (e) {
      debugPrint('Error initializing error handling: $e');
    }
  }
  
  /// Handle errors that need UI notification
  void _handleErrorNotification(AppError error) {
    // If context is available, show error UI
    if (mounted && context.mounted) {
      _errorHandler.showErrorUI(context, error);
    }
  }

  @override
  void dispose() {
    // Cancel all timers and subscriptions
    _locationTimer?.cancel();
    _notificationSubscription?.cancel();
    _errorSubscription?.cancel();
    super.dispose();
  }

  void _startLocationSampling() {
    // Sample every 10 minutes (600 seconds)
    _locationTimer = Timer.periodic(const Duration(minutes: 10), (_) async {
      try {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
            return;
          }
        }
        final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        final sample = LocationSample(latitude: pos.latitude, longitude: pos.longitude, timestamp: DateTime.now());
        final prev = _historyManager.addSampleAndDetectJump(sample);
        if (prev != null && mounted) {
          // Flight jump detected, query OpenSky for possible matching flights
          final openSky = OpenSkyService();
          final double delta = 0.5; // larger bounding box for matching
          // Query near origin
          final originFlights = await openSky.getFlightsInArea(
            lamin: prev.latitude - delta,
            lomin: prev.longitude - delta,
            lamax: prev.latitude + delta,
            lomax: prev.longitude + delta,
          );
          // Query near destination
          final destFlights = await openSky.getFlightsInArea(
            lamin: sample.latitude - delta,
            lomin: sample.longitude - delta,
            lamax: sample.latitude + delta,
            lomax: sample.longitude + delta,
          );
          // Try to find flights present in both areas by callsign (may be empty if no overlap)
          final originCallsigns = originFlights.map((f) => (f[1] ?? '').toString().trim()).toSet();
          final destCallsigns = destFlights.map((f) => (f[1] ?? '').toString().trim()).toSet();
          final matchingCallsigns = originCallsigns.intersection(destCallsigns)..removeWhere((c) => c.isEmpty);
          // Filter: altitude > 1000m, velocity > 100m/s, proximity to airports (origin/dest within 30km)
          final originAirport = AirportUtils.nearestAirport(prev.latitude, prev.longitude);
          final destAirport = AirportUtils.nearestAirport(sample.latitude, sample.longitude);
          // TODO: Replace with real matches logic
          final List<dynamic> matches = [];
          final filteredMatches = matches.where((f) {
            final altitude = (f[7] is num) ? f[7] as num : null;
            final velocity = (f[9] is num) ? f[9] as num : null;
            final isHighAltitude = altitude != null && altitude > 1000;
            final isFast = velocity != null && velocity > 100;
            final nearOrigin = originAirport != null &&
              AirportUtils.distanceKm(prev.latitude, prev.longitude, originAirport.latitude, originAirport.longitude) < 30;
            final nearDest = destAirport != null &&
              AirportUtils.distanceKm(sample.latitude, sample.longitude, destAirport.latitude, destAirport.longitude) < 30;
            return isHighAltitude && isFast && nearOrigin && nearDest;
          }).toList();

          if (mounted) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Flight Detected!'),
                content: SizedBox(
                  width: 300,
                  height: 350,
                  child: filteredMatches.isEmpty
                      ? const Text('No filtered flights found.\nJump from (origin) to (destination) detected.')
                      : Scrollbar(
                          child: ListView.builder(
                            itemCount: filteredMatches.length,
                            itemBuilder: (context, index) {
                              final f = filteredMatches[index];
                              final callsign = (f[1] ?? '').toString().trim();
                              final originCountry = (f[2] ?? '').toString();
                              final altitude = f[7]?.toStringAsFixed(0) ?? 'N/A';
                              final velocity = f[9]?.toStringAsFixed(0) ?? 'N/A';
                              return ListTile(
                                leading: const Icon(Icons.flight),
                                title: Text('Callsign: \\${callsign.isEmpty ? 'N/A' : callsign}'),
                                subtitle: Text('Country: \\${originCountry}\nAlt: \\${altitude} m\nVel: \\${velocity} m/s'),
                                onTap: () async {
                                  final confirmed = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Confirm Flight'),
                                      content: Text('Do you confirm this is your flight?\n\nCallsign: \\${callsign}\nCountry: \\${originCountry}\nAlt: \\${altitude} m\nVel: \\${velocity} m/s'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(false),
                                          child: const Text('No'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(true),
                                          child: const Text('Yes'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirmed == true && context.mounted) {
                                    // Try to extract details for pre-filling
                                    String flightNumber = callsign;
                                    String departureAirport = originAirport?.code ?? '';
                                    String arrivalAirport = destAirport?.code ?? '';
                                    DateTime flightDate = DateTime.now();
                                    // Store confirmed flight
                                    final confirmedFlight = ConfirmedFlight(
                                      callsign: flightNumber,
                                      originAirport: departureAirport,
                                      destinationAirport: arrivalAirport,
                                      detectedAt: DateTime.now(),
                                    );
                                    await ConfirmedFlightStorage().saveFlight(confirmedFlight);
                                    if (context.mounted) {
                                      Navigator.of(context).pop(); // close dialog
                                      final allRequired = flightNumber.isNotEmpty &&
                                          departureAirport.isNotEmpty &&
                                          arrivalAirport.isNotEmpty &&
                                          flightDate != null;
                                      if (allRequired) {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => QuickClaimScreen(
                                              flightNumber: flightNumber,
                                              departureAirport: departureAirport,
                                              arrivalAirport: arrivalAirport,
                                              flightDate: flightDate,
                                            ),
                                          ),
                                        );
                                      } else {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => ClaimSubmissionScreen(
                                              prefillFlightNumber: flightNumber,
                                              prefillDepartureAirport: departureAirport,
                                              prefillArrivalAirport: arrivalAirport,
                                              prefillFlightDate: flightDate,
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  }
                                },
                              );
                            },
                          ),
                        ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
        }
      } catch (_) {}
    });
  }

  void _onItemTapped(int index) {
    // Map the new navigation structure (3 tabs instead of 4)
    // 0 = Home, 1 = Claims Dashboard, 2 = Profile
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Claims',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
