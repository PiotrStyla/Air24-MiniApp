import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
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
    if (status == 'delayed') {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Delayed Flight Detected!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Flight: \\${flight.flightData['number'] ?? ''}'),
              Text('From: \\${flight.departureAirport.name}'),
              Text('To: \\${flight.arrivalAirport.name}'),
              Text('Status: \\${flight.flightData['status'] ?? ''}'),
              const SizedBox(height: 12),
              const Text('This flight is delayed. You may be eligible for compensation.'),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Dismiss'),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
            ElevatedButton(
              child: const Text('Start Claim'),
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
        title: const Text('Flight Detected!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Flight: \\${flight.flightData['number'] ?? ''}'),
            Text('From: \\${flight.departureAirport.name}'),
            Text('To: \\${flight.arrivalAirport.name}'),
            Text('Status: \\${flight.flightData['status'] ?? ''}'),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Dismiss'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          ElevatedButton(
            child: const Text('Start Claim'),
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
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Column(
        children: [
          // View Compensation Eligible Flights button removed
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.calculate, color: Colors.blue),
              label: const Text('Check Flight Compensation Eligibility'),
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
              label: const Text('EU-Wide Compensation Eligible Flights'),
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
            child: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                final user = snapshot.data;
                if (user == null) {
                  return Center(child: Text('Not signed in'));
                }
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (user.photoURL != null)
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(user.photoURL!),
                        ),
                      const SizedBox(height: 16),
                      Text('Welcome, ${user.email ?? "User"}'),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}