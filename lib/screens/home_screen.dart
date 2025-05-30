import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/auth_service.dart';
import '../core/services/service_initializer.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'compensation_eligible_flights_screen.dart';
import 'eu_eligible_flights_screen.dart';
import '../services/airport_selection_helper.dart';
import '../services/flight_detection_service.dart';

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
    final localizations = AppLocalizations.of(context)!;
    if (status == 'delayed') {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(localizations.delayedFlightDetected),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(localizations.flightLabel(flight.flightData['number'] ?? '')),
              Text(localizations.fromAirport(flight.departureAirport.name)),
              Text(localizations.toAirport(flight.arrivalAirport.name)),
              Text(localizations.statusLabel(flight.flightData['status'] ?? '')),
              const SizedBox(height: 12),
              Text(localizations.delayedEligible),
            ],
          ),
          actions: [
            TextButton(
              child: Text(localizations.dismiss),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
            ElevatedButton(
              child: Text(localizations.startClaim),
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
        title: Text(localizations.flightDetected),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(localizations.flightLabel(flight.flightData['number'] ?? '')),
            Text(localizations.fromAirport(flight.departureAirport.name)),
            Text(localizations.toAirport(flight.arrivalAirport.name)),
            Text(localizations.statusLabel(flight.flightData['status'] ?? '')),
          ],
        ),
        actions: [
          TextButton(
            child: Text(localizations.dismiss),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          ElevatedButton(
            child: Text(localizations.startClaim),
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
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(localizations.home)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.calculate, color: Colors.blue),
              label: Text(localizations.checkCompensationEligibility),
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
              label: Text(localizations.euWideEligibleFlights),
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
                            const Text(
                              'Sign in to track your claims',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Create an account to save your flight data\nand manage your compensation claims',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.login),
                              label: const Text('Sign In / Sign Up'),
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
                            'Welcome, ${user.displayName ?? user.email ?? "User"}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24),
                          OutlinedButton.icon(
                            icon: const Icon(Icons.logout),
                            label: const Text('Sign Out'),
                            onPressed: () async {
                              try {
                                await authService.signOut();
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error signing out: $e'),
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