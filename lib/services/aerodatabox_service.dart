import 'dart:convert';
import 'package:http/http.dart' as http;

class AeroDataBoxService {
  final String apiKey;
  final String apiHost;

  AeroDataBoxService({required this.apiKey, this.apiHost = 'aerodatabox.p.rapidapi.com'});

  /// Fetch recent arrivals for a given airport ICAO code using the correct AeroDataBox endpoint.
  /// Returns a list of arrivals within the past [minutesBeforeNow] (max 720 = 12h).
  Future<List<Map<String, dynamic>>> getRecentArrivals({
    required String airportIcao,
    int minutesBeforeNow = 120, // up to 720 (12h)
  }) async {
    // offsetMinutes negative = past, durationMinutes = window length
    final url = Uri.https(
      apiHost,
      '/flights/airports/icao/$airportIcao',
      {
        'offsetMinutes': (-minutesBeforeNow).toString(),
        'durationMinutes': minutesBeforeNow.toString(),
      },
    );

    print('Request URL: $url');
    final response = await http.get(url, headers: {
      'X-RapidAPI-Key': apiKey,
      'X-RapidAPI-Host': apiHost,
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResp = json.decode(response.body);
      // arrivals are in the 'arrivals' key
      if (jsonResp.containsKey('arrivals')) {
        return List<Map<String, dynamic>>.from(jsonResp['arrivals']);
      } else {
        return [];
      }
    } else {
      throw Exception('AeroDataBox API failed: ${response.statusCode} ${response.reasonPhrase}');
    }
  }
}
