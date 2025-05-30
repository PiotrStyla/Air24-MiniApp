"""
Prepare Database for Flight Compensation App
-------------------------------------------
Simple script to directly add example eligible flights to your centralized database
without requiring API calls. This ensures your app has data to display immediately.
"""

import os
import sys
import json
import logging
from datetime import datetime, timedelta

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger("prepare_db")

# Path to your flight data storage file
DATA_FILE = "./data/flight_compensation_data.json"

def load_data():
    """Load current flight data from storage"""
    try:
        if os.path.exists(DATA_FILE):
            with open(DATA_FILE, "r") as f:
                return json.load(f)
        else:
            # Create directory if it doesn't exist
            os.makedirs(os.path.dirname(DATA_FILE), exist_ok=True)
            
            # Return initial data structure
            return {
                "flights": [],
                "stats": {
                    "total_flights": 0,
                    "total_eligible_flights": 0,
                    "total_lot_flights": 0,
                    "data_sources": {
                        "Example": a0,
                        "AviationStack": 0
                    }
                }
            }
    except Exception as e:
        logger.error(f"Error loading data: {e}")
        return {
            "flights": [],
            "stats": {
                "total_flights": 0,
                "total_eligible_flights": 0,
                "total_lot_flights": 0,
                "data_sources": {
                    "Example": 0,
                    "AviationStack": 0
                }
            }
        }

def save_data(data):
    """Save flight data to storage"""
    try:
        with open(DATA_FILE, "w") as f:
            json.dump(data, f, indent=2)
        logger.info(f"Data saved to {DATA_FILE}")
    except Exception as e:
        logger.error(f"Error saving data: {e}")

def add_example_flights():
    """Add example flights with compensation eligibility"""
    logger.info("Adding example delayed flights for testing")
    
    # Load current data
    data = load_data()
    
    # Example flights eligible for compensation
    example_flights = [
        {
            'flight_number': 'LO282',
            'departure_date': '2024-03-15T14:30:00',
            'arrival_date': '2024-03-15T16:15:00',
            'departure_airport': 'WAW',
            'arrival_airport': 'LHR',
            'airline': 'LO',
            'delay_minutes': 180,
            'eligible_for_compensation': True,
            'compensation_amount_eur': 400,
            'distance_km': 1450,
            'dataSource': 'Example',
            'storedAt': datetime.utcnow().isoformat()
        },
        {
            'flight_number': 'LO379',
            'departure_date': '2024-04-20T08:45:00',
            'arrival_date': '2024-04-20T10:30:00',
            'departure_airport': 'WAW',
            'arrival_airport': 'CDG',
            'airline': 'LO',
            'delay_minutes': 220,
            'eligible_for_compensation': True,
            'compensation_amount_eur': 350,
            'distance_km': 1365,
            'dataSource': 'Example',
            'storedAt': datetime.utcnow().isoformat()
        },
        {
            'flight_number': 'LH1234',
            'departure_date': '2024-05-18T09:15:00',
            'arrival_date': '2024-05-18T11:45:00',
            'departure_airport': 'FRA',
            'arrival_airport': 'MAD',
            'airline': 'LH',
            'delay_minutes': 195,
            'eligible_for_compensation': True,
            'compensation_amount_eur': 250,
            'distance_km': 1420,
            'dataSource': 'Example',
            'storedAt': datetime.utcnow().isoformat()
        },
        {
            'flight_number': 'AF1028',
            'departure_date': '2024-05-19T13:20:00',
            'arrival_date': '2024-05-19T15:10:00',
            'departure_airport': 'CDG',
            'arrival_airport': 'FCO',
            'airline': 'AF',
            'delay_minutes': 210,
            'eligible_for_compensation': True,
            'compensation_amount_eur': 250,
            'distance_km': 1100,
            'dataSource': 'Example',
            'storedAt': datetime.utcnow().isoformat()
        },
        {
            'flight_number': 'KL1082',
            'departure_date': '2024-05-19T08:40:00',
            'arrival_date': '2024-05-19T10:50:00',
            'departure_airport': 'AMS',
            'arrival_airport': 'BCN',
            'airline': 'KL',
            'delay_minutes': 240,
            'eligible_for_compensation': True,
            'compensation_amount_eur': 400,
            'distance_km': 1300,
            'dataSource': 'Example',
            'storedAt': datetime.utcnow().isoformat()
        }
    ]
    
    # Add example flights to data
    existing_flight_ids = {f.get("flight_number", "") + "_" + f.get("departure_date", "") 
                         for f in data["flights"]}
    
    flights_added = 0
    
    for flight in example_flights:
        flight_id = flight.get("flight_number", "") + "_" + flight.get("departure_date", "")
        
        # Skip if already exists
        if flight_id in existing_flight_ids:
            continue
            
        # Add to storage
        data["flights"].append(flight)
        flights_added += 1
        
        # Add to unique IDs to avoid duplicates in this batch
        existing_flight_ids.add(flight_id)
    
    # Update stats
    data["stats"]["total_flights"] += flights_added
    data["stats"]["total_eligible_flights"] += flights_added
    data["stats"]["data_sources"]["Example"] += flights_added
    
    # Save updated data
    save_data(data)
    
    logger.info(f"Added {flights_added} example flights to database")
    logger.info(f"Total flights in database: {data['stats']['total_flights']}")
    
    return flights_added

def main():
    logger.info("Starting database preparation")
    
    # Add example flights
    flights_added = add_example_flights()
    
    logger.info("Database preparation complete")
    logger.info(f"Added {flights_added} flights")
    
    return 0

if __name__ == "__main__":
    sys.exit(main())
