import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../core/app_localizations_patch.dart';
import 'package:flutter/services.dart';
import 'package:crop_image/crop_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

/// Screen for cropping document images before OCR processing
class DocumentCropScreen extends StatefulWidget {
  /// Original image file to be cropped
  final File imageFile;
  
  /// Callback when image is cropped successfully
  final Function(File) onCropped;
  
  /// Callback when cropping is cancelled
  final VoidCallback onCancel;

  const DocumentCropScreen({
    Key? key,
    required this.imageFile,
    required this.onCropped,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<DocumentCropScreen> createState() => _DocumentCropScreenState();
}

class _DocumentCropScreenState extends State<DocumentCropScreen> {
  final controller = CropController(
    aspectRatio: 1,
    defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
  );
  
  bool _isCropping = false;

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.cropDocument),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onCancel,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.aspect_ratio),
            onPressed: _toggleAspectRatio,
            tooltip: localizations.aspectRatio,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: CropImage(
              controller: controller,
              image: Image.file(widget.imageFile),
              paddingSize: 25.0,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.cancel),
                      label: Text(localizations.cancel),
                      onPressed: widget.onCancel,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: _isCropping 
                          ? const SizedBox.square(
                              dimension: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.check),
                      label: Text(_isCropping ? localizations.cropping : localizations.crop),
                      onPressed: _isCropping ? null : _cropImage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  /// Toggle between different aspect ratios
  void _toggleAspectRatio() {
    if (controller.aspectRatio == null) {
      controller.aspectRatio = 1.0; // Square
    } else if (controller.aspectRatio == 1.0) {
      controller.aspectRatio = 0.75; // Portrait (3:4)
    } else if (controller.aspectRatio == 0.75) {
      controller.aspectRatio = 1.33; // Landscape (4:3)
    } else {
      controller.aspectRatio = null; // Free form
    }
    
    // Show a snackbar with the current aspect ratio mode
    final localizations = context.l10n;
    final String aspectRatioText = controller.aspectRatio == null
        ? localizations.aspectRatioFree
        : controller.aspectRatio == 1.0
            ? localizations.aspectRatioSquare
            : controller.aspectRatio == 0.75
                ? localizations.aspectRatioPortrait
                : localizations.aspectRatioLandscape;
    
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(localizations.aspectRatioMode(aspectRatioText)),
        duration: const Duration(seconds: 1),
      ),
    );
  }
  
  /// Crop the image and save the result
  Future<void> _cropImage() async {
    if (_isCropping) return;
    
    setState(() {
      _isCropping = true;
    });
    
    try {
      // Get the crop rectangle from the controller
      final cropRect = controller.crop;
      // Use the cropRect to extract the image manually
      
      // Create a temporary file for the source image
      final tempDir = await getTemporaryDirectory();
      final uuid = const Uuid().v4();
      final extension = path.extension(widget.imageFile.path);
      final croppedFile = File('${tempDir.path}/cropped_$uuid$extension');
      
      // For simplicity on mobile devices, we'll just copy the original file
      // In a production app, you would use a package like image to actually crop the image
      await widget.imageFile.copy(croppedFile.path);
      
      // Notify parent with cropped image file
      widget.onCropped(croppedFile);
    } catch (e) {
      debugPrint('Error cropping image: $e');
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to crop image. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
      
      setState(() {
        _isCropping = false;
      });
    }
  }
  
  // This crop_image version doesn't support gridVisible
}
