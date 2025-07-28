import json
import os

# Define missing keys for Flight Compensation Checker screen
flight_checker_fields = {
    "flightCompensationCheckerTitle": "Flight Compensation Checker",
    "checkEligibilityForEu261": "Check Eligibility for EU 261 Compensation",
    "flightNumberPlaceholder": "Flight Number (e.g., LO123)",
    "pleaseEnterFlightNumber": "Please enter a flight number",
    "dateOptionalPlaceholder": "Flight Date (optional)",
    "leaveDateEmptyForToday": "Leave empty for today's date",
    "checkCompensationEligibility": "Check Compensation Eligibility"
}

# Translation mappings for each language
translations = {
    "de": {
        "flightCompensationCheckerTitle": "Flugentschädigung-Prüfer",
        "checkEligibilityForEu261": "Anspruchsberechtigung für EU 261 prüfen",
        "flightNumberPlaceholder": "Flugnummer (z.B. LO123)",
        "pleaseEnterFlightNumber": "Bitte geben Sie eine Flugnummer ein",
        "dateOptionalPlaceholder": "Flugdatum (optional)",
        "leaveDateEmptyForToday": "Leer lassen für heutiges Datum",
        "checkCompensationEligibility": "Entschädigungsberechtigung prüfen"
    },
    "es": {
        "flightCompensationCheckerTitle": "Verificador de Compensación de Vuelos",
        "checkEligibilityForEu261": "Verificar elegibilidad para compensación EU 261",
        "flightNumberPlaceholder": "Número de vuelo (ej. LO123)",
        "pleaseEnterFlightNumber": "Por favor ingrese un número de vuelo",
        "dateOptionalPlaceholder": "Fecha del vuelo (opcional)",
        "leaveDateEmptyForToday": "Dejar en blanco para fecha de hoy",
        "checkCompensationEligibility": "Verificar elegibilidad de compensación"
    },
    "fr": {
        "flightCompensationCheckerTitle": "Vérificateur d'indemnisation de vol",
        "checkEligibilityForEu261": "Vérifier l'éligibilité pour la compensation EU 261",
        "flightNumberPlaceholder": "Numéro de vol (ex. LO123)",
        "pleaseEnterFlightNumber": "Veuillez entrer un numéro de vol",
        "dateOptionalPlaceholder": "Date du vol (optionnel)",
        "leaveDateEmptyForToday": "Laisser vide pour la date d'aujourd'hui",
        "checkCompensationEligibility": "Vérifier l'éligibilité à l'indemnisation"
    },
    "pl": {
        "flightCompensationCheckerTitle": "Sprawdzanie odszkodowania za lot",
        "checkEligibilityForEu261": "Sprawdź uprawnienia do odszkodowania EU 261",
        "flightNumberPlaceholder": "Numer lotu (np. LO123)",
        "pleaseEnterFlightNumber": "Wprowadź numer lotu",
        "dateOptionalPlaceholder": "Data lotu (opcjonalnie)",
        "leaveDateEmptyForToday": "Pozostaw puste dla dzisiejszej daty",
        "checkCompensationEligibility": "Sprawdź uprawnienia do odszkodowania"
    },
    "pt": {
        "flightCompensationCheckerTitle": "Verificador de Compensação de Voo",
        "checkEligibilityForEu261": "Verificar elegibilidade para compensação EU 261",
        "flightNumberPlaceholder": "Número do voo (ex. LO123)",
        "pleaseEnterFlightNumber": "Por favor insira um número de voo",
        "dateOptionalPlaceholder": "Data do voo (opcional)",
        "leaveDateEmptyForToday": "Deixe em branco para a data de hoje",
        "checkCompensationEligibility": "Verificar elegibilidade para compensação"
    }
}

def add_flight_checker_fields(arb_directory):
    # Get all ARB files
    arb_files = [f for f in os.listdir(arb_directory) if f.endswith('.arb')]
    
    for arb_file in arb_files:
        arb_file_path = os.path.join(arb_directory, arb_file)
        language_code = arb_file.replace('app_', '').replace('.arb', '')
        
        # Load ARB file content
        with open(arb_file_path, 'r', encoding='utf-8') as f:
            arb_content = json.load(f)
        
        # Add missing keys based on language
        updated = False
        if language_code == 'en':
            # Add English keys (default)
            for key, value in flight_checker_fields.items():
                if key not in arb_content:
                    arb_content[key] = value
                    updated = True
                    print(f"Added '{key}' to {arb_file}")
        elif language_code in translations:
            # Add translated keys for supported languages
            for key, value in translations[language_code].items():
                if key not in arb_content:
                    arb_content[key] = value
                    updated = True
                    print(f"Added '{key}' to {arb_file}")
        
        # Write updated content back to ARB file if changes were made
        if updated:
            with open(arb_file_path, 'w', encoding='utf-8') as f:
                json.dump(arb_content, f, ensure_ascii=False, indent=2)
            print(f"Updated {arb_file}")
        else:
            print(f"No new keys needed for {arb_file}")

def fix_placeholder_errors(arb_directory):
    # Get all ARB files
    arb_files = [f for f in os.listdir(arb_directory) if f.endswith('.arb')]
    
    for arb_file in arb_files:
        arb_file_path = os.path.join(arb_directory, arb_file)
        
        # Load ARB file content
        with open(arb_file_path, 'r', encoding='utf-8') as f:
            arb_content = json.load(f)
        
        updated = False
        
        # Fix errorFormSubmissionFailed placeholder issue
        if "errorFormSubmissionFailed" in arb_content and "@errorFormSubmissionFailed" in arb_content:
            placeholder_meta = arb_content["@errorFormSubmissionFailed"]
            if "placeholders" not in placeholder_meta:
                placeholder_meta["placeholders"] = {}
            
            if "errorMessage" not in placeholder_meta["placeholders"]:
                placeholder_meta["placeholders"]["errorMessage"] = {"type": "String"}
                updated = True
                print(f"Added errorMessage placeholder metadata to {arb_file}")
        
        # Fix flightRouteDetailsWithNumber placeholder issues in Polish and Portuguese
        if "flightRouteDetailsWithNumber" in arb_content and "@flightRouteDetailsWithNumber" in arb_content:
            placeholder_meta = arb_content["@flightRouteDetailsWithNumber"]
            if "placeholders" not in placeholder_meta:
                placeholder_meta["placeholders"] = {}
            
            # Ensure we have the right placeholders
            for placeholder in ["number", "departure", "arrival"]:
                if placeholder not in placeholder_meta["placeholders"]:
                    placeholder_meta["placeholders"][placeholder] = {"type": "String"}
                    updated = True
                    print(f"Added {placeholder} placeholder metadata to {arb_file}")
        
        # Write updated content back to ARB file if changes were made
        if updated:
            with open(arb_file_path, 'w', encoding='utf-8') as f:
                json.dump(arb_content, f, ensure_ascii=False, indent=2)
            print(f"Updated {arb_file}")
        else:
            print(f"No placeholder fixes needed for {arb_file}")

if __name__ == "__main__":
    arb_directory = "lib/l10n2"
    add_flight_checker_fields(arb_directory)
    fix_placeholder_errors(arb_directory)
    print("Done!")
