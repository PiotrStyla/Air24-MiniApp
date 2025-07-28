#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os

def add_error_message_getter_to_file(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        content = file.read()
    
    # Check if the file already has the errorMessage getter
    if 'String get errorMessage =>' not in content:
        # Find the class declaration line
        lines = content.split('\n')
        for i, line in enumerate(lines):
            if 'class AppLocalization' in line and 'extends AppLocalizations' in line:
                # Insert the getter after the class declaration
                lines.insert(i+1, '  String get errorMessage => "Error";')
                break
        
        # Write the updated content back to the file
        with open(file_path, 'w', encoding='utf-8') as file:
            file.write('\n'.join(lines))
        print(f'Added errorMessage getter to {file_path}')
    else:
        print(f'errorMessage getter already exists in {file_path}')

# Find all localization files in the lib/l10n2 directory
localization_dir = 'lib/l10n2'
for file in os.listdir(localization_dir):
    if file.startswith('app_localizations_') and file.endswith('.dart'):
        file_path = os.path.join(localization_dir, file)
        add_error_message_getter_to_file(file_path)
