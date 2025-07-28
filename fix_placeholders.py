import json
import os
import sys

def fix_arb_file_placeholders():
    """Fix placeholder type mismatches in ARB files."""
    # Directory containing ARB files
    arb_dir = 'lib/l10n2'
    
    # Get the English ARB file as the template
    en_arb_path = os.path.join(arb_dir, 'app_en.arb')
    try:
        with open(en_arb_path, 'r', encoding='utf-8') as f:
            en_data = json.load(f)
    except Exception as e:
        print(f"Error loading English ARB file: {e}")
        return False
    
    # Extract placeholder types from English ARB
    placeholder_types = {}
    for key, value in en_data.items():
        if key.startswith('@') and 'placeholders' in value:
            base_key = key[1:]  # Remove '@' prefix
            placeholder_types[base_key] = {}
            for placeholder_name, placeholder_info in value.get('placeholders', {}).items():
                if 'type' in placeholder_info:
                    placeholder_types[base_key][placeholder_name] = placeholder_info['type']
    
    # Process each non-English ARB file
    for filename in os.listdir(arb_dir):
        if filename.endswith('.arb') and filename != 'app_en.arb' and not filename.startswith('intl_'):
            arb_path = os.path.join(arb_dir, filename)
            try:
                # Read existing ARB file
                with open(arb_path, 'r', encoding='utf-8') as f:
                    arb_data = json.load(f)
                
                # Backup ARB file
                backup_path = arb_path + '.bak'
                with open(backup_path, 'w', encoding='utf-8') as f:
                    json.dump(arb_data, f, ensure_ascii=False, indent=2)
                
                # Flag to track if we made changes
                changes_made = False
                
                # Fix placeholder types
                for key, value in list(arb_data.items()):
                    if key.startswith('@') and 'placeholders' in value:
                        base_key = key[1:]  # Remove '@' prefix
                        if base_key in placeholder_types:
                            for placeholder_name, correct_type in placeholder_types[base_key].items():
                                if (placeholder_name in value.get('placeholders', {}) and 
                                    'type' in value['placeholders'][placeholder_name] and
                                    value['placeholders'][placeholder_name]['type'] != correct_type):
                                    # Fix the type to match the English template
                                    print(f"In {filename}, fixing {base_key}.{placeholder_name} type from {value['placeholders'][placeholder_name]['type']} to {correct_type}")
                                    value['placeholders'][placeholder_name]['type'] = correct_type
                                    changes_made = True
                        
                        # Check if any placeholders are missing and add them from the template
                        if base_key in placeholder_types and base_key in arb_data:
                            for placeholder_name, correct_type in placeholder_types[base_key].items():
                                if placeholder_name not in value.get('placeholders', {}):
                                    if 'placeholders' not in value:
                                        value['placeholders'] = {}
                                    value['placeholders'][placeholder_name] = {
                                        'type': correct_type,
                                        'example': en_data.get('@' + base_key, {}).get('placeholders', {}).get(placeholder_name, {}).get('example', '')
                                    }
                                    print(f"In {filename}, adding missing placeholder {base_key}.{placeholder_name}")
                                    changes_made = True
                
                # Add missing entries from the template
                for key, value in en_data.items():
                    if key not in arb_data and not key.startswith('@'):
                        # Add the message with the same text as English for now (translators can update later)
                        arb_data[key] = en_data[key]
                        changes_made = True
                        print(f"In {filename}, adding missing key {key}")
                    
                    # Add metadata
                    meta_key = f'@{key}'
                    if not key.startswith('@') and meta_key in en_data and meta_key not in arb_data:
                        arb_data[meta_key] = en_data[meta_key]
                        changes_made = True
                        print(f"In {filename}, adding missing metadata key {meta_key}")
                
                # Write updated ARB file if changes were made
                if changes_made:
                    with open(arb_path, 'w', encoding='utf-8') as f:
                        json.dump(arb_data, f, ensure_ascii=False, indent=2)
                    print(f"Updated {filename} with fixed placeholders")
                else:
                    print(f"No placeholder fixes needed for {filename}")
                    
            except Exception as e:
                print(f"Error processing {filename}: {e}")
    
    return True

if __name__ == "__main__":
    success = fix_arb_file_placeholders()
    sys.exit(0 if success else 1)
