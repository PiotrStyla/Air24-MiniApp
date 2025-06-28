import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/claim.dart';
import '../services/airline_procedure_service.dart';
import '../services/auth_service.dart';
import '../services/claim_submission_service.dart';
import 'package:get_it/get_it.dart';
import '../l10n2/app_localizations.dart';

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

  Future<Map<String, String>> _fetchEmailDetails() async {
    try {
      final authService = GetIt.instance<AuthService>();
      String userEmail = 'user@example.com'; // Default fallback
      
      if (authService.currentUser?.email != null) {
        userEmail = authService.currentUser!.email!;
      }
      
      // Get airline IATA code with safety check
      String airlineIata;
      if (widget.claim.flightNumber.length >= 2) {
        airlineIata = widget.claim.flightNumber.substring(0, 2);
        print('Extracted airline IATA code: $airlineIata from flight number: ${widget.claim.flightNumber}');
      } else {
        print('Flight number too short: ${widget.claim.flightNumber}');
        airlineIata = 'LH'; // Default to Lufthansa as a fallback
      }
      
      String airlineEmail = 'customer.relations@lufthansa.com'; // Default fallback email
      
      try {
        final procedure = await AirlineProcedureService.getProcedureByIata(airlineIata);
        if (procedure != null && procedure.claimEmail.isNotEmpty) {
          airlineEmail = procedure.claimEmail;
        }
      } catch (e) {
        print('Error getting airline procedure: $e');
        // Use default email already set
      }
      
      print('User email: $userEmail, Airline email: $airlineEmail');
      
      return {
        'userEmail': userEmail,
        'airlineEmail': airlineEmail,
      };
    } catch (e) {
      print('Error fetching email details: $e');
      return {
        'userEmail': 'user@example.com',
        'airlineEmail': 'customer.relations@lufthansa.com',
      };
    }
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
        SnackBar(content: Text(AppLocalizations.of(context)!.emailAppOpenedMessage)),
      );
      // Pop all the way back to the root
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.emailAppErrorMessage(airlineEmail))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.confirmAndSend),
      ),
      body: FutureBuilder<Map<String, String?>>(
        future: _emailDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text(AppLocalizations.of(context)!.errorLoadingEmailDetails));
          }

          final userEmail = snapshot.data?['userEmail'];
          final airlineEmail = snapshot.data?['airlineEmail'];

          if (userEmail == null || airlineEmail == null) {
            return Center(child: Text(AppLocalizations.of(context)!.noEmailInfo));
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
                        Text(AppLocalizations.of(context)!.finalConfirmation, style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 16),
                        Text(AppLocalizations.of(context)!.claimWillBeSentTo, style: Theme.of(context).textTheme.titleMedium),
                        Text(airlineEmail, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 16),
                        Text(AppLocalizations.of(context)!.copyToYourEmail, style: Theme.of(context).textTheme.titleMedium),
                        Text(userEmail, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => _sendClaimEmail(airlineEmail, userEmail),
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: Text(AppLocalizations.of(context)!.confirmAndSendEmail),
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
