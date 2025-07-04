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
          userId: 'current-user', // Would normally get from auth service
          documentName: fileName,
          documentType: FlightDocumentType.other,
          flightNumber: widget.claim.flightNumber,
          flightDate: widget.claim.flightDate,
          storageUrl: mockDocId, // Using mockDocId as the storage URL for web documents
          uploadDate: DateTime.now(),
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
                title: Text(doc.documentName ?? AppLocalizations.of(context)!.claimAttachment),
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
                secondary: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.visibility, color: Colors.blue),
                      tooltip: 'Preview',
                      onPressed: () => _previewDocument(context, doc),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      tooltip: 'Delete',
                      onPressed: () => _deleteDocument(context, doc),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        _buildBottomActionBar(context),
      ],
    );
  }

  /// Method to preview a document
  void _previewDocument(BuildContext context, FlightDocument document) {
    final String fileName = document.documentName ?? 'Document';
    final bool isImageFile = _isImageFile(fileName);
    final bool isPdfFile = fileName.toLowerCase().endsWith('.pdf');
    
    if (kIsWeb && document.storageUrl.startsWith('web-doc-')) {
      // For web mock documents, we need to use a different approach
      // since we don't have actual file data stored in Firebase
      _showFullScreenPreview(context, fileName);
    } else {
      // For actual documents, we'd show a dialog with an image/PDF viewer
      showDialog(
        context: context,
        builder: (context) => Dialog(
          child: Container(
            padding: const EdgeInsets.all(16),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        fileName,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: isImageFile
                      ? _buildImagePreview(document.storageUrl)
                      : isPdfFile
                          ? Center(child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.picture_as_pdf, size: 100, color: Colors.red),
                                const SizedBox(height: 16),
                                Text(AppLocalizations.of(context)!.pdfPreviewMessage),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.download),
                                  label: Text(AppLocalizations.of(context)!.downloadPdf),
                                  onPressed: () {
                                    // Would implement actual download functionality here
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Download would start here')),
                                    );
                                  },
                                ),
                              ],
                            ))
                          : Center(child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.insert_drive_file, size: 100, color: Colors.blue),
                                const SizedBox(height: 16),
                                Text(AppLocalizations.of(context)!.filePreviewNotAvailable),
                                Text('File type: ${_getFileExtension(fileName)}'),
                              ],
                            )),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
  
  /// Determine if a file is an image based on its name/extension
  bool _isImageFile(String fileName) {
    final extension = _getFileExtension(fileName).toLowerCase();
    return ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'].contains(extension);
  }
  
  /// Get the file extension from a filename
  String _getFileExtension(String fileName) {
    return fileName.contains('.')
        ? fileName.split('.').last.toLowerCase()
        : '';
  }
  
  /// Build an image preview widget
  Widget _buildImagePreview(String url) {
    if (url.startsWith('web-doc-')) {
      // For web mock documents, we can't show the actual image
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.image, size: 100, color: Colors.blue),
            const SizedBox(height: 16),
            const Text('Preview not available for web mock documents'),
            const SizedBox(height: 16),
            const Text('In a real implementation, the actual image would be shown here'),
          ],
        ),
      );
    } else {
      // For actual images with a real URL
      return Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: Image.network(
            url,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.broken_image, size: 100, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Failed to load image: $error'),
                ],
              );
            },
          ),
        ),
      );
    }
  }
  
  /// Show full-screen preview for web mock documents
  void _showFullScreenPreview(BuildContext context, String fileName) {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) => Material(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.image, size: 150, color: Colors.white70),
                    const SizedBox(height: 20),
                    Text(
                      'Preview of $fileName',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'In a production app, the actual image would be shown here.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Previewing: $fileName',
                      style: const TextStyle(color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
  
  /// Method to delete a document
  Future<void> _deleteDocument(BuildContext context, FlightDocument document) async {
    final viewModel = Provider.of<DocumentViewModel>(context, listen: false);
    
    // Show confirmation dialog
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteDocument),
        content: Text(AppLocalizations.of(context)!.deleteDocumentConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(AppLocalizations.of(context)!.delete, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ) ?? false;
    
    if (!shouldDelete) return;
    
    // Delete the document
    try {
      final success = await viewModel.deleteDocument(document);
      
      if (success) {
        // Remove from selected attachments if it was selected
        setState(() {
          _selectedAttachmentUrls.remove(document.storageUrl);
        });
        
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.documentDeletedSuccess),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.documentDeleteFailed),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete document: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
