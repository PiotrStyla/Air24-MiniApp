import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import '../services/auth_service.dart';
import '../core/services/service_initializer.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'compensation_eligible_flights_screen.dart';
import 'eu_eligible_flights_screen.dart';
import '../services/airport_selection_helper.dart';
import '../services/flight_detection_service.dart';
import '../utils/translation_helper.dart';
import '../services/manual_localization_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DetectedFlight? _detectedFlight;
  String? _flightDetectionError;
  bool _checkingFlight = false;

  @override
  void initState() {
    super.initState();
    _checkForFlightJump();
    // Force refresh of translations when screen loads to ensure consistency
    Future.delayed(Duration.zero, () {
      if (mounted) {
        debugPrint('HomeScreen: Ensuring translations are loaded correctly');
        TranslationHelper.forceReloadTranslations(context);
      }
    });
  }

  Future<void> _checkForFlightJump() async {
    setState(() { _checkingFlight = true; });
    try {
      await FlightDetectionService().checkForFlightJump(
        onFlightDetected: (flight) {
          setState(() {
            _detectedFlight = flight;
            _checkingFlight = false;
          });
          if (flight != null) {
            _showFlightDetectedDialog(flight);
          }
        },
      );
    } catch (e) {
      setState(() {
        _flightDetectionError = e.toString();
        _checkingFlight = false;
      });
    }
  }

  DateTime? _parseFlightDate(Map<String, dynamic> flightData) {
    final movement = flightData['movement'] ?? {};
    final scheduled = movement['scheduledTime'] ?? {};
    final dateStr = scheduled['utc'] ?? scheduled['local'];
    if (dateStr != null) {
      try {
        return DateTime.parse(dateStr);
      } catch (_) {}
    }
    return null;
  }

  void _showFlightDetectedDialog(DetectedFlight flight) {
    final status = (flight.flightData['status'] ?? '').toString().toLowerCase();
    if (status == 'delayed') {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(TranslationHelper.getString(context, 'delayedFlightDetected', fallback: 'Delayed Flight Detected!')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(TranslationHelper.getString(context, 'flightLabel', fallback: 'Flight: {number}').replaceAll('{number}', flight.flightData['number'] ?? '')),
              Text(TranslationHelper.getString(context, 'fromAirport', fallback: 'From: {airport}').replaceAll('{airport}', flight.departureAirport.name)),
              Text(TranslationHelper.getString(context, 'toAirport', fallback: 'To: {airport}').replaceAll('{airport}', flight.arrivalAirport.name)),
              Text(TranslationHelper.getString(context, 'statusLabel', fallback: 'Status: {status}').replaceAll('{status}', flight.flightData['status'] ?? '')),
              const SizedBox(height: 12),
              Text(TranslationHelper.getString(context, 'delayedEligible', fallback: 'This flight may be eligible for compensation!')),
            ],
          ),
          actions: [
            TextButton(
              child: Text(TranslationHelper.getString(context, 'dismiss', fallback: 'Dismiss')),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
            ElevatedButton(
              child: Text(TranslationHelper.getString(context, 'startClaim', fallback: 'Start Claim')),
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pushNamed(
                  '/claim-submission',
                  arguments: {
                    'prefillFlightNumber': flight.flightData['number'],
                    'prefillDepartureAirport': flight.departureAirport.icao,
                    'prefillArrivalAirport': flight.arrivalAirport.icao,
                    'prefillFlightDate': _parseFlightDate(flight.flightData),
                    'prefillReason': 'delay',
                  },
                );
              },
            ),
          ],
        ),
      );
      return;
    }
    // Default (not delayed)
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(TranslationHelper.getString(context, 'flightDetected', fallback: 'Flight Detected')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(TranslationHelper.getString(context, 'flightLabel', fallback: 'Flight: {number}').replaceAll('{number}', flight.flightData['number'] ?? '')),
            Text(TranslationHelper.getString(context, 'fromAirport', fallback: 'From: {airport}').replaceAll('{airport}', flight.departureAirport.name)),
            Text(TranslationHelper.getString(context, 'toAirport', fallback: 'To: {airport}').replaceAll('{airport}', flight.arrivalAirport.name)),
            Text(TranslationHelper.getString(context, 'statusLabel', fallback: 'Status: {status}').replaceAll('{status}', flight.flightData['status'] ?? '')),
          ],
        ),
        actions: [
          TextButton(
            child: Text(TranslationHelper.getString(context, 'dismiss', fallback: 'Dismiss')),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          ElevatedButton(
            child: Text(TranslationHelper.getString(context, 'startClaim', fallback: 'Start Claim')),
            onPressed: () {
              Navigator.of(ctx).pop();
              // Navigate to claim submission with prefilled details
              Navigator.of(context).pushNamed(
                '/claim-submission',
                arguments: {
                  'prefillFlightNumber': flight.flightData['number'],
                  'prefillDepartureAirport': flight.departureAirport.icao,
                  'prefillArrivalAirport': flight.arrivalAirport.icao,
                  'prefillFlightDate': _parseFlightDate(flight.flightData),
                },
              );
            },
          ),
          // Delayed Arrivals button removed as it wasn't working properly
        ],
      ),
    );
  }

  String? _currentAirportIcao;
  String? _currentAirportName;

  @override
  Widget build(BuildContext context) {
    // Use TranslationHelper instead of direct AppLocalizations
    // to ensure consistent Polish translations
    return Scaffold(
      appBar: AppBar(title: Text(TranslationHelper.getString(context, 'home', fallback: 'Home'))),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.calculate, color: Colors.blue),
              label: Text(TranslationHelper.getString(context, 'checkCompensationEligibility', fallback: 'Check Compensation Eligibility')),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
                elevation: 2,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/compensation-checker');
              },
            ),
          ),
          // Adding EU-wide compensation eligible flights button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.public, color: Colors.green),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.green[800],
                side: BorderSide(color: Colors.green[800]!),
              ),
              label: Text(TranslationHelper.getString(context, 'euWideEligibleFlights', fallback: 'EU-Wide Eligible Flights')),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => const EUEligibleFlightsScreen(),
                  ),
                );
              },
            ),
          ),

          Expanded(
            child: Consumer<AuthService>(
              builder: (context, authService, _) {
                return StreamBuilder<User?>(
                  stream: authService.userChanges,
                  builder: (context, snapshot) {
                    final user = snapshot.data;
                    if (user == null) {
                      // User is not signed in
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.account_circle_outlined,
                              size: 80,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              TranslationHelper.getString(context, 'signInToTrackClaims', fallback: 'Sign in to track your claims'),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              TranslationHelper.getString(context, 'createAccountDescription', fallback: 'Create an account to save your flight data\nand manage your compensation claims'),
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.login),
                              label: Text(TranslationHelper.getString(context, 'signInOrSignUp', fallback: 'Sign In / Sign Up')),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                              onPressed: () {
                                // Navigate to the improved auth screen
                                Navigator.of(context).pushNamed('/auth');
                              },
                            ),
                          ],
                        ),
                      );
                    }
                    
                    // User is signed in
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (user.photoURL != null)
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(user.photoURL!),
                            )
                          else
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              child: Text(
                                (user.displayName?.isNotEmpty == true)
                                    ? user.displayName![0].toUpperCase()
                                    : (user.email?.isNotEmpty == true)
                                        ? user.email![0].toUpperCase()
                                        : 'U',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          const SizedBox(height: 16),
                          Text(
                            TranslationHelper.getString(context, 'welcomeUser', fallback: 'Welcome, {username}').replaceAll('{username}', user.displayName ?? user.email ?? TranslationHelper.getString(context, 'genericUser', fallback: 'User')),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24),
                          OutlinedButton.icon(
                            icon: const Icon(Icons.logout),
                            label: Text(TranslationHelper.getString(context, 'signOut', fallback: 'Sign Out')),
                            onPressed: () async {
                              try {
                                await authService.signOut();
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(TranslationHelper.getString(context, 'errorSigningOut', fallback: 'Error signing out: {error}').replaceAll('{error}', e.toString())),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}