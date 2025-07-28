"""
Flight data generator for Flight Compensation app
Creates sample flights with proper eligibility attributes for EU compensation
"""
import os
import json
import random
from datetime import datetime, timedelta

# Configuration
OUTPUT_FILE = "/home/PiotrS/data/flight_compensation_data.json"
NUM_FLIGHTS = 120
EU_FLIGHT_PERCENTAGE = 40  # Percentage of flights with EU airports
DELAY_PERCENTAGE = 30      # Percentage of delayed flights
CANCEL_PERCENTAGE = 15     # Percentage of cancelled flights
MIN_DELAY_MINUTES = 30
MAX_DELAY_MINUTES = 480    # Up to 8 hours delay

# EU airports - commonly used in European flights
EU_AIRPORTS = [
    {"iata": "MAD", "name": "Madrid Barajas Airport", "country": "Spain"},
    {"iata": "CDG", "name": "Paris Charles de Gaulle Airport", "country": "France"},
    {"iata": "FRA", "name": "Frankfurt Airport", "country": "Germany"},
    {"iata": "AMS", "name": "Amsterdam Schiphol Airport", "country": "Netherlands"},
    {"iata": "FCO", "name": "Rome Fiumicino Airport", "country": "Italy"},
    {"iata": "LHR", "name": "London Heathrow Airport", "country": "United Kingdom"},
    {"iata": "MUC", "name": "Munich Airport", "country": "Germany"},
    {"iata": "BCN", "name": "Barcelona El Prat Airport", "country": "Spain"},
    {"iata": "ATH", "name": "Athens International Airport", "country": "Greece"},
    {"iata": "VIE", "name": "Vienna International Airport", "country": "Austria"},
    {"iata": "WAW", "name": "Warsaw Chopin Airport", "country": "Poland"},
    {"iata": "CPH", "name": "Copenhagen Airport", "country": "Denmark"},
    {"iata": "LIS", "name": "Lisbon Airport", "country": "Portugal"},
    {"iata": "HEL", "name": "Helsinki Airport", "country": "Finland"},
    {"iata": "BRU", "name": "Brussels Airport", "country": "Belgium"}
]

# Non-EU airports
NON_EU_AIRPORTS = [
    {"iata": "JFK", "name": "John F. Kennedy International Airport", "country": "United States"},
    {"iata": "LAX", "name": "Los Angeles International Airport", "country": "United States"},
    {"iata": "ORD", "name": "Chicago O'Hare International Airport", "country": "United States"},
    {"iata": "DXB", "name": "Dubai International Airport", "country": "United Arab Emirates"},
    {"iata": "HND", "name": "Tokyo Haneda Airport", "country": "Japan"},
    {"iata": "SIN", "name": "Singapore Changi Airport", "country": "Singapore"},
    {"iata": "ICN", "name": "Incheon International Airport", "country": "South Korea"},
    {"iata": "YYZ", "name": "Toronto Pearson International Airport", "country": "Canada"},
    {"iata": "SYD", "name": "Sydney Airport", "country": "Australia"},
    {"iata": "GRU", "name": "São Paulo/Guarulhos International Airport", "country": "Brazil"},
    {"iata": "DEL", "name": "Indira Gandhi International Airport", "country": "India"},
    {"iata": "IST", "name": "Istanbul Airport", "country": "Turkey"},
    {"iata": "DOH", "name": "Hamad International Airport", "country": "Qatar"},
    {"iata": "CAN", "name": "Guangzhou Baiyun International Airport", "country": "China"},
    {"iata": "JNB", "name": "O. R. Tambo International Airport", "country": "South Africa"}
]

# Airlines with IATA codes
AIRLINES = [
    {"name": "Lufthansa", "iata": "LH"},
    {"name": "British Airways", "iata": "BA"},
    {"name": "Air France", "iata": "AF"},
    {"name": "KLM Royal Dutch Airlines", "iata": "KL"},
    {"name": "Ryanair", "iata": "FR"},
    {"name": "Wizz Air", "iata": "W6"},
    {"name": "easyJet", "iata": "U2"},
    {"name": "Eurowings", "iata": "EW"},
    {"name": "Vueling Airlines", "iata": "VY"},
    {"name": "TAP Air Portugal", "iata": "TP"},
    {"name": "Iberia", "iata": "IB"},
    {"name": "SAS Scandinavian Airlines", "iata": "SK"},
    {"name": "LOT Polish Airlines", "iata": "LO"},
    {"name": "Finnair", "iata": "AY"},
    {"name": "Alitalia", "iata": "AZ"}
]

# Flight statuses
STATUSES = ["SCHEDULED", "DELAYED", "CANCELLED"]

def generate_flight_number(airline_iata):
    """Generate a realistic flight number"""
    return f"{airline_iata}{random.randint(100, 9999)}"

def generate_datetime_within_days(days=3):
    """Generate a datetime within the last few days"""
    now = datetime.now()
    random_hours = random.randint(0, days * 24)
    flight_time = now - timedelta(hours=random_hours)
    return flight_time.strftime("%Y-%m-%dT%H:%M:%S.000Z")

