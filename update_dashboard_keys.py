import json
import os
import sys

def update_arb_files_with_dashboard_keys():
    # Path to dashboard keys JSON file
    dashboard_keys_file = 'dashboard_localizations.json'
    
    # Directory containing ARB files
    arb_dir = 'lib/l10n2'
    
    # Load dashboard localization keys
    try:
        with open(dashboard_keys_file, 'r', encoding='utf-8') as f:
            dashboard_keys = json.load(f)
    except Exception as e:
        print(f"Error loading dashboard keys: {e}")
        return False
    
    # Process each ARB file
    for filename in os.listdir(arb_dir):
        if filename.endswith('.arb') and not filename.startswith('intl_'):
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
                
                # Add dashboard keys to ARB file
                for key, value in dashboard_keys.items():
                    # Skip metadata keys (those starting with @)
                    if key.startswith('@'):
                        continue
                    
                    # Add main key if it doesn't exist
                    if key not in arb_data:
                        # For non-English files, we'll add placeholder translation
                        if filename != 'app_en.arb':
                            arb_data[key] = dashboard_keys[key]  # Use English as placeholder
                        else:
                            arb_data[key] = dashboard_keys[key]
                        changes_made = True
                    
                    # Add metadata key if it doesn't exist
                    meta_key = f'@{key}'
                    if meta_key in dashboard_keys and meta_key not in arb_data:
                        arb_data[meta_key] = dashboard_keys[meta_key]
                        changes_made = True
                
                # Write updated ARB file if changes were made
                if changes_made:
                    with open(arb_path, 'w', encoding='utf-8') as f:
                        json.dump(arb_data, f, ensure_ascii=False, indent=2)
                    print(f"Updated {filename} with dashboard keys")
                else:
                    print(f"No changes needed for {filename}")
                    
            except Exception as e:
                print(f"Error processing {filename}: {e}")
    
    return True

if __name__ == "__main__":
    success = update_arb_files_with_dashboard_keys()
    sys.exit(0 if success else 1)
