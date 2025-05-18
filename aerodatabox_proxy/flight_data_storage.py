import json
import os
import logging
from datetime import datetime, timedelta
from typing import Dict, Any, List, Optional

# Setup logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.StreamHandler(),
    ]
)
logger = logging.getLogger("flight_data_storage")

class FlightDataStorage:
    """
    Persistent storage for flight compensation data.
    Stores historical flight data and provides methods for querying and updating.
    
    This is designed to evolve into a centralized database architecture in the future.
    """
    
    def __init__(self, storage_path="./data", filename="flight_compensation_data.json"):
        """Initialize the storage with path configuration"""
        self.storage_path = storage_path
        self.filename = filename
        self.full_path = os.path.join(storage_path, filename)
        
        # Create data directory if it doesn't exist
        if not os.path.exists(storage_path):
            os.makedirs(storage_path)
            logger.info(f"Created storage directory: {storage_path}")
        
        # Initialize data structure if file doesn't exist
        if not os.path.exists(self.full_path):
            self._initialize_storage()
            logger.info(f"Initialized new storage file: {self.full_path}")
        
        logger.info(f"Flight data storage initialized at {self.full_path}")
    
    def _initialize_storage(self):
        """Create initial storage structure"""
        initial_data = {
            "flights": [],                 # Historical flight records
            "last_updated": datetime.utcnow().isoformat() + "Z",
            "stats": {
                "total_flights": 0,
                "total_eligible_flights": 0,
                "total_lot_flights": 0,
                "data_sources": {
                    "real_api": 0,         # Count of flights from real API
                    "fallback": 0          # Count of fallback generated flights
                }
            },
            "metadata": {
                "created": datetime.utcnow().isoformat() + "Z",
                "version": "1.0.0",
                "description": "Persistent storage for flight compensation data"
            }
        }
        
        # Write initial data structure
        with open(self.full_path, "w") as f:
            json.dump(initial_data, f, indent=2)
    
    def _load_data(self) -> Dict[str, Any]:
        """Load data from storage file"""
        try:
            with open(self.full_path, "r") as f:
                return json.load(f)
        except Exception as e:
            logger.error(f"Error loading data: {str(e)}")
            # If file is corrupted, initialize a new one
            self._initialize_storage()
            with open(self.full_path, "r") as f:
                return json.load(f)
    
    def _save_data(self, data: Dict[str, Any]):
        """Save data to storage file"""
        try:
            # Update last_updated timestamp
            data["last_updated"] = datetime.utcnow().isoformat() + "Z"
            
            # Write to file
            with open(self.full_path, "w") as f:
                json.dump(data, f, indent=2)
                
            logger.info(f"Saved data to {self.full_path}")
        except Exception as e:
            logger.error(f"Error saving data: {str(e)}")
    
    def store_flights(self, flights: List[Dict[str, Any]], source="real_api"):
        """Store new flight data, merging with existing data"""
        if not flights:
            logger.info("No flights to store")
            return
        
        # Load current data
        data = self._load_data()
        
        # Track new flight IDs to avoid duplicates
        existing_flight_ids = {f.get("flight", "") + "_" + 
                             f.get("departure", {}).get("scheduledTime", "") 
                             for f in data["flights"]}
        
        new_flights_added = 0
        lot_flights_added = 0
        
        # Add new flights, avoiding duplicates
        for flight in flights:
            # Create a unique ID for the flight 
            flight_id = flight.get("flight", "") + "_" + flight.get("departure", {}).get("scheduledTime", "")
            
            # Skip if already exists
            if flight_id in existing_flight_ids:
                continue
            
            # Add source information
            flight["dataSource"] = source
            flight["storedAt"] = datetime.utcnow().isoformat() + "Z"
            
            # Add to storage
            data["flights"].append(flight)
            new_flights_added += 1
            
            # Track LOT flights
            airline_name = flight.get("airline", {}).get("name", "")
            if airline_name and "LOT" in airline_name:
                lot_flights_added += 1
            
            # Add to unique IDs to avoid duplicates in this batch
            existing_flight_ids.add(flight_id)
        
        # Update stats
        data["stats"]["total_flights"] += new_flights_added
        data["stats"]["total_eligible_flights"] += new_flights_added
        data["stats"]["total_lot_flights"] += lot_flights_added
        data["stats"]["data_sources"][source] += new_flights_added
        
        # Save updated data
        self._save_data(data)
        
        logger.info(f"Stored {new_flights_added} new flights from source: {source}")
        logger.info(f"Total flights in storage: {data['stats']['total_flights']}")
    
    def get_all_flights(self) -> List[Dict[str, Any]]:
        """Get all flights from storage without filtering"""
        # Load current data
        data = self._load_data()
        
        # Return all flights
        return data["flights"]
    
    def get_eligible_flights(self, hours=72, airline_filter=None, max_results=50) -> List[Dict[str, Any]]:
        """Get compensation-eligible flights from the last X hours"""
        # Load current data
        data = self._load_data()
        
        # Calculate time window
        now = datetime.utcnow()
        lookback_time = now - timedelta(hours=hours)
        
        logger.info(f"Filtering flights for last {hours} hours (from {lookback_time.isoformat()} to {now.isoformat()})")
        
        # Filter flights based on criteria
        filtered_flights = []
        for flight in data["flights"]:
            # Check if flight has arrival info
            if "arrival" not in flight:
                continue
                
            # First try actual arrival time if available (for real delays)
            arrival_time_str = None
            if "actualTime" in flight.get("arrival", {}):
                arrival_time_str = flight["arrival"]["actualTime"]
            
            # If no actual time, fall back to scheduled time
            if not arrival_time_str:
                arrival_time_str = flight.get("arrival", {}).get("scheduledTime")
                
            if not arrival_time_str:
                continue
                
            try:
                # Try to parse ISO format
                arrival_time = None
                try:
                    # Handle Z timezone
                    if arrival_time_str.endswith('Z'):
                        arrival_time = datetime.fromisoformat(arrival_time_str.replace("Z", "+00:00"))
                    else:
                        arrival_time = datetime.fromisoformat(arrival_time_str)
                except:
                    # Try dateutil parser as fallback
                    from dateutil import parser
                    arrival_time = parser.parse(arrival_time_str)
                
                # Check if flight is within time window
                # The comparison should be: now >= arrival_time >= lookback_time
                if arrival_time and arrival_time >= lookback_time and arrival_time <= now:
                    # Apply airline filter if specified
                    if airline_filter:
                        airline_name = flight.get("airline", {}).get("name", "")
                        if airline_filter.lower() not in airline_name.lower():
                            continue
                    
                    filtered_flights.append(flight)
            except Exception as e:
                # Skip flights with unparseable dates
                continue
        
        # Sort by delay time (most delayed first)
        filtered_flights.sort(key=lambda x: x.get("delayMinutes", 0), reverse=True)
        
        # Limit results
        if max_results > 0:
            filtered_flights = filtered_flights[:max_results]
        
        logger.info(f"Retrieved {len(filtered_flights)} eligible flights for last {hours} hours")
        
        return filtered_flights
    
    def get_stats(self) -> Dict[str, Any]:
        """Get storage statistics"""
        data = self._load_data()
        return data["stats"]
    
    def clear_old_data(self, days=90):
        """Clear data older than specified days"""
        # Load current data
        data = self._load_data()
        
        # Calculate cutoff time
        now = datetime.utcnow()
        cutoff_time = now - timedelta(days=days)
        
        # Count before cleanup
        original_count = len(data["flights"])
        
        # Filter flights based on storage time
        updated_flights = []
        for flight in data["flights"]:
            stored_at_str = flight.get("storedAt")
            if not stored_at_str:
                # Keep flights without storage timestamp (shouldn't happen)
                updated_flights.append(flight)
                continue
                
            try:
                stored_at = datetime.fromisoformat(stored_at_str.replace("Z", "+00:00"))
                if stored_at >= cutoff_time:
                    updated_flights.append(flight)
            except Exception:
                # Keep flights with unparseable dates
                updated_flights.append(flight)
        
        # Update flights list
        data["flights"] = updated_flights
        
        # Update stats
        removed_count = original_count - len(updated_flights)
        data["stats"]["total_flights"] = len(updated_flights)
        
        # Save updated data
        self._save_data(data)
        
        logger.info(f"Cleared {removed_count} flights older than {days} days")
        
        return {
            "removed_flights": removed_count,
            "remaining_flights": len(updated_flights)
        }

# Example usage
if __name__ == "__main__":
    storage = FlightDataStorage()
    print(f"Storage stats: {storage.get_stats()}")
