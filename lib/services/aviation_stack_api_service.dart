import 'dart:convert';
import 'package:http/http.dart' as http;

class AviationStackApiService {
  static bool isTestMode = false;
  // TODO: Replace with your own Aviation Stack API key.
  static const String _apiKey = 'YOUR_AVIATION_STACK_API_KEY';
  static const String _baseUrl = 'http://api.aviationstack.com/v1/';

  static Future<List<Map<String, dynamic>>> findFlightsByFlightNumber({
    required String flightNumber,
    required DateTime flightDate,
  }) async {
    if (isTestMode) {
      print('AviationStackApiService: In test mode, returning empty list of flights.');
      return [];
    }

    final date = '${flightDate.year}-${flightDate.month.toString().padLeft(2, '0')}-${flightDate.day.toString().padLeft(2, '0')}';
    final url = Uri.parse('${_baseUrl}flights?access_key=$_apiKey&flight_iata=$flightNumber&flight_date=$date');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded['data'] != null) {
          return List<Map<String, dynamic>>.from(decoded['data']);
        }
      }
      return [];
    } catch (e) {
      print('Error fetching flight data from Aviation Stack: $e');
      return [];
    }
  }
}
