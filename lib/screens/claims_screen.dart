import 'package:flutter/material.dart';
import '../models/claim.dart';
import '../core/services/service_initializer.dart';
import '../services/auth_service.dart';
import '../services/claim_tracking_service.dart';
import 'claim_submission_screen.dart' hide Colors, SizedBox, Container, Text, EdgeInsets, Column, TextStyle;
import 'claim_detail_screen.dart';
import 'faq_screen.dart';

class _AnimatedClaimsList extends StatefulWidget {
  final List<Claim> claims;
  const _AnimatedClaimsList({Key? key, required this.claims}) : super(key: key);

  @override
  State<_AnimatedClaimsList> createState() => _AnimatedClaimsListState();
}

class _AnimatedClaimsListState extends State<_AnimatedClaimsList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late List<Claim> _claims;

  @override
  void initState() {
    super.initState();
    _claims = List.from(widget.claims);
  }

  @override
  void didUpdateWidget(covariant _AnimatedClaimsList oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Animate removals
    final oldClaims = oldWidget.claims;
    final newClaims = widget.claims;
    for (int i = 0; i < oldClaims.length; i++) {
      final oldClaim = oldClaims[i];
      if (!newClaims.any((c) => c.id == oldClaim.id)) {
        final removeIndex = _claims.indexWhere((c) => c.id == oldClaim.id);
        if (removeIndex != -1) {
          final removedClaim = _claims.removeAt(removeIndex);
          _listKey.currentState?.removeItem(
            removeIndex,
            (context, animation) => _buildClaimTile(removedClaim, animation),
            duration: const Duration(milliseconds: 400),
          );
        }
      }
    }
    // Animate insertions
    for (int i = 0; i < newClaims.length; i++) {
      final newClaim = newClaims[i];
      if (!_claims.any((c) => c.id == newClaim.id)) {
        _claims.insert(i, newClaim);
        _listKey.currentState?.insertItem(i, duration: const Duration(milliseconds: 400));
      }
    }
  }

  Widget _buildClaimTile(Claim claim, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: ListTile(
        leading: const Icon(Icons.flight_takeoff),
        title: Text('Flight: ${claim.flightNumber}'),
        subtitle: Text('Date: ${claim.flightDate.toLocal().toString().split(' ')[0]}\nStatus: ${claim.status}'),
        trailing: claim.compensationAmount != null
            ? Text('€${claim.compensationAmount!.toStringAsFixed(2)}')
            : null,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ClaimDetailScreen(claimId: claim.id),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      initialItemCount: _claims.length,
      itemBuilder: (context, index, animation) {
        final claim = _claims[index];
        return _buildClaimTile(claim, animation);
      },
    );
  }
}

class ClaimsScreen extends StatelessWidget {
  const ClaimsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = ServiceInitializer.get<AuthService>();
    final user = authService.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Claims'),
        actions: [
          Tooltip(
            message: 'FAQ & Help',
            child: IconButton(
              icon: const Icon(Icons.help_outline, color: Colors.blue),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FAQScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 0),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Below is a list of your submitted claims. Track the status, view details, or take action as needed.',
                    style: TextStyle(color: Colors.blue[900]),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.edit_note),
                label: const Text('Manual Claim Entry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 2,
                ),
                onPressed: () async {
                  final result = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ClaimSubmissionScreen(),
                    ),
                  );
                  // Optionally handle result
                },
              ),
            ),
          ),
          Expanded(
            child: user == null
                ? const Center(child: Text('You must be logged in to view your claims.'))
                : StreamBuilder<List<Claim>>(
                    stream: ServiceInitializer.get<ClaimTrackingService>().getUserClaimsStream(user.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      final claims = snapshot.data;
                      if (claims == null || claims.isEmpty) {
                        return const Center(child: Text('No claims found.'));
                      }
                      return _AnimatedClaimsList(claims: claims);
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 16),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Tips & Reminders',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                ),
                SizedBox(height: 6),
                Text('• Only you can see your claims. Your data is private and secure.'),
                Text('• Track the status of your claims here (pending, approved, rejected, etc).'),
                Text('• Edit or withdraw claims if you notice mistakes (feature coming soon).'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ClaimSubmissionScreen(),
            ),
          );
          // Optionally, handle result (e.g., refresh claims list)
        },
        child: const Icon(Icons.add),
        tooltip: 'Submit a new claim',
      ),
    );
  }
}
