import 'package:flutter/material.dart';
import '../core/app_localizations_patch.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../core/services/service_initializer.dart';
import '../models/claim.dart';
import '../models/flight_document.dart';
import '../viewmodels/document_viewmodel.dart';
// Removed navigation back to review; this screen now returns updated claim

/// A wrapper that provides the DocumentViewModel to the attachment view.
class ClaimAttachmentScreen extends StatelessWidget {
  final Claim claim;
  final String? userEmail;

  const ClaimAttachmentScreen({Key? key, required this.claim, this.userEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DocumentViewModel>(
      // Get a fresh view model instance and fetch the user's documents right away.
      create: (_) => ServiceInitializer.get<DocumentViewModel>()..loadAllUserDocuments(),
      child: _ClaimAttachmentView(claim: claim, userEmail: userEmail),
    );
  }
}

/// The main view for attaching documents, consuming the DocumentViewModel.
class _ClaimAttachmentView extends StatefulWidget {
  final Claim claim;
  final String? userEmail;

  const _ClaimAttachmentView({required this.claim, this.userEmail});

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
                content: Text(context.l10n.noFileSelected),
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
              content: Text(context.l10n.documentUploadSuccess),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${context.l10n.uploadFailed}: $e'),
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
        documentName: context.l10n.claimAttachment,
      );

      if (mounted) {
        if (newDocument != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.documentUploadSuccess), backgroundColor: Colors.green),
          );
          // Automatically select the newly uploaded document, avoiding race conditions.
          setState(() {
            _selectedAttachmentUrls.add(newDocument.storageUrl);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(viewModel.errorMessage ?? context.l10n.uploadFailed), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${context.l10n.uploadFailed}: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.attachments),
      ),
      body: Consumer<DocumentViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoadingInitialData) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = vm.documents;
          if (docs.isEmpty) {
            // Show empty state with ability to upload, along with a persistent action bar
            return Column(
              children: [
                _buildAttachmentGuidancePanel(context),
                Expanded(child: _buildEmptyState(context)),
                _buildBottomActionBar(context),
              ],
            );
          }
          return _buildDocumentList(context, docs);
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
          Text(context.l10n.noDocuments),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _uploadNewDocument(context),
            icon: const Icon(Icons.upload_file),
            label: Text(context.l10n.uploadFirstDocument),
          ),
        ],
      ),
    );
  }

  /// Widget that displays the list of documents and the action buttons.
  Widget _buildDocumentList(BuildContext context, List<FlightDocument> documents) {
    return Column(
      children: [
        _buildAttachmentGuidancePanel(context),
        Expanded(
          child: ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final doc = documents[index];
              final isSelected = _selectedAttachmentUrls.contains(doc.storageUrl);
              return CheckboxListTile(
                title: Text(doc.documentName ?? context.l10n.claimAttachment),
                subtitle: Text(doc.documentType == FlightDocumentType.other ? context.l10n.other : doc.documentType.name),
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
                      tooltip: context.l10n.preview,
                      onPressed: () => _previewDocument(context, doc),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      tooltip: context.l10n.delete,
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

  /// Guidance panel for the attachment step, reusing existing localization keys
  /// and visual style used elsewhere in the app (e.g., Quick Claim screen).
  Widget _buildAttachmentGuidancePanel(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.tipsAndRemindersTitle,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
          ),
          const SizedBox(height: 6),
          // New primary guidance about attachments
          Text(context.l10n.emailPreviewAttachmentGuidance),
          const SizedBox(height: 6),
          // Additional tips retained for consistency
          Text(context.l10n.tipSecureData),
          Text(context.l10n.tipDoubleCheckDetails),
        ],
      ),
    );
  }

  /// Method to preview a document
  void _previewDocument(BuildContext context, FlightDocument document) {
    final String fileName = document.documentName ?? context.l10n.claimAttachment;
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
                                Text(context.l10n.pdfPreviewMessage),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.download),
                                  label: Text(context.l10n.downloadPdf),
                                  onPressed: () {
                                    // Would implement actual download functionality here
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(context.l10n.downloadStarting)),
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
                                Text(context.l10n.filePreviewNotAvailable),
                                Text('${context.l10n.fileTypeLabel} ${_getFileExtension(fileName)}'),
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
            Text(context.l10n.filePreviewNotAvailable),
            const SizedBox(height: 16),
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
                  Text('${context.l10n.failedToLoadImage}: $error'),
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
                      fileName,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      context.l10n.filePreviewNotAvailable,
                      style: const TextStyle(color: Colors.white70),
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
                      fileName,
                      style: const TextStyle(color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(context.l10n.done, style: const TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: true,
      barrierLabel: context.l10n.cancel,
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
        title: Text(context.l10n.deleteDocument),
        content: Text(context.l10n.deleteDocumentConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(context.l10n.delete, style: const TextStyle(color: Colors.red)),
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
              content: Text(context.l10n.documentDeletedSuccess),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.documentDeleteFailed),
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
            content: Text('${context.l10n.documentDeleteFailed}: $e'),
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
            label: Text(context.l10n.uploadNew),
          ),
          ElevatedButton(
            onPressed: () {
              final updatedClaim = widget.claim.copyWith(attachmentUrls: _selectedAttachmentUrls.toList());
              // Return to caller (e.g., confirmation screen) with updated claim
              Navigator.of(context).pop<Claim>(updatedClaim);
            },
            child: Text(context.l10n.continueAction),
          ),
        ],
      ),
    );
  }
}
