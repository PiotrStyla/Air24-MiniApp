import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/claim.dart';
import '../services/firestore_service.dart';
import 'claim_submission_screen.dart';
import 'claim_detail_screen.dart';

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
              builder: (context) => ClaimDetailScreen(claim: claim),
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
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Claims'),
      ),
      body: user == null
          ? const Center(child: Text('You must be logged in to view your claims.'))
          : StreamBuilder<List<Claim>>(
              stream: FirestoreService().streamClaimsForUser(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final claims = snapshot.data;
                if (claims == null || claims.isEmpty) {
                  return const Center(child: Text('No claims found. Tap + to submit a new claim.'));
                }
                return _AnimatedClaimsList(claims: claims);

              },
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
