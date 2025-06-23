import 'package:flutter/material.dart';
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
        title: const Text('Step 1: Review Your Claim'),
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
                    Text('Please review the details of your claim before proceeding.', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 24),
                    _buildReviewRow('Flight Number:', claim.flightNumber),
                    _buildReviewRow('Flight Date:', DateFormat.yMd().format(claim.flightDate)),
                    _buildReviewRow('Departure Airport:', claim.departureAirport),
                    _buildReviewRow('Arrival Airport:', claim.arrivalAirport),
                    _buildReviewRow('Reason for Claim:', claim.reason),
                    if (claim.attachmentUrls.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Attachments:', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            ...claim.attachmentUrls.map((url) => Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Text(
                                    Uri.decodeFull(url.split('?').first.split('%2F').last),
                                    style: const TextStyle(fontSize: 14, color: Colors.blueAccent),
                                    overflow: TextOverflow.ellipsis,
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
              child: const Text('Proceed to Confirmation'),
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
}
