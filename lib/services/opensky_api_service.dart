import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenSkyApiService {
  // WARNING: Never hardcode real credentials in production. Use secure storage or environment variables.
  static const String _defaultUsername = 'piotr styła';
  static const String _defaultPassword = 'HippiH-01HippiH-01';
  static const String _baseUrl = 'https://opensky-network.org/api';

  /// Fetches flights for a given airport and date (UNIX timestamps in seconds)
  /// type: 'arrival' or 'departure'
  static Future<List<dynamic>?> fetchFlights({
    String? airportIcao,
    required int begin,
    required int end,
    String type = 'arrival',
    String? username,
    String? password,
  }) async {
    Uri url;
    if (airportIcao != null && airportIcao.isNotEmpty) {
      url = Uri.parse('$_baseUrl/flights_$type?airport=$airportIcao&begin=$begin&end=$end');
    } else {
      // If no airport specified, fetch all flights for the day (may be limited)
      url = Uri.parse('$_baseUrl/flights/all?begin=$begin&end=$end');
    }
    final headers = <String, String>{};
    http.Response response;
    // Use provided credentials, or fallback to default for quick testing
    final user = username ?? _defaultUsername;
    final pass = password ?? _defaultPassword;
    if (user.isNotEmpty && pass.isNotEmpty) {
      String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));
      headers['authorization'] = basicAuth;
      response = await http.get(url, headers: headers);
    } else {
      response = await http.get(url);
    }
    if (response.statusCode == 200) {
      print('API URL: $url');
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return json.decode(response.body) as List<dynamic>;
    } else {
      return null;
    }
  }

  /// Checks if a flight number operated on a given date (returns true if found)
  static Future<bool> verifyFlight({
    required String flightNumber,
    required String departureIcao,
    required DateTime flightDate,
    String? username,
    String? password,
  }) async {
    // OpenSky uses ICAO codes and UNIX timestamps
    final begin = DateTime.utc(flightDate.year, flightDate.month, flightDate.day).millisecondsSinceEpoch ~/ 1000;
    final end = begin + 86399; // End of day
    final flights = await fetchFlights(
      airportIcao: departureIcao,
      begin: begin,
      end: end,
      type: 'departure',
      username: username,
      password: password,
    );
    if (flights == null) return false;
    return flights.any((f) => (f['callsign'] ?? '').replaceAll(' ', '').toUpperCase().startsWith(flightNumber.toUpperCase()));
  }

  /// Finds all flights matching a flight number on a given day (any airport)
  static Future<List<dynamic>> findFlightsByFlightNumber({
    required String flightNumber,
    required DateTime flightDate,
    String? username,
    String? password,
  }) async {
    final begin = DateTime.utc(flightDate.year, flightDate.month, flightDate.day).millisecondsSinceEpoch ~/ 1000;
    final end = begin + 86399;
    final flights = await fetchFlights(
      airportIcao: null,
      begin: begin,
      end: end,
      type: 'departure',
      username: username,
      password: password,
    );
    if (flights == null) return [];
    return flights.where((f) => (f['callsign'] ?? '').replaceAll(' ', '').toUpperCase().startsWith(flightNumber.toUpperCase())).toList();
  }
}
