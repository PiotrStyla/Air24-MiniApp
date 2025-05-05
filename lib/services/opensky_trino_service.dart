import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenSkyTrinoService {
  /// Query recent arrivals at a specific airport (last 24h)
  static Future<List<Map<String, dynamic>>> getRecentArrivals({
    required String airportIcao,
    required String username,
  }) async {
    final url = Uri.parse('https://data.opensky-network.org/trino/v1/statement');
    final sql = '''
      SELECT icao24, callsign, estarrivalairport, estdepartureairport, firstseen, lastseen
      FROM flights_data4
      WHERE estarrivalairport = '$airportIcao'
        AND lastseen > (extract(epoch from now()) - 24*3600)
      ORDER BY lastseen DESC
      LIMIT 10
    ''';

    final response = await http.post(
      url,
      headers: {
        'X-Trino-User': username,
        'X-Trino-Catalog': 'opensky',
        'X-Trino-Schema': 'public',
        'Content-Type': 'text/plain',
      },
      body: sql,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResp = json.decode(response.body);
      if (jsonResp.containsKey('data') && jsonResp.containsKey('columns')) {
        final columns = (jsonResp['columns'] as List)
            .map((col) => col['name'] as String)
            .toList();
        final data = (jsonResp['data'] as List)
            .map<Map<String, dynamic>>((row) => Map.fromIterables(columns, row))
            .toList();
        return data;
      } else {
        return [];
      }
    } else {
      throw Exception('Trino query failed: ${response.statusCode} ${response.reasonPhrase}');
    }
  }
}
