import 'package:flutter/material.dart';
import '../models/claim.dart';
import '../services/firestore_service.dart';
import 'package:flutter/services.dart';

class ClaimDetailScreen extends StatefulWidget {
  final Claim claim;
  const ClaimDetailScreen({Key? key, required this.claim}) : super(key: key);

  @override
  State<ClaimDetailScreen> createState() => _ClaimDetailScreenState();
}

class _ClaimDetailScreenState extends State<ClaimDetailScreen> {
  late TextEditingController _flightNumberController;
  late TextEditingController _departureAirportController;
  late TextEditingController _arrivalAirportController;
  late TextEditingController _reasonController;
  late TextEditingController _compensationAmountController;
  bool _isEditing = false;
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _flightNumberController = TextEditingController(text: widget.claim.flightNumber);
    _departureAirportController = TextEditingController(text: widget.claim.departureAirport);
    _arrivalAirportController = TextEditingController(text: widget.claim.arrivalAirport);
    _reasonController = TextEditingController(text: widget.claim.reason);
    _compensationAmountController = TextEditingController(
      text: widget.claim.compensationAmount?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _flightNumberController.dispose();
    _departureAirportController.dispose();
    _arrivalAirportController.dispose();
    _reasonController.dispose();
    _compensationAmountController.dispose();
    super.dispose();
  }

  Future<void> _saveEdits() async {
    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });
    try {
      final updatedClaim = widget.claim.copyWith(
        flightNumber: _flightNumberController.text.trim(),
        departureAirport: _departureAirportController.text.trim(),
        arrivalAirport: _arrivalAirportController.text.trim(),
        reason: _reasonController.text.trim(),
        compensationAmount: _compensationAmountController.text.isNotEmpty
            ? double.tryParse(_compensationAmountController.text)
            : null,
      );
      await FirestoreService().setClaim(updatedClaim);
      if (mounted) {
        setState(() {
          _isEditing = false;
          _isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Claim updated successfully!')),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to update claim.';
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final claim = widget.claim;
    String claimLetter = '''
To whom it may concern,

I am writing to submit a claim for compensation under EC261/2004 for the following flight disruption:

- Flight: ${claim.flightNumber}
- Date: ${claim.flightDate.toLocal().toString().split(' ')[0]}
- From: ${claim.departureAirport}
- To: ${claim.arrivalAirport}
- Reason: ${claim.reason}
${claim.compensationAmount != null ? '- Claimed amount: €${claim.compensationAmount!.toStringAsFixed(2)}\n' : ''}

Please process my claim in accordance with EU regulations. I look forward to your prompt response.

Sincerely,
[Your Name]
''';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Claim Details'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.cancel : Icons.edit),
            tooltip: _isEditing ? 'Cancel Edit' : 'Edit',
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Delete Claim',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Claim'),
                  content: const Text('Are you sure you want to delete this claim? This action cannot be undone.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                try {
                  final deletedClaim = widget.claim;
                  await FirestoreService().deleteClaim(deletedClaim.id);
                  if (mounted) {
                    Navigator.of(context).pop(true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Claim deleted.'),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () async {
                            await FirestoreService().setClaim(deletedClaim);
                          },
                        ),
                        duration: const Duration(seconds: 5),
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to delete claim.')),
                    );
                  }
                }
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _isEditing
                ? TextField(
                    controller: _flightNumberController,
                    decoration: const InputDecoration(labelText: 'Flight Number'),
                  )
                : ListTile(
                    title: const Text('Flight Number'),
                    subtitle: Text(claim.flightNumber),
                  ),
            _isEditing
                ? TextField(
                    controller: _departureAirportController,
                    decoration: const InputDecoration(labelText: 'Departure Airport'),
                  )
                : ListTile(
                    title: const Text('Departure Airport'),
                    subtitle: Text(claim.departureAirport),
                  ),
            _isEditing
                ? TextField(
                    controller: _arrivalAirportController,
                    decoration: const InputDecoration(labelText: 'Arrival Airport'),
                  )
                : ListTile(
                    title: const Text('Arrival Airport'),
                    subtitle: Text(claim.arrivalAirport),
                  ),
            ListTile(
              title: const Text('Flight Date'),
              subtitle: Text(claim.flightDate.toLocal().toString().split(' ')[0]),
            ),
            _isEditing
                ? TextField(
                    controller: _reasonController,
                    decoration: const InputDecoration(labelText: 'Reason'),
                  )
                : ListTile(
                    title: const Text('Reason'),
                    subtitle: Text(claim.reason),
                  ),
            _isEditing
                ? TextField(
                    controller: _compensationAmountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Compensation Amount'),
                  )
                : ListTile(
                    title: const Text('Compensation Amount'),
                    subtitle: Text(claim.compensationAmount != null
                        ? '€${claim.compensationAmount!.toStringAsFixed(2)}'
                        : 'N/A'),
                  ),
            ListTile(
              title: const Text('Status'),
              subtitle: Text(claim.status),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
              ),
            const SizedBox(height: 24),
            Card(
              color: Colors.green.shade50,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.email, color: Colors.green),
                        const SizedBox(width: 8),
                        const Text('Claim Request Letter Preview', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green)),
                        const Spacer(),
                        Tooltip(
                          message: 'Copy letter to clipboard',
                          child: IconButton(
                            icon: const Icon(Icons.copy),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: claimLetter));
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Claim letter copied!')));
                            },
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    SelectableText(claimLetter, style: const TextStyle(fontFamily: 'monospace', fontSize: 14)),
                  ],
                ),
              ),
            ),
            if (_isEditing)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveEdits,
                      child: _isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('Save Changes'),
                    ),
                  ),
                ],
              ),
            if (!_isEditing)
              const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
