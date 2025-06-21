import os
import requests
import logging

# Configure logging
logger = logging.getLogger(__name__)

class AviationStackClient:
    """A client for interacting with the AviationStack API."""

    def __init__(self):
        """Initializes the client and gets the API key from environment variables."""
        self.api_key = os.environ.get('AVIATION_STACK_API_KEY')
        self.base_url = 'http://api.aviationstack.com/v1'
        if not self.api_key:
            logger.error("AVIATION_STACK_API_KEY environment variable not set.")
            raise ValueError("API key for AviationStack is not configured.")

    def _make_request(self, endpoint, params=None):
        """Makes a request to a given endpoint of the AviationStack API."""
        if not params:
            params = {}
        params['access_key'] = self.api_key
        
        try:
            response = requests.get(f"{self.base_url}/{endpoint}", params=params)
            response.raise_for_status()  # Raise an exception for bad status codes (4xx or 5xx)
            return response.json().get('data', [])
        except requests.exceptions.RequestException as e:
            logger.error(f"Error connecting to AviationStack API: {e}")
            return []
        except Exception as e:
            logger.error(f"An unexpected error occurred: {e}")
            return []

    def get_flight_by_number(self, flight_number):
        """Fetches flight data for a specific flight number (IATA)."""
        params = {'flight_iata': flight_number}
        return self._make_request('flights', params=params)

    def get_flights(self, params=None):
        """Fetches a list of flights with optional filters."""
        return self._make_request('flights', params=params)
