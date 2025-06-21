import 'package:flutter/foundation.dart';

@immutable
class Flight {
  final String flightNumber;
  final String departureAirport;
  final String arrivalAirport;
  final DateTime flightDate;

  Flight({
    required this.flightNumber,
    required this.departureAirport,
    required this.arrivalAirport,
    required this.flightDate,
  });
}
