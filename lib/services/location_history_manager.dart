import 'dart:math';

class LocationSample {
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  LocationSample({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });
}

class LocationHistoryManager {
  final int maxHistory;
  final List<LocationSample> _history = [];

  LocationHistoryManager({this.maxHistory = 10});

  List<LocationSample> get history => List.unmodifiable(_history);

  // Add a new sample and check for a flight jump
  LocationSample? addSampleAndDetectJump(LocationSample newSample, {double minDistanceKm = 200, int maxHours = 3}) {
    // Remove old samples if needed
    if (_history.length >= maxHistory) {
      _history.removeAt(0);
    }
    // Check for a jump with any previous sample
    for (final prev in _history) {
      final dt = newSample.timestamp.difference(prev.timestamp).inHours.abs();
      final dist = _distanceBetweenKm(prev.latitude, prev.longitude, newSample.latitude, newSample.longitude);
      if (dist > minDistanceKm && dt <= maxHours) {
        // Flight jump detected
        _history.add(newSample);
        return prev;
      }
    }
    _history.add(newSample);
    return null;
  }

  // Haversine formula
  double _distanceBetweenKm(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371.0; // Earth radius in km
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);
    final a = sin(dLat/2) * sin(dLat/2) + cos(_deg2rad(lat1)) * cos(_deg2rad(lat2)) * sin(dLon/2) * sin(dLon/2);
    final c = 2 * atan2(sqrt(a), sqrt(1-a));
    return R * c;
  }
  double _deg2rad(double deg) => deg * pi / 180.0;
}
