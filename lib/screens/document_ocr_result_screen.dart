import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:f35_flight_compensation/l10n/app_localizations.dart';
import '../models/document_ocr_result.dart';
import '../viewmodels/document_scanner_viewmodel.dart';
import '../core/services/service_initializer.dart';

/// Screen to display OCR result and extracted fields
class DocumentOcrResultScreen extends StatefulWidget {
  /// OCR result to display
  final DocumentOcrResult ocrResult;
  
  /// Callback when done viewing the result
  final VoidCallback onDone;

  const DocumentOcrResultScreen({
    Key? key,
    required this.ocrResult,
    required this.onDone,
  }) : super(key: key);

  @override
  State<DocumentOcrResultScreen> createState() => _DocumentOcrResultScreenState();
}

class _DocumentOcrResultScreenState extends State<DocumentOcrResultScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Map<String, TextEditingController> _fieldControllers = {};
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Initialize text controllers for each extracted field
    for (final entry in widget.ocrResult.extractedFields.entries) {
      _fieldControllers[entry.key] = TextEditingController(text: entry.value);
    }
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    for (final controller in _fieldControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.ocrResult.documentType.displayName} - ${localizations.documentOcrResult}'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: localizations.extractedFields),
            Tab(text: localizations.fullText),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: widget.onDone,
            tooltip: localizations.done,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildExtractedFieldsTab(),
          _buildRawTextTab(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.assignment),
                  label: Text(localizations.useExtractedData),
                  onPressed: () => _showFormFieldSelection(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Build tab for displaying and editing extracted fields
  Widget _buildExtractedFieldsTab() {
    final extractedFields = widget.ocrResult.extractedFields;
    
    final localizations = AppLocalizations.of(context)!;
    if (extractedFields.isEmpty) {
      return Center(
        child: Text(
          localizations.noFieldsExtracted,
          style: const TextStyle(color: Colors.grey),
        ),
      );
    }
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Document image preview
        if (File(widget.ocrResult.imagePath).existsSync()) ...[
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(widget.ocrResult.imagePath),
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        
        // Extracted fields
        Text(
          localizations.extractedInformation,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...extractedFields.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatFieldName(entry.key),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.blueGrey,
                  ),
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: _fieldControllers[entry.key],
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.content_copy, size: 20),
                      onPressed: () => _copyToClipboard(entry.key),
                      tooltip: 'Copy to clipboard',
                    ),
                  ),
                  style: const TextStyle(fontSize: 16),
                  onChanged: (value) {
                    // Update the field value in memory
                    // Note: This doesn't persist changes to Firestore
                    setState(() {
                      widget.ocrResult.extractedFields[entry.key] = value;
                    });
                  },
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
  
  /// Build tab for displaying raw OCR text
  Widget _buildRawTextTab() {
    final localizations = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                localizations.rawOcrText,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.content_copy),
                onPressed: () => _copyToClipboard('raw_text'),
                tooltip: localizations.copyAllText,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: SelectableText(
              widget.ocrResult.rawText,
              style: TextStyle(
                fontFamily: 'monospace',
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  /// Format field name for display (convert snake_case to Title Case)
  String _formatFieldName(String fieldName) {
    return fieldName
        .split('_')
        .map((word) => word.isEmpty ? '' : '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }
  
  /// Copy field value to clipboard
  void _copyToClipboard(String field) {
    String textToCopy;
    
    if (field == 'raw_text') {
      textToCopy = widget.ocrResult.rawText;
    } else {
      textToCopy = widget.ocrResult.extractedFields[field] ?? '';
    }
    
    Clipboard.setData(ClipboardData(text: textToCopy));
    
    final localizations = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(localizations.copiedToClipboard),
        duration: const Duration(seconds: 1),
      ),
    );
  }
  
  /// Show dialog to select which form to fill with extracted data
  void _showFormFieldSelection(BuildContext context) {
    final viewModel = ServiceInitializer.get<DocumentScannerViewModel>();
    
    final localizations = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(localizations.fillForm),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(localizations.chooseUseInfo),
              const SizedBox(height: 16),
              _buildFormOptionButton(
                context,
                icon: Icons.article,
                title: localizations.compensationClaimForm,
                subtitle: localizations.fillPassengerFlight,
                onPressed: () {
                  Navigator.of(ctx).pop();
                  _navigateToClaimForm(context);
                },
              ),
              const SizedBox(height: 8),
              _buildFormOptionButton(
                context,
                icon: Icons.flight_takeoff,
                title: localizations.flightSearch,
                subtitle: localizations.searchFlightNumber,
                onPressed: () {
                  Navigator.of(ctx).pop();
                  _navigateToFlightSearch(context);
                },
              ),
              const SizedBox(height: 8),
              _buildFormOptionButton(
                context,
                icon: Icons.receipt_long,
                title: 'Expense Record',
                subtitle: 'Add receipt details to expenses',
                onPressed: () {
                  Navigator.of(ctx).pop();
                  _navigateToExpenseRecord(context);
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }
  
  /// Build button for form selection options
  Widget _buildFormOptionButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).primaryColor, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
  
  /// Navigate to claim form with extracted data
  void _navigateToClaimForm(BuildContext context) {
    // Get relevant data from OCR result
    final extractedFields = widget.ocrResult.extractedFields;
    
    // Build map of data to prefill in the claim form
    final Map<String, String> prefillData = {};
    
    // Add passenger information if available
    if (extractedFields.containsKey('passenger_name')) {
      prefillData['passengerName'] = extractedFields['passenger_name']!;
    } else if (extractedFields.containsKey('full_name')) {
      prefillData['passengerName'] = extractedFields['full_name']!;
    }
    
    // Add flight information if available
    if (extractedFields.containsKey('flight_number')) {
      prefillData['flightNumber'] = extractedFields['flight_number']!;
    }
    
    if (extractedFields.containsKey('departure_airport')) {
      prefillData['departureAirport'] = extractedFields['departure_airport']!;
    }
    
    if (extractedFields.containsKey('arrival_airport')) {
      prefillData['arrivalAirport'] = extractedFields['arrival_airport']!;
    }
    
    if (extractedFields.containsKey('departure_date')) {
      prefillData['departureDate'] = extractedFields['departure_date']!;
    }
    
    // Navigate to the claim form with prefill data
    Navigator.of(context).pushNamed(
      '/compensation-claim-form',
      arguments: {
        'prefillData': prefillData,
        'documentId': widget.ocrResult.documentId,
      },
    );
    
    // Show message about prefilled data
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Form fields have been prefilled with document data'),
      ),
    );
  }
  
  /// Navigate to flight search with extracted data
  void _navigateToFlightSearch(BuildContext context) {
    final extractedFields = widget.ocrResult.extractedFields;
    
    // Check if we have flight number
    final flightNumber = extractedFields['flight_number'];
    if (flightNumber == null || flightNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No flight number found in this document'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    // Navigate to flight search screen with flight number
    Navigator.of(context).pushNamed(
      '/flight-search',
      arguments: {'flightNumber': flightNumber},
    );
  }
  
  /// Navigate to expense record with extracted data
  void _navigateToExpenseRecord(BuildContext context) {
    final extractedFields = widget.ocrResult.extractedFields;
    
    // Only useful for receipt document type
    if (widget.ocrResult.documentType != DocumentType.receipt) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This document is not a receipt'),
          backgroundColor: Colors.orange,
        ),
      );
    }
    
    // Build expense data from receipt
    final Map<String, String> expenseData = {};
    
    if (extractedFields.containsKey('merchant_name')) {
      expenseData['merchantName'] = extractedFields['merchant_name']!;
    }
    
    if (extractedFields.containsKey('date')) {
      expenseData['date'] = extractedFields['date']!;
    }
    
    if (extractedFields.containsKey('total_amount')) {
      expenseData['amount'] = extractedFields['total_amount']!;
    }
    
    if (extractedFields.containsKey('currency')) {
      expenseData['currency'] = extractedFields['currency']!;
    }
    
    // Navigate to expense record screen
    Navigator.of(context).pushNamed(
      '/expense-record',
      arguments: {
        'expenseData': expenseData,
        'documentId': widget.ocrResult.documentId,
      },
    );
  }
}
