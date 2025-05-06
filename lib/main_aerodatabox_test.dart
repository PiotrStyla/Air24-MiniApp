import 'dart:io';
import 'services/aerodatabox_service.dart';

/// Reads the RapidAPI key from a local file for security.
Future<String> loadRapidApiKey() async {
  // Store your API key in a file named 'rapidapi_key.txt' in the project root (not in version control)
  final file = File('rapidapi_key.txt');
  if (!await file.exists()) {
    throw Exception('rapidapi_key.txt not found! Please create this file and put your RapidAPI key inside.');
  }
  return file.readAsString().then((s) => s.trim());
}

Future<void> main() async {
  final apiKey = await loadRapidApiKey();
  final aeroService = AeroDataBoxService(apiKey: apiKey);

  try {
    final arrivals = await aeroService.getRecentArrivals(
      airportIcao: 'EDDF', // ICAO code for Frankfurt (use ICAO codes, not IATA)
      minutesBeforeNow: 720,  // Get arrivals from the last 12 hours (max allowed)

    );
    print('Recent arrivals at EDDF:');
    for (final flight in arrivals) {
      print(flight);
    }
  } catch (e) {
    print('Error: $e');
  }
}
