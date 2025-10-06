"""
Flight data population script for PythonAnywhere
Fetches real flight data from AviationStack API and saves to JSON file

Usage:
  Set AVSTACK_API_KEY environment variable or replace 'YOUR_API_KEY' below
  python populate_flight_data.py

This will fetch real flight data and save to /home/PiotrS/flight_compensation/data/flight_compensation_data.json
"""
import os
import json
import requests
from datetime import datetime, timedelta

# --- Configuration ---
# IMPORTANT: Replace with your actual API key or set as an environment variable
API_KEY = os.environ.get('AVSTACK_API_KEY', '060ddc369d9d250b1a718aafad97c05a')
BASE_URL = 'https://api.aviationstack.com/v1'
DATA_FILE = "/home/PiotrS/flight_compensation/data/flight_compensation_data.json"

# --- Main Functions ---
def fetch_flights_by_status(limit=50, status='landed'):
    """Fetches a list of recent flights from the AviationStack API for a given status."""
    params = {
        'access_key': API_KEY,
        'limit': limit,
        'flight_status': status
    }
    print("Fetching flights from AviationStack API...")
    try:
        response = requests.get(f'{BASE_URL}/flights', params=params)
        response.raise_for_status()
        data = response.json()
        print(f"Successfully fetched {len(data.get('data', []))} flight records.")
        return data.get('data', [])
    except requests.exceptions.RequestException as e:
        print(f"Error fetching flights: {e}")
        if e.response is not None:
            print(f"Response Body: {e.response.text}")
        return []

def normalize_flight(flight):
    """
    Safely normalizes a single flight record from AviationStack API
    to the format expected by the Flutter app. Handles inconsistent data types.
    """
    # Safely extract departure and arrival nodes
    dep_node = flight.get('departure', {})
    arr_node = flight.get('arrival', {})

    # --- Safely extract airport IATA codes ---
    dep_iata = ''
    if isinstance(dep_node, dict):
        # CORRECTED PATH: 'iata' is a direct key in the departure/arrival object
        dep_iata = dep_node.get('iata', '')

    arr_iata = ''
    if isinstance(arr_node, dict):
        # CORRECTED PATH: 'iata' is a direct key in the departure/arrival object
        arr_iata = arr_node.get('iata', '')

    # --- Safely extract other fields ---
    flight_info = flight.get('flight', {})
    flight_iata = flight_info.get('iata', '') if isinstance(flight_info, dict) else flight.get('flight_number', '')

    airline_info = flight.get('airline', {})
    airline_name = airline_info.get('name', 'Unknown Airline') if isinstance(airline_info, dict) else 'Unknown Airline'
    airline_iata = airline_info.get('iata', '') if isinstance(airline_info, dict) else ''

    dep_sched = dep_node.get('scheduled', '') if isinstance(dep_node, dict) else ''
    arr_sched = arr_node.get('scheduled', '') if isinstance(arr_node, dict) else ''
    delay_minutes = dep_node.get('delay', 0) if isinstance(dep_node, dict) else 0

    return {
        "id": flight_iata or str(flight.get('flight_number', '')),
        "flight_number": flight_iata,
        "flight_iata": flight_iata,
        "airline_name": airline_name,
        "airline_iata": airline_iata,
        "departure_airport_iata": dep_iata,
        "arrival_airport_iata": arr_iata,
        "departure_scheduled_time": dep_sched,
        "arrival_scheduled_time": arr_sched,
        "status": flight.get('flight_status', 'UNKNOWN').upper(),
        "delay_minutes": delay_minutes or 0,
        "distance_km": 0,
        "eu_compensation_eligible": False,
        "compensation_amount_eur": 0
    }

# --- Eligibility Logic (from WSGI app) ---

def get_status_lower(flight_record):
    """Safely get lowercase status from flight record, handling None values"""
    status = flight_record.get('status')
    return status.lower() if status else ""

def is_eligible_for_compensation(flight):
    """Determines if a flight is eligible for compensation under EU261 rules."""
    try:
        status_lower = get_status_lower(flight)
        delay_minutes = flight.get('delay_minutes', 0) or 0

        # A flight is eligible if it's cancelled or delayed by 3+ hours (180 minutes).
        is_eligible_status = "cancel" in status_lower or delay_minutes >= 180
        if not is_eligible_status:
            return False

        departure_airport = flight.get('departure_airport_iata', '')
        arrival_airport = flight.get('arrival_airport_iata', '')
        
        # This list should be comprehensive for EU261 coverage.
        eu_airports = [
            'VIE', 'BRU', 'SOF', 'ZAG', 'LCA', 'PRG', 'CPH', 'TLL', 'HEL', 'CDG', 
            'ORY', 'FRA', 'MUC', 'DUS', 'TXL', 'ATH', 'BUD', 'DUB', 'FCO', 'CIA', 
            'RIX', 'VNO', 'LUX', 'MLA', 'AMS', 'WAW', 'LIS', 'OTP', 'LJU', 'KSC', 
            'MAD', 'BCN', 'ARN', 'LHR', 'LGW', 'STN', 'MAN', 'BHX', 'GLA', 'EDI'
        ]
        
        is_eu_flight = departure_airport in eu_airports or arrival_airport in eu_airports
        return is_eu_flight
    except Exception:
        return False

def main():
    """Main function to find and save at least 10 eligible flights."""
    os.makedirs(os.path.dirname(DATA_FILE), exist_ok=True)
    
    eligible_flights = []
    max_attempts = 10  # Limit API calls to prevent infinite loops
    attempts = 0

    print(f"Searching for at least 10 eligible flights...")

    while len(eligible_flights) < 10 and attempts < max_attempts:
        attempts += 1
        print(f"\n--- Attempt {attempts}/{max_attempts} ---")
        
        # Fetch a mix of potentially eligible flights
        print("Fetching cancelled and landed flights...")
        cancelled = fetch_flights_by_status(limit=100, status='cancelled')
        landed = fetch_flights_by_status(limit=100, status='landed')
        flights = cancelled + landed

        if not flights:
            print("API returned no flights this attempt. Waiting before retrying...")
            continue

        print(f"Normalizing {len(flights)} fetched flights...")
        normalized_flights = [normalize_flight(f) for f in flights]
        
        print("Filtering for eligible flights...")
        for flight in normalized_flights:
            if is_eligible_for_compensation(flight):
                # Add compensation amount for display
                flight['eu_compensation_eligible'] = True
                flight['compensation_amount_eur'] = 400 # Default, can be refined
                eligible_flights.append(flight)
                print(f"  [+] Found eligible flight: {flight['flight_iata']} ({flight['airline_name']}). Total found: {len(eligible_flights)}")

            if len(eligible_flights) >= 10:
                break

    if len(eligible_flights) >= 10:
        print(f"\nSuccessfully found {len(eligible_flights)} eligible flights.")
    else:
        print(f"\nWarning: Found only {len(eligible_flights)} eligible flights after {max_attempts} attempts.")

    if not eligible_flights:
        print("No eligible flights found. Exiting without updating data file.")
        return

    data_to_save = {"flights": eligible_flights}
    
    with open(DATA_FILE, "w") as f:
        json.dump(data_to_save, f, indent=2)
    
    print(f"Saved {len(eligible_flights)} eligible flights to {DATA_FILE}")
    print("Script finished successfully!")

if __name__ == "__main__":
    main()
