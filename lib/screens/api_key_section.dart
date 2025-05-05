import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiKeySection extends StatefulWidget {
  const ApiKeySection({super.key});
  @override
  State<ApiKeySection> createState() => _ApiKeySectionState();
}

class _ApiKeySectionState extends State<ApiKeySection> {
  final _controller = TextEditingController();
  final _storage = FlutterSecureStorage();
  String? _status;

  @override
  void initState() {
    super.initState();
    _loadKey();
  }

  Future<void> _loadKey() async {
    final key = await _storage.read(key: 'rapidapi_key');
    if (key != null && key.isNotEmpty) {
      setState(() {
        _controller.text = key;
      });
    }
  }

  Future<void> _saveKey() async {
    final value = _controller.text.trim();
    await _storage.write(key: 'rapidapi_key', value: value);
    setState(() {
      _status = 'API key saved securely!';
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() { _status = null; });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('RapidAPI Key (secure storage):', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Enter RapidAPI Key',
          ),
          obscureText: true,
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: _saveKey,
          child: const Text('Save API Key'),
        ),
        if (_status != null) ...[
          const SizedBox(height: 8),
          Text(_status!, style: const TextStyle(color: Colors.green)),
        ]
      ],
    );
  }
}
