"""
Add test flight data to demonstrate EU261 compensation eligibility detection.
This script adds a mix of delayed and cancelled flights from various EU airports.
"""

import json
import os
import datetime

# Path to flight data file - will be uploaded to PythonAnywhere
DATA_FILE = "test_flight_data.json"

# Generate current timestamp in ISO format
now = datetime.datetime.now()
today = now.strftime("%Y-%m-%d")
timestamp = now.strftime("%Y-%m-%dT%H:%M:%S")

# Create test flight data
test_flights = {
    "flights": [
        # Cancelled flight from Warsaw to London
        {
            "flight_number": "LO281",
            "airline": "LO",
            "airline_name": "LOT Polish Airlines",
            "departure_airport": "WAW",
            "departure_date": f"{today}",
            "arrival_airport": "LHR",
            "arrival_date": f"{today}",
            "status": "Cancelled",
            "delay_minutes": 0,
            "distance_km": 1450,
            "compensation_amount_eur": 250,
            "eligible_for_compensation": True
        },
        # Cancelled flight from Paris to Berlin
        {
            "flight_number": "AF1734",
            "airline": "AF",
            "airline_name": "Air France",
            "departure_airport": "CDG",
            "departure_date": f"{today}",
            "arrival_airport": "BER",
            "arrival_date": f"{today}",
            "status": "Cancelled",
            "delay_minutes": 0,
            "distance_km": 880,
            "compensation_amount_eur": 250,
            "eligible_for_compensation": True
        },
        # Cancelled flight from Rome to Madrid
        {
            "flight_number": "AZ74",
            "airline": "AZ",
            "airline_name": "Alitalia",
            "departure_airport": "FCO",
            "departure_date": f"{today}",
            "arrival_airport": "MAD",
            "arrival_date": f"{today}",
            "status": "Cancelled",
            "delay_minutes": 0,
            "distance_km": 1360,
            "compensation_amount_eur": 250,
            "eligible_for_compensation": True
        },
        # Delayed flight from Amsterdam to Lisbon
        {
            "flight_number": "KL1695",
            "airline": "KL",
            "airline_name": "KLM",
            "departure_airport": "AMS",
            "departure_date": f"{today}",
            "arrival_airport": "LIS",
            "arrival_date": f"{today}",
            "status": "Delayed",
            "delay_minutes": 195,
            "distance_km": 1860,
            "compensation_amount_eur": 400,
            "eligible_for_compensation": True
        },
        # Delayed flight from Vienna to Copenhagen
        {
            "flight_number": "OS305",
            "airline": "OS",
            "airline_name": "Austrian Airlines",
            "departure_airport": "VIE",
            "departure_date": f"{today}",
            "arrival_airport": "CPH",
            "arrival_date": f"{today}",
            "status": "Delayed",
            "delay_minutes": 210,
            "distance_km": 720,
            "compensation_amount_eur": 250,
            "eligible_for_compensation": True
        }
    ]
}

# Save to file
with open(DATA_FILE, "w") as f:
    json.dump(test_flights, f, indent=2)

print(f"Test flight data saved to {DATA_FILE}")
print(f"Added {len(test_flights['flights'])} test flights:")
print(f"- 3 cancelled flights from various EU airports")
print(f"- 2 delayed flights (3+ hours) from various EU airports")
print("\nUpload this file to PythonAnywhere and run the following command:")
print("python -c \"import json; old=json.load(open('data/flight_compensation_data.json')); new=json.load(open('test_flight_data.json')); old['flights'].extend(new['flights']); json.dump(old, open('data/flight_compensation_data.json', 'w'), indent=2)\"")
