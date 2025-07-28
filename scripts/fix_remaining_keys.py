#!/usr/bin/env python3
import json
import os
import re
from pathlib import Path

# Additional missing profile screen keys
PROFILE_KEYS = {
    "phoneNumber": "Phone Number",
    "passportNumber": "Passport Number",
    "nationality": "Nationality",
    "dateOfBirth": "Date of Birth",
    "dateFormat": "DD/MM/YYYY",
    "privacySettings": "Privacy Settings",
    "consentToShareData": "I consent to share my data for claim processing",
    "requiredForProcessing": "Required for processing your claim"
}

# Methods with placeholders that need fixing
METHODS_WITH_PLACEHOLDERS = {
    "welcomeUser": {
        "content": "Welcome, {name}",
        "placeholders": {
            "name": {"type": "String"}
        }
    },
    "welcomeUser3": {
        "content": "Welcome, {name} ({role} at {company})",
        "placeholders": {
            "name": {"type": "String"},
            "role": {"type": "String"},
            "company": {"type": "String"}
        }
    },
    "flightRouteDetailsWithNumber": {
        "content": "{departureAirport} → {arrivalAirport} ({flightNumber}) on {date} at {time}",
        "placeholders": {
            "departureAirport": {"type": "String"},
            "arrivalAirport": {"type": "String"},
            "flightNumber": {"type": "String"},
            "date": {"type": "String"},
            "time": {"type": "String"}
        }
    },
    "emailAppOpenedMessage": {
        "content": "Email app opened with {email}",
        "placeholders": {
            "email": {"type": "String"}
        }
    },
    "errorFailedToSubmitClaim": {
        "content": "Failed to submit claim: {error}",
        "placeholders": {
            "error": {"type": "String"}
        }
    },
    "errorFormSubmissionFailed": {
        "content": "Form submission failed: {errorMessage}",
        "placeholders": {
            "errorMessage": {"type": "String"}
        }
    }
}

def fix_arb_file(filepath):
    """Add missing keys to an ARB file and fix method placeholders"""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
            
        # Parse the JSON content
        json_obj = json.loads(content)
        locale = json_obj.get("@@locale", "en")
        
        # Add missing profile screen keys
        for key, default_value in PROFILE_KEYS.items():
            if key not in json_obj:
                json_obj[key] = default_value
                print(f"Added profile key '{key}' to {filepath}")
                
            # Ensure metadata exists
            metadata_key = f"@{key}"
            if metadata_key not in json_obj:
                json_obj[metadata_key] = {"description": f"Auto-generated for {key}"}
                
        # Fix methods with placeholders
        for method_name, method_info in METHODS_WITH_PLACEHOLDERS.items():
            if method_name in json_obj:
                # Check if the method exists but might need placeholder fixes
                meta_key = f"@{method_name}"
                
                if meta_key not in json_obj:
                    # Add missing metadata with placeholders
                    json_obj[meta_key] = {
                        "description": f"Auto-generated for {method_name}",
                        "placeholders": method_info["placeholders"]
                    }
                    print(f"Added metadata for '{method_name}' in {filepath}")
                elif "placeholders" not in json_obj[meta_key]:
                    # Add missing placeholders to existing metadata
                    json_obj[meta_key]["placeholders"] = method_info["placeholders"]
                    print(f"Added placeholders for '{method_name}' in {filepath}")
                else:
                    # Ensure all expected placeholders exist
                    for placeholder, placeholder_info in method_info["placeholders"].items():
                        if placeholder not in json_obj[meta_key]["placeholders"]:
                            json_obj[meta_key]["placeholders"][placeholder] = placeholder_info
                            print(f"Added missing placeholder '{placeholder}' for '{method_name}' in {filepath}")
                        elif json_obj[meta_key]["placeholders"][placeholder].get("type") != placeholder_info.get("type"):
                            # Fix placeholder type if different
                            json_obj[meta_key]["placeholders"][placeholder]["type"] = placeholder_info["type"]
                            print(f"Fixed placeholder type for '{placeholder}' in '{method_name}' in {filepath}")
            else:
                # Add missing method with default content
                json_obj[method_name] = method_info["content"]
                json_obj[f"@{method_name}"] = {
                    "description": f"Auto-generated for {method_name}",
                    "placeholders": method_info["placeholders"]
                }
                print(f"Added missing method '{method_name}' with placeholders to {filepath}")
                
        # Fix errorFormSubmissionFailed to use {errorMessage} instead of errorMessage
        if "errorFormSubmissionFailed" in json_obj:
            text = json_obj["errorFormSubmissionFailed"]
            if "errorMessage" in text and "{errorMessage}" not in text:
                # Replace standalone errorMessage with {errorMessage}
                fixed_text = text.replace("errorMessage", "{errorMessage}")
                json_obj["errorFormSubmissionFailed"] = fixed_text
                print(f"Fixed errorMessage placeholder in errorFormSubmissionFailed in {filepath}")
                
            # Ensure the metadata has the correct placeholder definition
            meta_key = "@errorFormSubmissionFailed"
            if meta_key in json_obj and "placeholders" in json_obj[meta_key]:
                if "errorMessage" not in json_obj[meta_key]["placeholders"]:
                    json_obj[meta_key]["placeholders"]["errorMessage"] = {"type": "String"}
                    print(f"Added errorMessage placeholder definition in {meta_key} in {filepath}")
        
        # Write the updated JSON back to the file
        with open(filepath, 'w', encoding='utf-8') as f:
            json.dump(json_obj, f, ensure_ascii=False, indent=2)
            
        print(f"Successfully updated {filepath}")
        return True
        
    except Exception as e:
        print(f"Error processing {filepath}: {e}")
        return False

def main():
    # Directory containing ARB files
    arb_dir = Path("lib/l10n2")
    
    # Process all ARB files
    arb_files = list(arb_dir.glob("app_*.arb"))
    
    if not arb_files:
        print("No ARB files found!")
        return
        
    print(f"Found {len(arb_files)} ARB files to process")
    
    success_count = 0
    for arb_file in arb_files:
        if fix_arb_file(arb_file):
            success_count += 1
    
    print(f"Successfully processed {success_count} of {len(arb_files)} ARB files")
    
    # Next steps instruction
    print("\nNext steps:")
    print("1. Run 'flutter gen-l10n' to regenerate localization files")
    print("2. Build the app to verify the localization fixes")

if __name__ == "__main__":
    main()
