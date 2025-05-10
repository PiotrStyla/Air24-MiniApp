import 'dart:math';

class Airport {
  final String code; // IATA or ICAO for compatibility
  final String iata;
  final String icao;
  final String name;
  final double latitude;
  final double longitude;

  Airport({
    required this.code,
    required this.iata,
    required this.icao,
    required this.name,
    required this.latitude,
    required this.longitude,
  });
}

class AirportUtils {
  static final List<Airport> airports = [
    // Sample: Add more as needed or import from a data source
    Airport(code: 'JFK', iata: 'JFK', icao: 'KJFK', name: 'John F. Kennedy International Airport', latitude: 40.6413, longitude: -73.7781),
    Airport(code: 'LHR', iata: 'LHR', icao: 'EGLL', name: 'London Heathrow Airport', latitude: 51.4700, longitude: -0.4543),
    Airport(code: 'CDG', iata: 'CDG', icao: 'LFPG', name: 'Charles de Gaulle Airport', latitude: 49.0097, longitude: 2.5479),
    Airport(code: 'FRA', iata: 'FRA', icao: 'EDDF', name: 'Frankfurt Airport', latitude: 50.0379, longitude: 8.5622),
    Airport(code: 'WAW', iata: 'WAW', icao: 'EPWA', name: 'Warsaw Chopin Airport', latitude: 52.1657, longitude: 20.9671),
    // ... add more airports for better accuracy
  ];

  static Airport? nearestAirport(double lat, double lon, {double maxDistanceKm = 30}) {
    Airport? nearest;
    double minDist = double.infinity;
    for (final airport in airports) {
      final dist = distanceKm(lat, lon, airport.latitude, airport.longitude);
      if (dist < minDist && dist <= maxDistanceKm) {
        minDist = dist;
        nearest = airport;
      }
    }
    return nearest;
  }

  static double distanceKm(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371.0;
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);
    final a = sin(dLat/2) * sin(dLat/2) + cos(_deg2rad(lat1)) * cos(_deg2rad(lat2)) * sin(dLon/2) * sin(dLon/2);
    final c = 2 * atan2(sqrt(a), sqrt(1-a));
    return R * c;
  }
  static double _deg2rad(double deg) => deg * pi / 180.0;
}
