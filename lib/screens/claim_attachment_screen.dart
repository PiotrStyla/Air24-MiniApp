import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../core/services/service_initializer.dart';
import '../models/claim.dart';
import '../models/flight_document.dart';
import '../viewmodels/document_viewmodel.dart';
import 'claim_review_screen.dart';
import '../l10n2/app_localizations.dart';

/// A wrapper that provides the DocumentViewModel to the attachment view.
class ClaimAttachmentScreen extends StatelessWidget {
  final Claim claim;

  const ClaimAttachmentScreen({Key? key, required this.claim}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DocumentViewModel>(
      // Get a fresh view model instance and fetch the user's documents right away.
      create: (_) => ServiceInitializer.get<DocumentViewModel>()..loadAllUserDocuments(),
      child: _ClaimAttachmentView(claim: claim),
    );
  }
}

/// The main view for attaching documents, consuming the DocumentViewModel.
class _ClaimAttachmentView extends StatefulWidget {
  final Claim claim;

  const _ClaimAttachmentView({required this.claim});

  @override
  State<_ClaimAttachmentView> createState() => _ClaimAttachmentViewState();
}

class _ClaimAttachmentViewState extends State<_ClaimAttachmentView> {
  // Local state to track which documents are selected for this specific claim.
  Set<String> _selectedAttachmentUrls = {};

  @override
  void initState() {
    super.initState();
    // Initialize with URLs already associated with the claim.
    _selectedAttachmentUrls = Set.from(widget.claim.attachmentUrls);
    
    // Always reload documents when returning to this screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<DocumentViewModel>(context, listen: false);
      // Reload all documents including mock documents
      viewModel.loadAllUserDocuments();
    });
  }

  /// Handles the entire process of picking and uploading a new document.
  Future<void> _uploadNewDocument(BuildContext context) async {
    final viewModel = Provider.of<DocumentViewModel>(context, listen: false);
    
    // For web environments, use a modified approach
    if (kIsWeb) {
      try {
        // First show a file picker dialog
        final fileSelected = await viewModel.pickDocument();
        
        // Only proceed if a file was selected
        if (!fileSelected) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('No file selected'),
                backgroundColor: Colors.orange,
              ),
            );
          }
          return;
        }
        
        // Create mock document ID and file name
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final fileName = viewModel.selectedFileName ?? 'document.pdf';
        // Include the filename in the document ID so it can be extracted in the review screen
        final mockDocId = 'web-doc-$timestamp-${fileName.replaceAll(' ', '_')}';
        
        // Create a mock FlightDocument with the selected file's name
        final mockDocument = FlightDocument(
          id: mockDocId,
          name: fileName,
          documentType: FlightDocumentType.other,
          flightNumber: widget.claim.flightNumber,
          flightDate: widget.claim.flightDate,
          storageUrl: mockDocId, // Using mockDocId as the storage URL for web documents
          uploadDate: DateTime.now(),
          size: viewModel.selectedFileSize ?? 0,
          mimeType: viewModel.selectedFileMimeType ?? 'application/octet-stream',
          notes: '',
        );
        
        // Add the mock document to the view model
        // This will also persist it automatically
        await viewModel.addMockDocument(mockDocument);
        
        setState(() {
          _selectedAttachmentUrls.add(mockDocId);
        });
        
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Document "$fileName" added successfully (Web Demo)'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to create document: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
      return;
    }
    
    // For non-web environments, proceed with normal upload flow
    try {
      final newDocument = await viewModel.pickAndUploadDocument(
        flightNumber: widget.claim.flightNumber,
        flightDate: widget.claim.flightDate,
        documentType: FlightDocumentType.other,
        documentName: AppLocalizations.of(context)!.claimAttachment,
      );

      if (mounted) {
        if (newDocument != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.documentUploadSuccess), backgroundColor: Colors.green),
          );
          // Automatically select the newly uploaded document, avoiding race conditions.
          setState(() {
            _selectedAttachmentUrls.add(newDocument.storageUrl);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(viewModel.errorMessage ?? AppLocalizations.of(context)!.uploadFailed), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context)!.uploadFailed}: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.attachDocuments),
      ),
      body: Consumer<DocumentViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoadingInitialData) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              if (viewModel.documents.isEmpty)
                _buildEmptyState(context)
              else
                _buildDocumentList(context, viewModel.documents),
              if (viewModel.isUploading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(AppLocalizations.of(context)!.uploadingDocument, style: const TextStyle(color: Colors.white, fontSize: 16)),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  /// Widget to show when the user has no documents.
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(AppLocalizations.of(context)!.noDocuments),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _uploadNewDocument(context),
            icon: const Icon(Icons.upload_file),
            label: Text(AppLocalizations.of(context)!.uploadFirstDocument),
          ),
        ],
      ),
    );
  }

  /// Widget that displays the list of documents and the action buttons.
  Widget _buildDocumentList(BuildContext context, List<FlightDocument> documents) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final doc = documents[index];
              final isSelected = _selectedAttachmentUrls.contains(doc.storageUrl);
              return CheckboxListTile(
                title: Text(doc.documentName == 'Claim Attachment' ? AppLocalizations.of(context)!.claimAttachment : doc.documentName),
                subtitle: Text(doc.documentType == FlightDocumentType.other ? AppLocalizations.of(context)!.other : doc.documentType.name),
                value: isSelected,
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      _selectedAttachmentUrls.add(doc.storageUrl);
                    } else {
                      _selectedAttachmentUrls.remove(doc.storageUrl);
                    }
                  });
                },
              );
            },
          ),
        ),
        _buildBottomActionBar(context),
      ],
    );
  }

  /// Widget for the bottom action bar with upload and continue buttons.
  Widget _buildBottomActionBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: () => _uploadNewDocument(context),
            icon: const Icon(Icons.add_circle_outline),
            label: Text(AppLocalizations.of(context)!.uploadNew),
          ),
          ElevatedButton(
            onPressed: () {
              final updatedClaim = widget.claim.copyWith(attachmentUrls: _selectedAttachmentUrls.toList());
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ClaimReviewScreen(claim: updatedClaim),
                ),
              );
            },
            child: Text(AppLocalizations.of(context)!.continueAction),
          ),
        ],
      ),
    );
  }
}
