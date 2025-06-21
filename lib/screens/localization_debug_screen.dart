import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:f35_flight_compensation/generated/app_localizations.dart';
import '../services/localization_service.dart';
import 'package:get_it/get_it.dart';

/// A debug screen to view and test all translations
/// This screen is only meant for development and testing purposes
class LocalizationDebugScreen extends StatefulWidget {
  const LocalizationDebugScreen({super.key});

  @override
  State<LocalizationDebugScreen> createState() => _LocalizationDebugScreenState();
}

class _LocalizationDebugScreenState extends State<LocalizationDebugScreen> {
  late LocalizationService _localizationService;
  late List<Locale> _availableLocales;
  late Locale _selectedLocale;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final List<String> _categories = [
    'Common',
    'Form Fields',
    'Buttons',
    'Messages',
    'Documents',
    'Errors',
  ];
  String _selectedCategory = 'Common';

  @override
  void initState() {
    super.initState();
    _localizationService = GetIt.instance<LocalizationService>();
    _availableLocales = LocalizationService.supportedLocales;
    _selectedLocale = _localizationService.currentLocale;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Get all translation keys from the AppLocalizations class
  List<String> _getAllTranslationKeys(AppLocalizations localizations) {
    // This is a static list of common keys, in a real implementation you might
    // use reflection or a more dynamic approach to get all keys
    return [
      // Common
      'appTitle',
      'welcomeMessage',
      'home',
      'settings',
      'yes',
      'no',
      'ok',
      'back',
      'save',
      
      // Form Fields
      'passengerName',
      'passengerDetails',
      'flightNumber',
      'airline',
      'departureAirport',
      'arrivalAirport',
      'email',
      'bookingReference',
      'additionalInformation',
      'optional',
      'thisFieldIsRequired',
      'pleaseEnterDepartureAirport',
      
      // Buttons
      'uploadDocuments',
      'submitClaim',
      'addDocument',
      
      // Messages
      'claimSubmittedSuccessfully',
      'completeAllFields',
      
      // Documents
      'supportingDocuments',
      'cropDocument',
      'crop',
      'rotate',
      'aspectRatio',
      'documentOcrResult',
      'extractedFields',
      'fullText',
      'documentSaved',
      'useExtractedData',
      'copyToClipboard',
      'documentType',
      'saveDocument',
      'fieldName',
      'fieldValue',
      'noFieldsExtracted',
      
      // Errors
      'copiedToClipboard',
      'formSubmissionError',
      'networkError',
      'generalError',
      'loginRequiredForClaim',
      'errorConnectionFailed',
    ];
  }

  /// Filter keys by search query and category
  List<String> _getFilteredKeys(List<String> allKeys) {
    final searchLower = _searchQuery.toLowerCase();
    
    // Category filters
    final Map<String, List<String>> categoryFilters = {
      'Common': ['appTitle', 'welcomeMessage', 'home', 'settings', 'yes', 'no', 'ok', 'back', 'save'],
      'Form Fields': ['passengerName', 'passengerDetails', 'flightNumber', 'airline', 'departureAirport', 'arrivalAirport', 'email', 'bookingReference', 'additionalInformation', 'optional', 'thisFieldIsRequired', 'pleaseEnterDepartureAirport'],
      'Buttons': ['uploadDocuments', 'submitClaim', 'addDocument'],
      'Messages': ['claimSubmittedSuccessfully', 'completeAllFields'],
      'Documents': ['supportingDocuments', 'cropDocument', 'crop', 'rotate', 'aspectRatio', 'documentOcrResult', 'extractedFields', 'fullText', 'documentSaved', 'useExtractedData', 'copyToClipboard', 'documentType', 'saveDocument', 'fieldName', 'fieldValue', 'noFieldsExtracted'],
      'Errors': ['copiedToClipboard', 'formSubmissionError', 'networkError', 'generalError', 'loginRequiredForClaim', 'errorConnectionFailed'],
    };
    
    // Apply category filter
    List<String> filteredKeys = _selectedCategory == 'All' 
        ? allKeys 
        : categoryFilters[_selectedCategory] ?? [];
    
    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filteredKeys = filteredKeys.where((key) => 
        key.toLowerCase().contains(searchLower)).toList();
    }
    
    return filteredKeys;
  }

