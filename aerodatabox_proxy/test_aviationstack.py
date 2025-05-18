"""
Test script for AviationStack API integration
"""

import requests
import json

API_KEY = "9cb5db4ba59f1e5005591c572d8b5f1c"

def test_aviationstack_api():
    """Simple test to verify the AviationStack API is working"""
    print("Testing AviationStack API...")
    
    # Endpoint for real-time flights
    url = "http://api.aviationstack.com/v1/flights"
    
    # Parameters
    params = {
        "access_key": API_KEY,
        "limit": 5  # Just get a few flights
    }
    
    try:
        response = requests.get(url, params=params)
        response.raise_for_status()
        
        data = response.json()
        
        if "error" in data:
            print(f"API Error: {data['error']}")
            return False
        
        flights = data.get("data", [])
        print(f"Success! Retrieved {len(flights)} flights.")
        
        # Print the first flight details
        if flights:
            print("\nExample flight:")
            flight = flights[0]
            print(f"Flight Number: {flight.get('flight', {}).get('iata')}")
            print(f"Airline: {flight.get('airline', {}).get('name')}")
            print(f"Status: {flight.get('flight_status')}")
            print(f"From: {flight.get('departure', {}).get('airport')}")
            print(f"To: {flight.get('arrival', {}).get('airport')}")
        
        return True
    
    except Exception as e:
        print(f"Error testing API: {e}")
        return False

if __name__ == "__main__":
    success = test_aviationstack_api()
    print(f"\nTest {'passed' if success else 'failed'}")
