"""
Flight Data Storage Module
--------------------------
Handles persistent storage of flight data in JSON format
"""

import os
import json
import logging
from datetime import datetime

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger("flight_data_storage")

class FlightDataStorage:
    """
    Manages storage and retrieval of flight data from a JSON file.
    """
    def __init__(self, data_dir=None, filename=None):
        """
        Initialize the storage with configurable directory and filename.
        
        Args:
            data_dir: Directory where the data file will be stored
            filename: Name of the JSON data file
        """
        # Default to "/home/PiotrS/data" for PythonAnywhere compatibility
        self.data_dir = data_dir or os.environ.get('FLIGHT_DATA_DIR', '/home/PiotrS/data')
        self.filename = filename or "flight_compensation_data.json"
        self.filepath = os.path.join(self.data_dir, self.filename)
        
        # Ensure data directory exists
        os.makedirs(self.data_dir, exist_ok=True)
        
        logger.info(f"Flight data will be stored at: {self.filepath}")
        
        # Initialize empty data structure if file doesn't exist
        if not os.path.exists(self.filepath):
            self._initialize_data_file()
    
    def _initialize_data_file(self):
        """Create an empty data file with basic structure."""
        initial_data = {
            "metadata": {
                "created": datetime.now().isoformat(),
                "updated": datetime.now().isoformat(),
                "version": "3.0"
            },
            "flights": []
        }
        
        try:
            with open(self.filepath, 'w') as f:
                json.dump(initial_data, f, indent=2)
            logger.info(f"Created new flight data file at {self.filepath}")
        except Exception as e:
            logger.error(f"Failed to initialize data file: {e}")
    
    def _load_data(self):
        """Load flight data from the JSON file."""
        try:
            if not os.path.exists(self.filepath):
                logger.warning(f"Data file not found at {self.filepath}, initializing new file")
                self._initialize_data_file()
                return {"metadata": {"version": "3.0"}, "flights": []}
            
            with open(self.filepath, 'r') as f:
                data = json.load(f)
            logger.info(f"Loaded {len(data.get('flights', []))} flights from storage")
            return data
        except json.JSONDecodeError:
            logger.error(f"Invalid JSON in {self.filepath}, initializing new file")
            self._initialize_data_file()
            return {"metadata": {"version": "3.0"}, "flights": []}
        except Exception as e:
            logger.error(f"Error loading flight data: {e}")
            return {"metadata": {"version": "3.0"}, "flights": []}
    
    def _save_data(self, data):
        """Save flight data to the JSON file."""
        try:
            # Update metadata
            data["metadata"] = data.get("metadata", {})
            data["metadata"]["updated"] = datetime.now().isoformat()
            
            with open(self.filepath, 'w') as f:
                json.dump(data, f, indent=2)
            logger.info(f"Saved {len(data.get('flights', []))} flights to storage")
            return True
        except Exception as e:
            logger.error(f"Error saving flight data: {e}")
            return False
    
    def store_flights(self, flights, source="api"):
        """
        Store a list of flight records in the data file.
        
        Args:
            flights: List of flight dictionaries to store
            source: Source of the flight data (e.g., "api", "mock")
        
        Returns:
            bool: True if successful, False otherwise
        """
        try:
            data = self._load_data()
            existing_flights = data.get("flights", [])
            
            # Add source and timestamp to each flight
            timestamp = datetime.now().isoformat()
            for flight in flights:
                flight["source"] = source
                flight["stored_at"] = timestamp
                flight["status"] = flight.get("status", "UNKNOWN").upper()  # Standardize status
            
            # Update existing flights or append new ones
            flight_ids = {f.get("flight", {}).get("iata") for f in flights if f.get("flight")}
            
            # Remove existing entries for these flights (to avoid duplicates)
            data["flights"] = [f for f in existing_flights if f.get("flight", {}).get("iata") not in flight_ids]
            
            # Add the new flights
            data["flights"].extend(flights)
            
            return self._save_data(data)
        except Exception as e:
            logger.error(f"Error storing flights: {e}")
            return False
    
    def get_eligible_flights(self):
        """
        Retrieve only compensation-eligible flights.
        
        Returns:
            list: List of eligible flight dictionaries
        """
        try:
            data = self._load_data()
            flights = data.get("flights", [])
            
            # Filter for eligible flights
            eligible_flights = [
                flight for flight in flights 
                if flight.get("eligible_for_compensation") is True
            ]
            
            logger.info(f"Retrieved {len(eligible_flights)} eligible flights out of {len(flights)} total")
            return eligible_flights
        except Exception as e:
            logger.error(f"Error retrieving eligible flights: {e}")
            return []
    
    def get_all_flights(self):
        """
        Retrieve all flights.
        
        Returns:
            list: List of all flight dictionaries
        """
        try:
            data = self._load_data()
            flights = data.get("flights", [])
            logger.info(f"Retrieved {len(flights)} total flights")
            return flights
        except Exception as e:
            logger.error(f"Error retrieving all flights: {e}")
            return []
    
    def get_stats(self):
        """
        Get statistics about the stored flights.
        
        Returns:
            dict: Dictionary with statistics
        """
        try:
            data = self._load_data()
            flights = data.get("flights", [])
            eligible_count = sum(1 for f in flights if f.get("eligible_for_compensation") is True)
            
            return {
                "total_flights": len(flights),
                "eligible_flights": eligible_count,
                "last_updated": data.get("metadata", {}).get("updated", "unknown")
            }
        except Exception as e:
            logger.error(f"Error retrieving stats: {e}")
            return {"error": str(e)}
    
    def generate_mock_data(self, count=50):
        """
        Generate and store realistic mock flight data.
        
        Args:
            count: Number of mock flights to generate
        
        Returns:
            bool: True if successful, False otherwise
        """
        import random
        from datetime import datetime, timedelta
        
        try:
            # Define realistic mock data sources
            airlines = [
                {"iata": "LH", "name": "Lufthansa"},
                {"iata": "BA", "name": "British Airways"},
                {"iata": "LO", "name": "LOT Polish Airlines"},
                {"iata": "AF", "name": "Air France"},
                {"iata": "KL", "name": "KLM Royal Dutch Airlines"},
                {"iata": "FR", "name": "Ryanair"},
                {"iata": "W6", "name": "Wizz Air"},
                {"iata": "U2", "name": "easyJet"},
                {"iata": "EW", "name": "Eurowings"},
                {"iata": "VY", "name": "Vueling Airlines"},
                {"iata": "TP", "name": "TAP Air Portugal"},
            ]
            
            eu_airports = ['WAW', 'KRK', 'FRA', 'CDG', 'AMS', 'MAD', 'FCO', 'LHR', 'MUC', 'BCN', 'LIS', 'VIE']
            statuses = ["LANDED", "DELAYED", "CANCELLED", "SCHEDULED"]
            
            mock_flights = []
            now = datetime.now()
            
            for i in range(count):
                # Select random airline
                airline = random.choice(airlines)
                
                # Create flight number
                flight_number = f"{airline['iata']}{random.randint(100, 9999)}"
                
                # Select random airports
                dep_airport = random.choice(eu_airports)
                arr_airport = random.choice([a for a in eu_airports if a != dep_airport])
                
                # Generate times within the last 24 hours
                hours_ago = random.randint(0, 24)
                scheduled_departure = (now - timedelta(hours=hours_ago)).isoformat()
                scheduled_arrival = (now - timedelta(hours=hours_ago-2)).isoformat()
                
                # Determine if flight is delayed
                status = random.choices(statuses, weights=[70, 20, 5, 5])[0]
                
                # Generate delay in minutes
                delay_minutes = 0
                if status == "DELAYED":
                    delay_minutes = random.randint(15, 600)  # 15 minutes to 10 hours delay
                
                # Determine eligibility for compensation
                is_eligible = delay_minutes >= 180 or status == "CANCELLED"
                
                # Calculate distance (simplified)
                distance_km = random.randint(500, 5000)
                
                # Calculate compensation amount
                compensation_amount = 0
                if is_eligible:
                    if distance_km <= 1500:
                        compensation_amount = 250
                    elif distance_km <= 3500:
                        compensation_amount = 400
                    else:
                        compensation_amount = 600
                
                # Create actual arrival time
                actual_arrival = None
                if status == "LANDED" or status == "DELAYED":
                    delay_seconds = delay_minutes * 60
                    scheduled = datetime.fromisoformat(scheduled_arrival.replace('Z', '+00:00'))
                    actual = scheduled + timedelta(seconds=delay_seconds)
                    actual_arrival = actual.isoformat()
                
                # Build mock flight object
                mock_flight = {
                    'flight': {'iata': flight_number},
                    'departure': {
                        'airport': {'iata': dep_airport},
                        'scheduled': scheduled_departure
                    },
                    'arrival': {
                        'airport': {'iata': arr_airport},
                        'scheduled': scheduled_arrival,
                        'actual': actual_arrival
                    },
                    'airline': airline,
                    'status': status,
                    'delayMinutes': delay_minutes,
                    'eligible_for_compensation': is_eligible,
                    'compensation_amount_eur': compensation_amount,
                    'distance_km': distance_km
                }
                
                mock_flights.append(mock_flight)
            
            # Store the mock flights
            result = self.store_flights(mock_flights, source="mock")
            logger.info(f"Generated and stored {count} mock flights: {result}")
            return result
        
        except Exception as e:
            logger.error(f"Error generating mock data: {e}")
            return False
