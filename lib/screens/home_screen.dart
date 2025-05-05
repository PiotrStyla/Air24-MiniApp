import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'flight_arrivals_screen.dart';

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

  void _showFlightDetectedDialog(DetectedFlight flight) {
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
                  // Optionally: parse and pass flight date
                },
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            final user = snapshot.data;
            if (user == null) {
              // Not signed in
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Not signed in'),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      await authService.signInAnonymously();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Signed in anonymously!')),
                      );
                    },
                    child: const Text('Sign In Anonymously'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/email-auth'),
                    child: const Text('Email Sign In/Up'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.login),
                    label: const Text('Sign In with Google'),
                    onPressed: () async {
                      try {
                        await authService.signInWithGoogle();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Signed in with Google!')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Google sign-in failed: $e')),
                        );
                      }
                    },
                  ),
                ],
              );
            }
            // Signed in - show profile info
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (user.photoURL != null)
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.photoURL!),
                    radius: 40,
                  ),
                const SizedBox(height: 16),
                Text(
                  user.displayName ?? 'No display name',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  user.email ?? 'No email',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    await authService.signOut();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Signed out!')),
                    );
                  },
                  child: const Text('Sign Out'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/email-auth'),
                  child: const Text('Email Sign In/Up'),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: _buildSimulateJumpButton(),
    );
  }

  Widget? _buildSimulateJumpButton() {
    // Only show in debug mode
    const bool isDebug = !bool.fromEnvironment('dart.vm.product');
    if (!isDebug) return null;
    return FloatingActionButton.extended(
      icon: const Icon(Icons.flight_takeoff),
      label: _checkingFlight ? const Text('Simulating...') : const Text('Simulate Jump'),
      onPressed: _checkingFlight ? null : () async {
        final now = DateTime.now();
        final twoHoursAgo = now.subtract(const Duration(hours: 2));
        setState(() { _checkingFlight = true; });
        print('[SIM-JUMP] Starting simulation from LHR to FRA...');
        try {
          await FlightDetectionService().simulateJump(
            fromLat: 51.4700, // LHR
            fromLon: -0.4543,
            toLat: 50.0379,   // FRA
            toLon: 8.5622,
            fromTime: twoHoursAgo,
            toTime: now,
            onFlightDetected: (flight) {
              setState(() {
                _detectedFlight = flight;
                _checkingFlight = false;
              });
              if (flight != null) {
                print('[SIM-JUMP] Flight detected: \\${flight.flightData['number']}');
                _showFlightDetectedDialog(flight);
              } else {
                print('[SIM-JUMP] No matching flight found.');
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('No Flight Found'),
                    content: const Text('No matching flight found in simulation.'),
                    actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('OK'))],
                  ),
                );
              }
            },
            onError: (String errorMsg) {
              setState(() { _checkingFlight = false; });
              print('[SIM-JUMP][ERROR] $errorMsg');
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Simulation Error'),
                  content: Text(errorMsg),
                  actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('OK'))],
                ),
              );
            },
            onArrivalsFetched: (int count) {
              print('[SIM-JUMP] Arrivals fetched: $count');
            },
          );
        } catch (e, st) {
          setState(() { _checkingFlight = false; });
          print('[SIM-JUMP][ERROR] $e\n$st');
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Simulation Error'),
              content: Text('Error during simulation:\n$e'),
              actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('OK'))],
            ),
          );
        }
      },
    );
  }
}