  /// Get the translated value for a key using reflection
  String _getTranslatedValue(AppLocalizations localizations, String key) {
    try {
      switch (key) {
        case 'appTitle':
          return localizations.appTitle;
        case 'welcomeMessage':
          return localizations.welcomeMessage;
        case 'home':
          return localizations.home;
        case 'settings':
          return localizations.settings;
        case 'yes':
          return localizations.yes;
        case 'no':
          return localizations.no;
        case 'ok':
          return localizations.ok;
        case 'back':
          return localizations.back;
        case 'save':
          return localizations.save;
        case 'languageSelection':
          return localizations.languageSelection;
        case 'passengerName':
          return localizations.passengerName;
        case 'passengerDetails':
          return localizations.passengerDetails;
        case 'flightNumber':
          return localizations.flightNumber;
        case 'airline':
          return localizations.airline;
        case 'departureAirport':
          return localizations.departureAirport;
        case 'arrivalAirport':
          return localizations.arrivalAirport;
        case 'email':
          return localizations.email;
        case 'bookingReference':
          return localizations.bookingReference;
        case 'additionalInformation':
          return localizations.additionalInformation;
        case 'optional':
          return localizations.optional;
        case 'thisFieldIsRequired':
          return localizations.thisFieldIsRequired;
        case 'pleaseEnterDepartureAirport':
          return localizations.pleaseEnterDepartureAirport;
        case 'uploadDocuments':
          return localizations.uploadDocuments;
        case 'submitClaim':
          return localizations.submitClaim;
        case 'addDocument':
          return localizations.addDocument;
        case 'claimSubmittedSuccessfully':
          return localizations.claimSubmittedSuccessfully;
        case 'completeAllFields':
          return localizations.completeAllFields;
        case 'supportingDocuments':
          return localizations.supportingDocuments;
        case 'cropDocument':
          return localizations.cropDocument;
        case 'crop':
          return localizations.crop;
        case 'rotate':
          return localizations.rotate;
        case 'aspectRatio':
          return localizations.aspectRatio;
        case 'documentOcrResult':
          return localizations.documentOcrResult;
        case 'extractedFields':
          return localizations.extractedFields;
        case 'fullText':
          return localizations.fullText;
        case 'documentSaved':
          return localizations.documentSaved;
        case 'useExtractedData':
          return localizations.useExtractedData;
        case 'copyToClipboard':
          return localizations.copyToClipboard;
        case 'documentType':
          return localizations.documentType;
        case 'saveDocument':
          return localizations.saveDocument;
        case 'fieldName':
          return localizations.fieldName;
        case 'fieldValue':
          return localizations.fieldValue;
        case 'noFieldsExtracted':
          return localizations.noFieldsExtracted;
        case 'copiedToClipboard':
          return localizations.copiedToClipboard;
        case 'networkError':
          return localizations.networkError;
        case 'generalError':
          return localizations.generalError;
        case 'loginRequiredForClaim':
          return localizations.loginRequiredForClaim;
        case 'errorConnectionFailed':
          return localizations.errorConnectionFailed;
        // For strings with placeholders, use default examples
        case 'formSubmissionError':
          return localizations.formSubmissionError('Example Error');
        default:
          return 'Unknown key: $key';
      }
    } catch (e) {
      return 'Missing translation for: $key';
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final allKeys = _getAllTranslationKeys(localizations);
    final filteredKeys = _getFilteredKeys(allKeys);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Localization Debug'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Localization Debug Help'),
                  content: const SingleChildScrollView(
                    child: Text(
                      'This screen helps you test and debug localizations in the app.\n\n'
                      '- Switch between languages using the dropdown at the top\n'
                      '- Filter translations by category\n'
                      '- Search for specific translation keys\n'
                      '- Tap any translation to copy it to clipboard\n\n'
                      'This screen is only meant for development and testing purposes.'
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Language selection dropdown
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Text('Language: ', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                DropdownButton<Locale>(
                  value: _selectedLocale,
                  items: _availableLocales.map((locale) {
                    final name = _localizationService.getDisplayLanguage(locale.languageCode);
                    return DropdownMenuItem(
                      value: locale,
                      child: Text(name),
                    );
                  }).toList(),
                  onChanged: (locale) {
                    if (locale != null) {
                      setState(() {
                        _selectedLocale = locale;
                      });
                      // Change the app language
                      _localizationService.setLocale(locale);
                    }
                  },
                ),
              ],
            ),
          ),
          
          // Category filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Text('Category: ', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                ...['All', ..._categories].map((category) => 
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: _selectedCategory == category,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search translations',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty 
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          
          // Translation list
          Expanded(
            child: filteredKeys.isEmpty
              ? const Center(
                  child: Text('No translations found'),
                )
              : ListView.builder(
                  itemCount: filteredKeys.length,
                  itemBuilder: (context, index) {
                    final key = filteredKeys[index];
                    final value = _getTranslatedValue(localizations, key);
                    
                    return ListTile(
                      title: Text(key, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(value),
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: value));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Copied: $value')),
                        );
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.content_copy),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: value));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Copied: $value')),
                          );
                        },
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}
