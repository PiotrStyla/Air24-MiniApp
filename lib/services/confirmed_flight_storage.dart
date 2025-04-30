import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/confirmed_flight.dart';

class ConfirmedFlightStorage {
  static const _key = 'confirmed_flights';

  Future<List<ConfirmedFlight>> loadFlights() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key) ?? [];
    return jsonList.map((s) => ConfirmedFlight.fromJson(json.decode(s))).toList();
  }

  Future<void> saveFlight(ConfirmedFlight flight) async {
    final prefs = await SharedPreferences.getInstance();
    final flights = await loadFlights();
    flights.add(flight);
    final jsonList = flights.map((f) => json.encode(f.toJson())).toList();
    await prefs.setStringList(_key, jsonList);
  }

  Future<void> clearFlights() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
