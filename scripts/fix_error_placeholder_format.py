import json
import os

def fix_error_placeholder_format(arb_directory):
    # Get all ARB files
    arb_files = [f for f in os.listdir(arb_directory) if f.endswith('.arb')]
    
    for arb_file in arb_files:
        arb_file_path = os.path.join(arb_directory, arb_file)
        
        # Load ARB file content
        with open(arb_file_path, 'r', encoding='utf-8') as f:
            arb_content = json.load(f)
        
        # Fix errorFormSubmissionFailed
        if "errorFormSubmissionFailed" in arb_content:
            # Check for incorrect format {$errorMessage}
            message = arb_content["errorFormSubmissionFailed"]
            if "{$errorMessage}" in message:
                fixed_message = message.replace("{$errorMessage}", "{errorMessage}")
                arb_content["errorFormSubmissionFailed"] = fixed_message
                print(f"Fixed errorFormSubmissionFailed in {arb_file}: replaced {{$errorMessage}} with {{errorMessage}}")
                
                # Write updated content back to ARB file
                with open(arb_file_path, 'w', encoding='utf-8') as f:
                    json.dump(arb_content, f, ensure_ascii=False, indent=2)
                print(f"Updated {arb_file}")
            else:
                print(f"No placeholder format fix needed for {arb_file}")
        else:
            print(f"No errorFormSubmissionFailed key in {arb_file}")

if __name__ == "__main__":
    arb_directory = "lib/l10n2"
    fix_error_placeholder_format(arb_directory)
    print("Done!")
