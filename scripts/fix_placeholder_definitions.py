import json
import os
import re

def fix_placeholder_definitions(arb_directory):
    # Get all ARB files
    arb_files = [f for f in os.listdir(arb_directory) if f.endswith('.arb')]
    
    # Get the English ARB file as a reference
    english_file_path = os.path.join(arb_directory, "app_en.arb")
    with open(english_file_path, 'r', encoding='utf-8') as f:
        english_arb = json.load(f)
    
    # Process all non-English ARB files
    for arb_file in arb_files:
        if arb_file == "app_en.arb":  # Skip English file
            continue
            
        arb_file_path = os.path.join(arb_directory, arb_file)
        
        # Load ARB file content
        with open(arb_file_path, 'r', encoding='utf-8') as f:
            arb_content = json.load(f)
        
        # Track if any changes were made
        changes_made = False
        
        # Fix welcomeUser placeholder definition
        welcome_key = "welcomeUser"
        if welcome_key in arb_content:
            # Check for placeholder in text
            if "$userName" in arb_content[welcome_key]:
                arb_content[welcome_key] = arb_content[welcome_key].replace("$userName", "$name")
                changes_made = True
                print(f"Fixed {welcome_key} text in {arb_file}: replaced $userName with $name")
            
            # Check for placeholder metadata
            meta_key = f"@{welcome_key}"
            if meta_key in arb_content:
                if "placeholders" in arb_content[meta_key] and "userName" in arb_content[meta_key]["placeholders"]:
                    # Copy the userName placeholder definition to name
                    user_name_def = arb_content[meta_key]["placeholders"].pop("userName")
                    arb_content[meta_key]["placeholders"]["name"] = user_name_def
                    changes_made = True
                    print(f"Fixed {meta_key} metadata in {arb_file}: replaced userName with name")
            else:
                # Add metadata if missing, copying from English
                if meta_key in english_arb:
                    arb_content[meta_key] = english_arb[meta_key]
                    changes_made = True
                    print(f"Added {meta_key} metadata from English template to {arb_file}")
        
        # Fix errorFormSubmissionFailed placeholder definition
        error_key = "errorFormSubmissionFailed"
        if error_key in arb_content:
            # Check for placeholder metadata
            meta_key = f"@{error_key}"
            if meta_key not in arb_content:
                # Add metadata if missing, copying from English
                if meta_key in english_arb:
                    arb_content[meta_key] = english_arb[meta_key]
                    changes_made = True
                    print(f"Added {meta_key} metadata from English template to {arb_file}")
            elif "placeholders" in arb_content[meta_key] and "errorMessage" not in arb_content[meta_key]["placeholders"]:
                # Add errorMessage placeholder definition from English
                if meta_key in english_arb and "placeholders" in english_arb[meta_key] and "errorMessage" in english_arb[meta_key]["placeholders"]:
                    arb_content[meta_key]["placeholders"]["errorMessage"] = english_arb[meta_key]["placeholders"]["errorMessage"]
                    changes_made = True
                    print(f"Added errorMessage placeholder definition to {meta_key} in {arb_file}")

        # Fix flightRouteDetailsWithNumber placeholder definition
        flight_key = "flightRouteDetailsWithNumber"
        if flight_key in arb_content:
            # Check for placeholder in text
            if "$number" in arb_content[flight_key]:
                arb_content[flight_key] = arb_content[flight_key].replace("$number", "$flightNumber")
                changes_made = True
                print(f"Fixed {flight_key} text in {arb_file}: replaced $number with $flightNumber")
            
            # Check for placeholder metadata
            meta_key = f"@{flight_key}"
            if meta_key in arb_content:
                if "placeholders" in arb_content[meta_key] and "number" in arb_content[meta_key]["placeholders"]:
                    # Copy the number placeholder definition to flightNumber
                    number_def = arb_content[meta_key]["placeholders"].pop("number")
                    arb_content[meta_key]["placeholders"]["flightNumber"] = number_def
                    changes_made = True
                    print(f"Fixed {meta_key} metadata in {arb_file}: replaced number with flightNumber")
            else:
                # Add metadata if missing, copying from English
                if meta_key in english_arb:
                    arb_content[meta_key] = english_arb[meta_key]
                    changes_made = True
                    print(f"Added {meta_key} metadata from English template to {arb_file}")
        
        if changes_made:
            # Write updated content back to ARB file
            with open(arb_file_path, 'w', encoding='utf-8') as f:
                json.dump(arb_content, f, ensure_ascii=False, indent=2)
            print(f"Updated {arb_file} with placeholder definition fixes")
        else:
            print(f"No placeholder definition changes needed for {arb_file}")

if __name__ == "__main__":
    arb_directory = "lib/l10n2"
    fix_placeholder_definitions(arb_directory)
    print("Done!")
