"""
Flight data population script for PythonAnywhere
Populates the flight data JSON file with sample flight data

Usage:
  python populate_flight_data.py

This will create flight data at /home/PiotrS/data/flight_compensation_data.json
"""
import os
import json
import random
from datetime import datetime, timedelta
import uuid

import platform

# Path for flight data storage
if platform.system() == "Windows":
    # Local Windows development path
    DATA_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "data", "flight_compensation_data.json")
else:
    # PythonAnywhere deployment path
    DATA_FILE = "/home/PiotrS/data/flight_compensation_data.json"

# Create data directory if it doesn't exist
os.makedirs(os.path.dirname(DATA_FILE), exist_ok=True)

def generate_flight_id():
    """Generate a unique flight ID"""
    return str(uuid.uuid4())[:8]
    
def _calculate_compensation_amount(distance_km):
    """Calculate EU compensation amount based on flight distance"""
    if distance_km <= 1500:
        return 250  # Short flights (≤ 1500 km): €250
    elif distance_km <= 3500:
        return 400  # Medium flights (1500-3500 km): €400
    else:
        return 600  # Long flights (> 3500 km): €600

def generate_timestamp(hours_offset=None):
    """Generate a timestamp with an offset in hours from now
    
    If hours_offset is None, generates a random timestamp within the last 24 hours
    """
    now = datetime.now()
    
    if hours_offset is None:
        # Generate random timestamp within the last 24 hours
        # Use between 1-24 hours in the past to ensure all flights are from last 24h
        hours_ago = random.uniform(1, 24)  # Between 1 and 24 hours ago
        dt = now - timedelta(hours=hours_ago)
    else:
        dt = now + timedelta(hours=hours_offset)
        
    return dt.isoformat()

