import json
import os
import re

# Path to ARB files
arb_dir = "lib/l10n2"

# List all ARB files
arb_files = [f for f in os.listdir(arb_dir) if f.endswith('.arb')]
print(f"Found ARB files: {arb_files}")

# Missing keys from build errors
missing_keys = {
    "continueToAttachmentsButton": "Continue to Attachments",
    "flightNotFoundError": "Flight not found",
    "invalidFlightNumberError": "Invalid flight number",
    "networkTimeoutError": "Network timeout, please try again",
    "serverError": "Server error",
    "rateLimitError": "Too many requests, please try again later",
    "generalFlightCheckError": "Error checking flight eligibility"
}

# Fix ARB files
for arb_file in arb_files:
    arb_path = os.path.join(arb_dir, arb_file)
    print(f"Processing {arb_path}")
    
    try:
        # Read the ARB file
        with open(arb_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        # Add missing keys (only for English file, or if the key doesn't exist in other languages)
        changes_made = False
        for key, default_value in missing_keys.items():
            if key not in data:
                if arb_file == "app_en.arb":
                    data[key] = default_value
                    changes_made = True
                    print(f"Added missing key '{key}' to {arb_file}")
                elif arb_file == "app_de.arb":
                    # German translations
                    german_translations = {
                        "continueToAttachmentsButton": "Weiter zu Anhängen",
                        "flightNotFoundError": "Flug nicht gefunden",
                        "invalidFlightNumberError": "Ungültige Flugnummer",
                        "networkTimeoutError": "Netzwerk-Timeout, bitte versuchen Sie es erneut",
                        "serverError": "Serverfehler",
                        "rateLimitError": "Zu viele Anfragen, bitte versuchen Sie es später erneut",
                        "generalFlightCheckError": "Fehler bei der Überprüfung der Flugeberechtigung"
                    }
                    data[key] = german_translations.get(key, default_value)
                    changes_made = True
                    print(f"Added missing key '{key}' with German translation to {arb_file}")
                elif arb_file == "app_es.arb":
                    # Spanish translations
                    spanish_translations = {
                        "continueToAttachmentsButton": "Continuar a los adjuntos",
                        "flightNotFoundError": "Vuelo no encontrado",
                        "invalidFlightNumberError": "Número de vuelo inválido",
                        "networkTimeoutError": "Tiempo de espera de red, inténtelo de nuevo",
                        "serverError": "Error del servidor",
                        "rateLimitError": "Demasiadas solicitudes, inténtelo más tarde",
                        "generalFlightCheckError": "Error al verificar la elegibilidad del vuelo"
                    }
                    data[key] = spanish_translations.get(key, default_value)
                    changes_made = True
                    print(f"Added missing key '{key}' with Spanish translation to {arb_file}")
                elif arb_file == "app_fr.arb":
                    # French translations
                    french_translations = {
                        "continueToAttachmentsButton": "Continuer vers les pièces jointes",
                        "flightNotFoundError": "Vol non trouvé",
                        "invalidFlightNumberError": "Numéro de vol invalide",
                        "networkTimeoutError": "Délai d'attente du réseau, veuillez réessayer",
                        "serverError": "Erreur du serveur",
                        "rateLimitError": "Trop de demandes, veuillez réessayer plus tard",
                        "generalFlightCheckError": "Erreur lors de la vérification de l'éligibilité du vol"
                    }
                    data[key] = french_translations.get(key, default_value)
                    changes_made = True
                    print(f"Added missing key '{key}' with French translation to {arb_file}")
                elif arb_file == "app_pl.arb":
                    # Polish translations
                    polish_translations = {
                        "continueToAttachmentsButton": "Kontynuuj do załączników",
                        "flightNotFoundError": "Lot nie znaleziony",
                        "invalidFlightNumberError": "Nieprawidłowy numer lotu",
                        "networkTimeoutError": "Przekroczenie czasu połączenia, spróbuj ponownie",
                        "serverError": "Błąd serwera",
                        "rateLimitError": "Zbyt wiele żądań, spróbuj ponownie później",
                        "generalFlightCheckError": "Błąd sprawdzania kwalifikowalności lotu"
                    }
                    data[key] = polish_translations.get(key, default_value)
                    changes_made = True
                    print(f"Added missing key '{key}' with Polish translation to {arb_file}")
                elif arb_file == "app_pt.arb":
                    # Portuguese translations
                    portuguese_translations = {
                        "continueToAttachmentsButton": "Continuar para anexos",
                        "flightNotFoundError": "Voo não encontrado",
                        "invalidFlightNumberError": "Número de voo inválido",
                        "networkTimeoutError": "Tempo limite de rede, tente novamente",
                        "serverError": "Erro do servidor",
                        "rateLimitError": "Muitos pedidos, tente novamente mais tarde",
                        "generalFlightCheckError": "Erro ao verificar a elegibilidade do voo"
                    }
                    data[key] = portuguese_translations.get(key, default_value)
                    changes_made = True
                    print(f"Added missing key '{key}' with Portuguese translation to {arb_file}")
                else:
                    # For other languages, use English as fallback
                    data[key] = default_value
                    changes_made = True
                    print(f"Added missing key '{key}' with English fallback to {arb_file}")
        
        # Fix placeholder issues in errorFormSubmissionFailed
        if "errorFormSubmissionFailed" in data:
            # Check if it contains the placeholder {errorMessage}
            if "{errorMessage}" in data["errorFormSubmissionFailed"]:
                # Add the @errorMessage placeholder metadata if not present
                if "@errorFormSubmissionFailed" not in data or "placeholders" not in data["@errorFormSubmissionFailed"] or "errorMessage" not in data["@errorFormSubmissionFailed"]["placeholders"]:
                    if "@errorFormSubmissionFailed" not in data:
                        data["@errorFormSubmissionFailed"] = {"placeholders": {}}
                    elif "placeholders" not in data["@errorFormSubmissionFailed"]:
                        data["@errorFormSubmissionFailed"]["placeholders"] = {}
                    
                    data["@errorFormSubmissionFailed"]["placeholders"]["errorMessage"] = {
                        "type": "String"
                    }
                    changes_made = True
                    print(f"Fixed errorMessage placeholder metadata in {arb_file}")
        
        # Fix placeholder issues in flightRouteDetails
        if "flightRouteDetails" in data:
            # Check if it contains the placeholder {number}
            if "{number}" in data["flightRouteDetails"]:
                # Replace {number} with {flightNumber} for consistency
                data["flightRouteDetails"] = data["flightRouteDetails"].replace("{number}", "{flightNumber}")
                changes_made = True
                print(f"Replaced 'number' placeholder with 'flightNumber' in {arb_file}")
                
                # Update the placeholder metadata
                if "@flightRouteDetails" not in data:
                    data["@flightRouteDetails"] = {"placeholders": {}}
                elif "placeholders" not in data["@flightRouteDetails"]:
                    data["@flightRouteDetails"]["placeholders"] = {}
                
                # Add or update flightNumber placeholder
                data["@flightRouteDetails"]["placeholders"]["flightNumber"] = {
                    "type": "String"
                }
                data["@flightRouteDetails"]["placeholders"]["departure"] = {
                    "type": "String"
                }
                data["@flightRouteDetails"]["placeholders"]["arrival"] = {
                    "type": "String"
                }
                
                # Remove number placeholder if it exists
                if "number" in data["@flightRouteDetails"]["placeholders"]:
                    del data["@flightRouteDetails"]["placeholders"]["number"]
                
                print(f"Updated flightRouteDetails placeholder metadata in {arb_file}")
        
        # Fix welcomeUser placeholders (should have 2 parameters)
        if "welcomeUser" in data:
            # Ensure it has both {name} and {role} placeholders
            if "{name}" in data["welcomeUser"] and "{role}" not in data["welcomeUser"]:
                # Add role placeholder
                data["welcomeUser"] = data["welcomeUser"] + " ({role})"
                changes_made = True
                print(f"Added role placeholder to welcomeUser in {arb_file}")
            
            # Update placeholder metadata
            if "@welcomeUser" not in data:
                data["@welcomeUser"] = {"placeholders": {}}
            elif "placeholders" not in data["@welcomeUser"]:
                data["@welcomeUser"]["placeholders"] = {}
            
            # Add or update name and role placeholders
            data["@welcomeUser"]["placeholders"]["name"] = {"type": "String"}
            data["@welcomeUser"]["placeholders"]["role"] = {"type": "String"}
            print(f"Updated welcomeUser placeholder metadata in {arb_file}")
        
        # Fix flightRouteDetailsWithNumber (should have 4 parameters)
        if "flightRouteDetailsWithNumber" in data:
            # Ensure it has all required placeholders: flightNumber, airline, departure, arrival
            missing_placeholders = []
            for ph in ["flightNumber", "airline", "departure", "arrival"]:
                if "{" + ph + "}" not in data["flightRouteDetailsWithNumber"]:
                    missing_placeholders.append(ph)
            
            if missing_placeholders:
                # Add missing placeholders
                updated_text = data["flightRouteDetailsWithNumber"]
                if "flightNumber" in missing_placeholders:
                    updated_text += " {flightNumber}"
                if "airline" in missing_placeholders:
                    updated_text += " {airline}"
                if "departure" in missing_placeholders:
                    updated_text += " {departure}"
                if "arrival" in missing_placeholders:
                    updated_text += " {arrival}"
                
                data["flightRouteDetailsWithNumber"] = updated_text
                changes_made = True
                print(f"Added missing placeholders {missing_placeholders} to flightRouteDetailsWithNumber in {arb_file}")
            
            # Update placeholder metadata
            if "@flightRouteDetailsWithNumber" not in data:
                data["@flightRouteDetailsWithNumber"] = {"placeholders": {}}
            elif "placeholders" not in data["@flightRouteDetailsWithNumber"]:
                data["@flightRouteDetailsWithNumber"]["placeholders"] = {}
            
            # Add or update all required placeholders
            data["@flightRouteDetailsWithNumber"]["placeholders"]["flightNumber"] = {"type": "String"}
            data["@flightRouteDetailsWithNumber"]["placeholders"]["airline"] = {"type": "String"}
            data["@flightRouteDetailsWithNumber"]["placeholders"]["departure"] = {"type": "String"}
            data["@flightRouteDetailsWithNumber"]["placeholders"]["arrival"] = {"type": "String"}
            print(f"Updated flightRouteDetailsWithNumber placeholder metadata in {arb_file}")
        
        # Write changes back if any were made
        if changes_made:
            with open(arb_path, 'w', encoding='utf-8') as f:
                json.dump(data, f, indent=2, ensure_ascii=False)
            print(f"Updated {arb_file}")
        else:
            print(f"No changes needed for {arb_file}")
    
    except Exception as e:
        print(f"Error processing {arb_file}: {str(e)}")

print("Completed localization fixes!")
