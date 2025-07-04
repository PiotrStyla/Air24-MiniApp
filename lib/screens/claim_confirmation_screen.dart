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

  Future<Map<String, String?>> _fetchEmailDetails() async {
    try {
      final authService = GetIt.instance<AuthService>();
      String userEmail = 'user@example.com'; // Default fallback
      
      if (authService.currentUser?.email != null) {
        userEmail = authService.currentUser!.email!;
      }
      
      // Extract airline IATA code using proper validation
      String airlineIata = ''; // Will be set if an airline is identified
      String airlineEmail = userEmail; // Default to user's email as a safer fallback
      
      // Get the flight number and normalize it
      final String flightNumber = widget.claim.flightNumber.trim().toUpperCase();
      print('DEBUG: Original flight number: "$flightNumber"');
      
      // Special handling for Air Austral (UU) flights
      if (flightNumber.contains('UU')) {
        print('DEBUG: Detected potential Air Austral flight: $flightNumber');
        // Check if flight starts with UU
        if (flightNumber.startsWith('UU')) {
          print('DEBUG: Confirmed Air Austral flight (starts with UU)');
          airlineIata = 'UU';
        } else {
          // Check for UU with possible separators
          final uuRegex = RegExp(r'UU[\s-]?\d+');
          if (uuRegex.hasMatch(flightNumber)) {
            print('DEBUG: Matched Air Austral flight with regex: $flightNumber');
            airlineIata = 'UU';
          }
        }
      }
      
      // Check if flight number is empty
      if (flightNumber.isEmpty) {
        print('DEBUG: Flight number is empty. Using default airline (Lufthansa).');
      } else {
        // First check if the flight number has a special format like 'G3' for GOL
        // Directly check for airline IATA codes in the database
        final allProcedures = await AirlineProcedureService.loadProcedures();
        print('DEBUG: Loaded ${allProcedures.length} airline procedures');
        
        // Try to find a direct match for airline code at the beginning of the flight number
        bool directMatch = false;
        print('DEBUG: All IATA codes: ${allProcedures.map((p) => p.iata).join(', ')}');
        
        // First try with case-sensitive exact match
        for (var procedure in allProcedures) {
          if (flightNumber.startsWith(procedure.iata)) {
            airlineIata = procedure.iata;
            print('DEBUG: Direct IATA match: $airlineIata (${procedure.name}) at beginning of flight number: $flightNumber');
            directMatch = true;
            break;
          }
        }
        
        // If no direct match, try with normalized codes (all uppercase)
        if (!directMatch) {
          print('DEBUG: Trying normalized case-insensitive match');
          final upperFlightNumber = flightNumber.toUpperCase();
          for (var procedure in allProcedures) {
            final upperIata = procedure.iata.toUpperCase();
            if (upperFlightNumber.startsWith(upperIata)) {
              airlineIata = procedure.iata;
              print('DEBUG: Case-insensitive IATA match: $airlineIata (${procedure.name}) at beginning of flight number: $flightNumber');
              directMatch = true;
              break;
            }
          }
        }
        
        // If no direct match, try with regex patterns
        if (!directMatch) {
          print('DEBUG: No direct IATA match, trying regex patterns');
          final patterns = [
            // Standard format: 2 letters followed by 1-4 digits
            RegExp(r'^([A-Z]{2})\d{1,4}$'),
            // Format with space: 2 letters, space, 1-4 digits
            RegExp(r'^([A-Z]{2})\s+\d{1,4}$'),
            // Format with dash: 2 letters, dash, 1-4 digits
            RegExp(r'^([A-Z]{2})[-]\d{1,4}$'),
            // Special format: letter + number + rest of numbers (for airlines like G3)
            RegExp(r'^([A-Z]\d)\d{1,4}$'),
          ];
        
          bool matched = false;
          for (var pattern in patterns) {
            final match = pattern.firstMatch(flightNumber);
            if (match != null) {
              // Extract the airline code (first group in the regex)
              airlineIata = match.group(1)!;
              print('DEBUG: Matched flight number pattern. Extracted airline IATA code: $airlineIata from: $flightNumber');
              matched = true;
              break;
            }
          }
          
          if (!matched) {
            // As a last resort, try to extract first two characters if they are letters
            if (flightNumber.length >= 2 && 
                RegExp(r'^[A-Z]{2}').hasMatch(flightNumber)) {
              airlineIata = flightNumber.substring(0, 2);
              print('DEBUG: Using first two letters as IATA code: $airlineIata from: $flightNumber');
            } else {
              print('DEBUG: Could not extract IATA code from: "$flightNumber". Using user email as fallback.');
              airlineEmail = userEmail;
            }
          }
        }
      }
      
      // Load all airline procedures for debugging
      final allProcedures = await AirlineProcedureService.loadProcedures();
      print('DEBUG: Loaded ${allProcedures.length} airline procedures');
      print('DEBUG: Looking for IATA code: "$airlineIata"');
      
      try {
        // First attempt a direct case-insensitive lookup
        final procedure = allProcedures.firstWhere(
          (p) => p.iata.toUpperCase() == airlineIata.toUpperCase(),
          orElse: () => throw Exception('No matching airline found'),
        );
        
        airlineEmail = procedure.claimEmail;
        print('DEBUG: Found matching airline: ${procedure.name} with email: $airlineEmail');
      } catch (e) {
        print('DEBUG: Direct lookup failed: $e');
        print('DEBUG: Available airline IATA codes: ${allProcedures.map((p) => p.iata).join(', ')}');
        
        // If direct lookup fails, try to get from service
        try {
          final procedure = await AirlineProcedureService.getProcedureByIata(airlineIata);
          if (procedure != null && procedure.claimEmail.isNotEmpty) {
            airlineEmail = procedure.claimEmail;
            print('DEBUG: Found airline through service: ${procedure.name} with email: $airlineEmail');
          } else {
            print('DEBUG: No airline procedure found for IATA code: "$airlineIata". Using user email as fallback.');
            airlineEmail = userEmail;
          }
        } catch (e) {
          print('DEBUG: Error getting airline procedure: $e');
          // Use user's email as fallback
          print('DEBUG: Using user email as fallback due to error.');
          airlineEmail = userEmail;
        }
      }
      
      print('FINAL EMAIL SELECTION: User email: $userEmail, Airline email: $airlineEmail');
      
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
  
  /// Preview the claim email content before sending
  void _previewClaimEmail(String airlineEmail, String userEmail) {
    print('_previewClaimEmail called with: $airlineEmail, $userEmail');
    try {
      // Directly create email content without dependency on provider
      final attachmentsSection = widget.claim.attachmentUrls.isNotEmpty
        ? '\n\nSupporting Documents:\n${widget.claim.attachmentUrls.map((url) => '- $url').join('\n')}'
        : '';

      final emailContent = '''
Dear Sir or Madam,

I am writing to claim compensation under EC Regulation 261/2004 for the flight detailed below:

- Flight Number: ${widget.claim.flightNumber}
- Flight Date: ${widget.claim.flightDate.toIso8601String().split('T').first}
- Departure Airport: ${widget.claim.departureAirport}
- Arrival Airport: ${widget.claim.arrivalAirport}
- Reason for Claim: ${widget.claim.reason}

Please find my details and the flight information above for your processing.$attachmentsSection

Sincerely,
${GetIt.instance<AuthService>().currentUser?.displayName ?? 'Awaiting your reply'}
''';
      
      final subject = 'Flight Compensation Claim - Flight ${widget.claim.flightNumber}';
      
      showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.9,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Email Preview',
                      style: Theme.of(context).textTheme.titleLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('To: ', style: TextStyle(fontWeight: FontWeight.bold)),
                        Expanded(
                          child: Text(airlineEmail, overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Text('Cc: ', style: TextStyle(fontWeight: FontWeight.bold)),
                        Expanded(
                          child: Text(userEmail, overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Text('Subject: ', style: TextStyle(fontWeight: FontWeight.bold)),
                        Expanded(
                          child: Text(subject, overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text('Message:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SingleChildScrollView(
                    child: Text(emailContent),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.send),
                    label: const Text('Send Email'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _sendClaimEmail(airlineEmail, userEmail);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    } catch (e) {
      print('Error showing email preview: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error previewing email content')),
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
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.preview),
                        label: Text(AppLocalizations.of(context)!.previewEmail),
                        style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                        onPressed: () {
                          print('Preview button pressed');
                          _previewClaimEmail(airlineEmail, userEmail);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.send),
                        label: Text(AppLocalizations.of(context)!.confirmAndSendEmail),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () => _sendClaimEmail(airlineEmail, userEmail),
                      ),
                    ),
                  ],
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