def generate_sample_flights(num_eu_to_eu=80, num_eu_to_non_eu=40, num_non_eu_to_non_eu=10):
    """Generate a list of sample flights for EU compensation testing"""
    # Define top 25 EU airports by passenger volume
    eu_airports = [
        # Top 5 busiest
        {"iata": "LHR", "name": "Heathrow Airport", "city": "London", "country": "United Kingdom"},
        {"iata": "CDG", "name": "Charles de Gaulle Airport", "city": "Paris", "country": "France"},
        {"iata": "AMS", "name": "Amsterdam Airport Schiphol", "city": "Amsterdam", "country": "Netherlands"},
        {"iata": "FRA", "name": "Frankfurt Airport", "city": "Frankfurt", "country": "Germany"},
        {"iata": "MAD", "name": "Adolfo Suárez Madrid–Barajas Airport", "city": "Madrid", "country": "Spain"},
        
        # 6-10
        {"iata": "BCN", "name": "Barcelona–El Prat Airport", "city": "Barcelona", "country": "Spain"},
        {"iata": "LGW", "name": "Gatwick Airport", "city": "London", "country": "United Kingdom"},
        {"iata": "MUC", "name": "Munich Airport", "city": "Munich", "country": "Germany"},
        {"iata": "FCO", "name": "Leonardo da Vinci–Fiumicino Airport", "city": "Rome", "country": "Italy"},
        {"iata": "ORY", "name": "Orly Airport", "city": "Paris", "country": "France"},
        
        # 11-15
        {"iata": "DUB", "name": "Dublin Airport", "city": "Dublin", "country": "Ireland"},
        {"iata": "CPH", "name": "Copenhagen Airport", "city": "Copenhagen", "country": "Denmark"},
        {"iata": "PMI", "name": "Palma de Mallorca Airport", "city": "Palma", "country": "Spain"},
        {"iata": "MAN", "name": "Manchester Airport", "city": "Manchester", "country": "United Kingdom"},
        {"iata": "ZRH", "name": "Zurich Airport", "city": "Zurich", "country": "Switzerland"},
        
        # 16-20
        {"iata": "VIE", "name": "Vienna International Airport", "city": "Vienna", "country": "Austria"},
        {"iata": "LIS", "name": "Lisbon Airport", "city": "Lisbon", "country": "Portugal"},
        {"iata": "AYT", "name": "Antalya Airport", "city": "Antalya", "country": "Turkey"},
        {"iata": "ARN", "name": "Stockholm Arlanda Airport", "city": "Stockholm", "country": "Sweden"},
        {"iata": "BRU", "name": "Brussels Airport", "city": "Brussels", "country": "Belgium"},
        
        # 21-25
        {"iata": "WAW", "name": "Warsaw Chopin Airport", "city": "Warsaw", "country": "Poland"},
        {"iata": "ATH", "name": "Athens International Airport", "city": "Athens", "country": "Greece"},
        {"iata": "HEL", "name": "Helsinki Airport", "city": "Helsinki", "country": "Finland"},
        {"iata": "PRG", "name": "Václav Havel Airport Prague", "city": "Prague", "country": "Czech Republic"},
        {"iata": "BUD", "name": "Budapest Ferenc Liszt International Airport", "city": "Budapest", "country": "Hungary"},
        
        # Additional Polish airports
        {"iata": "KRK", "name": "Kraków John Paul II International Airport", "city": "Kraków", "country": "Poland"},
        {"iata": "KTW", "name": "Katowice International Airport", "city": "Katowice", "country": "Poland"},
        {"iata": "GDN", "name": "Gdańsk Lech Wałęsa Airport", "city": "Gdańsk", "country": "Poland"},
        {"iata": "RZE", "name": "Rzeszów-Jasionka Airport", "city": "Rzeszów", "country": "Poland"}
    ]
    
    # Define non-EU airports
    non_eu_airports = [
        {"iata": "JFK", "name": "John F. Kennedy International Airport", "city": "New York", "country": "United States"},
        {"iata": "LAX", "name": "Los Angeles International Airport", "city": "Los Angeles", "country": "United States"},
        {"iata": "DXB", "name": "Dubai International Airport", "city": "Dubai", "country": "United Arab Emirates"},
        {"iata": "HND", "name": "Haneda Airport", "city": "Tokyo", "country": "Japan"},
        {"iata": "SYD", "name": "Sydney Airport", "city": "Sydney", "country": "Australia"},
    ]
    
    # Define airlines
    airlines = [
        # Major traditional carriers
        {"name": "Lufthansa", "iata": "LH"},
        {"name": "Air France", "iata": "AF"},
        {"name": "British Airways", "iata": "BA"},
        {"name": "KLM", "iata": "KL"},
        {"name": "Iberia", "iata": "IB"},
        {"name": "Emirates", "iata": "EK"},
        {"name": "Delta Air Lines", "iata": "DL"},
        {"name": "United Airlines", "iata": "UA"},
        {"name": "LOT Polish Airlines", "iata": "LO"},
        
        # Low-cost carriers
        {"name": "Ryanair", "iata": "FR"},
        {"name": "Wizz Air", "iata": "W6"},
        {"name": "easyJet", "iata": "U2"},
        {"name": "Eurowings", "iata": "EW"},
        {"name": "Vueling Airlines", "iata": "VY"},
        
        # Additional carriers
        {"name": "TAP Air Portugal", "iata": "TP"},
    ]
    
    flights = []
    
    # Generate flights between EU airports (30 flights)
    for _ in range(num_eu_to_eu):
        departure_airport = random.choice(eu_airports)
        arrival_airport = random.choice([a for a in eu_airports if a != departure_airport])
        
        # Use last 24 hours for all flights
        # Random timestamp in the past 24 hours
        timestamp = generate_timestamp()
        
        # Random status - USE LOWERCASE for the app
        # Increasing probability of eligible flights (delayed/cancelled)
        status = random.choice(["delayed", "delayed", "cancelled", "scheduled"])
        
        # Random delay minutes for delayed flights
        delay_minutes = 0
        if status == "delayed":
            # Almost all delayed flights will be eligible (3+ hours delay)
            delay_minutes = random.randint(180, 720)  # 3-12 hours delay (ensuring compensation eligibility)
        elif status == "cancelled":
            delay_minutes = 0
        
        # Calculate distance (simplified)
        distance_km = random.randint(500, 3000)
        
        # Determine EU compensation eligibility based on delay and distance
        eu_compensation_eligible = False
        if status == "cancelled":
            eu_compensation_eligible = True
        elif status == "delayed" and delay_minutes >= 180:  # 3+ hour delay
            eu_compensation_eligible = True
        
        # Choose an airline
        airline = random.choice(airlines)
        
        # Generate flight ID - should match airline code
        flight_number = f"{airline['iata']}{random.randint(1000, 9999)}"
        
        # Generate a unique ID for the flight
        unique_id = generate_flight_id()
        
        # Format fields according to what the app expects
        flight = {
            "id": unique_id,
            "flight_number": flight_number,
            "flight_iata": flight_number,  # Add this field for API compatibility
            "airline_name": airline["name"],
            "airline_iata": airline["iata"],
            "departure_airport_iata": departure_airport["iata"],
            "departure_airport_name": departure_airport["name"],
            "departure_city": departure_airport["city"],
            "departure_country": departure_airport["country"],
            "arrival_airport_iata": arrival_airport["iata"],
            "arrival_airport_name": arrival_airport["name"],
            "arrival_city": arrival_airport["city"],
            "arrival_country": arrival_airport["country"],
            "departure_scheduled_time": timestamp,
            "departure_actual_time": timestamp if status != "delayed" else (datetime.fromisoformat(timestamp) + timedelta(minutes=delay_minutes)).isoformat(),
            "arrival_scheduled_time": (datetime.fromisoformat(timestamp) + timedelta(hours=random.uniform(1, 5))).isoformat(),
            "arrival_actual_time": None if status == "cancelled" else (datetime.fromisoformat(timestamp) + timedelta(hours=random.uniform(1, 5), minutes=delay_minutes if status == "delayed" else 0)).isoformat(),
            "status": status,
            "delay_minutes": delay_minutes,
            "distance_km": distance_km,
            "eu_compensation_eligible": eu_compensation_eligible,
            "compensation_amount_eur": _calculate_compensation_amount(distance_km) if eu_compensation_eligible else 0
        }
        
        flights.append(flight)
    
    # Generate EU to non-EU flights (eligible)
    for i in range(20):  # 20 EU to non-EU flights
        # Select random airports
        departure_airport = eu_airports[i % len(eu_airports)]
        arrival_airport = non_eu_airports[i % len(non_eu_airports)]
        
        # Select random airline
        airline = airlines[(i + 2) % len(airlines)]
        
        # Create flight details with realistic delays
        delay_minutes = 0
        if i % 2 == 0:  # 1/2 of flights will have delays
            delay_minutes = random.randint(210, 480)  # Delays between 3.5 and 8 hours for long flights
        
        # Status in lowercase to match EU-EU flights
        status = "cancelled" if i % 4 == 0 else ("delayed" if delay_minutes > 0 else "scheduled")
        
        # Generate departure time (random within last 24 hours)
        timestamp = generate_timestamp(None)  # Random within last 24h
        
        # Calculate arrival based on departure (longer flights for international)
        flight_duration_hours = random.uniform(6, 12)  # Reasonable international flight duration
        
        # Distance for long-haul flights
        distance_km = 5000 + i * 500
        
        # Determine EU compensation eligibility (same logic as EU-EU flights)
        eu_compensation_eligible = False
        if status == "cancelled":
            eu_compensation_eligible = True
        elif status == "delayed" and delay_minutes >= 180:  # 3+ hour delay
            eu_compensation_eligible = True
        
        # Generate flight ID matching airline
        flight_number = f"{airline['iata']}{2000 + i}"
        
        # Generate a unique ID for the flight
        unique_id = generate_flight_id()
        
        # Format fields in flat structure, exactly like EU-EU flights
        flight = {
            "id": unique_id,
            "flight_number": flight_number,
            "flight_iata": flight_number,
            "airline_name": airline["name"],
            "airline_iata": airline["iata"],
            "departure_airport_iata": departure_airport["iata"],
            "departure_airport_name": departure_airport["name"],
            "departure_city": departure_airport["city"],
            "departure_country": departure_airport["country"],
            "arrival_airport_iata": arrival_airport["iata"],
            "arrival_airport_name": arrival_airport["name"],
            "arrival_city": arrival_airport["city"],
            "arrival_country": arrival_airport["country"],
            "departure_scheduled_time": timestamp,
            "departure_actual_time": timestamp if status != "delayed" else (datetime.fromisoformat(timestamp) + timedelta(minutes=delay_minutes)).isoformat(),
            "arrival_scheduled_time": (datetime.fromisoformat(timestamp) + timedelta(hours=flight_duration_hours)).isoformat(),
            "arrival_actual_time": None if status == "cancelled" else (datetime.fromisoformat(timestamp) + timedelta(hours=flight_duration_hours, minutes=delay_minutes if status == "delayed" else 0)).isoformat(),
            "status": status,
            "delay_minutes": delay_minutes,
            "distance_km": distance_km,
            "eu_compensation_eligible": eu_compensation_eligible,
            "compensation_amount_eur": _calculate_compensation_amount(distance_km) if eu_compensation_eligible else 0
        }
        flights.append(flight)
    
    # Generate non-EU to non-EU flights (not eligible)
    for i in range(10):  # 10 non-EU to non-EU flights
        # Select random airports
        departure_airport = non_eu_airports[i % len(non_eu_airports)]
        arrival_airport = non_eu_airports[(i + 2) % len(non_eu_airports)]
        
        # Select random airline
        airline = airlines[(i + 4) % len(airlines)]
        
        # Create flight details with realistic delays
        delay_minutes = 0
        if i % 2 == 0:  # 1/2 of flights will have delays
            delay_minutes = random.randint(240, 600)  # Delays between 4 and 10 hours for long flights
        
        # Status in lowercase to match other sections
        status = "cancelled" if i % 3 == 0 else ("delayed" if delay_minutes > 0 else "scheduled")
        
        # Generate departure time (random within last 24 hours)
        timestamp = generate_timestamp(None)  # Random within last 24h
        
        # Calculate arrival based on departure (longer flights for international)
        flight_duration_hours = random.uniform(8, 14)  # Reasonable long-haul flight duration
        
        # Distance for long-haul flights
        distance_km = 8000 + i * 1000
        
        # Non-EU to Non-EU flights are not eligible for compensation
        eu_compensation_eligible = False
        
        # Generate flight ID matching airline
        flight_number = f"{airline['iata']}{3000 + i}"
        
        # Generate a unique ID for the flight
        unique_id = generate_flight_id()
        
        # Format fields in flat structure, exactly like other flight sections
        flight = {
            "id": unique_id,
            "flight_number": flight_number,
            "flight_iata": flight_number,
            "airline_name": airline["name"],
            "airline_iata": airline["iata"],
            "departure_airport_iata": departure_airport["iata"],
            "departure_airport_name": departure_airport["name"],
            "departure_city": departure_airport["city"],
            "departure_country": departure_airport["country"],
            "arrival_airport_iata": arrival_airport["iata"],
            "arrival_airport_name": arrival_airport["name"],
            "arrival_city": arrival_airport["city"],
            "arrival_country": arrival_airport["country"],
            "departure_scheduled_time": timestamp,
            "departure_actual_time": timestamp if status != "delayed" else (datetime.fromisoformat(timestamp) + timedelta(minutes=delay_minutes)).isoformat(),
            "arrival_scheduled_time": (datetime.fromisoformat(timestamp) + timedelta(hours=flight_duration_hours)).isoformat(),
            "arrival_actual_time": None if status == "cancelled" else (datetime.fromisoformat(timestamp) + timedelta(hours=flight_duration_hours, minutes=delay_minutes if status == "delayed" else 0)).isoformat(),
            "status": status,
            "delay_minutes": delay_minutes,
            "distance_km": distance_km,
            "eu_compensation_eligible": eu_compensation_eligible,
            "compensation_amount_eur": 0  # Always 0 for non-eligible flights
        }
        flights.append(flight)
    
    return flights

def main():
    """Main function to populate flight data"""
    print("Generating sample flight data...")
    flights = generate_sample_flights()
    print(f"Generated {len(flights)} sample flights")
    
    # Save to JSON file
    data = {"flights": flights}
    with open(DATA_FILE, "w") as f:
        json.dump(data, f, indent=2)
    
    print(f"Flight data saved to {DATA_FILE}")
    print("Done!")

if __name__ == "__main__":
    main()
