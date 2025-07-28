import json
import os
import re

def fix_all_placeholder_metadata(arb_directory):
    # Get all ARB files
    arb_files = [f for f in os.listdir(arb_directory) if f.endswith('.arb')]
    
    # Get the English ARB file as a reference
    english_file_path = os.path.join(arb_directory, "app_en.arb")
    with open(english_file_path, 'r', encoding='utf-8') as f:
        english_arb = json.load(f)
    
    # Add missing placeholder metadata to English ARB first
    english_changes = False
    
    # Add errorFormSubmissionFailed metadata if missing
    if "errorFormSubmissionFailed" in english_arb and "@errorFormSubmissionFailed" not in english_arb:
        english_arb["@errorFormSubmissionFailed"] = {
            "placeholders": {
                "errorMessage": {
                    "type": "String"
                }
            }
        }
        english_changes = True
        print("Added @errorFormSubmissionFailed metadata to English ARB")
    
    # Add welcomeUser metadata if missing
    if "welcomeUser" in english_arb and "@welcomeUser" not in english_arb:
        english_arb["@welcomeUser"] = {
            "placeholders": {
                "name": {
                    "type": "String"
                }
            }
        }
        english_changes = True
        print("Added @welcomeUser metadata to English ARB")
    
    # Save changes to English ARB if needed
    if english_changes:
        with open(english_file_path, 'w', encoding='utf-8') as f:
            json.dump(english_arb, f, ensure_ascii=False, indent=2)
        print("Updated English ARB file with new metadata")
    
    # Process all ARB files
    for arb_file in arb_files:
        arb_file_path = os.path.join(arb_directory, arb_file)
        
        # Load ARB file content
        with open(arb_file_path, 'r', encoding='utf-8') as f:
            arb_content = json.load(f)
        
        # Track if any changes were made
        changes_made = False
        
        # Fix errorFormSubmissionFailed metadata
        if "errorFormSubmissionFailed" in arb_content:
            error_meta_key = "@errorFormSubmissionFailed"
            
            # Add metadata if missing
            if error_meta_key not in arb_content and error_meta_key in english_arb:
                arb_content[error_meta_key] = english_arb[error_meta_key]
                changes_made = True
                print(f"Added {error_meta_key} metadata to {arb_file}")
            
            # Fix string to use correct placeholder syntax
            error_text = arb_content["errorFormSubmissionFailed"]
            if "$errorMessage" not in error_text:
                # Use the English pattern but keep the translated text
                english_pattern = english_arb["errorFormSubmissionFailed"]
                error_parts = english_pattern.split("{errorMessage}")
                
                if len(error_parts) == 2:
                    # Get the translated parts (before and after where placeholder should be)
                    translated_parts = error_text.split("errorMessage")
                    if len(translated_parts) >= 2:
                        new_text = f"{translated_parts[0]}$errorMessage{translated_parts[1]}"
                        arb_content["errorFormSubmissionFailed"] = new_text
                        changes_made = True
                        print(f"Fixed errorFormSubmissionFailed text in {arb_file} to use $errorMessage placeholder")
        
        # Fix welcomeUser metadata
        if "welcomeUser" in arb_content:
            welcome_meta_key = "@welcomeUser"
            
            # Add metadata if missing
            if welcome_meta_key not in arb_content and welcome_meta_key in english_arb:
                arb_content[welcome_meta_key] = english_arb[welcome_meta_key]
                changes_made = True
                print(f"Added {welcome_meta_key} metadata to {arb_file}")
            
            # Fix placeholder in metadata if it uses wrong name
            if welcome_meta_key in arb_content and "placeholders" in arb_content[welcome_meta_key]:
                if "userName" in arb_content[welcome_meta_key]["placeholders"] and "name" not in arb_content[welcome_meta_key]["placeholders"]:
                    # Copy userName definition to name
                    user_name_def = arb_content[welcome_meta_key]["placeholders"].pop("userName")
                    arb_content[welcome_meta_key]["placeholders"]["name"] = user_name_def
                    changes_made = True
                    print(f"Fixed {welcome_meta_key} metadata in {arb_file} to use 'name' placeholder")
            
            # Fix placeholder in text
            welcome_text = arb_content["welcomeUser"]
            if "$userName" in welcome_text and "$name" not in welcome_text:
                arb_content["welcomeUser"] = welcome_text.replace("$userName", "$name")
                changes_made = True
                print(f"Fixed welcomeUser text in {arb_file} to use $name placeholder")
        
        # Fix flightRouteDetailsWithNumber metadata and placeholder
        flight_key = "flightRouteDetailsWithNumber"
        if flight_key in arb_content:
            flight_meta_key = f"@{flight_key}"
            
            # Fix text to use correct placeholder
            flight_text = arb_content[flight_key]
            if "$number" in flight_text and "$flightNumber" not in flight_text:
                arb_content[flight_key] = flight_text.replace("$number", "$flightNumber")
                changes_made = True
                print(f"Fixed {flight_key} text in {arb_file} to use $flightNumber placeholder")
            
            # Fix metadata to use correct placeholder name
            if flight_meta_key in arb_content and "placeholders" in arb_content[flight_meta_key]:
                if "number" in arb_content[flight_meta_key]["placeholders"] and "flightNumber" not in arb_content[flight_meta_key]["placeholders"]:
                    # Copy number definition to flightNumber
                    number_def = arb_content[flight_meta_key]["placeholders"].pop("number")
                    arb_content[flight_meta_key]["placeholders"]["flightNumber"] = number_def
                    changes_made = True
                    print(f"Fixed {flight_meta_key} metadata in {arb_file} to use 'flightNumber' placeholder")
        
        # Save changes if any were made
        if changes_made:
            with open(arb_file_path, 'w', encoding='utf-8') as f:
                json.dump(arb_content, f, ensure_ascii=False, indent=2)
            print(f"Updated {arb_file} with placeholder metadata fixes")
        else:
            print(f"No placeholder metadata changes needed for {arb_file}")

if __name__ == "__main__":
    arb_directory = "lib/l10n2"
    fix_all_placeholder_metadata(arb_directory)
    print("Done!")
