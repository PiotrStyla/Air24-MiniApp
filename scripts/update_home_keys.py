import json
import os

def update_arb_files_with_keys(home_keys_file, arb_directory):
    # Load home screen keys
    with open(home_keys_file, 'r', encoding='utf-8') as f:
        home_keys = json.load(f)
    
    # Get all ARB files
    arb_files = [f for f in os.listdir(arb_directory) if f.endswith('.arb')]
    
    for arb_file in arb_files:
        arb_file_path = os.path.join(arb_directory, arb_file)
        
        # Load ARB file content
        with open(arb_file_path, 'r', encoding='utf-8') as f:
            arb_content = json.load(f)
        
        # Add home screen keys to ARB content
        # For non-English files, we'll just copy the English strings as placeholders
        is_english = 'en' in arb_file
        
        # Track if any keys were added
        keys_added = False
        
        for key, value in home_keys.items():
            # Skip metadata entries (starting with @) for non-English files
            if key.startswith('@') and not is_english:
                continue
                
            # Only add if key doesn't exist
            if key not in arb_content:
                arb_content[key] = value
                keys_added = True
                print(f"Added key '{key}' to {arb_file}")
                
            # Add metadata for all files if it exists in home_keys
            meta_key = f"@{key}"
            if meta_key in home_keys and meta_key not in arb_content:
                arb_content[meta_key] = home_keys[meta_key]
                keys_added = True
                print(f"Added metadata '{meta_key}' to {arb_file}")
        
        # Special handling for errorFormSubmissionFailed - check if errorMessage reference exists in non-English files
        if not is_english and "errorFormSubmissionFailed" in arb_content:
            # Check if it contains errorMessage reference
            content = arb_content["errorFormSubmissionFailed"]
            if "$errorMessage" in content:
                print(f"Found errorMessage reference in {arb_file}, no need to fix")
            else:
                # Add errorMessage reference
                print(f"Warning: errorFormSubmissionFailed in {arb_file} does not contain errorMessage reference")
        
        # Special handling for flightRouteDetailsWithNumber - check if number reference exists in non-English files
        if not is_english and "flightRouteDetailsWithNumber" in arb_content:
            # Check if it contains number reference
            content = arb_content["flightRouteDetailsWithNumber"]
            if "$flightNumber" not in content and "$number" in content:
                # Replace $number with $flightNumber
                arb_content["flightRouteDetailsWithNumber"] = content.replace("$number", "$flightNumber")
                keys_added = True
                print(f"Fixed flightRouteDetailsWithNumber in {arb_file} to use $flightNumber instead of $number")
        
        if keys_added:
            # Write updated content back to ARB file
            with open(arb_file_path, 'w', encoding='utf-8') as f:
                json.dump(arb_content, f, ensure_ascii=False, indent=2)
            print(f"Updated {arb_file}")
        else:
            print(f"No changes needed for {arb_file}")

if __name__ == "__main__":
    home_keys_file = "scripts/home_localizations.json"
    arb_directory = "lib/l10n2"
    update_arb_files_with_keys(home_keys_file, arb_directory)
    print("Done!")
