import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../models/flight_document.dart';
import '../viewmodels/document_viewmodel.dart';
import '../core/services/service_initializer.dart';

/// Screen for uploading flight-related documents
class DocumentUploadScreen extends StatefulWidget {
  final String? flightNumber;

  const DocumentUploadScreen({
    Key? key,
    this.flightNumber,
  }) : super(key: key);

  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  late final DocumentViewModel _viewModel;
  final _formKey = GlobalKey<FormState>();
  final _flightNumberController = TextEditingController();
  final _documentNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _viewModel = ServiceInitializer.get<DocumentViewModel>();
    
    // Pre-fill flight number if provided
    if (widget.flightNumber != null && widget.flightNumber!.isNotEmpty) {
      _flightNumberController.text = widget.flightNumber!;
      _viewModel.setFlightNumber(widget.flightNumber!);
    }
  }

  @override
  void dispose() {
    _flightNumberController.dispose();
    _documentNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Upload Document'),
        ),
        body: Consumer<DocumentViewModel>(
          builder: (context, viewModel, _) {
            // Update controllers when viewModel changes
            if (_documentNameController.text != viewModel.documentName) {
              _documentNameController.text = viewModel.documentName;
            }
            if (_descriptionController.text != viewModel.description) {
              _descriptionController.text = viewModel.description;
            }
            
            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (viewModel.errorMessage != null)
                          Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.error_outline, color: Colors.red[700]),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    viewModel.errorMessage!,
                                    style: TextStyle(color: Colors.red[700]),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: viewModel.clearError,
                                  color: Colors.red[700],
                                  iconSize: 20,
                                ),
                              ],
                            ),
                          ),
                        
                        // File selection area
                        _buildFileSelectionArea(context, viewModel),
                        
                        const SizedBox(height: 24),
                        
                        // Flight details
                        _buildFlightDetailsSection(context, viewModel),
                        
                        const SizedBox(height: 24),
                        
                        // Document details
                        _buildDocumentDetailsSection(context, viewModel),
                        
                        const SizedBox(height: 32),
                        
                        // Upload button
                        ElevatedButton.icon(
                          icon: const Icon(Icons.cloud_upload),
                          label: const Text('Upload Document'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: viewModel.isUploading || !viewModel.hasSelectedFile
                              ? null
                              : () => _uploadDocument(context),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Loading overlay
                if (viewModel.isUploading)
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFileSelectionArea(BuildContext context, DocumentViewModel viewModel) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: viewModel.hasSelectedFile
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outline.withOpacity(0.3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: viewModel.hasSelectedFile
            ? _buildSelectedFilePreview(context, viewModel)
            : _buildFileSelectionButtons(context),
      ),
    );
  }

  Widget _buildSelectedFilePreview(BuildContext context, DocumentViewModel viewModel) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 200,
            width: double.infinity,
            color: Colors.grey[200],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.insert_drive_file,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 8),
                Text(
                  viewModel.selectedFileName ?? 'File selected',
                  style: Theme.of(context).textTheme.labelLarge,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          icon: const Icon(Icons.refresh),
          label: const Text('Change File'),
          onPressed: () => _showFilePickerOptions(context),
        ),
      ],
    );
  }

  Widget _buildFileSelectionButtons(BuildContext context) {
    return Column(
      children: [
        const Icon(
          Icons.cloud_upload_outlined,
          size: 48,
          color: Colors.grey,
        ),
        const SizedBox(height: 16),
        const Text(
          'Select a document to upload',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Upload boarding passes, tickets, luggage tags or other flight documents',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          icon: const Icon(Icons.add_photo_alternate),
          label: const Text('Select Document'),
          onPressed: () => _showFilePickerOptions(context),
        ),
      ],
    );
  }

  Widget _buildFlightDetailsSection(BuildContext context, DocumentViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Flight Details',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _flightNumberController,
          decoration: const InputDecoration(
            labelText: 'Flight Number',
            hintText: 'e.g., LH123',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.flight),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a flight number';
            }
            return null;
          },
          onChanged: (value) => viewModel.setFlightNumber(value),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () => _selectDate(context, viewModel),
          child: InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Flight Date',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.calendar_today),
            ),
            child: Text(
              DateFormat('yyyy-MM-dd').format(_selectedDate),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentDetailsSection(BuildContext context, DocumentViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Document Details',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<FlightDocumentType>(
          decoration: const InputDecoration(
            labelText: 'Document Type',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.description),
          ),
          value: viewModel.selectedDocumentType,
          items: viewModel.documentTypeOptions.map((option) {
            return DropdownMenuItem<FlightDocumentType>(
              value: option['value'],
              child: Text(option['label']),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              viewModel.setDocumentType(value);
            }
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _documentNameController,
          decoration: const InputDecoration(
            labelText: 'Document Name',
            hintText: 'e.g., Boarding Pass LH123',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.title),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a document name';
            }
            return null;
          },
          onChanged: (value) => viewModel.setDocumentName(value),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'Description (Optional)',
            hintText: 'Add any notes or details about this document',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.notes),
          ),
          maxLines: 3,
          onChanged: (value) => viewModel.setDescription(value),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, DocumentViewModel viewModel) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      viewModel.setFlightDate(_selectedDate);
    }
  }

  void _showFilePickerOptions(BuildContext context) {
    final viewModel = Provider.of<DocumentViewModel>(context, listen: false);
    
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
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  viewModel.pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  viewModel.pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.file_present),
                title: const Text('Select Document File'),
                onTap: () {
                  Navigator.pop(context);
                  viewModel.pickDocument();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _uploadDocument(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final uploaded = await _viewModel.uploadSelectedFile();
      
      if (uploaded != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Document uploaded successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    }
  }
}
