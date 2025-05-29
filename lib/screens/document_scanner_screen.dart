import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/services/service_initializer.dart';
import '../models/document_ocr_result.dart';
import '../viewmodels/document_scanner_viewmodel.dart';
import 'document_crop_screen.dart';
import 'document_ocr_result_screen.dart';

/// Screen for scanning documents and processing with OCR
class DocumentScannerScreen extends StatefulWidget {
  /// Route name for navigation
  static const routeName = '/document-scanner';

  const DocumentScannerScreen({Key? key}) : super(key: key);

  @override
  State<DocumentScannerScreen> createState() => _DocumentScannerScreenState();
}

class _DocumentScannerScreenState extends State<DocumentScannerScreen> {
  late final DocumentScannerViewModel _viewModel;
  
  @override
  void initState() {
    super.initState();
    _viewModel = ServiceInitializer.get<DocumentScannerViewModel>();
    _loadSavedDocuments();
  }
  
  /// Load saved documents when screen initializes
  Future<void> _loadSavedDocuments() async {
    await _viewModel.loadSavedDocuments();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<DocumentScannerViewModel>(
        builder: (context, viewModel, _) {
          // Show cropping screen if in cropping state
          if (viewModel.isCropping && viewModel.selectedImage != null) {
            return DocumentCropScreen(
              imageFile: viewModel.selectedImage!,
              onCropped: viewModel.saveCroppedImage,
              onCancel: viewModel.cancelCropping,
            );
          }
          
          // Show OCR result screen if result is available
          if (viewModel.ocrResult != null) {
            return DocumentOcrResultScreen(
              ocrResult: viewModel.ocrResult!,
              onDone: viewModel.cancelProcessing,
            );
          }
          
          return Scaffold(
            appBar: AppBar(
              title: const Text('Document Scanner'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.help_outline),
                  onPressed: () => _showHelpDialog(context),
                ),
              ],
            ),
            body: viewModel.isProcessing
                ? _buildLoadingIndicator()
                : _buildDocumentScannerContent(viewModel, context),
          );
        },
      ),
    );
  }
  
  /// Build loading indicator with progress message
  Widget _buildLoadingIndicator() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Processing document...'),
          SizedBox(height: 8),
          Text(
            'Extracting text and identifying fields',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
  
  /// Build the main content of the document scanner screen
  Widget _buildDocumentScannerContent(
    DocumentScannerViewModel viewModel,
    BuildContext context,
  ) {
    return Column(
      children: [
        // Error message display
        if (viewModel.errorMessage.isNotEmpty)
          Container(
            color: Colors.red.shade100,
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.red),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    viewModel.errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: viewModel.resetError,
                  color: Colors.red,
                ),
              ],
            ),
          ),
          
        // Image capture options
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Document Type',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildDocumentTypeSelector(viewModel),
              const SizedBox(height: 24),
              const Text(
                'Capture Document',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCaptureButton(
                    icon: Icons.camera_alt,
                    label: 'Take Photo',
                    onPressed: viewModel.takePhoto,
                  ),
                  _buildCaptureButton(
                    icon: Icons.photo_library,
                    label: 'Gallery',
                    onPressed: viewModel.pickImage,
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Preview of selected/cropped image
        if (viewModel.croppedImage != null) ...[
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selected Document',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                _buildImagePreview(viewModel.croppedImage!),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.document_scanner),
                    label: const Text('Process Document'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: viewModel.selectedDocumentType != DocumentType.unknown
                        ? viewModel.processDocument
                        : () => ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select a document type'),
                              ),
                            ),
                  ),
                ),
              ],
            ),
          ),
        ],
        
        // List of previously scanned documents
        if (viewModel.savedDocuments.isNotEmpty) ...[
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                const Text(
                  'Recent Documents',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${viewModel.savedDocuments.length} documents',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          Expanded(
            child: _buildSavedDocumentsList(viewModel),
          ),
        ],
      ],
    );
  }
  
  /// Build document type selector dropdown
  Widget _buildDocumentTypeSelector(DocumentScannerViewModel viewModel) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<DocumentType>(
          value: viewModel.selectedDocumentType,
          isExpanded: true,
          hint: const Text('Select Document Type'),
          items: DocumentType.values.map((type) {
            return DropdownMenuItem<DocumentType>(
              value: type,
              child: Text(type.displayName),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              viewModel.setDocumentType(value);
            }
          },
        ),
      ),
    );
  }
  
  /// Build capture button (camera or gallery)
  Widget _buildCaptureButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ElevatedButton.icon(
          icon: Icon(icon),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
  
  /// Build image preview widget
  Widget _buildImagePreview(File image) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(
          maxHeight: 200,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            image,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
  
  /// Build list of saved documents
  Widget _buildSavedDocumentsList(DocumentScannerViewModel viewModel) {
    return ListView.builder(
      itemCount: viewModel.savedDocuments.length,
      itemBuilder: (context, index) {
        final document = viewModel.savedDocuments[index];
        return ListTile(
          leading: _buildDocumentTypeIcon(document.documentType),
          title: Text(document.documentType.displayName),
          subtitle: Text(
            'Scanned on ${_formatDate(document.scanDate)}',
            style: const TextStyle(fontSize: 12),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () => _showDeleteConfirmation(context, document.documentId),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DocumentOcrResultScreen(
                  ocrResult: document,
                  onDone: () => Navigator.of(context).pop(),
                ),
              ),
            );
          },
        );
      },
    );
  }
  
  /// Show confirmation dialog before deleting a document
  Future<void> _showDeleteConfirmation(BuildContext context, String documentId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Document'),
        content: const Text('Are you sure you want to delete this document?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      await _viewModel.deleteDocument(documentId);
    }
  }
  
  /// Show help dialog with instructions
  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Document Scanner Help'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHelpSection(
                'Document Types',
                'Select the type of document you\'re scanning for better text recognition:',
                [
                  'Boarding Pass: Flight details, seat number',
                  'Flight Ticket: Booking reference, fare amount',
                  'Luggage Tag: Tag number, flight details',
                  'ID/Passport: Personal information',
                  'Receipt: Purchase details, amount',
                ],
              ),
              const SizedBox(height: 16),
              _buildHelpSection(
                'Tips for Better Scanning',
                'For best results:',
                [
                  'Ensure good lighting',
                  'Hold camera steady',
                  'Crop to include only the document',
                  'Flatten folded documents',
                ],
              ),
              const SizedBox(height: 16),
              _buildHelpSection(
                'Using Scanned Documents',
                'After scanning:',
                [
                  'Review extracted information',
                  'Use the "Fill Form" button to auto-fill forms',
                  'Edit any incorrectly recognized text',
                  'Save important documents for later use',
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Close'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }
  
  /// Build a section for the help dialog
  Widget _buildHelpSection(String title, String intro, List<String> points) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(intro),
        const SizedBox(height: 8),
        ...points.map((point) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                  Expanded(child: Text(point)),
                ],
              ),
            )),
      ],
    );
  }
  
  /// Build icon based on document type
  Widget _buildDocumentTypeIcon(DocumentType type) {
    IconData icon;
    Color color;
    
    switch (type) {
      case DocumentType.boardingPass:
        icon = Icons.airplane_ticket;
        color = Colors.blue;
        break;
      case DocumentType.flightTicket:
        icon = Icons.flight;
        color = Colors.indigo;
        break;
      case DocumentType.luggageTag:
        icon = Icons.luggage;
        color = Colors.brown;
        break;
      case DocumentType.idCard:
        icon = Icons.badge;
        color = Colors.teal;
        break;
      case DocumentType.passport:
        icon = Icons.book;
        color = Colors.deepPurple;
        break;
      case DocumentType.receipt:
        icon = Icons.receipt;
        color = Colors.green;
        break;
      case DocumentType.unknown:
        icon = Icons.help_outline;
        color = Colors.grey;
        break;
    }
    
    return CircleAvatar(
      backgroundColor: color.withOpacity(0.2),
      child: Icon(icon, color: color),
    );
  }
  
  /// Format date to a readable string
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
