import json
import os

def fix_error_placeholders(arb_directory):
    # Get all ARB files
    arb_files = [f for f in os.listdir(arb_directory) if f.endswith('.arb')]
    
    # English template for errorFormSubmissionFailed
    english_template = "Error submitting form: {errorMessage}. Please check your connection and try again."
    
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
            
            # Check if it has been incorrectly modified with "$errorMessage {errorMessage}"
            if "$errorMessage {errorMessage}" in current_message:
                print(f"Fixing incorrectly modified errorFormSubmissionFailed in {arb_file}")
                
                # Replace the incorrect pattern with just "$errorMessage"
                fixed_message = current_message.replace("$errorMessage {errorMessage}", "$errorMessage")
                arb_content["errorFormSubmissionFailed"] = fixed_message
                
                # Write updated content back to ARB file
                with open(arb_file_path, 'w', encoding='utf-8') as f:
                    json.dump(arb_content, f, ensure_ascii=False, indent=2)
                print(f"Updated {arb_file} with fixed errorFormSubmissionFailed: {fixed_message}")
            elif "$errorMessage" not in current_message:
                print(f"Still missing errorMessage in {arb_file}. Setting to English template with $errorMessage")
                arb_content["errorFormSubmissionFailed"] = "Error submitting form: $errorMessage. Please check your connection and try again."
                
                # Write updated content back to ARB file
                with open(arb_file_path, 'w', encoding='utf-8') as f:
                    json.dump(arb_content, f, ensure_ascii=False, indent=2)
                print(f"Updated {arb_file} with English template")
            else:
                print(f"{arb_file} has correct errorMessage placeholder")

if __name__ == "__main__":
    arb_directory = "lib/l10n2"
    fix_error_placeholders(arb_directory)
    print("Done!")
