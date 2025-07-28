#!/usr/bin/env python3
import os
import re

"""
This script automatically fixes generated Dart localization files after Flutter gen-l10n
has run but before compilation starts. It addresses common issues such as using $errorMessage 
instead of $error parameter in the formSubmissionError method.

Run this script after every 'flutter gen-l10n' or during the build process.
"""

# Define language codes
language_codes = ['de', 'es', 'fr', 'pl', 'pt']
base_dir = 'lib/l10n2'

def fix_formSubmissionError(file_path):
    """Fix formSubmissionError method to use the parameter correctly"""
    if not os.path.exists(file_path):
        print(f"File not found: {file_path}")
        return False

    with open(file_path, 'r', encoding='utf-8') as file:
        content = file.read()
    
    # Replace $errorMessage with $error in formSubmissionError method
    # First, check for the exact pattern where errorMessage is referenced in string interpolation
    pattern = r'(\s+String formSubmissionError\(String error\) \{\s+return [^;]+)\$errorMessage([^;]+;)'
    replacement = r'\1$error\2'
    
    # Try first with specific pattern
    new_content = re.sub(pattern, replacement, content)
    
    # If no changes were made, try a more direct approach
    if new_content == content:
        # Direct replacement of errorMessage with error in any formSubmissionError method
        direct_pattern = r'(formSubmissionError\([^\)]+\)[^{]*\{[^}]*?)\$errorMessage'
        direct_replacement = r'\1$error'
        new_content = re.sub(direct_pattern, direct_replacement, content)
    
    if new_content != content:
        with open(file_path, 'w', encoding='utf-8') as file:
            file.write(new_content)
        print(f"Fixed formSubmissionError in {file_path}")
        return True
    else:
        print(f"No changes needed in {file_path}")
        return False

# Fix all language files
fixed_files = []
for lang_code in language_codes:
    file_path = os.path.join(base_dir, f'app_localizations_{lang_code}.dart')
    if fix_formSubmissionError(file_path):
        fixed_files.append(file_path)

# Fix English file if it exists
en_file_path = os.path.join(base_dir, 'app_localizations_en.dart')
if os.path.exists(en_file_path):
    if fix_formSubmissionError(en_file_path):
        fixed_files.append(en_file_path)

# Summary
if fixed_files:
    print(f"Fixed formSubmissionError in {len(fixed_files)} files:")
    for file in fixed_files:
        print(f" - {file}")
else:
    print("No files needed fixing.")

print("Post-generation fixes completed successfully.")
