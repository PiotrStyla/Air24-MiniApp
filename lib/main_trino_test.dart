import 'package:f35_flight_compensation/services/opensky_trino_service.dart';

void main() async {
  // Replace with your OpenSky username
  const username = 'piotr styła';
  // Choose your airport ICAO code (e.g., 'LHR' for London Heathrow)
  const airportIcao = 'LHR';

  try {
    final arrivals = await OpenSkyTrinoService.getRecentArrivals(
      airportIcao: airportIcao,
      username: username,
    );
    print('Recent arrivals at $airportIcao:');
    for (final flight in arrivals) {
      print(flight);
    }
  } catch (e) {
    print('Error: $e');
  }
}
