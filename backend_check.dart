import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  print('Starting backend data check...');
  
  final String backendUrl = 'https://piotrs.pythonanywhere.com';
  
  // Test root endpoint
  try {
    print('\nTesting root endpoint: $backendUrl/');
    final rootResponse = await http.get(Uri.parse('$backendUrl/')).timeout(const Duration(seconds: 10));
    print('Status code: ${rootResponse.statusCode}');
    print('Response body: ${rootResponse.body.substring(0, rootResponse.body.length > 200 ? 200 : rootResponse.body.length)}...');
  } catch (e) {
    print('Error testing root endpoint: $e');
  }
  
  // Test environment endpoint
  try {
    print('\nTesting environment endpoint: $backendUrl/environment');
    final envResponse = await http.get(Uri.parse('$backendUrl/environment')).timeout(const Duration(seconds: 10));
    print('Status code: ${envResponse.statusCode}');
    print('Response body: ${envResponse.body.substring(0, envResponse.body.length > 200 ? 200 : envResponse.body.length)}...');
  } catch (e) {
    print('Error testing environment endpoint: $e');
  }
  
  // Test check data file endpoint
  try {
    print('\nTesting check_data_file endpoint: $backendUrl/check_data_file');
    final dataFileResponse = await http.get(Uri.parse('$backendUrl/check_data_file')).timeout(const Duration(seconds: 10));
    print('Status code: ${dataFileResponse.statusCode}');
    print('Response body: ${dataFileResponse.body.substring(0, dataFileResponse.body.length > 200 ? 200 : dataFileResponse.body.length)}...');
  } catch (e) {
    print('Error testing check_data_file endpoint: $e');
  }
  
  // Test eligible_flights endpoint
  try {
    print('\nTesting eligible_flights endpoint: $backendUrl/eligible_flights');
    final eligibleResponse = await http.get(
      Uri.parse('$backendUrl/eligible_flights').replace(queryParameters: {
        'hours': '72',
        'include_delayed': 'true'
      })
    ).timeout(const Duration(seconds: 20));
    
    print('Status code: ${eligibleResponse.statusCode}');
    if (eligibleResponse.statusCode == 200) {
      final data = json.decode(eligibleResponse.body);
      if (data is List) {
        print('Received ${data.length} flights');
        if (data.isNotEmpty) {
          print('First flight sample:');
          print(json.encode(data[0]));
          
          // Check for expected fields
          final requiredFields = [
            'flight_iata', 'airline_name', 'departure_airport_iata', 
            'arrival_airport_iata', 'status', 'delay_minutes'
          ];
          
          final missingFields = requiredFields.where(
            (field) => !data[0].containsKey(field) || data[0][field] == null
          ).toList();
          
          if (missingFields.isEmpty) {
            print('All required fields are present in the response');
          } else {
            print('Missing required fields: $missingFields');
          }
        }
      } else {
        print('Unexpected data format: ${data.runtimeType}');
        print('Data preview: ${eligibleResponse.body.substring(0, eligibleResponse.body.length > 200 ? 200 : eligibleResponse.body.length)}...');
      }
    } else {
      print('Response body: ${eligibleResponse.body}');
    }
  } catch (e) {
    print('Error testing eligible_flights endpoint: $e');
  }
  
  print('\nBackend check completed.');
}
