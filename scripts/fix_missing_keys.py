#!/usr/bin/env python3
import json
import os
import re
from pathlib import Path

# Missing keys from build errors
MISSING_KEYS = {
    # Profile screen keys
    "receiveNotifications": "Receive Notifications",
    "getClaimUpdates": "Get Claim Updates", 
    "saveProfile": "Save Profile",
    "profileInformation": "Profile Information",
    "firstName": "First Name",
    "lastName": "Last Name",
    "name": "Name",
    "email": "Email",
    "phone": "Phone",
    "address": "Address",
    "city": "City",
    "country": "Country",
    "postalCode": "Postal Code",
    
    # Claim submission screen keys
    "pleaseSelectFlightDate": "Please select a flight date",
    "submitNewClaim": "Submit New Claim",
    "pleaseEnterArrivalAirport": "Please enter arrival airport",
    "pleaseEnterReason": "Please enter reason for claim",
    "flightDateHint": "Select flight date",
    "departureAirport": "Departure Airport",
    "arrivalAirport": "Arrival Airport",
    "flightNumber": "Flight Number", 
    "flightDate": "Flight Date",
    "reasonForClaim": "Reason for Claim",
    "attachments": "Attachments",
    "proceedToConfirmation": "Proceed to Confirmation",
    "submitClaim": "Submit Claim",
    
    # Error messages
    "unknownError": "Unknown Error",
    "retry": "Retry",
    "claimNotFound": "Claim Not Found",
    "claimNotFoundDesc": "The claim you are looking for could not be found",
    "backToDashboard": "Back to Dashboard",
    "reviewYourClaim": "Review Your Claim",
    "reviewClaimDetails": "Review Claim Details",
    
    # Dashboard keys
    "eu261Rights": "EU 261 Rights",
    "dontLetAirlinesWin": "Don't let airlines win",
    "submitClaimAnyway": "Submit claim anyway",
    "number": "Number"
}

# Missing methods with placeholders
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
    },
    "emailAppOpenedMessage": {
        "content": "Email app opened with {email}",
        "placeholders": {
            "email": {"type": "String"}
        }
    }
}

def normalize_metadata(key, json_obj):
    """Ensure the metadata for a key exists in standard format"""
    metadata_key = f"@{key}"
    if metadata_key not in json_obj:
        json_obj[metadata_key] = {"description": f"Auto-generated for {key}"}
    return json_obj

def fix_arb_file(filepath):
    """Add missing keys to an ARB file and fix metadata"""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
            
        # Parse the JSON content
        json_obj = json.loads(content)
        locale = json_obj.get("@@locale", "en")
        
        # Add missing simple keys
        for key, default_value in MISSING_KEYS.items():
            if key not in json_obj:
                json_obj[key] = default_value
                print(f"Added key '{key}' to {filepath}")
                
            # Ensure metadata exists
            json_obj = normalize_metadata(key, json_obj)
                
        # Add or fix methods with placeholders
        for method_name, method_info in METHODS_WITH_PLACEHOLDERS.items():
            if method_name not in json_obj:
                # Add the method with default content
                json_obj[method_name] = method_info["content"]
                print(f"Added method '{method_name}' to {filepath}")
                
                # Add metadata with placeholders
                metadata_key = f"@{method_name}"
                if metadata_key not in json_obj:
                    json_obj[metadata_key] = {
                        "description": f"Auto-generated for {method_name}",
                        "placeholders": method_info["placeholders"]
                    }
            else:
                # Ensure metadata has correct placeholders
                metadata_key = f"@{method_name}"
                if metadata_key in json_obj:
                    if "placeholders" not in json_obj[metadata_key]:
                        json_obj[metadata_key]["placeholders"] = method_info["placeholders"]
                        print(f"Fixed placeholders for '{method_name}' in {filepath}")
                else:
                    # Create metadata if missing
                    json_obj[metadata_key] = {
                        "description": f"Auto-generated for {method_name}",
                        "placeholders": method_info["placeholders"]
                    }
                    print(f"Added metadata for '{method_name}' in {filepath}")
        
        # Fix errorMessage placeholder reference in errorFormSubmissionFailed
        if "errorFormSubmissionFailed" in json_obj:
            # Check if it contains errorMessage variable
            error_text = json_obj["errorFormSubmissionFailed"]
            if "{errorMessage}" not in error_text and "errorMessage" in error_text:
                # If errorMessage exists as a variable name but not a placeholder
                corrected_text = re.sub(r'errorMessage', '{errorMessage}', error_text)
                json_obj["errorFormSubmissionFailed"] = corrected_text
                print(f"Fixed errorMessage placeholder in errorFormSubmissionFailed in {filepath}")
        
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
