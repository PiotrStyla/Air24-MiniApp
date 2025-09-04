import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../core/app_localizations_patch.dart';
import 'package:f35_flight_compensation/services/auth_service_firebase.dart';

import 'compensation_claim_form_screen.dart';
import 'eu_eligible_flights_screen.dart';
import 'flight_compensation_checker_screen.dart';
import '../utils/translation_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<User?>? _userFuture;

  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _loadTranslations();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final authService = Provider.of<FirebaseAuthService>(context, listen: false);
      _userFuture = Future.value(authService.currentUser);
      _isInitialized = true;
    }
  }

  void _loadTranslations() {
    // Deferring this call until after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        debugPrint('HomeScreen: Ensuring translations are loaded correctly');
        TranslationHelper.forceReloadTranslations(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.home)),
      body: FutureBuilder<User?>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            // On error or no user, show the logged-out view.
            // Also useful for after sign-out.
            return _buildLoggedOutView(context);
          }

          final user = snapshot.data!;
          return _buildLoggedInBody(context, user);
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'home_screen_fab',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CompensationClaimFormScreen(flightData: {})),
          );
        },
        label: Text(context.l10n.newClaim),
        icon: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildLoggedOutView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(context.l10n.notLoggedIn),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Navigate to the auth screen for the user to sign in.
              Navigator.of(context).pushReplacementNamed('/auth');
            },
            child: Text(context.l10n.signIn),
          ),
        ],
      ),
    );
  }

  Widget _buildLoggedInBody(BuildContext context, User user) {
    final authService = Provider.of<FirebaseAuthService>(context, listen: false);
    // Prepare display values for greeting to avoid showing empty parentheses
    final String nameToShow = (user.displayName?.trim().isNotEmpty == true)
        ? user.displayName!.trim()
        : (user.email?.trim().isNotEmpty == true)
            ? user.email!.trim()
            : context.l10n.genericUser;
    final String? emailToShow = user.email?.trim();
    final String greetingText = (emailToShow?.isNotEmpty == true)
        ? context.l10n.welcomeUser(nameToShow, emailToShow!, "")
        : '${context.l10n.welcomeMessage}, $nameToShow';
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Check Flight Compensation Eligibility button
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.flight, color: Colors.blue),
                label: Text(
                  context.l10n.checkFlightEligibilityButtonText,
                  style: const TextStyle(color: Colors.blue),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  elevation: 2,
                ),
                onPressed: () {
                  // Navigate to eligibility check screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FlightCompensationCheckerScreen()),
                  );
                },
              ),
            ),
            
            // EU-Wide Compensation Eligible Flights button
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check_circle, color: Colors.green),
                label: Text(
                  context.l10n.euEligibleFlightsButtonText,
                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: const BorderSide(color: Colors.green, width: 1.5),
                  ),
                  elevation: 1,
                ),
                onPressed: () {
                  // Navigate to EU eligible flights screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EUEligibleFlightsScreen()),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 24),
            if (user.photoURL?.isNotEmpty == true)
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user.photoURL!),
                onBackgroundImageError: (exception, stackTrace) {
                  debugPrint('Error loading profile image: $exception');
                },
              )
            else
              CircleAvatar(
                radius: 50,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  (user.displayName?.isNotEmpty == true
                          ? user.displayName![0]
                          : user.email?.isNotEmpty == true
                              ? user.email![0]
                              : 'U')
                      .toUpperCase(),
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Text(
              greetingText,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 24),
            OutlinedButton.icon(
              icon: const Icon(Icons.logout),
              label: Text(context.l10n.signOut),
              onPressed: () async {
                try {
                  await authService.signOut();
                  // After signing out, we should refresh the future to rebuild the UI
                  // to the logged-out state without needing a full navigation.
                  setState(() {
                    _userFuture = Future.value(null);
                  });
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(context.l10n.errorSigningOut(e.toString())),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}