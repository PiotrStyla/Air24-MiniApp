import json
import os
import glob

# Load the new localization keys
with open('missing_profile_dashboard_localizations.json', 'r', encoding='utf-8') as f:
    new_localizations = json.load(f)

# Get all ARB files
arb_files = glob.glob('../lib/l10n2/app_*.arb')

for arb_file in arb_files:
    # Load existing ARB file
    with open(arb_file, 'r', encoding='utf-8') as f:
        arb_data = json.load(f)
    
    # Add missing keys (only if they don't already exist)
    for key, value in new_localizations.items():
        if key.startswith('@'):
            # Handle metadata entries
            if key not in arb_data:
                arb_data[key] = value
        else:
            # Handle text entries
            if key not in arb_data:
                # For English file, use the provided values
                if 'app_en.arb' in arb_file:
                    arb_data[key] = value
                # For other languages, add the key but use the English text as placeholder
                else:
                    arb_data[key] = new_localizations[key]
    
    # Write updated ARB file with pretty formatting
    with open(arb_file, 'w', encoding='utf-8') as f:
        json.dump(arb_data, f, ensure_ascii=False, indent=2)

print("All ARB files have been updated with profile and dashboard localization keys.")
