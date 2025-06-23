import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/claim.dart';
import '../services/airline_procedure_service.dart';
import '../services/auth_service.dart';
import '../services/claim_submission_service.dart';
import 'package:get_it/get_it.dart';

class ClaimConfirmationScreen extends StatefulWidget {
  final Claim claim;

  const ClaimConfirmationScreen({Key? key, required this.claim}) : super(key: key);

  @override
  State<ClaimConfirmationScreen> createState() => _ClaimConfirmationScreenState();
}

class _ClaimConfirmationScreenState extends State<ClaimConfirmationScreen> {
  Future<Map<String, String?>>? _emailDetailsFuture;

  @override
  void initState() {
    super.initState();
    _emailDetailsFuture = _fetchEmailDetails();
  }

  Future<Map<String, String?>> _fetchEmailDetails() async {
    final authService = GetIt.instance<AuthService>();
    final procedure = await AirlineProcedureService.getProcedureByIata(widget.claim.flightNumber.substring(0, 2));
    return {
      'userEmail': authService.currentUser?.email,
      'airlineEmail': procedure?.claimEmail,
    };
  }

  Future<void> _sendClaimEmail(String airlineEmail, String userEmail) async {
    final claimSubmissionService = context.read<ClaimSubmissionService>();
    final mailtoUri = claimSubmissionService.constructClaimMailtoUri(
      claim: widget.claim,
      airlineEmail: airlineEmail,
      userEmail: userEmail,
    );

    if (await canLaunchUrl(mailtoUri)) {
      await launchUrl(mailtoUri);
      // After launching, save the claim to the database
      await claimSubmissionService.submitClaim(widget.claim);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your email app has been opened. Please send the email to finalize your claim.')),
      );
      // Pop all the way back to the root
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open email app. Please send your claim manually to $airlineEmail.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Step 2: Confirm & Send'),
      ),
      body: FutureBuilder<Map<String, String?>>(
        future: _emailDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Error: Could not load email details.'));
          }

          final userEmail = snapshot.data?['userEmail'];
          final airlineEmail = snapshot.data?['airlineEmail'];

          if (userEmail == null || airlineEmail == null) {
            return const Center(child: Text('Could not find email information for the user or airline.'));
          }

          return Padding(
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
                        Text('Final Confirmation', style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 16),
                        Text('The claim will be sent to:', style: Theme.of(context).textTheme.titleMedium),
                        Text(airlineEmail, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 16),
                        Text('A copy will be sent to your email:', style: Theme.of(context).textTheme.titleMedium),
                        Text(userEmail, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => _sendClaimEmail(airlineEmail, userEmail),
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: const Text('Confirm and Send Email'),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}
