import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/claim.dart';
import '../models/claim_status.dart';

/// Beautiful timeline widget showing claim status history (Day 11 - Priority 3)
class ClaimStatusTimeline extends StatelessWidget {
  final Claim claim;
  
  const ClaimStatusTimeline({
    Key? key,
    required this.claim,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final events = _buildTimelineEvents();
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.timeline, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Claim Timeline',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...events.map((event) => _buildTimelineItem(context, event, events.indexOf(event), events.length)),
          ],
        ),
      ),
    );
  }

  List<TimelineEvent> _buildTimelineEvents() {
    final events = <TimelineEvent>[];
    
    // Always start with submission
    events.add(TimelineEvent(
      title: 'Claim Submitted',
      description: 'Your claim has been created and is ready to be sent to ${claim.airlineName}',
      timestamp: claim.flightDate, // Use flightDate as proxy for submission
      icon: Icons.send,
      color: Colors.blue,
      isCompleted: true,
    ));
    
    // Current status
    final currentStatus = _parseStatus(claim.status);
    
    switch (currentStatus) {
      case ClaimStatus.submitted:
        events.add(TimelineEvent(
          title: 'Awaiting Airline Response',
          description: 'Forward airline emails to claims@unshaken-strategy.eu with your Claim ID: ${claim.claimId}',
          timestamp: DateTime.now(),
          icon: Icons.email,
          color: Colors.orange,
          isCompleted: false,
          isCurrent: true,
        ));
        break;
        
      case ClaimStatus.reviewing:
        events.add(TimelineEvent(
          title: 'Under Review',
          description: 'The airline is reviewing your compensation claim',
          timestamp: DateTime.now(),
          icon: Icons.rate_review,
          color: Colors.amber,
          isCompleted: true,
        ));
        events.add(TimelineEvent(
          title: 'Awaiting Decision',
          description: 'We\'re monitoring for the airline\'s decision',
          timestamp: DateTime.now(),
          icon: Icons.hourglass_empty,
          color: Colors.orange,
          isCompleted: false,
          isCurrent: true,
        ));
        break;
        
      case ClaimStatus.requiresAction:
        events.add(TimelineEvent(
          title: 'More Information Required',
          description: 'The airline has requested additional information',
          timestamp: DateTime.now(),
          icon: Icons.info_outline,
          color: Colors.blue,
          isCompleted: true,
        ));
        events.add(TimelineEvent(
          title: 'Action Required',
          description: 'Please provide the requested documents or information',
          timestamp: DateTime.now(),
          icon: Icons.assignment,
          color: Colors.orange,
          isCompleted: false,
          isCurrent: true,
        ));
        break;
        
      case ClaimStatus.approved:
        events.add(TimelineEvent(
          title: 'Claim Approved! 🎉',
          description: 'Your claim has been approved for €${claim.compensationAmount.toInt()}',
          timestamp: DateTime.now(),
          icon: Icons.check_circle,
          color: Colors.green,
          isCompleted: true,
        ));
        events.add(TimelineEvent(
          title: 'Payment Processing',
          description: 'Your compensation will be processed by the airline',
          timestamp: DateTime.now(),
          icon: Icons.euro,
          color: Colors.green,
          isCompleted: false,
          isCurrent: true,
        ));
        break;
        
      case ClaimStatus.paid:
        events.add(TimelineEvent(
          title: 'Claim Approved! 🎉',
          description: 'Your claim was approved for €${claim.compensationAmount.toInt()}',
          timestamp: DateTime.now().subtract(const Duration(days: 7)),
          icon: Icons.check_circle,
          color: Colors.green,
          isCompleted: true,
        ));
        events.add(TimelineEvent(
          title: 'Payment Received! 💰',
          description: 'Congratulations! Your compensation has been paid',
          timestamp: DateTime.now(),
          icon: Icons.payment,
          color: Colors.green,
          isCompleted: true,
          isCurrent: true,
        ));
        break;
        
      case ClaimStatus.rejected:
        events.add(TimelineEvent(
          title: 'Claim Rejected',
          description: 'The airline has rejected your compensation claim',
          timestamp: DateTime.now(),
          icon: Icons.cancel,
          color: Colors.red,
          isCompleted: true,
        ));
        events.add(TimelineEvent(
          title: 'Appeal Options',
          description: 'You can appeal this decision or contact us for help',
          timestamp: DateTime.now(),
          icon: Icons.gavel,
          color: Colors.orange,
          isCompleted: false,
          isCurrent: true,
        ));
        break;
        
      case ClaimStatus.appealing:
        events.add(TimelineEvent(
          title: 'Under Appeal',
          description: 'Your appeal is being processed',
          timestamp: DateTime.now(),
          icon: Icons.gavel,
          color: Colors.amber,
          isCompleted: false,
          isCurrent: true,
        ));
        break;
        
      case ClaimStatus.processing:
        events.add(TimelineEvent(
          title: 'Processing Payment',
          description: 'Your claim is being processed for payment',
          timestamp: DateTime.now(),
          icon: Icons.loop,
          color: Colors.purple,
          isCompleted: false,
          isCurrent: true,
        ));
        break;
    }
    
    return events;
  }

  ClaimStatus _parseStatus(String status) {
    try {
      return ClaimStatus.values.firstWhere(
        (e) => e.name == status,
        orElse: () => ClaimStatus.submitted,
      );
    } catch (e) {
      return ClaimStatus.submitted;
    }
  }

  Widget _buildTimelineItem(BuildContext context, TimelineEvent event, int index, int totalEvents) {
    final isLast = index == totalEvents - 1;
    
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          Column(
            children: [
              // Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: event.isCompleted 
                      ? event.color 
                      : event.color.withOpacity(0.2),
                  border: event.isCurrent 
                      ? Border.all(color: event.color, width: 3)
                      : null,
                ),
                child: Icon(
                  event.icon,
                  size: 20,
                  color: event.isCompleted 
                      ? Colors.white 
                      : event.color,
                ),
              ),
              
              // Connecting line
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: event.isCompleted
                            ? [event.color, event.color.withOpacity(0.3)]
                            : [Colors.grey.shade300, Colors.grey.shade300],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          
          const SizedBox(width: 16),
          
          // Event content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    event.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: event.isCurrent ? FontWeight.bold : FontWeight.w600,
                      color: event.isCompleted 
                          ? Colors.grey.shade800 
                          : Colors.grey.shade600,
                    ),
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Timestamp
                  Text(
                    _formatTimestamp(event.timestamp),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  
                  const SizedBox(height: 6),
                  
                  // Description
                  Text(
                    event.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                  
                  // Current indicator badge
                  if (event.isCurrent) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: event.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: event.color.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.lens, size: 8, color: event.color),
                          const SizedBox(width: 4),
                          Text(
                            'Current Status',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: event.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
      }
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else {
      return DateFormat('MMM d, yyyy').format(timestamp);
    }
  }
}

/// Timeline event model
class TimelineEvent {
  final String title;
  final String description;
  final DateTime timestamp;
  final IconData icon;
  final Color color;
  final bool isCompleted;
  final bool isCurrent;
  
  TimelineEvent({
    required this.title,
    required this.description,
    required this.timestamp,
    required this.icon,
    required this.color,
    this.isCompleted = false,
    this.isCurrent = false,
  });
}
