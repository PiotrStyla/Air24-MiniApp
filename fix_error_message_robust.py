#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import re

def fix_localization_file(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        content = file.read()

    # First check if errorMessage getter already exists
    if 'String get errorMessage' in content:
        print(f"errorMessage getter already exists in {file_path}")
        return False
        
    # Find the class definition
    class_match = re.search(r'class (\w+) extends AppLocalizations {', content)
    if not class_match:
        print(f"Could not find class definition in {file_path}")
        return False
    
    class_name = class_match.group(1)
    
    # Add the errorMessage getter right before the end of the class
    pattern = r'}(\s*)$'
    replacement = r'''
  @override
  String get errorMessage => 'Error message';
}\1'''

    # For language-specific error messages
    if 'app_localizations_de.dart' in file_path:
        replacement = r'''
  @override
  String get errorMessage => 'Fehlermeldung';
}\1'''
    elif 'app_localizations_es.dart' in file_path:
        replacement = r'''
  @override
  String get errorMessage => 'Mensaje de error';
}\1'''
    elif 'app_localizations_fr.dart' in file_path:
        replacement = r'''
  @override
  String get errorMessage => 'Message d\'erreur';
}\1'''
    elif 'app_localizations_pl.dart' in file_path:
        replacement = r'''
  @override
  String get errorMessage => 'Komunikat o błędzie';
}\1'''
    elif 'app_localizations_pt.dart' in file_path:
        replacement = r'''
  @override
  String get errorMessage => 'Mensagem de erro';
}\1'''
    elif 'app_localizations_en.dart' in file_path:
        replacement = r'''
  @override
  String get errorMessage => 'Error message';
}\1'''
    
    updated_content = re.sub(pattern, replacement, content)
    
    if updated_content != content:
        with open(file_path, 'w', encoding='utf-8') as file:
            file.write(updated_content)
        print(f"Added errorMessage getter to {file_path}")
        return True
    else:
        print(f"Failed to add errorMessage getter to {file_path}")
        return False

def fix_all_localization_files():
    base_dir = 'lib/l10n2'
    files_fixed = 0
    
    for filename in os.listdir(base_dir):
        if filename.startswith('app_localizations_') and filename.endswith('.dart'):
            file_path = os.path.join(base_dir, filename)
            if fix_localization_file(file_path):
                files_fixed += 1
    
    return files_fixed

if __name__ == '__main__':
    files_fixed = fix_all_localization_files()
    print(f"Total files fixed: {files_fixed}")
