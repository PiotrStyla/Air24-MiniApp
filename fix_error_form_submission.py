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
            if lang_code == 'de':
                new_impl = '@override\n  String errorFormSubmissionFailed(String errorMessage) {\n    return \'Fehler beim Senden des Formulars: \' + errorMessage + \'. Bitte überprüfen Sie Ihre Verbindung und versuchen Sie es erneut.\';'
            elif lang_code == 'es':
                new_impl = '@override\n  String errorFormSubmissionFailed(String errorMessage) {\n    return \'Error al enviar el formulario: \' + errorMessage + \'. Verifique su conexión e inténtelo de nuevo.\';'
            elif lang_code == 'fr':
                new_impl = '@override\n  String errorFormSubmissionFailed(String errorMessage) {\n    return \'Erreur lors de la soumission du formulaire : \' + errorMessage + \'. Veuillez vérifier votre connexion et réessayer.\';'
            elif lang_code == 'pl':
                new_impl = '@override\n  String errorFormSubmissionFailed(String errorMessage) {\n    return \'Błąd podczas wysyłania formularza: \' + errorMessage + \'. Sprawdź połączenie i spróbuj ponownie.\';'
            elif lang_code == 'pt':
                new_impl = '@override\n  String errorFormSubmissionFailed(String errorMessage) {\n    return \'Erro ao submeter o formulário: \' + errorMessage + \'. Verifique a sua ligação e tente novamente.\';'
            
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
