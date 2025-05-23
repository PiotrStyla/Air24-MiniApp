import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/flight_document.dart';

/// Screen for viewing document details and preview
class DocumentDetailScreen extends StatelessWidget {
  final FlightDocument document;
  
  const DocumentDetailScreen({
    Key? key,
    required this.document,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Implement sharing
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sharing coming soon')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Document preview area
              _buildDocumentPreview(context),
              
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Document title and type
                    _buildDocumentHeader(context),
                    
                    const Divider(height: 32),
                    
                    // Flight details
                    _buildFlightDetails(context),
                    
                    const Divider(height: 32),
                    
                    // Document metadata
                    _buildDocumentMetadata(context),
                    
                    const SizedBox(height: 24),
                    
                    // Actions
                    _buildActionButtons(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentPreview(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Main document image/preview
          Center(
            child: Image.network(
              document.storageUrl,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / 
                            (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.broken_image_outlined,
                      size: 64,
                      color: Colors.white.withOpacity(0.6),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Could not load image',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      icon: const Icon(Icons.open_in_browser, color: Colors.white),
                      label: const Text(
                        'Open in Browser',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () => _openDocumentUrl(document.storageUrl),
                    ),
                  ],
                );
              },
            ),
          ),
          
          // Gradient overlay at the top for better visibility of the back button
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 80,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.5),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentHeader(BuildContext context) {
    // Convert document type enum to readable string
    String documentTypeString = document.documentType.toString().split('.').last;
    documentTypeString = documentTypeString.replaceAllMapped(
      RegExp(r'([A-Z])'),
      (match) => ' ${match.group(0)}',
    ).trim();
    documentTypeString = documentTypeString[0].toUpperCase() + documentTypeString.substring(1);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                document.documentName,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Chip(
              label: Text(documentTypeString),
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            ),
          ],
        ),
        if (document.description != null && document.description!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            document.description!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFlightDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Flight Information',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildInfoRow(
          context,
          label: 'Flight Number',
          value: document.flightNumber,
          icon: Icons.flight,
        ),
        const SizedBox(height: 12),
        _buildInfoRow(
          context,
          label: 'Flight Date',
          value: DateFormat('MMMM d, yyyy').format(document.flightDate),
          icon: Icons.calendar_today,
        ),
      ],
    );
  }

  Widget _buildDocumentMetadata(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Document Information',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildInfoRow(
          context,
          label: 'Uploaded On',
          value: DateFormat('MMMM d, yyyy - h:mm a').format(document.uploadDate),
          icon: Icons.access_time,
        ),
        
        // Display any additional metadata if available
        if (document.metadata != null && document.metadata!.isNotEmpty)
          ...document.metadata!.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(top: 12),
              child: _buildInfoRow(
                context,
                label: _formatMetadataKey(entry.key),
                value: entry.value.toString(),
                icon: Icons.info_outline,
              ),
            );
          }),
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          context,
          label: 'Open',
          icon: Icons.open_in_browser,
          onPressed: () => _openDocumentUrl(document.storageUrl),
          primary: true,
        ),
        _buildActionButton(
          context,
          label: 'Download',
          icon: Icons.download,
          onPressed: () => _downloadDocument(document.storageUrl),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    bool primary = false,
  }) {
    final color = primary 
      ? Theme.of(context).colorScheme.primary
      : Theme.of(context).colorScheme.secondary;
      
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        foregroundColor: primary ? Colors.white : null,
        backgroundColor: primary ? color : Theme.of(context).colorScheme.surface,
        elevation: primary ? 2 : 0,
        side: primary ? null : BorderSide(color: color),
      ),
      onPressed: onPressed,
    );
  }

  String _formatMetadataKey(String key) {
    // Convert camelCase or snake_case to Title Case with spaces
    String formatted = key
        .replaceAll('_', ' ')
        .replaceAllMapped(
          RegExp(r'([A-Z])'),
          (match) => ' ${match.group(0)}',
        ).trim();
    
    // Capitalize first letter of each word
    formatted = formatted.split(' ').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
    
    return formatted;
  }

  Future<void> _openDocumentUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // Handle the case when the URL can't be launched
      debugPrint('Could not launch $url');
    }
  }

  Future<void> _downloadDocument(String url) async {
    // For mobile devices, opening the URL often triggers a download
    // This is a simplified implementation
    await _openDocumentUrl(url);
  }
}
