import 'package:flutter/material.dart';

/// Beautiful empty state widget (Day 11 - Priority 2)
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionText;
  final VoidCallback? onAction;
  
  const EmptyStateWidget({
    Key? key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionText,
    this.onAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated icon with gradient
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).primaryColor.withOpacity(0.1),
                    Theme.of(context).primaryColor.withOpacity(0.05),
                  ],
                ),
              ),
              child: Icon(
                icon,
                size: 64,
                color: Theme.of(context).primaryColor.withOpacity(0.6),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Title
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 12),
            
            // Message
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            
            // Action button
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add),
                label: Text(actionText!),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Empty claims state (Day 11 - Priority 2)
class EmptyClaimsState extends StatelessWidget {
  final VoidCallback onCreateClaim;
  
  const EmptyClaimsState({
    Key? key,
    required this.onCreateClaim,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.flight_takeoff,
      title: 'No Claims Yet',
      message: 'Start your first claim to track your flight compensation journey. '
               'We\'ll guide you through every step of the process.',
      actionText: 'Create Your First Claim',
      onAction: onCreateClaim,
    );
  }
}

/// Empty flight history state (Day 11 - Priority 2)
class EmptyFlightsState extends StatelessWidget {
  final VoidCallback onAddFlight;
  
  const EmptyFlightsState({
    Key? key,
    required this.onAddFlight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.airplane_ticket_outlined,
      title: 'No Flights Found',
      message: 'We haven\'t detected any flights yet. '
               'Add your flight details manually to check eligibility.',
      actionText: 'Add Flight',
      onAction: onAddFlight,
    );
  }
}

/// Empty search results state (Day 11 - Priority 2)
class EmptySearchState extends StatelessWidget {
  final String searchQuery;
  
  const EmptySearchState({
    Key? key,
    required this.searchQuery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.search_off,
      title: 'No Results Found',
      message: searchQuery.isEmpty
          ? 'Try searching for flight numbers, airlines, or destinations.'
          : 'No results found for "$searchQuery".\nTry a different search term.',
    );
  }
}

/// Generic error state with retry (Day 11 - Priority 2)
class ErrorStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onRetry;
  
  const ErrorStateWidget({
    Key? key,
    required this.title,
    required this.message,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red.shade50,
              ),
              child: Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red.shade400,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Title
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 12),
            
            // Message
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 32),
            
            // Retry button
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
