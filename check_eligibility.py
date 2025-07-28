"""
Diagnostic script to analyze flight eligibility issues
This will check the flight data and report details on eligibility criteria
"""
import os
import json
import sys
from datetime import datetime

# Path for flight data storage
DATA_FILE = "/home/PiotrS/data/flight_compensation_data.json"
# For local testing, use a local path if needed
LOCAL_TEST_FILE = "./sample_flight_data.json"

def load_flight_data(file_path):
    """Load flight data from the specified file"""
    try:
        with open(file_path, "r") as f:
            return json.load(f)
    except (json.JSONDecodeError, FileNotFoundError) as e:
        print(f"Error reading data file: {e}")
        return {"flights": []}

def get_status_lower(flight_record):
    """Safely get lowercase status from flight record, handling None values"""
    if flight_record is None:
        return ""
    
    status = flight_record.get('status')
    if status is None:
        return ""
    
    return status.lower()

def is_eligible_for_compensation(flight, hours_ago=None):
    """
    Determines if a flight is eligible for compensation under EU261 rules
    with explicit handling of None values and missing fields
    Returns eligibility status and reason
    """
    try:
        # Safe status processing with None handling
        status_lower = get_status_lower(flight)
        
        # Default values
        delay_minutes = flight.get('delayMinutes', 0)
        if delay_minutes is None:
            delay_minutes = 0
        
        # Debug info
        print(f"Flight: {flight.get('flight', 'N/A')} | Status: {flight.get('status', 'N/A')} | DelayMinutes: {delay_minutes}")
            
        # Check cancellation status
        is_cancelled = "cancel" in status_lower
        is_delayed = delay_minutes >= 180  # 3+ hours delay
        
        # Debug
        print(f"  - is_cancelled: {is_cancelled}, is_delayed: {is_delayed}")
        
        # Only delayed or cancelled flights are eligible
        if is_cancelled or is_delayed:
            # Check if airports are in EU
            departure_airport = flight.get('departure', {}).get('airport', {}).get('iata', '')
            arrival_airport = flight.get('arrival', {}).get('airport', {}).get('iata', '')
            
            # Simple check - in a real app would use a proper EU airport database
            eu_airports = ['MAD', 'CDG', 'FRA', 'AMS', 'FCO', 'LHR', 'MUC', 'BCN', 'ATH', 'VIE', 'WAW', 'DUB', 'BRU', 'LIS', 'HEL', 'PRG', 'CPH', 'BUD', 'ARN', 'TXL', 'OTP', 'SOF', 'LJU', 'RIX', 'VNO', 'TLL']
            
            # Either departure or arrival airport must be in the EU
            is_eu_flight = departure_airport in eu_airports or arrival_airport in eu_airports
            
            # Debug
            print(f"  - Departure: {departure_airport}, Arrival: {arrival_airport}, is_eu_flight: {is_eu_flight}")
            
            if is_eu_flight:
                return True, f"{'Cancelled' if is_cancelled else 'Delayed by ' + str(delay_minutes) + ' mins'} EU flight"
            else:
                return False, "Not an EU flight"
        else:
            return False, "Not delayed or cancelled"
    except Exception as e:
        print(f"Error in eligibility check: {str(e)}")
        return False, f"Error: {str(e)}"

def analyze_flight_data(file_path):
    """Analyze flight data for eligibility issues"""
    print(f"\n--- ANALYZING FLIGHT DATA IN {file_path} ---\n")
    
    data = load_flight_data(file_path)
    flights = data.get("flights", [])
    
    print(f"Total flights in dataset: {len(flights)}")
    
    if not flights:
        print("No flights found in dataset!")
        return
    
    # Check flight data structure
    sample_flight = flights[0]
    print("\nSample flight data structure:")
    for key, value in sample_flight.items():
        print(f"{key}: {type(value).__name__}")
    
    # Check eligibility statistics
    print("\nAnalyzing eligibility criteria...")
    eligible_count = 0
    cancelled_count = 0
    delayed_count = 0
    eu_flight_count = 0
    
    for flight in flights:
        # Check cancellation
        status = flight.get('status', '').lower()
        if "cancel" in status:
            cancelled_count += 1
        
        # Check delay
        delay_minutes = flight.get('delayMinutes', 0)
        if delay_minutes is not None and delay_minutes >= 180:
            delayed_count += 1
        
        # Check EU airports
        departure_airport = flight.get('departure', {}).get('airport', {}).get('iata', '')
        arrival_airport = flight.get('arrival', {}).get('airport', {}).get('iata', '')
        
        eu_airports = ['MAD', 'CDG', 'FRA', 'AMS', 'FCO', 'LHR', 'MUC', 'BCN', 'ATH', 'VIE', 'WAW', 'DUB', 'BRU', 'LIS', 'HEL', 'PRG', 'CPH', 'BUD', 'ARN', 'TXL', 'OTP', 'SOF', 'LJU', 'RIX', 'VNO', 'TLL']
        
        if departure_airport in eu_airports or arrival_airport in eu_airports:
            eu_flight_count += 1
    
    print(f"\nFlights with cancellation: {cancelled_count}")
    print(f"Flights with >= 3 hour delay: {delayed_count}")
    print(f"Flights with EU airport: {eu_flight_count}")
    
    print("\nDetailed eligibility analysis (first 10 flights):")
    print("--------------------------------------------")
    
    eligible_count = 0
    for i, flight in enumerate(flights[:10]):
        is_eligible, reason = is_eligible_for_compensation(flight)
        print(f"Flight {i+1}: {is_eligible} - {reason}")
        if is_eligible:
            eligible_count += 1
    
    print("\nChecking for all eligible flights...")
    all_eligible = []
    
    for flight in flights:
        is_eligible, reason = is_eligible_for_compensation(flight)
        if is_eligible:
            all_eligible.append({
                'flight': flight.get('flight', ''),
                'reason': reason
            })
            eligible_count += 1
    
    print(f"\nTotal eligible flights found: {eligible_count}")
    
    if all_eligible:
        print("\nEligible flights:")
        for flight in all_eligible:
            print(f"- {flight['flight']}: {flight['reason']}")
    else:
        print("\nNo eligible flights found!")
        print("\nPossible issues:")
        print("1. No flights with sufficient delay (>=180 minutes)")
        print("2. No cancelled flights")
        print("3. No flights with EU airports")
        print("4. Data structure issues (delayMinutes field missing or None)")
        print("5. Status field not containing 'cancel' for cancelled flights")

if __name__ == "__main__":
    # Use local file path for testing if provided
    if len(sys.argv) > 1:
        file_path = sys.argv[1]
    else:
        file_path = DATA_FILE if os.path.exists(DATA_FILE) else LOCAL_TEST_FILE
    
    analyze_flight_data(file_path)
