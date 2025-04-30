import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenSkyService {
  Future<List<dynamic>> getFlightsInArea({
    required double lamin,
    required double lomin,
    required double lamax,
    required double lomax,
  }) async {
    final url = Uri.parse(
      'https://opensky-network.org/api/states/all?lamin=$lamin&lomin=$lomin&lamax=$lamax&lomax=$lomax',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['states'] ?? [];
    } else {
      throw Exception('Failed to fetch flights');
    }
  }
}
