import json
import os

def clean_arb_file(file_path):
    print(f"Cleaning ARB file: {file_path}")
    
    try:
        # Read the file as text to handle potentially invalid JSON
        with open(file_path, 'r', encoding='utf-8') as file:
            content = file.read()
        
        # Try to parse as JSON, but this may fail if badly corrupted
        try:
            original_data = json.loads(content)
            print(f"Successfully parsed JSON from {file_path}")
        except json.JSONDecodeError:
            print(f"Error: Could not parse {file_path} as valid JSON")
            print("Attempting manual cleanup...")
            
            # Fallback to manual extraction of key-value pairs
            # This is a simplistic approach for demonstration
            cleaned_content = "{\n  \"@@locale\": \"" + file_path.split('_')[-1].split('.')[0] + "\",\n"
            
            # Extract the properly formatted JSON from the beginning until we hit corruption
            open_braces = 0
            for i, char in enumerate(content):
                if char == '{':
                    open_braces += 1
                elif char == '}':
                    open_braces -= 1
                    if open_braces == 0 and i > 100:  # We've reached the end of a valid JSON object
                        cleaned_content = content[:i+1]
                        break
            
            # Try to parse the cleaned content
            try:
                original_data = json.loads(cleaned_content)
                print("Partial JSON extraction successful")
            except:
                print("Failed to extract partial JSON, performing more aggressive cleanup...")
                
                # If all else fails, start fresh with just the locale
                locale_code = file_path.split('_')[-1].split('.')[0]
                original_data = {"@@locale": locale_code}
    
        # Create a clean dictionary with unique entries
        clean_data = {}
        
        # First add the locale
        if "@@locale" in original_data:
            clean_data["@@locale"] = original_data["@@locale"]
        else:
            # Extract locale from filename if not in the data
            locale_code = file_path.split('_')[-1].split('.')[0]
            clean_data["@@locale"] = locale_code
            
        # Process all keys to maintain order but eliminate duplicates
        seen_keys = set(["@@locale"])
        
        for key, value in original_data.items():
            if key not in seen_keys:
                clean_data[key] = value
                seen_keys.add(key)
                
                # Add any metadata keys (@key entries)
                meta_key = f"@{key}"
                if meta_key in original_data and meta_key not in seen_keys:
                    clean_data[meta_key] = original_data[meta_key]
                    seen_keys.add(meta_key)
        
        # Add new keys from eu_eligible_flights_localizations.json if it exists
        localization_file = os.path.join(os.path.dirname(file_path), "..", "..", "eu_eligible_flights_localizations.json")
        if os.path.exists(localization_file):
            try:
                with open(localization_file, 'r', encoding='utf-8') as file:
                    new_keys = json.load(file)
                    
                for key, value in new_keys.items():
                    if key not in seen_keys:
                        # For non-English files, keep the key but not the English value
                        if not file_path.endswith("app_en.arb") and not key.startswith("@"):
                            # Keep the key with TODO placeholder
                            clean_data[key] = f"TODO: Translate '{value}'"
                        else:
                            # For English or metadata, copy as is
                            clean_data[key] = value
                        seen_keys.add(key)
                
                print(f"Added new localization keys from {localization_file}")
            except Exception as e:
                print(f"Error adding new keys: {str(e)}")
        
        # Add email confirmation keys from email_confirmation_localizations.json if it exists
        email_localization_file = os.path.join(os.path.dirname(file_path), "..", "..", "email_confirmation_localizations.json")
        if os.path.exists(email_localization_file):
            try:
                with open(email_localization_file, 'r', encoding='utf-8') as file:
                    email_keys = json.load(file)
                    
                for key, value in email_keys.items():
                    if key not in seen_keys:
                        # For non-English files, keep the key but not the English value
                        if not file_path.endswith("app_en.arb") and not key.startswith("@"):
                            # Keep the key with TODO placeholder
                            clean_data[key] = f"TODO: Translate '{value}'"
                        else:
                            # For English or metadata, copy as is
                            clean_data[key] = value
                        seen_keys.add(key)
                
                print(f"Added email confirmation localization keys from {email_localization_file}")
            except Exception as e:
                print(f"Error adding email confirmation keys: {str(e)}")
        
        # Add claim review keys from claim_review_localizations.json if it exists
        claim_review_file = os.path.join(os.path.dirname(file_path), "..", "..", "claim_review_localizations.json")
        if os.path.exists(claim_review_file):
            try:
                with open(claim_review_file, 'r', encoding='utf-8') as file:
                    claim_keys = json.load(file)
                    
                for key, value in claim_keys.items():
                    if key not in seen_keys:
                        # For non-English files, keep the key but not the English value
                        if not file_path.endswith("app_en.arb") and not key.startswith("@"):
                            # Keep the key with TODO placeholder
                            clean_data[key] = f"TODO: Translate '{value}'"
                        else:
                            # For English or metadata, copy as is
                            clean_data[key] = value
                        seen_keys.add(key)
                
                print(f"Added claim review localization keys from {claim_review_file}")
            except Exception as e:
                print(f"Error adding claim review keys: {str(e)}")
        
        # Add claim detail keys from claim_detail_localizations.json if it exists
        claim_detail_file = os.path.join(os.path.dirname(file_path), "..", "..", "claim_detail_localizations.json")
        if os.path.exists(claim_detail_file):
            try:
                with open(claim_detail_file, 'r', encoding='utf-8') as file:
                    detail_keys = json.load(file)
                    
                for key, value in detail_keys.items():
                    if key not in seen_keys:
                        # For non-English files, keep the key but not the English value
                        if not file_path.endswith("app_en.arb") and not key.startswith("@"):
                            # Keep the key with TODO placeholder
                            clean_data[key] = f"TODO: Translate '{value}'"
                        else:
                            # For English or metadata, copy as is
                            clean_data[key] = value
                        seen_keys.add(key)
                
                print(f"Added claim detail localization keys from {claim_detail_file}")
            except Exception as e:
                print(f"Error adding claim detail keys: {str(e)}")
                
        # Add final localization keys from final_localizations.json if it exists
        final_localization_file = os.path.join(os.path.dirname(file_path), "..", "..", "final_localizations.json")
        if os.path.exists(final_localization_file):
            try:
                with open(final_localization_file, 'r', encoding='utf-8') as file:
                    final_keys = json.load(file)
                    
                for key, value in final_keys.items():
                    if key not in seen_keys:
                        # For non-English files, keep the key but not the English value
                        if not file_path.endswith("app_en.arb") and not key.startswith("@"):
                            # Keep the key with TODO placeholder
                            if key == "noFlightsMatchingFilter":
                                # Special handling for placeholder in non-English files
                                clean_data[key] = f"TODO: Translate 'No flights matching filter: {{filter}}'"
                            else:
                                clean_data[key] = f"TODO: Translate '{value}'"
                        else:
                            # For English or metadata, copy as is
                            clean_data[key] = value
                        seen_keys.add(key)
                
                print(f"Added final localization keys from {final_localization_file}")
            except Exception as e:
                print(f"Error adding final localization keys: {str(e)}")
        
        # Add EU eligible flights header keys from eu_eligible_flights_header_localizations.json if it exists
        eu_header_file = os.path.join(os.path.dirname(file_path), "..", "..", "eu_eligible_flights_header_localizations.json")
        if os.path.exists(eu_header_file):
            try:
                with open(eu_header_file, 'r', encoding='utf-8') as file:
                    eu_header_keys = json.load(file)
                    
                for key, value in eu_header_keys.items():
                    if key not in seen_keys:
                        # For non-English files, keep the key but not the English value
                        if not file_path.endswith("app_en.arb") and not key.startswith("@"):
                            # Keep the key with TODO placeholder
                            if key == "lastHours":
                                # Special handling for placeholder in non-English files
                                clean_data[key] = f"TODO: Translate 'Last {{hours}} Hours'"
                            else:
                                clean_data[key] = f"TODO: Translate '{value}'"
                        else:
                            # For English or metadata, copy as is
                            clean_data[key] = value
                        seen_keys.add(key)
                
                print(f"Added EU eligible flights header localization keys from {eu_header_file}")
            except Exception as e:
                print(f"Error adding EU eligible flights header keys: {str(e)}")
                
        # Add error message keys from error_localizations.json if it exists
        error_file = os.path.join(os.path.dirname(file_path), "..", "..", "error_localizations.json")
        if os.path.exists(error_file):
            try:
                with open(error_file, 'r', encoding='utf-8') as file:
                    error_keys = json.load(file)
                    
                for key, value in error_keys.items():
                    if key not in seen_keys:
                        # For non-English files, keep the key but not the English value
                        if not file_path.endswith("app_en.arb") and not key.startswith("@"):
                            # Keep the key with TODO placeholder
                            if key == "formSubmissionError":
                                # Special handling for placeholder in non-English files
                                clean_data[key] = f"TODO: Translate 'Form submission error: {{error}}'"
                            elif key == "noEligibleFlightsDescription":
                                # Special handling for placeholder in non-English files
                                clean_data[key] = f"TODO: Translate 'No flights eligible for EU compensation were found in the last {{hours}} hours. Check again later.'"
                            else:
                                clean_data[key] = f"TODO: Translate '{value}'"
                        else:
                            # For English or metadata, copy as is
                            clean_data[key] = value
                        seen_keys.add(key)
                
                print(f"Added error message localization keys from {error_file}")
            except Exception as e:
                print(f"Error adding error message keys: {str(e)}")
                
        # Add debug screen keys from debug_screen_localizations.json if it exists
        debug_screen_file = os.path.join(os.path.dirname(file_path), "..", "..", "debug_screen_localizations.json")
        if os.path.exists(debug_screen_file):
            try:
                with open(debug_screen_file, 'r', encoding='utf-8') as file:
                    debug_screen_keys = json.load(file)
                    
                for key, value in debug_screen_keys.items():
                    if key not in seen_keys:
                        # For non-English files, keep the key but not the English value
                        if not file_path.endswith("app_en.arb") and not key.startswith("@"):
                            # Keep the key with TODO placeholder
                            clean_data[key] = f"TODO: Translate '{value}'"
                        else:
                            # For English or metadata, copy as is
                            clean_data[key] = value
                        seen_keys.add(key)
                
                print(f"Added debug screen localization keys from {debug_screen_file}")
            except Exception as e:
                print(f"Error adding debug screen keys: {str(e)}")
                
        # Add document processing keys from document_processing_localizations.json if it exists
        document_processing_file = os.path.join(os.path.dirname(file_path), "..", "..", "document_processing_localizations.json")
        if os.path.exists(document_processing_file):
            try:
                with open(document_processing_file, 'r', encoding='utf-8') as file:
                    document_processing_keys = json.load(file)
                    
                for key, value in document_processing_keys.items():
                    if key not in seen_keys:
                        # For non-English files, keep the key but not the English value
                        if not file_path.endswith("app_en.arb") and not key.startswith("@"):
                            # Keep the key with TODO placeholder
                            clean_data[key] = f"TODO: Translate '{value}'"
                        else:
                            # For English or metadata, copy as is
                            clean_data[key] = value
                        seen_keys.add(key)
                
                print(f"Added document processing localization keys from {document_processing_file}")
            except Exception as e:
                print(f"Error adding document processing keys: {str(e)}")
                
        # Add claim form keys from claim_form_localizations.json if it exists
        claim_form_file = os.path.join(os.path.dirname(file_path), "..", "..", "claim_form_localizations.json")
        if os.path.exists(claim_form_file):
            try:
                with open(claim_form_file, 'r', encoding='utf-8') as file:
                    claim_form_keys = json.load(file)
                    
                for key, value in claim_form_keys.items():
                    if key not in seen_keys:
                        # For non-English files, keep the key but not the English value
                        if not file_path.endswith("app_en.arb") and not key.startswith("@"):
                            # Keep the key with TODO placeholder
                            clean_data[key] = f"TODO: Translate '{value}'"
                        else:
                            # For English or metadata, copy as is
                            clean_data[key] = value
                        seen_keys.add(key)
                
                print(f"Added claim form localization keys from {claim_form_file}")
            except Exception as e:
                print(f"Error adding claim form keys: {str(e)}")
                
        # Add form field keys from form_field_localizations.json if it exists
        form_field_file = os.path.join(os.path.dirname(file_path), "..", "..", "form_field_localizations.json")
        if os.path.exists(form_field_file):
            try:
                with open(form_field_file, 'r', encoding='utf-8') as file:
                    form_field_keys = json.load(file)
                    
                for key, value in form_field_keys.items():
                    if key not in seen_keys:
                        # For non-English files, keep the key but not the English value
                        if not file_path.endswith("app_en.arb") and not key.startswith("@"):
                            # Keep the key with TODO placeholder
                            clean_data[key] = f"TODO: Translate '{value}'"
                        else:
                            # For English or metadata, copy as is
                            clean_data[key] = value
                        seen_keys.add(key)
                
                print(f"Added form field localization keys from {form_field_file}")
            except Exception as e:
                print(f"Error adding form field keys: {str(e)}")
                
        # Add common UI keys from common_ui_localizations.json if it exists
        common_ui_file = os.path.join(os.path.dirname(file_path), "..", "..", "common_ui_localizations.json")
        if os.path.exists(common_ui_file):
            try:
                with open(common_ui_file, 'r', encoding='utf-8') as file:
                    common_ui_keys = json.load(file)
                    
                for key, value in common_ui_keys.items():
                    if key not in seen_keys:
                        # For non-English files, keep the key but not the English value
                        if not file_path.endswith("app_en.arb") and not key.startswith("@"):
                            # Keep the key with TODO placeholder
                            clean_data[key] = f"TODO: Translate '{value}'"
                        else:
                            # For English or metadata, copy as is
                            clean_data[key] = value
                        seen_keys.add(key)
                
                print(f"Added common UI localization keys from {common_ui_file}")
            except Exception as e:
                print(f"Error adding common UI keys: {str(e)}")
                
        # Add app navigation keys from app_navigation_localizations.json if it exists
        app_navigation_file = os.path.join(os.path.dirname(file_path), "..", "..", "app_navigation_localizations.json")
        if os.path.exists(app_navigation_file):
            try:
                with open(app_navigation_file, 'r', encoding='utf-8') as file:
                    app_navigation_keys = json.load(file)
                    
                for key, value in app_navigation_keys.items():
                    if key not in seen_keys:
                        # For non-English files, keep the key but not the English value
                        if not file_path.endswith("app_en.arb") and not key.startswith("@"):
                            # Keep the key with TODO placeholder
                            clean_data[key] = f"TODO: Translate '{value}'"
                        else:
                            # For English or metadata, copy as is
                            clean_data[key] = value
                        seen_keys.add(key)
                
                print(f"Added app navigation localization keys from {app_navigation_file}")
            except Exception as e:
                print(f"Error adding app navigation keys: {str(e)}")
                
        # Add final document keys from final_document_localizations.json if it exists
        final_document_file = os.path.join(os.path.dirname(file_path), "..", "..", "final_document_localizations.json")
        if os.path.exists(final_document_file):
            try:
                with open(final_document_file, 'r', encoding='utf-8') as file:
                    final_document_keys = json.load(file)
                    
                for key, value in final_document_keys.items():
                    if key not in seen_keys:
                        # For non-English files, keep the key but not the English value
                        if not file_path.endswith("app_en.arb") and not key.startswith("@"):
                            # Keep the key with TODO placeholder
                            clean_data[key] = f"TODO: Translate '{value}'"
                        else:
                            # For English or metadata, copy as is
                            clean_data[key] = value
                        seen_keys.add(key)
                
                print(f"Added final document localization keys from {final_document_file}")
            except Exception as e:
                print(f"Error adding final document keys: {str(e)}")
        
        # Add document management keys from document_management_localizations.json if it exists
        document_management_file = os.path.join(os.path.dirname(file_path), "..", "..", "document_management_localizations.json")
        if os.path.exists(document_management_file):
            try:
                with open(document_management_file, 'r', encoding='utf-8') as file:
                    document_management_keys = json.load(file)
                    
                for key, value in document_management_keys.items():
                    if key not in seen_keys:
                        # For non-English files, keep the key but not the English value
                        if not file_path.endswith("app_en.arb") and not key.startswith("@"):
                            # Keep the key with TODO placeholder
                            clean_data[key] = f"TODO: Translate '{value}'"
                        else:
                            # For English or metadata, copy as is
                            clean_data[key] = value
                        seen_keys.add(key)
                
                print(f"Added document management localization keys from {document_management_file}")
            except Exception as e:
                print(f"Error adding document management keys: {str(e)}")
                
        # Add attachment keys from attachment_localizations.json if it exists
        attachment_file = os.path.join(os.path.dirname(file_path), "..", "..", "attachment_localizations.json")
        if os.path.exists(attachment_file):
            try:
                with open(attachment_file, 'r', encoding='utf-8') as file:
                    attachment_keys = json.load(file)
                    
                for key, value in attachment_keys.items():
                    if key not in seen_keys:
                        # For non-English files, keep the key but not the English value
                        if not file_path.endswith("app_en.arb") and not key.startswith("@"):
                            # Keep the key with TODO placeholder
                            clean_data[key] = f"TODO: Translate '{value}'"
                        else:
                            # For English or metadata, copy as is
                            clean_data[key] = value
                        seen_keys.add(key)
                
                print(f"Added attachment localization keys from {attachment_file}")
            except Exception as e:
                print(f"Error adding attachment keys: {str(e)}")
                
        # Add tips keys from tips_localizations.json if it exists
        tips_file = os.path.join(os.path.dirname(file_path), "..", "..", "tips_localizations.json")
        if os.path.exists(tips_file):
            try:
                with open(tips_file, 'r', encoding='utf-8') as file:
                    tips_keys = json.load(file)
                    
                for key, value in tips_keys.items():
                    if key not in seen_keys:
                        # For non-English files, keep the key but not the English value
                        if not file_path.endswith("app_en.arb") and not key.startswith("@"):
                            # Keep the key with TODO placeholder
                            clean_data[key] = f"TODO: Translate '{value}'"
                        else:
                            # For English or metadata, copy as is
                            clean_data[key] = value
                        seen_keys.add(key)
                
                print(f"Added tips localization keys from {tips_file}")
            except Exception as e:
                print(f"Error adding tips keys: {str(e)}")
                
        # Add document status keys from document_status_localizations.json if it exists
        document_status_file = os.path.join(os.path.dirname(file_path), "..", "..", "document_status_localizations.json")
        if os.path.exists(document_status_file):
            try:
                with open(document_status_file, 'r', encoding='utf-8') as file:
                    document_status_keys = json.load(file)
                    
                for key, value in document_status_keys.items():
                    if key not in seen_keys:
                        # For non-English files, keep the key but not the English value
                        if not file_path.endswith("app_en.arb") and not key.startswith("@"):
                            # Keep the key with TODO placeholder
                            clean_data[key] = f"TODO: Translate '{value}'"
                        else:
                            # For English or metadata, copy as is
                            clean_data[key] = value
                        seen_keys.add(key)
                
                print(f"Added document status localization keys from {document_status_file}")
            except Exception as e:
                print(f"Error adding document status keys: {str(e)}")
                
        # Add quick claim form keys from quick_claim_form_localizations.json if it exists
        quick_claim_form_file = os.path.join(os.path.dirname(file_path), "..", "..", "quick_claim_form_localizations.json")
        if os.path.exists(quick_claim_form_file):
            try:
                with open(quick_claim_form_file, 'r', encoding='utf-8') as file:
                    quick_claim_form_keys = json.load(file)
                    
                for key, value in quick_claim_form_keys.items():
                    if key not in seen_keys:
                        # For non-English files, keep the key but not the English value
                        if not file_path.endswith("app_en.arb") and not key.startswith("@"):
                            # Keep the key with TODO placeholder
                            clean_data[key] = f"TODO: Translate '{value}'"
                        else:
                            # For English or metadata, copy as is
                            clean_data[key] = value
                        seen_keys.add(key)
                
                print(f"Added quick claim form localization keys from {quick_claim_form_file}")
            except Exception as e:
                print(f"Error adding quick claim form keys: {str(e)}")
                
        # Add airport fields keys from airport_fields_localizations.json if it exists
        airport_fields_file = os.path.join(os.path.dirname(file_path), "..", "..", "airport_fields_localizations.json")
        if os.path.exists(airport_fields_file):
            try:
                with open(airport_fields_file, 'r', encoding='utf-8') as file:
                    airport_fields_keys = json.load(file)
                    
                for key, value in airport_fields_keys.items():
                    if key not in seen_keys:
                        # For non-English files, keep the key but not the English value
                        if not file_path.endswith("app_en.arb") and not key.startswith("@"):
                            # Keep the key with TODO placeholder
                            clean_data[key] = f"TODO: Translate '{value}'"
                        else:
                            # For English or metadata, copy as is
                            clean_data[key] = value
                        seen_keys.add(key)
                
                print(f"Added airport fields localization keys from {airport_fields_file}")
            except Exception as e:
                print(f"Error adding airport fields keys: {str(e)}")
                
        # Add flight fields keys from flight_fields_localizations.json if it exists
        flight_fields_file = os.path.join(os.path.dirname(file_path), "..", "..", "flight_fields_localizations.json")
        if os.path.exists(flight_fields_file):
            try:
                with open(flight_fields_file, 'r', encoding='utf-8') as file:
                    flight_fields_keys = json.load(file)
                    
                for key, value in flight_fields_keys.items():
                    if key not in seen_keys:
                        # For non-English files, keep the key but not the English value
                        if not file_path.endswith("app_en.arb") and not key.startswith("@"):
                            # Keep the key with TODO placeholder
                            clean_data[key] = f"TODO: Translate '{value}'"
                        else:
                            # For English or metadata, copy as is
                            clean_data[key] = value
                        seen_keys.add(key)
                
                print(f"Added flight fields localization keys from {flight_fields_file}")
            except Exception as e:
                print(f"Error adding flight fields keys: {str(e)}")
                
        # Add claim status keys from claim_status_localizations.json if it exists
        claim_status_file = os.path.join(os.path.dirname(file_path), "..", "..", "claim_status_localizations.json")
        if os.path.exists(claim_status_file):
            try:
                with open(claim_status_file, 'r', encoding='utf-8') as file:
                    claim_status_keys = json.load(file)
                    
                for key, value in claim_status_keys.items():
                    if key not in seen_keys:
                        # For non-English files, keep the key but not the English value
                        if not file_path.endswith("app_en.arb") and not key.startswith("@"):
                            # Keep the key with TODO placeholder
                            clean_data[key] = f"TODO: Translate '{value}'"
                        else:
                            # For English or metadata, copy as is
                            clean_data[key] = value
                        seen_keys.add(key)
                
                print(f"Added claim status localization keys from {claim_status_file}")
            except Exception as e:
                print(f"Error adding claim status keys: {str(e)}")
                
        # Add claim dashboard keys from claim_dashboard_localizations.json if it exists
        claim_dashboard_file = os.path.join(os.path.dirname(file_path), "..", "..", "claim_dashboard_localizations.json")
        if os.path.exists(claim_dashboard_file):
            try:
                with open(claim_dashboard_file, 'r', encoding='utf-8') as file:
                    claim_dashboard_keys = json.load(file)
                    
                for key, value in claim_dashboard_keys.items():
                    if key not in seen_keys:
                        # For non-English files, keep the key but not the English value
                        if not file_path.endswith("app_en.arb") and not key.startswith("@"):
                            # Keep the key with TODO placeholder
                            clean_data[key] = f"TODO: Translate '{value}'"
                        else:
                            # For English or metadata, copy as is
                            clean_data[key] = value
                        seen_keys.add(key)
                
                print(f"Added claim dashboard localization keys from {claim_dashboard_file}")
            except Exception as e:
                print(f"Error adding claim dashboard keys: {str(e)}")
                
        # Add claim dashboard details keys from claim_dashboard_details_localizations.json if it exists
        claim_dashboard_details_file = os.path.join(os.path.dirname(file_path), "..", "..", "claim_dashboard_details_localizations.json")
        if os.path.exists(claim_dashboard_details_file):
            try:
                with open(claim_dashboard_details_file, 'r', encoding='utf-8') as file:
                    claim_dashboard_details_keys = json.load(file)
                    
                for key, value in claim_dashboard_details_keys.items():
                    if key not in seen_keys:
                        # For non-English files, keep the key but not the English value
                        if not file_path.endswith("app_en.arb") and not key.startswith("@"):
                            # Keep the key with TODO placeholder
                            clean_data[key] = f"TODO: Translate '{value}'"
                        else:
                            # For English or metadata, copy as is
                            clean_data[key] = value
                        seen_keys.add(key)
                
                print(f"Added claim dashboard details localization keys from {claim_dashboard_details_file}")
            except Exception as e:
                print(f"Error adding claim dashboard details keys: {str(e)}")
        
        # Write the clean data back to a file
        output_path = file_path
        with open(output_path, 'w', encoding='utf-8') as file:
            json.dump(clean_data, file, indent=2, ensure_ascii=False)
        
        print(f"Cleaned file written to {output_path}")
        return True
    
    except Exception as e:
        print(f"Error cleaning {file_path}: {str(e)}")
        return False

def main():
    arb_dir = "lib/l10n2"
    
    # Process all ARB files
    for filename in os.listdir(arb_dir):
        if filename.endswith(".arb") and not os.path.isdir(os.path.join(arb_dir, filename)):
            clean_arb_file(os.path.join(arb_dir, filename))

if __name__ == "__main__":
    main()
