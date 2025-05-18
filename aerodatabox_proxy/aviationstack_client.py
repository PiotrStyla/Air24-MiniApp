"""
AviationStack API Client
------------------------
Client to interact with the AviationStack API for flight data.
"""

import requests
import os
import logging
from datetime import datetime, timedelta
from typing import Dict, Any, List, Optional

# Setup logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("aviationstack_client")

class AviationStackClient:
    """Client for AviationStack API interactions"""
    
    BASE_URL = "http://api.aviationstack.com/v1"
    
    def __init__(self, api_key: Optional[str] = None):
        """Initialize the AviationStack API client.
        
        Args:
            api_key: Optional API key. If not provided, will look for 
                    AVIATIONSTACK_API_KEY environment variable.
        """
        self.api_key = api_key or os.environ.get('AVIATIONSTACK_API_KEY')
        if not self.api_key:
            logger.warning("No AviationStack API key provided. API calls will fail.")
        
        self.session = requests.Session()
    
    def _make_request(self, endpoint: str, params: Dict[str, Any] = None) -> Dict[str, Any]:
        """Make a request to the AviationStack API.
        
        Args:
            endpoint: API endpoint to call
            params: Query parameters for the request
            
        Returns:
            JSON response as a dictionary
            
        Raises:
            Exception: If the API call fails
        """
        if params is None:
            params = {}
            
        # Add API key to parameters
        params['access_key'] = self.api_key
        
        url = f"{self.BASE_URL}/{endpoint}"
        
        try:
            logger.info(f"Making request to AviationStack API: {url} with params: {params}")
            response = self.session.get(url, params=params, timeout=30)
            response.raise_for_status()
            
            data = response.json()
            
            # Check for API errors
            if data.get('error'):
                error_info = data['error']
                logger.error(f"AviationStack API error: {error_info}")
                raise Exception(f"AviationStack API error: {error_info}")
                
            return data
        except requests.exceptions.RequestException as e:
            logger.error(f"Request to AviationStack API failed: {e}")
            raise
    
    def get_real_time_flights(self, 
                            airline_iata: Optional[str] = None,
                            flight_status: Optional[str] = None,
                            limit: int = 100) -> List[Dict[str, Any]]:
        """Get real-time flight data.
        
        Args:
            airline_iata: Optional airline IATA code to filter by
            flight_status: Optional flight status to filter by 
                          (scheduled, active, landed, cancelled, incident, diverted)
            limit: Maximum number of results to return (1-100)
            
        Returns:
            List of flight data dictionaries
        """
        params = {
            'limit': min(limit, 100)  # API max is 100
        }
        
        if airline_iata:
            params['airline_iata'] = airline_iata
            
        if flight_status:
            params['flight_status'] = flight_status
        
        response = self._make_request('flights', params)
        
        # Return the actual flight data array
        return response.get('data', [])
    
    def get_flight_by_number(self, 
                           flight_iata: str,
                           date: Optional[str] = None) -> List[Dict[str, Any]]:
        """Get flight data for a specific flight number.
        
        Args:
            flight_iata: IATA flight number (e.g., LO135)
            date: Optional flight date in YYYY-MM-DD format
            
        Returns:
            List of matching flight data
        """
        params = {
            'flight_iata': flight_iata
        }
        
        if date:
            params['flight_date'] = date
        
        response = self._make_request('flights', params)
        return response.get('data', [])
    
    def get_airport_flights(self, 
                          airport_iata: str,
                          flight_type: str = 'arrival',  # 'arrival' or 'departure'
                          limit: int = 100) -> List[Dict[str, Any]]:
        """Get flights for a specific airport.
        
        Args:
            airport_iata: IATA code for the airport
            flight_type: 'arrival' or 'departure'
            limit: Maximum number of results to return (1-100)
            
        Returns:
            List of flight data dictionaries
        """
        params = {
            'limit': min(limit, 100)  # API max is 100
        }
        
        # Set the appropriate parameter based on flight type
        if flight_type.lower() == 'arrival':
            params['arr_iata'] = airport_iata
        else:
            params['dep_iata'] = airport_iata
        
        response = self._make_request('flights', params)
        return response.get('data', [])
    
    def format_flight_for_storage(self, flight: Dict[str, Any]) -> Dict[str, Any]:
        """Convert AviationStack flight data format to our storage format.
        
        Args:
            flight: Flight data from AviationStack API
            
        Returns:
            Reformatted flight data compatible with our storage format
        """
        try:
            # Extract delay information
            departure_delay = flight.get('departure', {}).get('delay', 0)
            arrival_delay = flight.get('arrival', {}).get('delay', 0)
            
            # Determine overall delay (use arrival delay for compensation)
            delay_minutes = max(arrival_delay or 0, 0)  # Ensure non-negative
            
            # Determine flight status
            status = flight.get('flight_status', '').capitalize()
            if status == 'Landed' and delay_minutes >= 180:
                status = 'Delayed'
                
            # Format the flight data to match our storage schema
            formatted_flight = {
                'number': flight.get('flight', {}).get('iata'),
                'airline': {
                    'name': flight.get('airline', {}).get('name'),
                    'iata': flight.get('airline', {}).get('iata')
                },
                'departure': {
                    'airport': {
                        'name': flight.get('departure', {}).get('airport'),
                        'iata': flight.get('departure', {}).get('iata'),
                        'icao': flight.get('departure', {}).get('icao')
                    },
                    'scheduledTime': {
                        'local': flight.get('departure', {}).get('scheduled'),
                        'utc': flight.get('departure', {}).get('scheduled')  # API uses UTC already
                    },
                    'actualTime': {
                        'local': flight.get('departure', {}).get('actual'),
                        'utc': flight.get('departure', {}).get('actual')
                    }
                },
                'arrival': {
                    'airport': {
                        'name': flight.get('arrival', {}).get('airport'),
                        'iata': flight.get('arrival', {}).get('iata'),
                        'icao': flight.get('arrival', {}).get('icao')
                    },
                    'scheduledTime': {
                        'local': flight.get('arrival', {}).get('scheduled'),
                        'utc': flight.get('arrival', {}).get('scheduled')
                    },
                    'actualTime': {
                        'local': flight.get('arrival', {}).get('actual'),
                        'utc': flight.get('arrival', {}).get('actual')
                    }
                },
                'status': status,
                'delayMinutes': delay_minutes,
                'aircraft': {
                    'model': flight.get('aircraft', {}).get('icao', 'Unknown Aircraft')
                },
                'distance': flight.get('flight', {}).get('distance'),  # For compensation calculation
                'data_source': 'AviationStack'
            }
            
            return formatted_flight
        except Exception as e:
            logger.error(f"Error formatting flight data: {e}")
            return {}
    
    def get_eligible_flights_for_compensation(self, 
                                            limit: int = 100,
                                            airline_iata: Optional[str] = None) -> List[Dict[str, Any]]:
        """Find flights eligible for EU261 compensation (delayed, cancelled, diverted).
        
        Args:
            limit: Maximum number of results to return
            airline_iata: Optional airline IATA code to filter by
            
        Returns:
            List of eligible flights formatted for our storage system
        """
        eligible_flights = []
        
        # First, check for flights with status indicating compensation possibility
        for status in ['cancelled', 'diverted']:
            params = {'flight_status': status, 'limit': limit}
            if airline_iata:
                params['airline_iata'] = airline_iata
                
            try:
                response = self._make_request('flights', params)
                flights = response.get('data', [])
                
                for flight in flights:
                    formatted = self.format_flight_for_storage(flight)
                    if formatted:
                        eligible_flights.append(formatted)
            except Exception as e:
                logger.error(f"Error fetching {status} flights: {e}")
        
        # Then look for delayed flights
        try:
            # AviationStack doesn't have a direct delay filter, so we get active flights
            # and filter them by delay in our processing
            params = {'flight_status': 'active', 'limit': limit}
            if airline_iata:
                params['airline_iata'] = airline_iata
                
            response = self._make_request('flights', params)
            flights = response.get('data', [])
            
            for flight in flights:
                # Check for delayed flights (arrival delay 3+ hours)
                arrival_delay = flight.get('arrival', {}).get('delay', 0)
                if arrival_delay and arrival_delay >= 180:  # 3+ hours delay
                    formatted = self.format_flight_for_storage(flight)
                    if formatted:
                        eligible_flights.append(formatted)
        except Exception as e:
            logger.error(f"Error fetching delayed flights: {e}")
            
        # Also check recently landed flights for delays
        try:
            params = {'flight_status': 'landed', 'limit': limit}
            if airline_iata:
                params['airline_iata'] = airline_iata
                
            response = self._make_request('flights', params)
            flights = response.get('data', [])
            
            for flight in flights:
                # Check for delayed flights (arrival delay 3+ hours)
                arrival_delay = flight.get('arrival', {}).get('delay', 0)
                if arrival_delay and arrival_delay >= 180:  # 3+ hours delay
                    formatted = self.format_flight_for_storage(flight)
                    if formatted:
                        eligible_flights.append(formatted)
        except Exception as e:
            logger.error(f"Error fetching landed flights: {e}")
        
        return eligible_flights

# Testing function
def test_client():
    """Test the AviationStack API client with a simple request."""
    client = AviationStackClient()
    try:
        # Test with a simple request
        flights = client.get_real_time_flights(limit=5)
        print(f"Retrieved {len(flights)} flights:")
        for flight in flights:
            print(f"  Flight: {flight.get('flight', {}).get('iata')}, "
                  f"Status: {flight.get('flight_status')}")
        
        # Test formatting
        if flights:
            print("\nFormatted flight example:")
            formatted = client.format_flight_for_storage(flights[0])
            print(formatted)
            
    except Exception as e:
        print(f"Test failed with error: {e}")

if __name__ == "__main__":
    test_client()
