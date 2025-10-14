import 'package:flutter/material.dart';
import 'package:f35_flight_compensation/core/app_localizations_patch.dart';

/// Dialog to collect real email from World ID users for carrier correspondence
class EmailCollectionDialog extends StatefulWidget {
  final String? initialEmail;
  
  const EmailCollectionDialog({
    super.key,
    this.initialEmail,
  });

  @override
  State<EmailCollectionDialog> createState() => _EmailCollectionDialogState();
}

class _EmailCollectionDialogState extends State<EmailCollectionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialEmail != null && !widget.initialEmail!.contains('worldid_')) {
      _emailController.text = widget.initialEmail!;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.l10n.authEmailRequired;
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return context.l10n.authInvalidEmail;
    }
    
    return null;
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.of(context).pop(_emailController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.email_outlined, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          const Expanded(
            child: Text('Email Address Required'),
          ),
        ],
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'To receive claim updates and correspondence from the airline, please provide your email address.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email Address',
                hintText: 'your.email@example.com',
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              validator: _validateEmail,
              onFieldSubmitted: (_) => _submit(),
              enabled: !_isLoading,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This email will be used for airline communications only. We\'ll never spam you.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(null),
          child: Text(context.l10n.cancel),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Continue'),
        ),
      ],
    );
  }
}
