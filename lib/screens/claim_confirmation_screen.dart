import 'package:flutter/material.dart';
import '../core/app_localizations_patch.dart';
import 'package:get_it/get_it.dart';

import '../models/claim.dart';
import '../services/claim_submission_service.dart';
import '../services/secure_email_service.dart';
import '../services/auth_service_firebase.dart';
import '../services/airline_procedure_service.dart';
import '../services/push_notification_service.dart';
import '../widgets/secure_email_preview_dialog.dart';

class ClaimConfirmationScreen extends StatefulWidget {
  final Claim claim;
  final String? userEmail;

  const ClaimConfirmationScreen({Key? key, required this.claim, this.userEmail}) : super(key: key);

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
      // Use the passed email parameter first, then fallback to AuthService
      String userEmail = widget.userEmail ?? 'dev@example.com'; // Use passed email or fallback
      
      // If no email was passed, try to get it from AuthService
      if (widget.userEmail == null) {
        final authService = GetIt.instance<FirebaseAuthService>();
        if (authService.currentUser?.email != null) {
          userEmail = authService.currentUser!.email!;
        }
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
    try {
      // Show loading + guidance before launching external email app
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(context.l10n.openingEmailApp),
                      const SizedBox(height: 2),
                      Text(
                        context.l10n.tipReturnBackGesture,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            duration: const Duration(seconds: 4),
          ),
        );
      }

      // Create SecureEmailService instance for localized email generation
      final emailService = SecureEmailService();
      
      // Get current locale for localized email template (user's app language preference)
      final fullLocale = Localizations.localeOf(context);
      final locale = fullLocale.languageCode;
      
      // Get the actual user name using the new async method from AuthService
      final authService = GetIt.instance<FirebaseAuthService>();
      final userName = await authService.getUserDisplayNameAsync();
      
      print('🌍 Full locale detected: $fullLocale');
      print('📧 Language code extracted: "$locale"');
      print('👤 Generating email for user: "$userName"');
      print('✈️ Flight: ${widget.claim.flightNumber}');
      
      // Debug: Check if locale is supported
      final supportedLanguages = ['en', 'de', 'es', 'fr', 'pl', 'pt'];
      final isSupported = supportedLanguages.contains(locale);
      print('🔍 Is language "$locale" supported? $isSupported');
      if (!isSupported) {
        print('⚠️ Language "$locale" not supported, will fallback to English');
      }
      
      // Generate professional email content using SecureEmailService with user's language preference
      final emailBody = emailService.generateCompensationEmailBody(
        passengerName: userName, // Use actual user name from profile
        flightNumber: widget.claim.flightNumber,
        flightDate: widget.claim.flightDate.toString().split(' ')[0], // Format date
        departureAirport: widget.claim.departureAirport,
        arrivalAirport: widget.claim.arrivalAirport,
        delayReason: widget.claim.reason,
        compensationAmount: widget.claim.compensationAmount.toString(),
        locale: locale, // Use user's app language preference
      );
      
      // Generate subject line based on user's app language preference
      String subject;
      switch (locale) {
        case 'de':
          subject = 'Entschädigungsanspruch Flug ${widget.claim.flightNumber} - EU261';
          break;
        case 'es':
          subject = 'Reclamación de Compensación Vuelo ${widget.claim.flightNumber} - EU261';
          break;
        case 'fr':
          subject = 'Demande d\'indemnisation Vol ${widget.claim.flightNumber} - EU261';
          break;
        case 'pl':
          subject = 'Roszczenie o odszkodowanie Lot ${widget.claim.flightNumber} - EU261';
          break;
        case 'pt':
          subject = 'Reclamação de Compensação Voo ${widget.claim.flightNumber} - EU261';
          break;
        default:
          subject = 'Flight Compensation Claim ${widget.claim.flightNumber} - EU261';
      }
      
      // Send email using SecureEmailService
      final result = await emailService.sendEmail(
        toEmail: airlineEmail,
        ccEmail: userEmail,
        subject: subject,
        body: emailBody,
        userEmail: userEmail, // For reply-to functionality
      );
      
      final bool emailLaunched = result.success;
      
      if (emailLaunched) {
        // Email app opened successfully
        final claimSubmissionService = GetIt.instance<ClaimSubmissionService>();
        
        // Save the claim to the database
        await claimSubmissionService.submitClaim(widget.claim);
        
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.emailAppOpenedMessage(userEmail)),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
        }

        // Send a local notification to help user return to the app (ignore failures on web)
        try {
          await PushNotificationService.sendReturnToAppReminder(
            title: context.l10n.returnToAppTitle,
            body: context.l10n.returnToAppBody,
          );
        } catch (e) {
          debugPrint('ℹ️ Local notification not available on this platform: $e');
        }
      } else {
        // Email app not available - show better email composition experience
        final emailSent = await _showEmailCompositionDialog(
          context,
          airlineEmail,
          userEmail, // CC email
          subject,
          emailBody,
          userEmail, // User email for reply-to functionality
        );
        
        if (emailSent) {
          // Email was sent successfully - submit the claim
          final claimSubmissionService = GetIt.instance<ClaimSubmissionService>();
          await claimSubmissionService.submitClaim(widget.claim);
          
          // Show success message and navigate back
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      context.l10n.emailSentSuccessfully,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                backgroundColor: Colors.green.shade600,
                duration: const Duration(seconds: 3),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }
        } else {
          return;
        }
      }
    } catch (e) {
      print('Error sending claim email: $e');
      
      // Show error message only if still mounted (avoid false red snackbar when app backgrounded)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.l10n.errorFailedToSubmitClaim(e.toString()),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () {
                _sendClaimEmail(airlineEmail, userEmail);
              },
            ),
          ),
        );
      }
    }
  }
  
  /// Show secure email preview dialog with backend email sending
  Future<bool> _showEmailCompositionDialog(
    BuildContext context,
    String toEmail,
    String ccEmail,
    String subject,
    String body,
    String userEmail, // User's email for reply-to functionality
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => SecureEmailPreviewDialog(
        toEmail: toEmail,
        ccEmail: ccEmail.isNotEmpty ? ccEmail : null,
        subject: subject,
        body: body,
        userEmail: userEmail, // Pass user email for reply-to functionality
      ),
    );
    return result ?? false; // Return false if dialog was dismissed without result
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.confirmAndSend),
      ),
      body: FutureBuilder<Map<String, String?>>(
        future: _emailDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text(context.l10n.errorLoadingEmailDetails));
          }

          final userEmail = snapshot.data?['userEmail'];
          final airlineEmail = snapshot.data?['airlineEmail'];

          if (userEmail == null || airlineEmail == null) {
            return Center(child: Text(context.l10n.noEmailInfo));
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
                        Text(context.l10n.finalConfirmation, style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 16),
                        Text(context.l10n.claimWillBeSentTo, style: Theme.of(context).textTheme.titleMedium),
                        Text(airlineEmail, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 16),
                        Text(context.l10n.copyToYourEmail, style: Theme.of(context).textTheme.titleMedium),
                        Text(userEmail, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.send),
                    label: Text(context.l10n.confirmAndSendEmail),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () => _sendClaimEmail(airlineEmail, userEmail),
                  ),
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
