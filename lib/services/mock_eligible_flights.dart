import 'package:flutter/foundation.dart';

/// Mock data for eligible flights when connection to the server fails
/// This is used as a fallback mechanism to ensure the app remains functional
class MockEligibleFlights {
  static List<Map<String, dynamic>> getEligibleFlights() {
    debugPrint('Using mock eligible flights data as fallback');
    
    return [
      {
        'flightNumber': 'LO282',
        'airline': 'LOT',
        'departureAirport': 'WAW',
        'arrivalAirport': 'LHR',
        'departureTime': '2024-03-15T14:30:00',
        'arrivalTime': '2024-03-15T16:15:00',
        'status': 'Delayed',
        'delayMinutes': 180,
        'isEligibleForCompensation': true,
        'potentialCompensationAmount': 400,
        'currency': 'EUR',
        'distance': 1450,
      },
      {
        'flightNumber': 'LO379',
        'airline': 'LOT',
        'departureAirport': 'WAW',
        'arrivalAirport': 'CDG',
        'departureTime': '2024-04-20T08:45:00',
        'arrivalTime': '2024-04-20T10:30:00',
        'status': 'Delayed',
        'delayMinutes': 220,
        'isEligibleForCompensation': true,
        'potentialCompensationAmount': 350,
        'currency': 'EUR',
        'distance': 1365,
      },
      {
        'flightNumber': 'LH1234',
        'airline': 'Lufthansa',
        'departureAirport': 'FRA',
        'arrivalAirport': 'MAD',
        'departureTime': '2024-05-18T09:15:00',
        'arrivalTime': '2024-05-18T11:45:00',
        'status': 'Delayed',
        'delayMinutes': 195,
        'isEligibleForCompensation': true,
        'potentialCompensationAmount': 250,
        'currency': 'EUR',
        'distance': 1420,
      },
      {
        'flightNumber': 'AF1028',
        'airline': 'Air France',
        'departureAirport': 'CDG',
        'arrivalAirport': 'FCO',
        'departureTime': '2024-05-19T13:20:00',
        'arrivalTime': '2024-05-19T15:10:00',
        'status': 'Delayed',
        'delayMinutes': 210,
        'isEligibleForCompensation': true,
        'potentialCompensationAmount': 250,
        'currency': 'EUR',
        'distance': 1100,
      },
      {
        'flightNumber': 'KL1082',
        'airline': 'KLM',
        'departureAirport': 'AMS',
        'arrivalAirport': 'BCN',
        'departureTime': '2024-05-19T08:40:00',
        'arrivalTime': '2024-05-19T10:50:00',
        'status': 'Delayed',
        'delayMinutes': 240,
        'isEligibleForCompensation': true,
        'potentialCompensationAmount': 400,
        'currency': 'EUR',
        'distance': 1300,
      }
    ];
  }
}
