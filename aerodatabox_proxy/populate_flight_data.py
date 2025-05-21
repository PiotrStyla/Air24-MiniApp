"""
Populate Flight Data Script
---------------------------
Run this script on PythonAnywhere to pre-populate your database with AviationStack data.
This ensures the app has flight data available immediately, without waiting for real-time API calls.
"""

import os
import sys
import logging
import time
import requests
import json
from datetime import datetime, timedelta

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger("populate_flight_data")

def main():
    logger.info("Starting database population with AviationStack flight data")
    
    # Use direct API calls that we know work
    try:
        # Your AviationStack API key
        api_key = "9cb5db4ba59f1e5005591c572d8b5f1c"
        
        # Set in environment for any code that might use it
        os.environ['AVIATIONSTACK_API_KEY'] = api_key
        logger.info(f"API key set: {api_key[:5]}...")
        
        # Base URL and endpoint
        base_url = "http://api.aviationstack.com/v1"
        flights_endpoint = "flights"
    except ImportError as e:
        logger.error(f"Failed to import AviationStack client: {e}")
        return 1
    except Exception as e:
        logger.error(f"Error initializing AviationStack client: {e}")
        return 1
    
    # Import storage
    try:
        from flight_data_storage import FlightDataStorage
        storage = FlightDataStorage()
        logger.info("Successfully initialized flight data storage")
    except ImportError as e:
        logger.error(f"Failed to import flight data storage: {e}")
        return 1
    except Exception as e:
        logger.error(f"Error initializing flight data storage: {e}")
        return 1
    
    # Major EU airports to check
    eu_airports = ['FRA', 'CDG', 'AMS', 'MAD', 'FCO', 'LHR', 'MUC', 'BCN', 'LIS', 'VIE', 'WAW']
    
    flights_added = 0
    errors = 0
    
    # Import storage directly to avoid module issues
    try:
        from flight_data_storage import FlightDataStorage
        storage = FlightDataStorage()
        logger.info("Flight data storage initialized successfully")
    except ImportError as e:
        logger.error(f"Failed to import flight data storage: {e}")
        return 1
    except Exception as e:
        logger.error(f"Error initializing flight data storage: {e}")
        return 1
    
    # Process each airport
    for airport in eu_airports:
        logger.info(f"Processing airport: {airport}")
        
        try:
            # Direct API call using the params format that worked in our test
            url = f"{base_url}/{flights_endpoint}"
            params = {
                'access_key': api_key,
                'arr_iata': airport,  # Airport arrival filter
                'limit': 100          # Get up to 100 flights
            }
            
            logger.info(f"Making direct request to: {url} for airport {airport}")
            response = requests.get(url, params=params, timeout=30)
            
            if response.status_code != 200:
                logger.error(f"API request failed with status code: {response.status_code}")
                logger.error(f"Response body: {response.text}")
                errors += 1
                continue
                
            # Parse JSON response
            data = response.json()
            flights = data.get('data', [])
            logger.info(f"Retrieved {len(flights)} flights for {airport}")

            
            logger.info(f"Retrieved {len(flights)} flights for {airport}")
            
            for flight in flights:
                try:
                    # Format flight data - direct approach without depending on client
                    # Extract basic flight info
                    flight_number = flight.get('flight', {}).get('iata', '')
                    airline_code = flight.get('airline', {}).get('iata', '')
                    airline_name = flight.get('airline', {}).get('name', 'Unknown Airline')
                    
                    # Extract departure/arrival info
                    departure_airport = flight.get('departure', {}).get('iata', '')
                    arrival_airport = flight.get('arrival', {}).get('iata', '')
                    scheduled_departure = flight.get('departure', {}).get('scheduled', '')
                    scheduled_arrival = flight.get('arrival', {}).get('scheduled', '')
                    
                    # Check for delay information
                    delay_minutes = flight.get('arrival', {}).get('delay', 0) or 0
                    
                    # Check if flight has a delay
                    if delay_minutes:
                        delay_minutes = flight.get('arrival', {}).get('delay', 0)
                    
                    # Check if eligible for compensation (3+ hour delay)
                    is_eligible = delay_minutes >= 180
                    
                    # Calculate flight distance (estimated)
                    # For real implementation, you'd use a distance calculation library
                    # This is a simple estimation for EU flights
                    distance_km = flight.get('flight', {}).get('distance', 2000) or 2000
                    
                    # Calculate compensation amount based on EU261 rules
                    compensation_amount = 0
                    if is_eligible:
                        if distance_km <= 1500:
                            compensation_amount = 250
                        elif distance_km <= 3500:
                            compensation_amount = 400
                        else:
                            compensation_amount = 600
                    
                    # Format flight for storage in the format expected by flight_data_storage.py
                    flight_for_storage = {
                        'flight': flight_number,
                        'departure': {
                            'airport': {
                                'iata': departure_airport
                            },
                            'scheduledTime': scheduled_departure
                        },
                        'arrival': {
                            'airport': {
                                'iata': arrival_airport
                            },
                            'scheduledTime': scheduled_arrival
                        },
                        'airline': {
                            'iata': airline_code,
                            'name': airline_name
                        },
                        'status': 'Delayed' if delay_minutes >= 180 else 'On Time',
                        'delay': delay_minutes,
                        'eligible_for_compensation': is_eligible,
                        'compensation_amount_eur': compensation_amount,
                        'distance_km': distance_km
                    }
                    
                    # Store the flight using the correct store_flights method
                    try:
                        # Use 'real_api' as the source since that's what the storage system expects
                        storage.store_flights([flight_for_storage], source="real_api")
                        flights_added += 1
                        logger.info(f"Added flight {flight_number} to database")
                    except Exception as e:
                        logger.error(f"Error storing flight {flight_number}: {e}")
                        errors += 1
                    
                    # Avoid hitting API rate limits by sleeping briefly
                    time.sleep(0.1)
                    
                except Exception as e:
                    logger.error(f"Error processing flight: {e}")
                    errors += 1
                    continue
            
            # Add some delay between airports to avoid hitting API rate limits
            logger.info(f"Completed processing for {airport}")
            time.sleep(2)
            
        except Exception as e:
            logger.error(f"Error processing airport {airport}: {e}")
            errors += 1
            continue
    
    # If no flights were found from the API, add fallback examples for testing
    if flights_added == 0:
        try:
            logger.info("No flights found from API, adding a few example flights for testing")
            
            # Create example delayed flights for testing, using the correct format
            example_flights = [
                # LO282: Warsaw to London, delayed 3 hours
                {
                    'flight': 'LO282',
                    'departure': {
                        'airport': {
                            'iata': 'WAW'
                        },
                        'scheduledTime': '2024-03-15T14:30:00'
                    },
                    'arrival': {
                        'airport': {
                            'iata': 'LHR'
                        },
                        'scheduledTime': '2024-03-15T16:15:00'
                    },
                    'airline': {
                        'iata': 'LO',
                        'name': 'LOT Polish Airlines'
                    },
                    'status': 'Delayed',
                    'delay': 180,
                    'eligible_for_compensation': True,
                    'compensation_amount_eur': 400,
                    'distance_km': 1450,
                },
                # LO379: Warsaw to Paris, delayed 3.5 hours
                {
                    'flight': 'LO379',
                    'departure': {
                        'airport': {
                            'iata': 'WAW'
                        },
                        'scheduledTime': '2024-04-20T08:45:00'
                    },
                    'arrival': {
                        'airport': {
                            'iata': 'CDG'
                        },
                        'scheduledTime': '2024-04-20T10:30:00'
                    },
                    'airline': {
                        'iata': 'LO',
                        'name': 'LOT Polish Airlines'
                    },
                    'status': 'Delayed',
                    'delay': 220,
                    'eligible_for_compensation': True,
                    'compensation_amount_eur': 350,
                    'distance_km': 1365,
                },
            ]
            
            # Use store_flights method with list of flights
            try:
                # Use 'fallback' as it's pre-defined in the storage system
                storage.store_flights(example_flights, source="fallback")
                flights_added += len(example_flights)
                logger.info(f"Added {len(example_flights)} example flights for testing")
            except Exception as storage_error:
                logger.error(f"Error storing example flights: {storage_error}")
                errors += 1
                
        except Exception as e:
            logger.error(f"Error preparing example flights: {e}")
            errors += 1
    
    # Log summary
    logger.info(f"Database population complete:")
    logger.info(f"- Added {flights_added} flights")
    logger.info(f"- Encountered {errors} errors")
    
    return 0

if __name__ == "__main__":
    sys.exit(main())
