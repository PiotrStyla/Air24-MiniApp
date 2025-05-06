import 'package:flutter/material.dart';
import 'airport_utils.dart';

/// Shows a dialog for the user to select an airport from the list.
/// Returns the selected Airport, or null if cancelled.
Future<Airport?> showAirportPicker(BuildContext context) async {
  return showDialog<Airport>(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: const Text('Select Airport'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: ListView.builder(
            itemCount: AirportUtils.airports.length,
            itemBuilder: (context, idx) {
              final airport = AirportUtils.airports[idx];
              return ListTile(
                title: Text('${airport.name}'),
                subtitle: Text(airport.code),
                onTap: () => Navigator.of(context).pop(airport),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}
