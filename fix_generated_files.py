import os
import re

# Define language codes
language_codes = ['de', 'es', 'fr', 'pl', 'pt']

# Base directory for localization files
base_dir = 'lib/l10n2'

for lang_code in language_codes:
    file_path = os.path.join(base_dir, f'app_localizations_{lang_code}.dart')
    
    if os.path.exists(file_path):
        print(f"Processing {file_path}...")
        
        # Read the file content
        with open(file_path, 'r', encoding='utf-8') as file:
            content = file.read()
        
        # Find the errorFormSubmissionFailed method
        pattern = r'@override\s+String errorFormSubmissionFailed\(String errorMessage\) \{\s+return [^;]+;'
        match = re.search(pattern, content)
        
        if match:
            # Extract the current implementation
            current_impl = match.group(0)
            
            # Create a new implementation that uses the parameter directly
            message_text = {
                'de': 'Fehler beim Senden des Formulars: ',
                'es': 'Error al enviar el formulario: ',
                'fr': 'Erreur lors de la soumission du formulaire : ',
                'pl': 'Błąd podczas wysyłania formularza: ',
                'pt': 'Erro ao submeter o formulário: '
            }
            
            suffix_text = {
                'de': '. Bitte überprüfen Sie Ihre Verbindung und versuchen Sie es erneut.',
                'es': '. Verifique su conexión e inténtelo de nuevo.',
                'fr': '. Veuillez vérifier votre connexion et réessayer.',
                'pl': '. Sprawdź połączenie i spróbuj ponownie.',
                'pt': '. Verifique a sua ligação e tente novamente.'
            }
            
            new_impl = f'@override\n  String errorFormSubmissionFailed(String errorMessage) {{\n    return \'{message_text[lang_code]}\' + errorMessage + \'{suffix_text[lang_code]}\';'
            
            # Replace the current implementation with the new one
            new_content = content.replace(current_impl, new_impl)
            
            # Write back to the file
            with open(file_path, 'w', encoding='utf-8') as file:
                file.write(new_content)
                
            print(f"Updated errorFormSubmissionFailed in {file_path}")
        else:
            print(f"Could not find errorFormSubmissionFailed method in {file_path}")
    else:
        print(f"File not found: {file_path}")

print("Processing complete!")
