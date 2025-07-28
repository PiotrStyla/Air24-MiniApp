import os
import re
import glob

def add_error_message_getter(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        content = file.read()
    
    # Check if errorMessage getter already exists to avoid duplicates
    if 'String get errorMessage' in content:
        print(f"  errorMessage getter already exists in {file_path}")
        return False
        
    # Find the class name to generate appropriate getter
    class_match = re.search(r'class (\w+) extends', content)
    if not class_match:
        print(f"  Could not find class name in {file_path}")
        return False
    
    class_name = class_match.group(1)
    
    # Different error messages for different languages
    error_messages = {
        'AppLocalizationsEn': '"An error occurred"',
        'AppLocalizationsDe': '"Ein Fehler ist aufgetreten"',
        'AppLocalizationsEs': '"Se ha producido un error"',
        'AppLocalizationsFr': '"Une erreur s\'est produite"',
        'AppLocalizationsPl': '"Wystąpił błąd"',
        'AppLocalizationsPt': '"Ocorreu um erro"',
    }
    
    error_message = error_messages.get(class_name, '"An error occurred"')
    
    # Find the last method or getter in the class to insert after it
    last_item_match = re.search(r'(  [^\n]+\n)(}[\n\s]*$)', content)
    if not last_item_match:
        print(f"  Could not find insertion point in {file_path}")
        return False
    
    # Insert the errorMessage getter
    new_content = content.replace(
        last_item_match.group(0),
        f'{last_item_match.group(1)}\n  @override\n  String get errorMessage => {error_message};\n{last_item_match.group(2)}'
    )
    
    with open(file_path, 'w', encoding='utf-8') as file:
        file.write(new_content)
    
    print(f"  Added errorMessage getter to {file_path}")
    return True

def fix_error_form_submission_failed(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        content = file.read()
    
    # Check if errorFormSubmissionFailed method uses $errorMessage
    if '$errorMessage' in content and 'errorFormSubmissionFailed' in content:
        # Replace $errorMessage with $error in the errorFormSubmissionFailed method
        pattern = r'(String errorFormSubmissionFailed\([^)]*error[^)]*\)[^{]*{[^}]*)\$errorMessage([^}]*})'
        if re.search(pattern, content):
            new_content = re.sub(pattern, r'\1$error\2', content)
            
            with open(file_path, 'w', encoding='utf-8') as file:
                file.write(new_content)
            
            print(f"  Fixed errorFormSubmissionFailed in {file_path}")
            return True
    
    return False

# Process all localization files
def process_files():
    # Find all app_localizations_*.dart files in the lib/l10n2 directory
    files = glob.glob(os.path.join('lib', 'l10n2', 'app_localizations_*.dart'))
    
    for file_path in files:
        print(f"Processing {file_path}...")
        add_error_message_getter(file_path)
        fix_error_form_submission_failed(file_path)

# Run the script
if __name__ == "__main__":
    process_files()
    print("Processing complete!")
