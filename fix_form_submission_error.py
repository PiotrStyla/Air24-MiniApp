#!/usr/bin/env python3
import json
import os
import re
from pathlib import Path

# Directory containing ARB files
arb_dir = Path("lib/l10n2")

# List of language codes (excluding English which is the template)
languages = ["de", "es", "fr", "pl", "pt"]

# Process each ARB file
for lang in languages:
    arb_file_path = arb_dir / f"app_{lang}.arb"
    
    if not arb_file_path.exists():
        print(f"Warning: {arb_file_path} does not exist, skipping.")
        continue
    
    # Read the ARB file
    with open(arb_file_path, "r", encoding="utf-8") as f:
        try:
            arb_data = json.load(f)
        except json.JSONDecodeError as e:
            print(f"Error parsing {arb_file_path}: {e}")
            continue
    
    # Check if formSubmissionError exists and fix it
    if "formSubmissionError" in arb_data:
        value = arb_data["formSubmissionError"]
        # Replace $errorMessage with $error
        if "$errorMessage" in value:
            print(f"Fixing formSubmissionError in {lang}: {value}")
            fixed_value = value.replace("$errorMessage", "$error")
            arb_data["formSubmissionError"] = fixed_value
            print(f"Fixed: {fixed_value}")
    
    # Write the updated ARB file
    with open(arb_file_path, "w", encoding="utf-8") as f:
        json.dump(arb_data, f, ensure_ascii=False, indent=2)
        print(f"Updated {arb_file_path}")

print("Script completed. Now run 'flutter gen-l10n' to regenerate localization files.")
