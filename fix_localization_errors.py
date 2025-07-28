import os
import re

# Define language codes and their error message translations
language_codes = {
    'de': 'Ein Fehler ist aufgetreten',
    'es': 'Ha ocurrido un error',
    'fr': 'Une erreur s\'est produite',
    'pl': 'Wystąpił błąd',
    'pt': 'Ocorreu um erro'
}

# Base directory for localization files
base_dir = 'lib/l10n2'

for lang_code, error_msg in language_codes.items():
    file_path = os.path.join(base_dir, f'app_localizations_{lang_code}.dart')
    
    if os.path.exists(file_path):
        print(f"Processing {file_path}...")
        
        # Read the file content
        with open(file_path, 'r', encoding='utf-8') as file:
            content = file.read()
        
        # 1. Add errorMessage getter if it doesn't exist
        class_name = f'AppLocalizations{lang_code.capitalize()}'
        
        # Check if errorMessage getter already exists
        if 'String get errorMessage' not in content:
            # Find the class declaration
            class_pattern = f'class {class_name} extends AppLocalizations'
            class_match = re.search(class_pattern, content)
            
            if class_match:
                # Find the last getter method
                last_getter_pattern = r'String get [a-zA-Z0-9_]+\s*\{\s*return [^;]+;\s*\}'
                last_getters = list(re.finditer(last_getter_pattern, content))
                
                if last_getters:
                    last_getter = last_getters[-1]
                    insert_pos = last_getter.end()
                    
                    # Insert errorMessage getter after the last getter
                    error_getter = f'\n\n  @override\n  String get errorMessage {{\n    return \'{error_msg}\';\n  }}'
                    
                    content = content[:insert_pos] + error_getter + content[insert_pos:]
                    print(f"  Added errorMessage getter to {file_path}")
        
        # 2. Fix errorFormSubmissionFailed method
        error_form_pattern = r'@override\s+String errorFormSubmissionFailed\(String errorMessage\)\s*\{[^}]+\}'
        
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
        
        replacement = f'@override\n  String errorFormSubmissionFailed(String errorMessage) {{\n    return \'{message_text[lang_code]}\' + errorMessage + \'{suffix_text[lang_code]}\';\n  }}'
        
        # Replace the errorFormSubmissionFailed method
        new_content = re.sub(error_form_pattern, replacement, content)
        
        if new_content != content:
            print(f"  Fixed errorFormSubmissionFailed in {file_path}")
            
        # Write changes back to file
        with open(file_path, 'w', encoding='utf-8') as file:
            file.write(new_content)
            
    else:
        print(f"File not found: {file_path}")

print("Processing complete!")
