"""
Check EU261 eligibility for existing flights in the database.
This script analyzes existing flight data with our enhanced detection logic
but does NOT add any test/mock data.
"""

import json
import os
import sys
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Import EU airports module
try:
    from eu_airports import is_eligible_for_eu261, calculate_eu261_compensation, is_airport_in_eu
    EU_AIRPORTS_MODULE_LOADED = True
except ImportError:
    logger.warning("EU airports module not found in local environment.")
    EU_AIRPORTS_MODULE_LOADED = False

# Path for flight data - this will be updated for PythonAnywhere
DATA_FILE = "flight_data_backup.json"

def analyze_flights():
    """Analyze existing flight data with enhanced EU261 detection."""
    try:
        # Load flight data from JSON file 
        with open(DATA_FILE, "r") as f:
            data = json.load(f)
        
        if "flights" not in data:
            logger.error(f"Invalid data format in {DATA_FILE}")
            return
        
        flights = data["flights"]
        logger.info(f"Analyzing {len(flights)} flights for EU261 eligibility")
        
        # Count statistics
        eligible_count = 0
        delay_count = 0
        cancel_count = 0
        
        # Check each flight with enhanced EU261 rules
        for flight in flights:
            # Skip flights without required fields
            if not flight.get('flight') and not flight.get('flight_number'):
                continue
            
            # Check eligibility with enhanced logic
            if EU_AIRPORTS_MODULE_LOADED:
                is_eligible = is_eligible_for_eu261(flight)
            else:
                # Fallback to basic eligibility check
                delay = flight.get('delay', flight.get('delay_minutes', 0))
                status = str(flight.get('status', '')).lower()
                is_cancelled = 'cancel' in status
                is_eligible = delay >= 180 or is_cancelled
            
            if is_eligible:
                eligible_count += 1
                
                # Count by type
                status = str(flight.get('status', '')).lower()
                if 'cancel' in status:
                    cancel_count += 1
                else:
                    delay_count += 1
        
        # Report results
        logger.info(f"EU261 Eligibility Analysis Results:")
        logger.info(f"- Total flights: {len(flights)}")
        logger.info(f"- Eligible for compensation: {eligible_count}")
        logger.info(f"  - Delayed flights: {delay_count}")
        logger.info(f"  - Cancelled flights: {cancel_count}")
        
        print(f"\nEU261 Eligibility Analysis Results:")
        print(f"- Total flights analyzed: {len(flights)}")
        print(f"- Eligible for compensation: {eligible_count}")
        print(f"  - Delayed flights: {delay_count}")
        print(f"  - Cancelled flights: {cancel_count}")
        
        if eligible_count == 0:
            print("\nNo eligible flights found.")
            print("Try refreshing the flight database with current AviationStack data.")
        else:
            print("\nEligible flights found in the database.")
            print("Refresh your app to see these flights in the EU-wide Compensation screen.")
        
    except Exception as e:
        logger.error(f"Error analyzing flights: {e}")
        print(f"Error: {str(e)}")

if __name__ == "__main__":
    # Check if data file exists
    if not os.path.exists(DATA_FILE):
        logger.error(f"Data file not found: {DATA_FILE}")
        print(f"Error: Data file not found: {DATA_FILE}")
        print("For PythonAnywhere, update the DATA_FILE path to: 'data/flight_compensation_data.json'")
        sys.exit(1)
    
    analyze_flights()
    
    # Instructions for PythonAnywhere
    print("\nFor PythonAnywhere, save this file and run:")
    print("1. Edit this file to set DATA_FILE = 'data/flight_compensation_data.json'")
    print("2. Run: python check_eu261_eligibility.py")
    print("3. Reload your web app")
