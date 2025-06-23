import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/services/service_initializer.dart';
import '../models/claim.dart';
import '../models/flight_document.dart';
import '../viewmodels/document_viewmodel.dart';
import 'claim_review_screen.dart';

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
  late final Set<String> _selectedAttachmentUrls;

  @override
  void initState() {
    super.initState();
    // Initialize with URLs already associated with the claim.
    _selectedAttachmentUrls = Set.from(widget.claim.attachmentUrls);
  }

  /// Handles the entire process of picking and uploading a new document.
  Future<void> _uploadNewDocument(BuildContext context) async {
    final viewModel = context.read<DocumentViewModel>();

    // The view model now returns the document object on success.
    final newDocument = await viewModel.pickAndUploadDocument(
      flightNumber: widget.claim.flightNumber,
      flightDate: widget.claim.flightDate,
      documentType: FlightDocumentType.other, // Default type for new uploads
    );

    if (mounted) {
      if (newDocument != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Document uploaded successfully!'), backgroundColor: Colors.green),
        );
        // Automatically select the newly uploaded document, avoiding race conditions.
        setState(() {
          _selectedAttachmentUrls.add(newDocument.storageUrl);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(viewModel.errorMessage ?? 'Upload failed. Please try again.'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attach Documents'),
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
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Uploading document...', style: TextStyle(color: Colors.white, fontSize: 16)),
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
          const Text('You have no documents.'),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _uploadNewDocument(context),
            icon: const Icon(Icons.upload_file),
            label: const Text('Upload First Document'),
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
                title: Text(doc.documentName),
                subtitle: Text(doc.documentType.name),
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
            label: const Text('Upload New'),
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
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}
