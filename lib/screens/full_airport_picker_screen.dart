import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/airport_utils.dart';

class FullAirportPickerScreen extends StatefulWidget {
  final Set<String> favoriteCodes;
  const FullAirportPickerScreen({Key? key, required this.favoriteCodes}) : super(key: key);

  @override
  State<FullAirportPickerScreen> createState() => _FullAirportPickerScreenState();
}

class _FullAirportPickerScreenState extends State<FullAirportPickerScreen> {
  List<Airport> _allAirports = [];
  List<Airport> _filtered = [];
  String _search = '';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAirports();
  }

  Future<void> _loadAirports() async {
    setState(() { _loading = true; });
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
      _loading = false;
    });
  }

  void _updateSearch(String value) {
    setState(() {
      _search = value;
      _filtered = _allAirports.where((a) =>
        a.name.toLowerCase().contains(_search.toLowerCase()) ||
        a.iata.toLowerCase().contains(_search.toLowerCase()) ||
        a.icao.toLowerCase().contains(_search.toLowerCase())
      ).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Airport')),
      body: _loading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search airport...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: _updateSearch,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _filtered.length,
                  itemBuilder: (context, idx) {
                    final airport = _filtered[idx];
                    final isFav = widget.favoriteCodes.contains(airport.code);
                    return ListTile(
                      leading: isFav ? const Icon(Icons.star, color: Colors.amber) : null,
                      title: Text(airport.name),
                      subtitle: Text('${airport.iata}${airport.iata.isNotEmpty && airport.icao.isNotEmpty ? ' / ' : ''}${airport.icao}'),
                      onTap: () => Navigator.of(context).pop(airport),
                    );
                  },
                ),
              ),
            ],
          ),
    );
  }
}
