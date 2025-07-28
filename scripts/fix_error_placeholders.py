import json
import os
import re

def fix_error_placeholders(arb_directory):
    # Get all ARB files
    arb_files = [f for f in os.listdir(arb_directory) if f.endswith('.arb')]
    
    # First get the English version to use as template
    english_template = None
    english_file = os.path.join(arb_directory, "app_en.arb")
    if os.path.exists(english_file):
        with open(english_file, 'r', encoding='utf-8') as f:
            english_template = json.load(f)
    
    if not english_template or "errorFormSubmissionFailed" not in english_template:
        print("Error: English template is missing or doesn't have errorFormSubmissionFailed key")
        return
    
    english_error_message = english_template["errorFormSubmissionFailed"]
    print(f"English template: {english_error_message}")
    
    for arb_file in arb_files:
        if arb_file == "app_en.arb":  # Skip English file
            continue
            
        arb_file_path = os.path.join(arb_directory, arb_file)
        
        # Load ARB file content
        with open(arb_file_path, 'r', encoding='utf-8') as f:
            arb_content = json.load(f)
        
        # Check if errorFormSubmissionFailed key exists
        if "errorFormSubmissionFailed" in arb_content:
            current_message = arb_content["errorFormSubmissionFailed"]
            
            # Check if it doesn't have the errorMessage placeholder
            if "$errorMessage" not in current_message:
                print(f"Fixing errorFormSubmissionFailed in {arb_file}")
                
                # Find where to insert the errorMessage
                # Strategy: Look for a typical pattern where the error message would be
                pattern = re.compile(r':[^.]+\.')  # Look for : followed by text and a period
                match = pattern.search(current_message)
                
                if match:
                    # Insert $errorMessage after the colon
                    colon_pos = match.start() + 1  # Position after the colon
                    fixed_message = current_message[:colon_pos] + " $errorMessage" + current_message[colon_pos:]
                    arb_content["errorFormSubmissionFailed"] = fixed_message
                    
                    # Write updated content back to ARB file
                    with open(arb_file_path, 'w', encoding='utf-8') as f:
                        json.dump(arb_content, f, ensure_ascii=False, indent=2)
                    print(f"Updated {arb_file} with fixed errorFormSubmissionFailed: {fixed_message}")
                else:
                    print(f"Couldn't find pattern to insert errorMessage in {arb_file}")
            else:
                print(f"{arb_file} already has correct errorMessage placeholder")
        else:
            print(f"{arb_file} doesn't have errorFormSubmissionFailed key")

if __name__ == "__main__":
    arb_directory = "lib/l10n2"
    fix_error_placeholders(arb_directory)
    print("Done!")
