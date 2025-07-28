import os

# Define error messages for each language
error_messages = {
    'de': 'Fehler',
    'es': 'Error',
    'fr': 'Erreur',
    'pl': 'Błąd',
    'pt': 'Erro'
}

# Base directory for localization files
base_dir = 'lib/l10n2'

for lang_code, error_text in error_messages.items():
    file_path = os.path.join(base_dir, f'app_localizations_{lang_code}.dart')
    
    if os.path.exists(file_path):
        print(f"Processing {file_path}...")
        
        # Read the file content
        with open(file_path, 'r', encoding='utf-8') as file:
            content = file.read()
        
        # Check if errorMessage getter already exists
        if 'String get errorMessage' not in content:
            # Find a good insertion point - after the class declaration
            class_pattern = f"class AppLocalizations{lang_code.capitalize()} extends AppLocalizations"
            
            if class_pattern in content:
                # Find the position of opening brace after class declaration
                class_pos = content.find(class_pattern)
                brace_pos = content.find("{", class_pos)
                
                if brace_pos > -1:
                    # Insert errorMessage getter after the opening brace
                    insert_text = f"\n  @override\n  String get errorMessage => '{error_text}';\n"
                    
                    new_content = content[:brace_pos+1] + insert_text + content[brace_pos+1:]
                    
                    # Write back the modified file
                    with open(file_path, 'w', encoding='utf-8') as file:
                        file.write(new_content)
                        
                    print(f"Added errorMessage getter to {file_path}")
                else:
                    print(f"Could not find opening brace for class in {file_path}")
            else:
                print(f"Could not find class declaration in {file_path}")
        else:
            print(f"errorMessage getter already exists in {file_path}")
    else:
        print(f"File not found: {file_path}")

print("Processing complete!")
