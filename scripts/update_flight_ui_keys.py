import json
import os

def update_arb_files_with_flight_ui_keys(flight_ui_keys_file, arb_directory):
    # Load flight UI keys
    with open(flight_ui_keys_file, 'r', encoding='utf-8') as f:
        flight_ui_keys = json.load(f)
    
    # Get all ARB files
    arb_files = [f for f in os.listdir(arb_directory) if f.endswith('.arb')]
    
    for arb_file in arb_files:
        arb_file_path = os.path.join(arb_directory, arb_file)
        
        # Load ARB file content
        with open(arb_file_path, 'r', encoding='utf-8') as f:
            arb_content = json.load(f)
        
        # Track if any keys were added
        keys_added = False
        
        for key, value in flight_ui_keys.items():
            # Only add if key doesn't exist
            if key not in arb_content:
                arb_content[key] = value
                keys_added = True
                print(f"Added key '{key}' to {arb_file}")
                
                # Add placeholder metadata for methods with parameters
                if key == "flightInfoFormat":
                    arb_content[f"@{key}"] = {
                        "placeholders": {
                            "flightCode": {
                                "type": "String"
                            },
                            "flightDate": {
                                "type": "String"
                            }
                        }
                    }
                    print(f"Added placeholder metadata for '{key}' to {arb_file}")
                elif key == "minutesFormat":
                    arb_content[f"@{key}"] = {
                        "placeholders": {
                            "minutes": {
                                "type": "int"
                            }
                        }
                    }
                    print(f"Added placeholder metadata for '{key}' to {arb_file}")
        
        if keys_added:
            # Write updated content back to ARB file
            with open(arb_file_path, 'w', encoding='utf-8') as f:
                json.dump(arb_content, f, ensure_ascii=False, indent=2)
            print(f"Updated {arb_file}")
        else:
            print(f"No changes needed for {arb_file}")

if __name__ == "__main__":
    flight_ui_keys_file = "scripts/flight_ui_localizations.json"
    arb_directory = "lib/l10n2"
    update_arb_files_with_flight_ui_keys(flight_ui_keys_file, arb_directory)
    print("Done!")
