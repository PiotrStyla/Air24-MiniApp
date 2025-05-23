import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/flight_document.dart';
import '../viewmodels/document_viewmodel.dart';
import '../core/services/service_initializer.dart';
import 'document_upload_screen.dart';
import 'document_detail_screen.dart';

/// Screen for viewing and managing flight documents
class DocumentManagementScreen extends StatefulWidget {
  final String? flightNumber;

  const DocumentManagementScreen({
    Key? key,
    this.flightNumber,
  }) : super(key: key);

  @override
  State<DocumentManagementScreen> createState() => _DocumentManagementScreenState();
}

class _DocumentManagementScreenState extends State<DocumentManagementScreen> {
  late final DocumentViewModel _viewModel;
  
  @override
  void initState() {
    super.initState();
    _viewModel = ServiceInitializer.get<DocumentViewModel>();
    _loadDocuments();
  }
  
  void _loadDocuments() {
    if (widget.flightNumber != null && widget.flightNumber!.isNotEmpty) {
      _viewModel.loadDocumentsForFlight(widget.flightNumber!);
    } else {
      _viewModel.loadAllUserDocuments();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.flightNumber != null 
                ? 'Documents for ${widget.flightNumber}'
                : 'My Flight Documents'
          ),
        ),
        body: Consumer<DocumentViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.isUploading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.errorMessage != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red[700], size: 48),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading documents',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      viewModel.errorMessage!,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                      onPressed: _loadDocuments,
                    ),
                  ],
                ),
              );
            }

            if (viewModel.documents.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.description_outlined,
                      size: 72,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No documents yet',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Upload boarding passes, tickets, and other\nflight documents to keep them organized',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Add Document'),
                      onPressed: () => _navigateToUpload(context),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async => _loadDocuments(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: viewModel.documents.length,
                itemBuilder: (context, index) {
                  final document = viewModel.documents[index];
                  return _buildDocumentCard(context, document);
                },
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _navigateToUpload(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildDocumentCard(BuildContext context, FlightDocument document) {
    // Function to get appropriate icon for document type
    IconData getDocumentIcon(FlightDocumentType type) {
      switch (type) {
        case FlightDocumentType.boardingPass:
          return Icons.airplane_ticket;
        case FlightDocumentType.ticket:
          return Icons.confirmation_number;
        case FlightDocumentType.luggageTag:
          return Icons.luggage;
        case FlightDocumentType.delayConfirmation:
          return Icons.schedule;
        case FlightDocumentType.hotelReceipt:
          return Icons.hotel;
        case FlightDocumentType.mealReceipt:
          return Icons.restaurant;
        case FlightDocumentType.transportReceipt:
          return Icons.directions_bus;
        case FlightDocumentType.other:
        default:
          return Icons.description;
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _navigateToDetail(context, document),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: Icon(
                      getDocumentIcon(document.documentType),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          document.documentName,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Flight ${document.flightNumber}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () => _showDocumentOptions(context, document),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Document type chip
                  Chip(
                    label: Text(
                      document.documentType.toString().split('.').last,
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                  ),
                  // Date
                  Text(
                    'Uploaded: ${_formatDate(document.uploadDate)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
  
  void _showDocumentOptions(BuildContext context, FlightDocument document) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.visibility),
                title: const Text('View Document'),
                onTap: () {
                  Navigator.pop(context);
                  _navigateToDetail(context, document);
                },
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement sharing
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sharing coming soon')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text('Delete', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete(context, document);
                },
              ),
            ],
          ),
        );
      },
    );
  }
  
  void _confirmDelete(BuildContext context, FlightDocument document) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Document?'),
          content: const Text(
            'This will permanently delete this document. This action cannot be undone.'
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.pop(context);
                _deleteDocument(document);
              },
            ),
          ],
        );
      },
    );
  }
  
  void _deleteDocument(FlightDocument document) async {
    final success = await _viewModel.deleteDocument(document);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? 'Document deleted' : 'Failed to delete document'
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }
  
  void _navigateToUpload(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DocumentUploadScreen(
          flightNumber: widget.flightNumber,
        ),
      ),
    ).then((_) => _loadDocuments());
  }
  
  void _navigateToDetail(BuildContext context, FlightDocument document) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DocumentDetailScreen(document: document),
      ),
    );
  }
}
