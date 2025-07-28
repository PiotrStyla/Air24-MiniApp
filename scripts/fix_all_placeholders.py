import json
import os
import re

def fix_all_placeholders(arb_directory):
    # Get all ARB files
    arb_files = [f for f in os.listdir(arb_directory) if f.endswith('.arb')]
    
    for arb_file in arb_files:
        if arb_file == "app_en.arb":  # Skip English file
            continue
            
        arb_file_path = os.path.join(arb_directory, arb_file)
        
        # Load ARB file content
        with open(arb_file_path, 'r', encoding='utf-8') as f:
            arb_content = json.load(f)
        
        # Track if any changes were made
        changes_made = False
        
        # Fix welcomeUser - replace $userName with $name
        if "welcomeUser" in arb_content:
            message = arb_content["welcomeUser"]
            if "$userName" in message:
                arb_content["welcomeUser"] = message.replace("$userName", "$name")
                print(f"Fixed welcomeUser in {arb_file}: replaced $userName with $name")
                changes_made = True
        
        # Fix flightRouteDetailsWithNumber - replace $number with $flightNumber
        if "flightRouteDetailsWithNumber" in arb_content:
            message = arb_content["flightRouteDetailsWithNumber"]
            if "$number" in message and "$flightNumber" not in message:
                arb_content["flightRouteDetailsWithNumber"] = message.replace("$number", "$flightNumber")
                print(f"Fixed flightRouteDetailsWithNumber in {arb_file}: replaced $number with $flightNumber")
                changes_made = True
                
        # Fix errorFormSubmissionFailed - replace incorrect usage of $errorMessage
        if "errorFormSubmissionFailed" in arb_content:
            message = arb_content["errorFormSubmissionFailed"]
            if "$errorMessage" not in message:
                # English template as reference
                arb_content["errorFormSubmissionFailed"] = "Error submitting form: $errorMessage. Please check your connection and try again."
                print(f"Fixed errorFormSubmissionFailed in {arb_file}: set to English template with $errorMessage")
                changes_made = True
        
        if changes_made:
            # Write updated content back to ARB file
            with open(arb_file_path, 'w', encoding='utf-8') as f:
                json.dump(arb_content, f, ensure_ascii=False, indent=2)
            print(f"Updated {arb_file} with placeholder fixes")
        else:
            print(f"No placeholder changes needed for {arb_file}")

if __name__ == "__main__":
    arb_directory = "lib/l10n2"
    fix_all_placeholders(arb_directory)
    print("Done!")
