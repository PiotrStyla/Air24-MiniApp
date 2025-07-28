import 'package:flutter/material.dart';
import 'dart:convert';
import 'airport_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/full_airport_picker_screen.dart';

/// Shows a dialog for the user to select an airport from the list, with search and favorites.
Future<Airport?> showAirportPicker(BuildContext context) async {
  return showDialog<Airport>(
    context: context,
    builder: (ctx) => _AirportPickerDialog(),
  );
}

class _AirportPickerDialog extends StatefulWidget {
  @override
  State<_AirportPickerDialog> createState() => _AirportPickerDialogState();
}

class _AirportPickerDialogState extends State<_AirportPickerDialog> {
  String _search = '';
  Set<String> _favoriteCodes = {};
  List<Airport> _allAirports = [];
  List<Airport> _filtered = [];
  bool _loadingFavorites = true;
  bool _loadingAirports = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _loadAirports();
  }

  Future<void> _loadAirports() async {
    setState(() { _loadingAirports = true; });
    final jsonStr = await DefaultAssetBundle.of(context).loadString('assets/lib/data/iata_codes.json');
    final List<dynamic> jsonList = jsonStr.isNotEmpty ? (jsonDecode(jsonStr) as List) : [];
    _allAirports = jsonList.map((a) => Airport(
      code: (a['iata']?.toString().isNotEmpty == true) ? a['iata'] : (a['icao'] ?? ''),
      iata: (a['iata'] ?? '').toString(),
      icao: (a['icao'] ?? '').toString(),
      name: a['name'] ?? '',
      latitude: (a['lat'] ?? 0).toDouble(),
      longitude: (a['lon'] ?? 0).toDouble(),
    )).where((a) => (a.iata.isNotEmpty || a.icao.isNotEmpty) && a.name.isNotEmpty).toList();
    setState(() {
      _filtered = _allAirports;
      _loadingAirports = false;
    });
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteCodes = prefs.getStringList('favorite_airports')?.toSet() ?? {};
      _loadingFavorites = false;
    });
  }

  Future<void> _toggleFavorite(String code) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_favoriteCodes.contains(code)) {
        _favoriteCodes.remove(code);
      } else {
        _favoriteCodes.add(code);
      }
      prefs.setStringList('favorite_airports', _favoriteCodes.toList());
    });
  }

  void _updateSearch(String value) {
    setState(() {
      _search = value;
      // Always filter from the full loaded list
      _filtered = _allAirports.where((a) =>
        a.name.toLowerCase().contains(_search.toLowerCase()) ||
        a.code.toLowerCase().contains(_search.toLowerCase()) ||
        a.iata.toLowerCase().contains(_search.toLowerCase()) ||
        a.icao.toLowerCase().contains(_search.toLowerCase())
      ).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingFavorites) {
      return const AlertDialog(
        title: Text('Select Airport'),
        content: SizedBox(
          height: 100,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    // Show favorites at the top
    final favoriteAirports = _filtered.where((a) => _favoriteCodes.contains(a.code)).toList();
    final otherAirports = _filtered.where((a) => !_favoriteCodes.contains(a.code)).toList();
    final displayList = [...favoriteAirports, ...otherAirports];
    return Stack(
      children: [
        AlertDialog(
          title: const Text('Select Airport'),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search airport...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: _updateSearch,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: displayList.length,
                    itemBuilder: (context, idx) {
                      final airport = displayList[idx];
                      final isFav = _favoriteCodes.contains(airport.code);
                      return ListTile(
                        leading: IconButton(
                          icon: Icon(isFav ? Icons.star : Icons.star_border, color: isFav ? Colors.amber : null),
                          onPressed: () => _toggleFavorite(airport.code),
                        ),
                        title: Text(airport.name),
                        subtitle: Text('${airport.iata}${airport.iata.isNotEmpty && airport.icao.isNotEmpty ? ' / ' : ''}${airport.icao}'),
                        onTap: () => Navigator.of(context).pop(airport),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        ),
        // Floating action button
        Positioned(
          bottom: 24,
          right: 24,
          child: FloatingActionButton(
            heroTag: 'airport_picker_fab',
            child: const Icon(Icons.add),
            onPressed: () async {
              final picked = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => FullAirportPickerScreen(favoriteCodes: _favoriteCodes),
                  fullscreenDialog: true,
                ),
              );
              if (picked is Airport) {
                if (!_favoriteCodes.contains(picked.code)) {
                  setState(() {
                    _favoriteCodes.add(picked.code);
                    _filtered = _allAirports;
                  });
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setStringList('favorite_airports', _favoriteCodes.toList());
                }
              }
            },
          ),
        ),
      ],
    );
  }
}
