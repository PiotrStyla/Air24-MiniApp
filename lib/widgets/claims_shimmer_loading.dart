import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Beautiful shimmer loading widget for claims list (Day 11 - Priority 2)
class ClaimsShimmerLoading extends StatelessWidget {
  final int itemCount;
  
  const ClaimsShimmerLoading({
    Key? key,
    this.itemCount = 3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      itemBuilder: (context, index) => _buildShimmerItem(context),
    );
  }

  Widget _buildShimmerItem(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Claim ID badge shimmer
                Row(
                  children: [
                    Container(
                      width: 120,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 60,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Flight number shimmer
                Container(
                  width: 100,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Airline name shimmer
                Container(
                  width: 150,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Route shimmer
                Container(
                  width: 200,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Status and amount shimmer
                Row(
                  children: [
                    Container(
                      width: 80,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 60,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Shimmer loading for analytics card (Day 11 - Priority 2)
class AnalyticsCardShimmer extends StatelessWidget {
  const AnalyticsCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatShimmer(),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.grey.shade300,
                ),
                _buildStatShimmer(),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.grey.shade300,
                ),
                _buildStatShimmer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatShimmer() {
    return Column(
      children: [
        Container(
          width: 40,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 60,
          height: 12,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}

/// Shimmer loading for claim detail screen (Day 11 - Priority 2)
class ClaimDetailShimmer extends StatelessWidget {
  const ClaimDetailShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Claim ID badge shimmer
            Container(
              width: 150,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Status card shimmer
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Flight details card shimmer
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...List.generate(5, (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        width: double.infinity,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
