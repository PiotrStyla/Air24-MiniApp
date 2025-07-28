import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:f35_flight_compensation/models/flight_document.dart';
import 'package:f35_flight_compensation/viewmodels/document_viewmodel.dart';
import 'package:f35_flight_compensation/screens/document_upload_screen.dart';
import '../l10n2/app_localizations.dart';

class DocumentManagementScreen extends StatefulWidget {
  final String? flightNumber;
  final DocumentViewModel? viewModel;

  const DocumentManagementScreen({Key? key, this.flightNumber, this.viewModel}) : super(key: key);

  @override
  State<DocumentManagementScreen> createState() => _DocumentManagementScreenState();
}

class _DocumentManagementScreenState extends State<DocumentManagementScreen> {
  late final DocumentViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel ?? Provider.of<DocumentViewModel>(context, listen: false);
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.flightNumber != null
            ? '${AppLocalizations.of(context)?.documentsForFlightTitle ?? 'Documents for flight'}: ${widget.flightNumber}'
            : AppLocalizations.of(context)?.documentManagementTitle ?? 'Document Management'),
      ),
      body: StreamBuilder<List<FlightDocument>>(
        stream: _viewModel.documentsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(AppLocalizations.of(context)?.errorLoadingDocuments ?? 'Error Loading Documents'));
          }

          final documents = snapshot.data ?? [];

          if (documents.isEmpty) {
            return Center(child: Text(AppLocalizations.of(context)?.noDocumentsYet ?? 'No documents attached yet'));
          }

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final document = documents[index];
              return ListTile(
                leading: Icon(_getIconForType(document.documentType)),
                title: Text(document.documentName),
                subtitle: Text(document.description ?? 'No description'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () =>
                      _showDeleteConfirmation(context, _viewModel, document),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'document_management_fab',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DocumentUploadScreen(flightNumber: widget.flightNumber)),
          );
        },
        child: const Icon(Icons.add),
        tooltip: AppLocalizations.of(context)?.addDocumentTooltip ?? 'Add Document',
      ),
    );
  }

  IconData _getIconForType(FlightDocumentType type) {
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
        return Icons.insert_drive_file;
    }
  }

  void _showDeleteConfirmation(BuildContext context, DocumentViewModel viewModel, FlightDocument document) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)?.deleteDocumentTitle ?? 'Delete Document?'),
          content: Text('${AppLocalizations.of(context)?.deleteDocumentMessage ?? 'Are you sure you want to delete'} ${document.documentName}?'),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)?.cancel ?? 'Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text(
                AppLocalizations.of(context)?.delete ?? 'Delete',
                style: const TextStyle(color: Colors.red),
              ),
              onPressed: () {
                viewModel.deleteDocument(document);
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
