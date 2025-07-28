"""
Enhanced flight data population script for PythonAnywhere
Populates the flight data JSON file with realistic flight data

Usage:
  python enhanced_populate_flight_data.py

This will create flight data at /home/PiotrS/data/flight_compensation_data.json

Statistics:
- Generates ~1000 flights (configurable)
- European flight statistics based on Eurocontrol data
- Realistic delay/cancellation rates (1-2% eligible for compensation)
"""
import os
import json
import random
from datetime import datetime, timedelta
import uuid
import math
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

def generate_realistic_flights(num_flights=1000):
    """Generate a list of realistic flights based on European aviation statistics
    
    Based on Eurocontrol data:
    - ~20,000-25,000 flights per day in Europe
    - ~1-2% are eligible for compensation (delayed >3h or cancelled)
    - This yields ~200-500 eligible flights per day
    
    We'll generate ~1000 flights with 1-2% eligible (10-20 flights)
    """
    # Define major airlines with IATA codes
    airlines = [
        # Major EU carriers
        {"name": "Lufthansa", "iata": "LH"},
        {"name": "Air France", "iata": "AF"},
        {"name": "British Airways", "iata": "BA"},
        {"name": "KLM Royal Dutch Airlines", "iata": "KL"},
        {"name": "Iberia", "iata": "IB"},
        {"name": "Alitalia", "iata": "AZ"},
        {"name": "SAS Scandinavian Airlines", "iata": "SK"},
        {"name": "Swiss International Air Lines", "iata": "LX"},
        {"name": "Austrian Airlines", "iata": "OS"},
        {"name": "Brussels Airlines", "iata": "SN"},
        {"name": "LOT Polish Airlines", "iata": "LO"},
        {"name": "TAP Air Portugal", "iata": "TP"},
        {"name": "Finnair", "iata": "AY"},
        {"name": "Aer Lingus", "iata": "EI"},
        {"name": "Aegean Airlines", "iata": "A3"},
        
        # Low-cost carriers
        {"name": "Ryanair", "iata": "FR"},
        {"name": "easyJet", "iata": "U2"},
        {"name": "Wizz Air", "iata": "W6"},
        {"name": "Vueling Airlines", "iata": "VY"},
        {"name": "Eurowings", "iata": "EW"},
        {"name": "Norwegian Air Shuttle", "iata": "DY"},
        {"name": "Transavia", "iata": "HV"},
        
        # Other major international carriers
        {"name": "Emirates", "iata": "EK"},
        {"name": "Qatar Airways", "iata": "QR"},
        {"name": "Turkish Airlines", "iata": "TK"},
        {"name": "United Airlines", "iata": "UA"},
        {"name": "American Airlines", "iata": "AA"},
        {"name": "Delta Air Lines", "iata": "DL"},
    ]

    # Define major European airports
    eu_airports = [
        # Western Europe
        {"iata": "LHR", "name": "Heathrow Airport", "city": "London", "country": "United Kingdom"},
        {"iata": "LGW", "name": "Gatwick Airport", "city": "London", "country": "United Kingdom"},
        {"iata": "STN", "name": "Stansted Airport", "city": "London", "country": "United Kingdom"},
        {"iata": "MAN", "name": "Manchester Airport", "city": "Manchester", "country": "United Kingdom"},
        {"iata": "CDG", "name": "Charles de Gaulle Airport", "city": "Paris", "country": "France"},
        {"iata": "ORY", "name": "Orly Airport", "city": "Paris", "country": "France"},
        {"iata": "NCE", "name": "Nice Côte d'Azur Airport", "city": "Nice", "country": "France"},
        {"iata": "FRA", "name": "Frankfurt Airport", "city": "Frankfurt", "country": "Germany"},
        {"iata": "MUC", "name": "Munich Airport", "city": "Munich", "country": "Germany"},
        {"iata": "DUS", "name": "Düsseldorf Airport", "city": "Düsseldorf", "country": "Germany"},
        {"iata": "TXL", "name": "Berlin Tegel Airport", "city": "Berlin", "country": "Germany"},
        {"iata": "AMS", "name": "Amsterdam Airport Schiphol", "city": "Amsterdam", "country": "Netherlands"},
        {"iata": "BRU", "name": "Brussels Airport", "city": "Brussels", "country": "Belgium"},
        {"iata": "ZRH", "name": "Zurich Airport", "city": "Zurich", "country": "Switzerland"},
        {"iata": "GVA", "name": "Geneva Airport", "city": "Geneva", "country": "Switzerland"},
        {"iata": "VIE", "name": "Vienna International Airport", "city": "Vienna", "country": "Austria"},

        # Southern Europe
        {"iata": "MAD", "name": "Adolfo Suárez Madrid–Barajas Airport", "city": "Madrid", "country": "Spain"},
        {"iata": "BCN", "name": "Barcelona–El Prat Airport", "city": "Barcelona", "country": "Spain"},
        {"iata": "PMI", "name": "Palma de Mallorca Airport", "city": "Palma", "country": "Spain"},
        {"iata": "AGP", "name": "Málaga Airport", "city": "Málaga", "country": "Spain"},
        {"iata": "FCO", "name": "Leonardo da Vinci–Fiumicino Airport", "city": "Rome", "country": "Italy"},
        {"iata": "MXP", "name": "Milan Malpensa Airport", "city": "Milan", "country": "Italy"},
        {"iata": "VCE", "name": "Venice Marco Polo Airport", "city": "Venice", "country": "Italy"},
        {"iata": "ATH", "name": "Athens International Airport", "city": "Athens", "country": "Greece"},
        {"iata": "LIS", "name": "Lisbon Airport", "city": "Lisbon", "country": "Portugal"},

        # Northern Europe
        {"iata": "CPH", "name": "Copenhagen Airport", "city": "Copenhagen", "country": "Denmark"},
        {"iata": "ARN", "name": "Stockholm Arlanda Airport", "city": "Stockholm", "country": "Sweden"},
        {"iata": "OSL", "name": "Oslo Airport, Gardermoen", "city": "Oslo", "country": "Norway"},
        {"iata": "HEL", "name": "Helsinki Airport", "city": "Helsinki", "country": "Finland"},
        {"iata": "DUB", "name": "Dublin Airport", "city": "Dublin", "country": "Ireland"},

        # Eastern Europe
        {"iata": "WAW", "name": "Warsaw Chopin Airport", "city": "Warsaw", "country": "Poland"},
        {"iata": "KRK", "name": "John Paul II International Airport Kraków–Balice", "city": "Kraków", "country": "Poland"},
        {"iata": "PRG", "name": "Václav Havel Airport Prague", "city": "Prague", "country": "Czech Republic"},
        {"iata": "BUD", "name": "Budapest Ferenc Liszt International Airport", "city": "Budapest", "country": "Hungary"},
        {"iata": "OTP", "name": "Henri Coandă International Airport", "city": "Bucharest", "country": "Romania"},
        {"iata": "SOF", "name": "Sofia Airport", "city": "Sofia", "country": "Bulgaria"},
    ]

    # Define non-EU international airports for connecting flights
    international_airports = [
        {"iata": "JFK", "name": "John F. Kennedy International Airport", "city": "New York", "country": "United States"},
        {"iata": "LAX", "name": "Los Angeles International Airport", "city": "Los Angeles", "country": "United States"},
        {"iata": "ORD", "name": "O'Hare International Airport", "city": "Chicago", "country": "United States"},
        {"iata": "DFW", "name": "Dallas/Fort Worth International Airport", "city": "Dallas", "country": "United States"},
        {"iata": "YYZ", "name": "Toronto Pearson International Airport", "city": "Toronto", "country": "Canada"},
        {"iata": "YVR", "name": "Vancouver International Airport", "city": "Vancouver", "country": "Canada"},
        {"iata": "DXB", "name": "Dubai International Airport", "city": "Dubai", "country": "United Arab Emirates"},
        {"iata": "DOH", "name": "Hamad International Airport", "city": "Doha", "country": "Qatar"},
        {"iata": "IST", "name": "Istanbul Airport", "city": "Istanbul", "country": "Turkey"},
        {"iata": "SIN", "name": "Singapore Changi Airport", "city": "Singapore", "country": "Singapore"},
        {"iata": "HKG", "name": "Hong Kong International Airport", "city": "Hong Kong", "country": "China"},
        {"iata": "PEK", "name": "Beijing Capital International Airport", "city": "Beijing", "country": "China"},
        {"iata": "NRT", "name": "Narita International Airport", "city": "Tokyo", "country": "Japan"},
        {"iata": "SYD", "name": "Sydney Airport", "city": "Sydney", "country": "Australia"},
        {"iata": "GRU", "name": "São Paulo/Guarulhos International Airport", "city": "São Paulo", "country": "Brazil"},
    ]
    
    # Predefined distance ranges for different flight types
    distance_ranges = {
        "short": (300, 1500),    # Short-haul (e.g., London-Paris)
        "medium": (1501, 3500),  # Medium-haul (e.g., London-Istanbul)
        "long": (3501, 12000)    # Long-haul (e.g., London-New York)
    }
    
    # Define flight status probabilities
    # Based on real-world statistics: ~1-2% of flights eligible for compensation
    status_probabilities = {
        "ON_TIME": 75,      # 75% on time
        "DELAYED": 23.5,    # 23.5% minor delays (<3h)
        "DELAYED_COMP": 1,  # 1% significant delays (>3h) - eligible for compensation
        "CANCELLED": 0.5    # 0.5% cancelled - eligible for compensation
    }
    
    # Generate the flights
    flights = []
    
    # Calculate how many flights should be EU-to-EU vs EU-to-International
    eu_to_eu_count = int(num_flights * 0.7)  # 70% EU to EU
    eu_to_intl_count = int(num_flights * 0.3)  # 30% EU to international
    
    # Calculate how many flights should be eligible for compensation (1-2%)
    total_eligible = int(num_flights * random.uniform(0.01, 0.02))
    eligible_remaining = total_eligible
    
    print(f"Generating {num_flights} flights...")

    # Track eligible flights to ensure we get enough
    eligible_count = 0
    
    # Generate EU to EU flights (70%)
    for i in range(eu_to_eu_count):
        # Select random airline
        airline = random.choice(airlines)
        
        # Select random departure and arrival airports from EU (ensure they're different)
        departure_airport = random.choice(eu_airports)
        arrival_airport = random.choice([a for a in eu_airports if a['iata'] != departure_airport['iata']])
        
        # Determine flight distance (mostly short/medium for EU-EU)
        distance_type = random.choices(
            ["short", "medium", "long"], 
            weights=[70, 29, 1], 
            k=1
        )[0]
        distance_km = random.randint(*distance_ranges[distance_type])
        
        # Generate flight number
        flight_number = airline["iata"] + str(random.randint(1000, 9999))
        
        # Force enough eligible flights if we're below target
        if eligible_count < total_eligible and i >= (eu_to_eu_count - (total_eligible - eligible_count)):
            # Force this flight to be eligible
            if random.random() < 0.5:
                # Make it significantly delayed
                status = "DELAYED"
                delay_minutes = random.randint(180, 500)
            else:
                # Make it cancelled
                status = "CANCELLED"
                delay_minutes = 0
            eligible = True
            eligible_count += 1
        else:
            # Normal probability distribution
            status_type = random.choices(
                ["ON_TIME", "DELAYED", "DELAYED_COMP", "CANCELLED"],
                weights=[
                    status_probabilities["ON_TIME"],
                    status_probabilities["DELAYED"],
                    status_probabilities["DELAYED_COMP"],
                    status_probabilities["CANCELLED"]
                ],
                k=1
            )[0]
            
            if status_type == "ON_TIME":
                status = "ON_TIME"
                delay_minutes = random.randint(0, 15)  # 0-15 minutes is considered on time
                eligible = False
            elif status_type == "DELAYED":
                status = "DELAYED"
                delay_minutes = random.randint(16, 179)  # 16-179 minutes (not eligible)
                eligible = False
            elif status_type == "DELAYED_COMP":
                status = "DELAYED"
                delay_minutes = random.randint(180, 500)  # 3+ hours delay (eligible)
                eligible = True
                eligible_count += 1
            elif status_type == "CANCELLED":
                status = "CANCELLED"
                delay_minutes = 0
                eligible = True
                eligible_count += 1
        
        # Generate scheduled and actual timestamps
        scheduled_departure = generate_timestamp()
        scheduled_arrival = generate_timestamp(hours_offset=distance_km/800)  # Rough estimate of flight duration
        
        if status == "CANCELLED":
            actual_departure = None
            actual_arrival = None
        elif status == "DELAYED":
            actual_departure = (datetime.fromisoformat(scheduled_departure) + timedelta(minutes=delay_minutes)).isoformat()
            actual_arrival = (datetime.fromisoformat(scheduled_arrival) + timedelta(minutes=delay_minutes)).isoformat()
        else:  # ON_TIME
            actual_departure = (datetime.fromisoformat(scheduled_departure) + timedelta(minutes=delay_minutes)).isoformat()
            actual_arrival = (datetime.fromisoformat(scheduled_arrival) + timedelta(minutes=delay_minutes)).isoformat()

        # Create flight object
        flight = {
            "id": generate_flight_id(),
            "flight": flight_number,
            "status": status,
            "delayMinutes": delay_minutes,
            "airline": {
                "name": airline["name"],
                "iata": airline["iata"]
            },
            "departure": {
                "airport": {
                    "name": departure_airport["name"],
                    "city": departure_airport["city"],
                    "country": departure_airport["country"],
                    "iata": departure_airport["iata"]
                },
                "scheduled": scheduled_departure,
                "actual": actual_departure,
                "terminal": str(random.randint(1, 5)),
                "gate": str(random.choice("ABCDEFG")) + str(random.randint(1, 30))
            },
            "arrival": {
                "airport": {
                    "name": arrival_airport["name"],
                    "city": arrival_airport["city"],
                    "country": arrival_airport["country"],
                    "iata": arrival_airport["iata"]
                },
                "scheduled": scheduled_arrival,
                "actual": actual_arrival,
                "terminal": str(random.randint(1, 5)),
                "gate": str(random.choice("ABCDEFG")) + str(random.randint(1, 30))
            },
            "aircraft": {
                "model": random.choice([
                    "Boeing 737", "Boeing 787", "Airbus A320", "Airbus A330", 
                    "Airbus A350", "Airbus A380", "Embraer E190"
                ]),
                "registration": random.choice(["G-", "F-", "D-", "EC-", "SP-"]) + "".join(random.choices("ABCDEFGHIJKLMNOPQRSTUVWXYZ", k=4))
            },
            "distance_km": distance_km,
            "_debug_eligible": eligible
        }
        
        flights.append(flight)

    # Generate EU to International flights (30%)
    for i in range(eu_to_intl_count):
        # Select random airline
        airline = random.choice(airlines)
        
        # Decide direction (EU to International or International to EU)
        if random.random() < 0.5:
            # EU to International
            departure_airport = random.choice(eu_airports)
            arrival_airport = random.choice(international_airports)
        else:
            # International to EU
            departure_airport = random.choice(international_airports)
            arrival_airport = random.choice(eu_airports)
        
        # Determine flight distance (mostly medium/long for international)
        distance_type = random.choices(
            ["medium", "long"], 
            weights=[40, 60], 
            k=1
        )[0]
        distance_km = random.randint(*distance_ranges[distance_type])
        
        # Generate flight number
        flight_number = airline["iata"] + str(random.randint(1000, 9999))
        
        # Force enough eligible flights if we're below target
        if eligible_count < total_eligible and i >= (eu_to_intl_count - (total_eligible - eligible_count)):
            # Force this flight to be eligible
            if random.random() < 0.5:
                # Make it significantly delayed
                status = "DELAYED"
                delay_minutes = random.randint(180, 500)
            else:
                # Make it cancelled
                status = "CANCELLED"
                delay_minutes = 0
            eligible = True
            eligible_count += 1
        else:
            # Normal probability distribution
            status_type = random.choices(
                ["ON_TIME", "DELAYED", "DELAYED_COMP", "CANCELLED"],
                weights=[
                    status_probabilities["ON_TIME"],
                    status_probabilities["DELAYED"],
                    status_probabilities["DELAYED_COMP"],
                    status_probabilities["CANCELLED"]
                ],
                k=1
            )[0]
            
            if status_type == "ON_TIME":
                status = "ON_TIME"
                delay_minutes = random.randint(0, 15)  # 0-15 minutes is considered on time
                eligible = False
            elif status_type == "DELAYED":
                status = "DELAYED"
                delay_minutes = random.randint(16, 179)  # 16-179 minutes (not eligible)
                eligible = False
            elif status_type == "DELAYED_COMP":
                status = "DELAYED"
                delay_minutes = random.randint(180, 500)  # 3+ hours delay (eligible)
                eligible = True
                eligible_count += 1
            elif status_type == "CANCELLED":
                status = "CANCELLED"
                delay_minutes = 0
                eligible = True
                eligible_count += 1
        
        # Generate scheduled and actual timestamps
        scheduled_departure = generate_timestamp()
        scheduled_arrival = generate_timestamp(hours_offset=distance_km/800)  # Rough estimate of flight duration
        
        if status == "CANCELLED":
            actual_departure = None
            actual_arrival = None
        elif status == "DELAYED":
            actual_departure = (datetime.fromisoformat(scheduled_departure) + timedelta(minutes=delay_minutes)).isoformat()
            actual_arrival = (datetime.fromisoformat(scheduled_arrival) + timedelta(minutes=delay_minutes)).isoformat()
        else:  # ON_TIME
            actual_departure = (datetime.fromisoformat(scheduled_departure) + timedelta(minutes=delay_minutes)).isoformat()
            actual_arrival = (datetime.fromisoformat(scheduled_arrival) + timedelta(minutes=delay_minutes)).isoformat()

        # Create flight object
        flight = {
            "id": generate_flight_id(),
            "flight": flight_number,
            "status": status,
            "delayMinutes": delay_minutes,
            "airline": {
                "name": airline["name"],
                "iata": airline["iata"]
            },
            "departure": {
                "airport": {
                    "name": departure_airport["name"],
                    "city": departure_airport["city"],
                    "country": departure_airport["country"],
                    "iata": departure_airport["iata"]
                },
                "scheduled": scheduled_departure,
                "actual": actual_departure,
                "terminal": str(random.randint(1, 5)),
                "gate": str(random.choice("ABCDEFG")) + str(random.randint(1, 30))
            },
            "arrival": {
                "airport": {
                    "name": arrival_airport["name"],
                    "city": arrival_airport["city"],
                    "country": arrival_airport["country"],
                    "iata": arrival_airport["iata"]
                },
                "scheduled": scheduled_arrival,
                "actual": actual_arrival,
                "terminal": str(random.randint(1, 5)),
                "gate": str(random.choice("ABCDEFG")) + str(random.randint(1, 30))
            },
            "aircraft": {
                "model": random.choice([
                    "Boeing 737", "Boeing 787", "Airbus A320", "Airbus A330", 
                    "Airbus A350", "Airbus A380", "Embraer E190"
                ]),
                "registration": random.choice(["G-", "F-", "D-", "EC-", "SP-"]) + "".join(random.choices("ABCDEFGHIJKLMNOPQRSTUVWXYZ", k=4))
            },
            "distance_km": distance_km,
            "_debug_eligible": eligible
        }
        
        flights.append(flight)
    
    # Count actual eligible flights
    actual_eligible = sum(1 for f in flights if f["_debug_eligible"])
    
    print(f"Generated {len(flights)} flights, {actual_eligible} are eligible for EU compensation")
    return flights

def main():
    """Main function to populate flight data"""
    flights = generate_realistic_flights(num_flights=1000)
    
    flight_data = {
        "flights": flights,
        "generated_at": datetime.now().isoformat(),
        "total_count": len(flights),
        "eligible_count": sum(1 for f in flights if f.get("_debug_eligible", False))
    }
    
    # Save flight data
    with open(DATA_FILE, "w") as f:
        json.dump(flight_data, f)
        
    print(f"Flight data saved to {DATA_FILE}")
    print("Done!")

if __name__ == "__main__":
    main()
