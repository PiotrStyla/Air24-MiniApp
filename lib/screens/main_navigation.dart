import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'claims_screen.dart';
import 'profile_screen.dart';
import '../services/opensky_service.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import '../services/location_history_manager.dart';
import '../services/airport_utils.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  Timer? _locationTimer;
  final LocationHistoryManager _historyManager = LocationHistoryManager();

  static final List<Widget> _screens = [
    HomeScreen(),
    ClaimsScreen(),
    // Wrap ProfileScreen with a button for confirmed flights
    Builder(
      builder: (context) => Stack(
        children: [
          ProfileScreen(),
          Positioned(
            right: 16,
            top: 16,
            child: ElevatedButton.icon(
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
                    builder: (context) => const ConfirmedFlightsScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startLocationSampling();
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
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
          final filteredMatches = matches.where((f) {
            final altitude = (f[7] is num) ? f[7] as num : null;
            final velocity = (f[9] is num) ? f[9] as num : null;
            final isHighAltitude = altitude != null && altitude > 1000;
            final isFast = velocity != null && velocity > 100;
            final nearOrigin = originAirport != null &&
              AirportUtils._distanceKm(prev.latitude, prev.longitude, originAirport.latitude, originAirport.longitude) < 30;
            final nearDest = destAirport != null &&
              AirportUtils._distanceKm(sample.latitude, sample.longitude, destAirport.latitude, destAirport.longitude) < 30;
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
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final service = OpenSkyService();
          try {
            // Request location permission if needed
            LocationPermission permission = await Geolocator.checkPermission();
            if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
              permission = await Geolocator.requestPermission();
              if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
                if (!mounted) return;
                showDialog(
                  context: context,
                  builder: (context) => const AlertDialog(
                    title: Text('Location Required'),
                    content: Text('Location permission is required to detect flights near you.'),
                  ),
                );
                return;
              }
            }
            final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
            // Create a bounding box of ~0.6 degrees around the user (about 60km)
            final double delta = 0.3;
            final flights = await service.getFlightsInArea(
              lamin: position.latitude - delta,
              lomin: position.longitude - delta,
              lamax: position.latitude + delta,
              lomax: position.longitude + delta,
            );
            if (!mounted) return;
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('OpenSky Test'),
                content: SizedBox(
                  width: 300,
                  height: 350,
                  child: flights.isEmpty
                      ? const Text('No flights found.')
                      : Scrollbar(
                          child: ListView.builder(
                            itemCount: flights.length,
                            itemBuilder: (context, index) {
                              final f = flights[index];
                              // OpenSky state vector: [0]icao24, [1]callsign, [2]origin_country, [5]baro_altitude, [6]on_ground, [9]velocity
                              final callsign = (f[1] ?? '').toString().trim();
                              final originCountry = (f[2] ?? '').toString();
                              final altitude = f[7]?.toStringAsFixed(0) ?? 'N/A';
                              final velocity = f[9]?.toStringAsFixed(0) ?? 'N/A';
                              return ListTile(
                                leading: const Icon(Icons.flight),
                                title: Text('Callsign: \\${callsign.isEmpty ? 'N/A' : callsign}'),
                                subtitle: Text('Country: \\${originCountry}\nAlt: \\${altitude} m\nVel: \\${velocity} m/s'),
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
          } catch (e) {
            if (!mounted) return;
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Error'),
                content: Text('Failed to fetch flights: \\${e.toString()}'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
        },
        child: const Icon(Icons.airplanemode_active),
        tooltip: 'Test OpenSky',
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Claims',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
