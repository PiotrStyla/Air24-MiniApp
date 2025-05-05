import 'dart:convert';
import 'package:http/http.dart' as http;

class AeroDataBoxService {
  // No apiKey or apiHost needed for proxy usage
  AeroDataBoxService();

  /// Fetch recent arrivals for a given airport ICAO code using the proxy endpoint.
  Future<List<Map<String, dynamic>>> getRecentArrivals({
    required String airportIcao,
    int minutesBeforeNow = 120, // up to 720 (12h)
  }) async {
    // Call the proxy endpoint (adjust URL to your actual Heroku app name)
    final url = Uri.parse('https://flight-compensation.herokuapp.com/recent-arrivals?icao=$airportIcao');
    print('Proxy Request URL: $url');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final dynamic jsonResp = json.decode(response.body);
      // arrivals are in the 'arrivals' key, or the full response if proxy returns directly
      if (jsonResp is Map<String, dynamic> && jsonResp.containsKey('arrivals')) {
        return List<Map<String, dynamic>>.from(jsonResp['arrivals']);
      } else if (jsonResp is List) {
        // In case the proxy returns a list directly
        return List<Map<String, dynamic>>.from(jsonResp);
      } else {
        return [];
      }
    } else {
      throw Exception('Proxy API failed: ${response.statusCode} ${response.reasonPhrase}');
    }
  }
}