def calculate_flight_distance(is_long_haul):
    """Calculate realistic flight distance based on short/long haul"""
    if is_long_haul:
        return random.randint(2000, 10000)
    else:
        return random.randint(300, 1999)

def generate_flights(count=100):
    """Generate sample flight data"""
    flights = []
    
    # Track how many eligible flights we're creating for debugging
    eligible_count = 0
    
    for _ in range(count):
        # Determine if this should be an EU flight
        is_eu_flight = random.random() < (EU_FLIGHT_PERCENTAGE / 100)
        
        # Determine if this should be a delayed flight with compensation-eligible delay
        is_eligible_delay = random.random() < (DELAY_PERCENTAGE / 100)
        
        # Determine if this should be a cancelled flight
        is_cancelled = not is_eligible_delay and random.random() < (CANCEL_PERCENTAGE / 100)
        
        # Flight characteristics
        is_long_haul = random.random() < 0.4
        
        # Select airline
        airline = random.choice(AIRLINES)
        
        # Select airports based on EU flight status
        if is_eu_flight:
            # Either departure or arrival (or both) should be an EU airport
            if random.random() < 0.5:
                # EU departure, non-EU arrival
                departure_airport = random.choice(EU_AIRPORTS)
                arrival_airport = random.choice(NON_EU_AIRPORTS)
            else:
                # Non-EU departure, EU arrival
                departure_airport = random.choice(NON_EU_AIRPORTS)
                arrival_airport = random.choice(EU_AIRPORTS)
        else:
            # Non-EU flight (both airports outside EU)
            departure_airport = random.choice(NON_EU_AIRPORTS)
            arrival_airport = random.choice(NON_EU_AIRPORTS)
            while arrival_airport["iata"] == departure_airport["iata"]:
                arrival_airport = random.choice(NON_EU_AIRPORTS)
        
        # Generate flight times
        departure_time = generate_datetime_within_days(3)
        flight_duration_minutes = random.randint(60, 600)  # 1-10 hours
        arrival_time_dt = datetime.strptime(departure_time, "%Y-%m-%dT%H:%M:%S.000Z") + timedelta(minutes=flight_duration_minutes)
        arrival_time = arrival_time_dt.strftime("%Y-%m-%dT%H:%M:%S.000Z")
        
        # Generate delay based on status
        delay_minutes = 0
        status = "SCHEDULED"
        
        if is_cancelled:
            status = "CANCELLED"
            delay_minutes = 0
        elif is_eligible_delay:
            status = "DELAYED"
            # For eligible flights, ensure delay is at least 180 minutes (3 hours)
            delay_minutes = random.randint(180, MAX_DELAY_MINUTES)
        else:
            # For non-eligible delayed flights
            if random.random() < 0.3:  # 30% of non-eligible flights have some delay
                status = "DELAYED"
                delay_minutes = random.randint(MIN_DELAY_MINUTES, 179)  # Less than 3 hours
        
        # Calculate distance
        distance_km = calculate_flight_distance(is_long_haul)
        
        # Determine if this flight should be eligible for compensation
        is_eligible = is_eu_flight and (is_cancelled or delay_minutes >= 180)
        
        if is_eligible:
            eligible_count += 1
        
        # Create flight object
        flight = {
            "flight": generate_flight_number(airline["iata"]),
            "status": status,
            "delayMinutes": delay_minutes,
            "airline": {
                "name": airline["name"],
                "iata": airline["iata"]
            },
            "departure": {
                "airport": departure_airport,
                "scheduled": departure_time,
                "terminal": str(random.randint(1, 5)),
                "gate": random.choice(["A", "B", "C", "D"]) + str(random.randint(1, 20))
            },
            "arrival": {
                "airport": arrival_airport,
                "scheduled": arrival_time,
                "terminal": str(random.randint(1, 5)),
                "gate": random.choice(["A", "B", "C", "D"]) + str(random.randint(1, 20))
            },
            "aircraft": {
                "model": random.choice(["Boeing 737", "Airbus A320", "Boeing 787", "Airbus A380", "Embraer E190"]),
                "registration": f"{random.choice(['N', 'G', 'D', 'F', 'SP'])}-{random.choice(['ABC', 'XYZ', 'JKL'])}{random.randint(100, 999)}"
            },
            "distance_km": distance_km,
            # Adding this field to help in debugging but it won't affect the eligibility calculation
            "_debug_eligible": is_eligible
        }
        
        flights.append(flight)
    
    print(f"Generated {count} flights, {eligible_count} are eligible for EU compensation")
    return flights

def save_flight_data(flights):
    """Save flight data to JSON file"""
    data = {"flights": flights}
    
    # Create directory if it doesn't exist
    os.makedirs(os.path.dirname(OUTPUT_FILE), exist_ok=True)
    
    with open(OUTPUT_FILE, 'w') as f:
        json.dump(data, f, indent=2)
    
    print(f"Flight data saved to {OUTPUT_FILE}")
    print(f"Total flights: {len(flights)}")

def main():
    """Main function"""
    print(f"Generating {NUM_FLIGHTS} flights...")
    flights = generate_flights(NUM_FLIGHTS)
    save_flight_data(flights)
    print("Done!")

if __name__ == "__main__":
    main()
