import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../l10n2/app_localizations.dart';
import 'package:intl/intl.dart';
import '../models/claim.dart';
import 'claim_confirmation_screen.dart'; // Will be created next

class ClaimReviewScreen extends StatelessWidget {
  final Claim claim;

  const ClaimReviewScreen({Key? key, required this.claim}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.reviewYourClaim),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)!.reviewClaimDetails, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 24),
                    _buildReviewRow(AppLocalizations.of(context)!.flightNumber, claim.flightNumber),
                    _buildReviewRow(AppLocalizations.of(context)!.flightDate, DateFormat.yMd().format(claim.flightDate)),
                    _buildReviewRow(AppLocalizations.of(context)!.departureAirport, claim.departureAirport),
                    _buildReviewRow(AppLocalizations.of(context)!.arrivalAirport, claim.arrivalAirport),
                    _buildReviewRow(AppLocalizations.of(context)!.reasonForClaim, claim.reason),
                    if (claim.attachmentUrls.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppLocalizations.of(context)!.attachments, style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            ...claim.attachmentUrls.map((url) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          _extractFileName(url),
                                          style: const TextStyle(fontSize: 14, color: Colors.blueAccent),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (kIsWeb && url.startsWith('web-doc-'))
                                        IconButton(
                                          icon: const Icon(Icons.visibility, size: 18, color: Colors.blue),
                                          tooltip: 'Preview attachment',
                                          onPressed: () {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('This is a mock file in web demo mode. File preview would be available in production.'),
                                                backgroundColor: Colors.blue,
                                              ),
                                            );
                                          },
                                        ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ClaimConfirmationScreen(claim: claim),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              child: Text(AppLocalizations.of(context)!.proceedToConfirmation),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 150, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
  
  /// Extracts a user-friendly filename from the document URL
  String _extractFileName(String url) {
    // Handle web mock documents with embedded filenames
    if (url.startsWith('web-doc-')) {
      // Extract the filename part after the timestamp
      final parts = url.split('-');
      if (parts.length > 2) {
        // Skip 'web-doc-timestamp-' and join the rest to get the filename
        return parts.skip(2).join('-').replaceAll('_', ' ');
      }
      return 'Attachment';
    }
    
    // Handle standard Firebase storage URLs
    try {
      return Uri.decodeFull(url.split('?').first.split('%2F').last);
    } catch (e) {
      return 'Document';
    }
  }
}
