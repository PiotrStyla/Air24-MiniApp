import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'airport_utils.dart';
import 'airport_picker.dart';

/// Attempts to get the nearest airport using location. If not possible, prompts user to select.
Future<Airport?> getAirportDynamically(BuildContext context) async {
  try {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
      // Fallback to picker
      return await showAirportPicker(context);
    }
    final pos = await Geolocator.getCurrentPosition();
    final airport = AirportUtils.nearestAirport(pos.latitude, pos.longitude);
    if (airport != null) return airport;
    return await showAirportPicker(context);
  } catch (_) {
    return await showAirportPicker(context);
  }
}
