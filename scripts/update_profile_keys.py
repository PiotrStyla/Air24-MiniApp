import json
import os

def update_arb_files_with_keys(profile_keys_file, arb_directory):
    # Load profile keys
    with open(profile_keys_file, 'r', encoding='utf-8') as f:
        profile_keys = json.load(f)
    
    # Get all ARB files
    arb_files = [f for f in os.listdir(arb_directory) if f.endswith('.arb')]
    
    for arb_file in arb_files:
        arb_file_path = os.path.join(arb_directory, arb_file)
        
        # Load ARB file content
        with open(arb_file_path, 'r', encoding='utf-8') as f:
            arb_content = json.load(f)
        
        # Add profile keys to ARB content
        # For non-English files, we'll just copy the English strings as placeholders
        is_english = 'en' in arb_file
        
        # Track if any keys were added
        keys_added = False
        
        for key, value in profile_keys.items():
            # Skip metadata entries (starting with @) for non-English files
            if key.startswith('@') and not is_english:
                continue
                
            # Only add if key doesn't exist
            if key not in arb_content:
                arb_content[key] = value
                keys_added = True
                print(f"Added key '{key}' to {arb_file}")
                
            # Add metadata for all files if it exists in profile_keys
            meta_key = f"@{key}"
            if meta_key in profile_keys and meta_key not in arb_content:
                arb_content[meta_key] = profile_keys[meta_key]
                keys_added = True
                print(f"Added metadata '{meta_key}' to {arb_file}")
        
        if keys_added:
            # Write updated content back to ARB file
            with open(arb_file_path, 'w', encoding='utf-8') as f:
                json.dump(arb_content, f, ensure_ascii=False, indent=2)
            print(f"Updated {arb_file}")
        else:
            print(f"No changes needed for {arb_file}")

if __name__ == "__main__":
    profile_keys_file = "scripts/profile_localizations.json"
    arb_directory = "lib/l10n2"
    update_arb_files_with_keys(profile_keys_file, arb_directory)
    print("Done!")
