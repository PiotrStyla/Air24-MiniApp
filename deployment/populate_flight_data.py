"""
Populate Flight Data Script (v3 - Ultra Robust)
------------------------------------------------
This script is designed to be highly resilient to inconsistent API data.
"""

import os
import sys
import logging
import time
import requests
import json

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger("populate_flight_data")

def safe_get(data, keys, default=''):
    """
    Safely gets a nested value from a dictionary. Handles cases where
    intermediate keys might be missing or not dictionaries.
    """
    if not isinstance(data, dict):
        return default
    temp = data
    for key in keys:
        if not isinstance(temp, dict):
            return default
        temp = temp.get(key)
    # Return the found value, or the default if the value is None
    return temp if temp is not None else default

def main():
    logger.info("Starting database population with AviationStack flight data (Ultra Robust Mode)")

    api_key = "9cb5db4ba59f1e5005591c572d8b5f1c"
    base_url = "http://api.aviationstack.com/v1/flights"

    try:
        from flight_data_storage import FlightDataStorage
        storage = FlightDataStorage()
        logger.info("Successfully initialized flight data storage")
    except Exception as e:
        logger.error(f"Failed to initialize flight data storage: {e}")
        return 1

    try:
        from eu_airports import get_major_eu_airports
        eu_airports = get_major_eu_airports()
        logger.info(f"Using {len(eu_airports)} major EU airports")
    except Exception:
        logger.warning("EU airports module not found, using fallback list")
        eu_airports = ['FRA', 'CDG', 'AMS', 'MAD', 'FCO', 'LHR', 'MUC', 'BCN', 'LIS', 'VIE', 'WAW']

    errors = 0
    flights_processed = 0

    for airport_iata in eu_airports:
        logger.info(f"Processing airport: {airport_iata}")
        try:
            params = {'access_key': api_key, 'arr_iata': airport_iata, 'limit': 100}
            response = requests.get(base_url, params=params, timeout=45)

            if response.status_code != 200:
                logger.error(f"API request failed for {airport_iata}: {response.status_code} - {response.text}")
                errors += 1
                continue

            data = response.json()
            flights_from_api = data.get('data', [])
            logger.info(f"Retrieved {len(flights_from_api)} flight items for {airport_iata}")

            for flight_data_item in flights_from_api:
                if not isinstance(flight_data_item, dict):
                    logger.warning(f"Skipping non-dictionary flight record: {type(flight_data_item)}")
                    errors += 1
                    continue

                try:
                    # Use the safe_get helper for all nested data extraction
                    flight_number = safe_get(flight_data_item, ['flight', 'iata'])
                    if not flight_number:
                        logger.warning(f"Skipping record with no flight number. Details: {flight_data_item.get('flight')}")
                        errors += 1
                        continue

                    airline_code = safe_get(flight_data_item, ['airline', 'iata'])
                    airline_name = safe_get(flight_data_item, ['airline', 'name'], 'Unknown Airline')

                    departure_airport = safe_get(flight_data_item, ['departure', 'iata'])
                    arrival_airport = safe_get(flight_data_item, ['arrival', 'iata'])
                    scheduled_departure = safe_get(flight_data_item, ['departure', 'scheduled'])
                    scheduled_arrival = safe_get(flight_data_item, ['arrival', 'scheduled'])
                    actual_arrival = safe_get(flight_data_item, ['arrival', 'actual'])

                    delay_minutes = safe_get(flight_data_item, ['arrival', 'delay'], 0)
                    # Ensure delay is an integer
                    delay_minutes = int(delay_minutes) if str(delay_minutes).isdigit() else 0

                    is_eligible = delay_minutes >= 180
                    distance_km = 2000 # Placeholder

                    compensation_amount = 0
                    if is_eligible:
                        if distance_km <= 1500: compensation_amount = 250
                        elif distance_km <= 3500: compensation_amount = 400
                        else: compensation_amount = 600

                    flight_for_storage = {
                        'flight': {'iata': flight_number},
                        'departure': {'airport': {'iata': departure_airport}, 'scheduled': scheduled_departure},
                        'arrival': {'airport': {'iata': arrival_airport}, 'scheduled': scheduled_arrival, 'actual': actual_arrival},
                        'airline': {'iata': airline_code, 'name': airline_name},
                        'status': flight_data_item.get('flight_status', 'scheduled'),
                        'delayMinutes': delay_minutes,
                        'eligible_for_compensation': is_eligible,
                        'compensation_amount_eur': compensation_amount,
                        'distance_km': distance_km
                    }

                    storage.store_flights([flight_for_storage], source="real_api")
                    flights_processed += 1

                except Exception as e_proc:
                    errors += 1
                    logger.error(f"CRITICAL UNHANDLED error processing record (iata: {flight_number}): {e_proc}")
                    # Log the types of nested objects to find the culprit
                    logger.error(f"--- Problematic Record Analysis ---")
                    logger.error(f"Type of flight: {type(flight_data_item.get('flight'))}")
                    logger.error(f"Type of airline: {type(flight_data_item.get('airline'))}")
                    logger.error(f"Type of departure: {type(flight_data_item.get('departure'))}")
                    logger.error(f"Type of arrival: {type(flight_data_item.get('arrival'))}")
                    logger.error(f"--- End Analysis ---")
                    continue

            logger.info(f"Completed processing for {airport_iata}.")
            time.sleep(0.5)

        except Exception as e_airport:
            logger.error(f"Major error processing airport {airport_iata}: {e_airport}")
            errors += 1
            continue

    final_stats = storage.get_stats()
    logger.info("--- FINAL REPORT ---")
    logger.info(f"Total flights in database: {final_stats.get('total_flights', 0)}")
    logger.info(f"Total flights processed in this run: {flights_processed}")
    logger.info(f"Encountered {errors} errors during this run.")
    logger.info("--- END REPORT ---")

    return 1 if errors > 0 else 0

if __name__ == "__main__":
    sys.exit(main())
