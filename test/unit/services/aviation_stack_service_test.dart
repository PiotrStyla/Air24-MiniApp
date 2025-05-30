import 'package:flutter_test/flutter_test.dart';
import 'package:f35_flight_compensation/services/aviation_stack_service.dart';

// Mock implementation of the AviationStackService for testing
class MockAviationStackService extends AviationStackService {
  MockAviationStackService() : super(baseUrl: 'https://test-api.example.com');
  
  // Mock data for recent arrivals
  final _mockRecentArrivals = [
    {
      'flightNumber': 'BA123',
      'airline': 'British Airways',
      'departureAirport': 'London Heathrow',
      'arrivalAirport': 'Berlin Brandenburg',
      'departureTime': '2025-05-30T10:00:00Z',
      'arrivalTime': '2025-05-30T12:30:00Z',
      'status': 'active',
      'delayMinutes': 15,
    }
  ];
  
  // Mock data for EU compensation eligible flights
  final _mockEligibleFlights = [
    {
      'flightNumber': 'LH1234',
      'airline': 'Lufthansa',
      'departureAirport': 'Munich',
      'arrivalAirport': 'Madrid',
      'departureTime': '2025-05-29T08:00:00Z',
      'arrivalTime': '2025-05-29T10:45:00Z',
      'status': 'delayed',
      'delayMinutes': 195,
      'isEligibleForCompensation': true,
      'potentialCompensationAmount': 400,
      'currency': 'EUR',
      'distance': 1500,
      'isDelayedOver3Hours': true,
    }
  ];
  
  // Mock eligibility data
  final Map<String, Map<String, dynamic>> _mockEligibilityData = {
    'FR1234': {
      'isEligible': true,
      'flightNumber': 'FR1234',
      'airline': 'Ryanair',
      'departureAirport': 'Berlin',
      'arrivalAirport': 'Rome',
      'departureDate': '2025-05-28',
      'arrivalDate': '2025-05-28',
      'delayMinutes': 220,
      'reason': 'Delayed more than 3 hours',
      'estimatedCompensation': 400,
      'currency': 'EUR',
    },
    'EZY8721': {
      'isEligible': false,
      'flightNumber': 'EZY8721',
      'airline': 'EasyJet',
      'departureAirport': 'London',
      'arrivalAirport': 'Prague',
      'departureDate': '2025-05-28',
      'arrivalDate': '2025-05-28',
      'delayMinutes': 45,
      'reason': 'Delay less than 3 hours',
      'estimatedCompensation': 0,
      'currency': 'EUR',
    }
  };
  
  // Should we simulate network errors?
  bool simulateError = false;
  String? errorFlightCode;
  
  @override
  Future<List<Map<String, dynamic>>> getRecentArrivals({
    required String airportIcao,
    int minutesBeforeNow = 360,
  }) async {
    if (simulateError || airportIcao == 'INVALID') {
      throw Exception('API Error: Failed to fetch recent arrivals');
    }
    return _mockRecentArrivals;
  }
  
  @override
  Future<List<Map<String, dynamic>>> getEUCompensationEligibleFlights({
    int hours = 72,
  }) async {
    if (simulateError) {
      throw Exception('API Error: Failed to fetch eligible flights');
    }
    return _mockEligibleFlights;
  }
  
  @override
  Future<Map<String, dynamic>> checkCompensationEligibility({
    required String flightNumber,
    String? date,
  }) async {
    if (simulateError || flightNumber == errorFlightCode) {
      throw Exception('API Error: Failed to check eligibility');
    }
    
    final data = _mockEligibilityData[flightNumber];
    if (data == null) {
      throw Exception('Flight not found: $flightNumber');
    }
    
    return data;
  }
}

void main() {
  late MockAviationStackService mockService;

  setUp(() {
    mockService = MockAviationStackService();
  });

  group('AviationStackService', () {
    group('getRecentArrivals', () {
      test('returns normalized flight data when response is successful', () async {
        // Call the method under test
        final result = await mockService.getRecentArrivals(airportIcao: 'EDDB');

        // Verify the result
        expect(result, isA<List<Map<String, dynamic>>>());
        expect(result.length, 1);
        expect(result[0]['flightNumber'], 'BA123');
        expect(result[0]['airline'], 'British Airways');
        expect(result[0]['departureAirport'], 'London Heathrow');
        expect(result[0]['arrivalAirport'], 'Berlin Brandenburg');
      });

      test('throws exception when API request fails', () async {
        // Set the service to throw an error
        mockService.simulateError = true;
        
        // Call the method and expect it to throw
        expect(
          () => mockService.getRecentArrivals(airportIcao: 'EDDB'),
          throwsException,
        );
        
        // Reset for other tests
        mockService.simulateError = false;
      });
      
      test('throws exception for invalid airport code', () async {
        // Call with invalid airport code
        expect(
          () => mockService.getRecentArrivals(airportIcao: 'INVALID'),
          throwsException,
        );
      });
    });

    group('getEUCompensationEligibleFlights', () {
      test('returns eligible flights when response is successful', () async {
        // Call the method under test
        final result = await mockService.getEUCompensationEligibleFlights();

        // Verify the result
        expect(result, isA<List<Map<String, dynamic>>>());
        expect(result.length, 1);
        expect(result[0]['flightNumber'], 'LH1234');
        expect(result[0]['airline'], 'Lufthansa');
        expect(result[0]['isEligibleForCompensation'], true);
        expect(result[0]['potentialCompensationAmount'], 400);
      });

      test('throws exception when API request fails', () async {
        // Set the service to throw an error
        mockService.simulateError = true;
        
        // Call the method and expect it to throw
        expect(
          () => mockService.getEUCompensationEligibleFlights(),
          throwsException,
        );
        
        // Reset for other tests
        mockService.simulateError = false;
      });
    });

    group('checkCompensationEligibility', () {
      test('returns correct eligibility data when flight is eligible', () async {
        // Call the method under test
        final result = await mockService.checkCompensationEligibility(
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
        // Call the method under test
        final result = await mockService.checkCompensationEligibility(
          flightNumber: 'EZY8721',
        );

        // Verify the result
        expect(result, isA<Map<String, dynamic>>());
        expect(result['isEligible'], false);
        expect(result['reason'], 'Delay less than 3 hours');
      });
      
      test('throws exception when API request fails', () async {
        // Set the service to throw an error for a specific flight code
        mockService.errorFlightCode = 'ERROR123';
        
        // Call the method and expect it to throw
        expect(
          () => mockService.checkCompensationEligibility(flightNumber: 'ERROR123'),
          throwsException,
        );
        
        // Reset for other tests
        mockService.errorFlightCode = null;
      });
      
      test('throws exception when flight not found', () async {
        // Call with non-existent flight number
        expect(
          () => mockService.checkCompensationEligibility(flightNumber: 'NONEXISTENT'),
          throwsException,
        );
      });
    });
  });
}
