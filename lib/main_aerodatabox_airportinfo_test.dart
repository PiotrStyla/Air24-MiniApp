import 'dart:io';
import 'package:http/http.dart' as http;

Future<String> loadRapidApiKey() async {
  final file = File('rapidapi_key.txt');
  if (!await file.exists()) {
    throw Exception('rapidapi_key.txt not found! Please create this file and put your RapidAPI key inside.');
  }
  return file.readAsString().then((s) => s.trim());
}

Future<void> main() async {
  final apiKey = await loadRapidApiKey();
  final apiHost = 'aerodatabox.p.rapidapi.com';
  final airportIcao = 'EGLL'; // London Heathrow

  final url = Uri.https(
    apiHost,
    '/airports/icao/$airportIcao',
  );
  print('Request URL: $url');
  final response = await http.get(url, headers: {
    'X-RapidAPI-Key': apiKey,
    'X-RapidAPI-Host': apiHost,
  });
  print('Status: ${response.statusCode}');
  print('Body: ${response.body}');
}
