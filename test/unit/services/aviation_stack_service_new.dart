import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:f35_flight_compensation/services/aviation_stack_service.dart';

// Custom Mock HTTP Client
class MockHttpClient extends http.BaseClient {
  final Map<String, http.Response> responses = {};
  final List<http.Request> requests = [];

  void mockResponse(String url, http.Response response) {
    responses[url] = response;
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (request is http.Request) {
      requests.add(request);

      final url = request.url.toString();
      final response = responses[url] ?? 
        http.Response('Not found', 404);

      return http.StreamedResponse(
        Stream.value(response.bodyBytes),
        response.statusCode,
        headers: response.headers,
      );
    }
    throw UnimplementedError();
  }
}

// Custom extension of AviationStackService to inject our mock client
class AviationStackServiceWithMockClient extends AviationStackService {
  final MockHttpClient mockClient;
  
  AviationStackServiceWithMockClient({
    required String baseUrl,
    required this.mockClient,
  }) : super(baseUrl: baseUrl);
  
  @override
  http.Client createHttpClient() {
    return mockClient;
  }
}

void main() {
  late MockHttpClient mockClient;
  late AviationStackService aviationStackService;
  const String baseUrl = 'https://test-api.example.com';

  setUp(() {
    mockClient = MockHttpClient();
    // Pass the mockClient to the service by extending the service with a custom constructor
    aviationStackService = AviationStackServiceWithMockClient(
      baseUrl: baseUrl,
      mockClient: mockClient,
    );
  });

  group('AviationStackService', () {
    group('getRecentArrivals', () {
      test('returns normalized flight data when response is successful', () async {
        // Prepare mock response data
        final mockResponseData = {
          'data': [
            {
              'flight': {
                'iata': 'BA123',
                'icao': 'BAW123',
              },
              'airline': {
                'name': 'British Airways',
              },
              'departure': {
                'airport': 'London Heathrow',
                'scheduled': '2025-05-30T10:00:00Z',
              },
              'arrival': {
                'airport': 'Berlin Brandenburg',
                'scheduled': '2025-05-30T12:30:00Z',
              },
              'flight_status': 'active',
              'delay': {
                'arrival': 15,
              }
            }
          ]
        };

        // Set up the mock client to return a successful response
        final responseJson = jsonEncode(mockResponseData);
        mockClient.mockResponse(
          Uri.parse('$baseUrl/arrivals?airport=EDDB&minutes=360').toString(), 
          http.Response(responseJson, 200),
        );

        // Call the method under test using our injected mock client
        final result = await aviationStackService.getRecentArrivals(
          airportIcao: 'EDDB',
        );

        // Verify the result matches our expectations
        expect(result, isA<List<Map<String, dynamic>>>());
        expect(result.length, 1);
        expect(result[0]['flightNumber'], 'BA123');
        expect(result[0]['airline'], 'British Airways');
        expect(result[0]['departureAirport'], 'London Heathrow');
        expect(result[0]['arrivalAirport'], 'Berlin Brandenburg');
      });

      test('throws exception when API request fails', () async {
        // Set up the mock client to return an error response
        mockClient.mockResponse(
          Uri.parse('$baseUrl/arrivals?airport=INVALID&minutes=360').toString(),
          http.Response('Not found', 404),
        );
        
        // Call the method and expect it to throw
        expect(
          () => aviationStackService.getRecentArrivals(airportIcao: 'INVALID'),
          throwsException,
        );
      });
    });

    group('getEUCompensationEligibleFlights', () {
      test('returns eligible flights when response is successful', () async {
        // Prepare mock response data
        final mockResponseData = {
          'flights': [
            {
              'flight_number': 'LH1234',
              'airline': 'Lufthansa',
              'departure_airport': 'Munich',
              'arrival_airport': 'Madrid',
              'departure_date': '2025-05-29T08:00:00Z',
              'arrival_date': '2025-05-29T10:45:00Z',
              'status': 'Delayed',
              'delay_minutes': 195,
              'compensation_amount_eur': 400,
              'distance_km': 1500
            }
          ]
        };

        // Set up the mock client to return a successful response
        final responseJson = jsonEncode(mockResponseData);
        mockClient.mockResponse(
          Uri.parse('$baseUrl/eu-compensation-eligible?hours=72').toString(),
          http.Response(responseJson, 200),
        );

        // Call the method under test
        final result = await aviationStackService.getEUCompensationEligibleFlights();

        // Verify the result
        expect(result, isA<List<Map<String, dynamic>>>());
        expect(result.length, 1);
        expect(result[0]['flightNumber'], 'LH1234');
        expect(result[0]['airline'], 'Lufthansa');
        expect(result[0]['isEligibleForCompensation'], true);
        expect(result[0]['potentialCompensationAmount'], 400);
      });

      test('throws exception when API request fails', () async {
        // Simulate a server error
        mockClient.mockResponse(
          Uri.parse('$baseUrl/eu-compensation-eligible?hours=72').toString(), 
          http.Response('Server error', 500),
        );

        // Call the method and expect it to throw
        expect(
          () => aviationStackService.getEUCompensationEligibleFlights(),
          throwsException,
        );
      });
    });

    group('checkCompensationEligibility', () {
      test('returns correct eligibility data when flight is eligible', () async {
        // Prepare mock response data
        final mockResponseData = {
          'flights': [
            {
              'flight_number': 'FR1234',
              'airline': 'Ryanair',
              'departure_airport': 'Berlin',
              'arrival_airport': 'Rome',
              'departure_date': '2025-05-28T14:00:00Z',
              'arrival_date': '2025-05-28T16:15:00Z',
              'status': 'Delayed',
              'delay_minutes': 220,
              'compensation_amount_eur': 400,
              'eligibility_reason': 'Delayed more than 3 hours',
              'eligibility': true
            }
          ],
          'meta': {
            'currency': 'EUR',
            'disclaimer': 'This is an estimate only'
          }
        };

        // Set up the mock client to return a successful response
        final responseJson = jsonEncode(mockResponseData);
        mockClient.mockResponse(
          Uri.parse('$baseUrl/compensation-check?flight_number=FR1234').toString(), 
          http.Response(responseJson, 200),
        );

        // Call the method under test
        final result = await aviationStackService.checkCompensationEligibility(
          flightNumber: 'FR1234',
        );

        // Verify the result
        expect(result, isA<Map<String, dynamic>>());
        expect(result['isEligible'], true);
        expect(result['flightNumber'], 'FR1234');
        expect(result['airline'], 'Ryanair');
        expect(result['estimatedCompensation'], 400);
        expect(result['reason'], 'Delayed more than 3 hours');
      });

      test('returns ineligible status when flight is not eligible', () async {
        // Prepare mock response data
        final mockResponseData = {
          'flights': [
            {
              'flight_number': 'EZY8721',
              'airline': 'EasyJet',
              'departure_airport': 'London',
              'arrival_airport': 'Prague',
              'departure_date': '2025-05-28T07:30:00Z',
              'arrival_date': '2025-05-28T10:30:00Z',
              'status': 'Delayed',
              'delay_minutes': 45,
              'eligibility': false,
              'eligibility_reason': 'Delay less than 3 hours'
            }
          ]
        };

        // Set up the mock client to return a successful response
        final responseJson = jsonEncode(mockResponseData);
        mockClient.mockResponse(
          Uri.parse('$baseUrl/compensation-check?flight_number=EZY8721').toString(), 
          http.Response(responseJson, 200),
        );

        // Call the method under test
        final result = await aviationStackService.checkCompensationEligibility(
          flightNumber: 'EZY8721',
        );

        // Verify the result
        expect(result, isA<Map<String, dynamic>>());
        expect(result['isEligible'], false);
        expect(result['reason'], 'Delay less than 3 hours');
      });
    });
  });
}
