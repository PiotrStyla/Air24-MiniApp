class ConfirmedFlight {
  final String callsign;
  final String? originAirport;
  final String? destinationAirport;
  final DateTime detectedAt;

  ConfirmedFlight({
    required this.callsign,
    this.originAirport,
    this.destinationAirport,
    required this.detectedAt,
  });

  Map<String, dynamic> toJson() => {
    'callsign': callsign,
    'originAirport': originAirport,
    'destinationAirport': destinationAirport,
    'detectedAt': detectedAt.toIso8601String(),
  };

  factory ConfirmedFlight.fromJson(Map<String, dynamic> json) => ConfirmedFlight(
    callsign: json['callsign'],
    originAirport: json['originAirport'],
    destinationAirport: json['destinationAirport'],
    detectedAt: DateTime.parse(json['detectedAt']),
  );
}
