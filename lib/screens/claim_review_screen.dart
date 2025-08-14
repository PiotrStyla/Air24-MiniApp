import 'package:flutter/material.dart';
import '../core/app_localizations_patch.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../models/claim.dart';
import 'claim_confirmation_screen.dart'; // Will be created next

class ClaimReviewScreen extends StatelessWidget {
  final Claim claim;
  final String? userEmail;

  const ClaimReviewScreen({Key? key, required this.claim, this.userEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.reviewYourClaim),
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
                    Text(context.l10n.reviewClaimDetails, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 24),
                    _buildReviewRow(context.l10n.flightNumber, claim.flightNumber),
                    _buildReviewRow(context.l10n.flightDate, DateFormat.yMd().format(claim.flightDate)),
                    _buildReviewRow(context.l10n.departureAirport, claim.departureAirport),
                    _buildReviewRow(context.l10n.arrivalAirport, claim.arrivalAirport),
                    _buildReviewRow(context.l10n.reasonForClaim, claim.reason),
                    if (claim.attachmentUrls.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(context.l10n.attachments, style: const TextStyle(fontWeight: FontWeight.bold)),
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
                    builder: (context) => ClaimConfirmationScreen(
                      claim: claim,
                      userEmail: userEmail, // Pass the user's email from the form
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              child: Text(context.l10n.proceedToConfirmation),
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
          Flexible(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(
              value,
              softWrap: true,
            ),
          ),
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
