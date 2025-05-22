"""
Check for cancelled flights in the database.
Run this on PythonAnywhere to analyze your flight data.
"""
import json
import sys

def main():
    try:
        # Load flight data
        with open('data/flight_compensation_data.json', 'r') as f:
            data = json.load(f)
        
        flights = data.get('flights', [])
        total = len(flights)
        print(f"Total flights: {total}")
        
        # Count delayed flights
        delayed = sum(1 for f in flights if f.get('delay', 0) >= 180)
        print(f"Delayed flights (3+ hrs): {delayed}")
        
        # Count cancelled flights
        cancelled = sum(1 for f in flights if 'cancel' in str(f.get('status', '')).lower())
        print(f"Cancelled flights: {cancelled}")
        
        # Show examples of cancelled flights
        if cancelled > 0:
            print("\nSample cancelled flights:")
            count = 0
            for flight in flights:
                if 'cancel' in str(flight.get('status', '')).lower():
                    flight_num = flight.get('flight', 'Unknown')
                    status = flight.get('status', 'Unknown')
                    dep = flight.get('departure', {}).get('airport', {}).get('iata', 'Unknown')
                    arr = flight.get('arrival', {}).get('airport', {}).get('iata', 'Unknown')
                    print(f"{flight_num}: {dep}-{arr} - {status}")
                    count += 1
                    if count >= 5:
                        break
            
            if cancelled > 5:
                print(f"... and {cancelled - 5} more cancelled flights")
        
        # Check for eligible flights
        eligible = sum(1 for f in flights if f.get('eligible_for_compensation', False))
        print(f"\nEligible for compensation: {eligible}")
        
        return 0
    except Exception as e:
        print(f"Error: {e}")
        return 1

if __name__ == "__main__":
    sys.exit(main())
