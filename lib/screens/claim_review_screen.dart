import 'package:flutter/material.dart';
import '../core/app_localizations_patch.dart';
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
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    Text(context.l10n.attachments, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    if (claim.attachmentUrls.isNotEmpty) ...[
                      ...claim.attachmentUrls.map(
                        (url) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            url,
                            style: const TextStyle(fontSize: 12, color: Colors.black87),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ),
                    ],
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
}
