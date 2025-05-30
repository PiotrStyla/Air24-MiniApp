"""
AviationStack Integration for Flight Compensation App
-----------------------------------------------------
Add this code to your PythonAnywhere server to properly integrate
the AviationStack API with your centralized architecture.
"""

import os
import json
import requests
from flask import request, jsonify
from datetime import datetime, timedelta

# Import your existing storage module
# from flight_data_storage import FlightDataStorage
# storage = FlightDataStorage()

class AviationStackClient:
    """Client for interacting with AviationStack API."""
    
    BASE_URL = "http://api.aviationstack.com/v1"
    
    def __init__(self, api_key=None):
        """Initialize with API key."""
        self.api_key = api_key or os.environ.get('AVIATIONSTACK_API_KEY')
        if not self.api_key:
            print("Warning: No AviationStack API key provided")
        
        self.session = requests.Session()
    
    def _make_request(self, endpoint, params=None):
        """Make a request to the AviationStack API."""
        if params is None:
            params = {}
        
        # Add API key to parameters
        params['access_key'] = self.api_key
        
        url = f"{self.BASE_URL}/{endpoint}"
        response = self.session.get(url, params=params)
        
        if response.status_code == 200:
            return response.json()
        else:
            print(f"Error: AviationStack API request failed with status {response.status_code}")
            print(f"Response: {response.text}")
            return {"error": f"API request failed with status {response.status_code}"}
    
    def get_flight_by_number(self, flight_number):
        """Get flight data by flight number."""
        params = {
            'flight_iata': flight_number
        }
        return self._make_request('flights', params)
    
    def get_airport_flights(self, airport_code, flight_type='arrival', limit=100):
        """Get flights for a specific airport."""
        params = {
            'arr_iata': airport_code if flight_type == 'arrival' else None,
            'dep_iata': airport_code if flight_type == 'departure' else None,
            'limit': limit
        }
        # Remove None values
        params = {k: v for k, v in params.items() if v is not None}
        return self._make_request('flights', params)
    
    def format_flight_for_storage(self, flight):
        """Format AviationStack flight data for storage."""
        try:
            # Extract basic flight info
            flight_number = flight.get('flight', {}).get('iata', '')
            airline_code = flight.get('airline', {}).get('iata', '')
            airline_name = flight.get('airline', {}).get('name', 'Unknown Airline')
            
            # Extract departure info
            departure_airport = flight.get('departure', {}).get('iata', '')
            scheduled_departure = flight.get('departure', {}).get('scheduled', '')
            actual_departure = flight.get('departure', {}).get('actual', '')
            
            # Extract arrival info
            arrival_airport = flight.get('arrival', {}).get('iata', '')
            scheduled_arrival = flight.get('arrival', {}).get('scheduled', '')
            actual_arrival = flight.get('arrival', {}).get('actual', '')
            
            # Calculate delay in minutes
            delay_minutes = 0
            if scheduled_arrival and actual_arrival:
                try:
                    scheduled = datetime.fromisoformat(scheduled_arrival.replace('Z', '+00:00'))
                    actual = datetime.fromisoformat(actual_arrival.replace('Z', '+00:00'))
                    delay = actual - scheduled
                    delay_minutes = int(delay.total_seconds() / 60)
                except (ValueError, TypeError):
                    delay_minutes = 0
            
            # Format for storage
            return {
                'flight_number': flight_number,
                'airline': airline_code,
                'airline_name': airline_name,
                'departure_airport': departure_airport,
                'arrival_airport': arrival_airport,
                'departure_date': scheduled_departure,
                'arrival_date': scheduled_arrival,
                'actual_departure': actual_departure,
                'actual_arrival': actual_arrival,
                'delay_minutes': delay_minutes,
                'status': 'Delayed' if delay_minutes > 0 else 'On Time',
                'source': 'AviationStack',
                'retrieved_at': datetime.utcnow().isoformat()
            }
        except Exception as e:
            print(f"Error formatting flight data: {e}")
            return {}

# Add this to your Flask app
"""
Add the following endpoint to your Flask app in wsgi_app.py:
"""

@app.route('/eu-compensation-eligible', methods=['GET'])
def eu_compensation_eligible():
    """Endpoint that uses AviationStack API for EU-wide compensation eligible flights."""
    try:
        # Get query parameters
        hours = request.args.get('hours', '72')
        try:
            hours = int(hours)
        except ValueError:
            hours = 72
        
        # Initialize AviationStack client
        aviationstack_client = AviationStackClient(api_key=os.environ.get('AVIATIONSTACK_API_KEY'))
        
        # Major EU airports to check
        eu_airports = ['FRA', 'CDG', 'AMS', 'MAD', 'FCO', 'LHR', 'MUC', 'BCN', 'LIS', 'VIE', 'WAW']
        
        all_eligible_flights = []
        airports_checked = 0
        errors = 0
        
        # First try to get data from storage if available
        try:
            stored_flights = storage.get_eligible_flights(hours=hours)
            if stored_flights and len(stored_flights) > 0:
                print(f"Found {len(stored_flights)} eligible flights in storage")
                all_eligible_flights.extend(stored_flights)
        except Exception as e:
            print(f"Error getting flights from storage: {e}")
        
        # Then get fresh data from AviationStack for each airport
        for airport in eu_airports:
            try:
                # Query AviationStack
                airport_data = aviationstack_client.get_airport_flights(
                    airport_code=airport,
                    flight_type='arrival',
                    limit=100
                )
                
                if 'data' in airport_data and airport_data['data']:
                    flights = airport_data['data']
                    
                    for flight in flights:
                        # Process each flight
                        formatted_flight = aviationstack_client.format_flight_for_storage(flight)
                        
                        # Check if eligible (3+ hour delay)
                        delay_minutes = formatted_flight.get('delay_minutes', 0)
                        if delay_minutes >= 180:  # 3 hours
                            formatted_flight['eligible_for_compensation'] = True
                            
                            # Calculate compensation based on flight distance
                            # This is a simplification - real calculation would consider the actual route
                            distance_km = 0
                            
                            # Estimate distance based on airports
                            dep = formatted_flight.get('departure_airport', '')
                            arr = formatted_flight.get('arrival_airport', '')
                            
                            # Very rough estimation by airport pairs
                            if (dep == 'LHR' and arr == 'MAD') or (dep == 'MAD' and arr == 'LHR'):
                                distance_km = 1200
                            elif (dep == 'CDG' and arr == 'FCO') or (dep == 'FCO' and arr == 'CDG'):
                                distance_km = 1100
                            elif (dep == 'AMS' and arr == 'ATH') or (dep == 'ATH' and arr == 'AMS'):
                                distance_km = 2200
                            elif (dep == 'FRA' and arr == 'LIS') or (dep == 'LIS' and arr == 'FRA'):
                                distance_km = 1800
                            else:
                                # Default to medium distance
                                distance_km = 2000
                            
                            # Store the distance
                            formatted_flight['distance_km'] = distance_km
                            
                            # Calculate compensation amount based on EU261 rules
                            if distance_km <= 1500:
                                compensation = 250
                            elif distance_km <= 3500:
                                compensation = 400
                            else:
                                compensation = 600
                            
                            # Set compensation amount
                            formatted_flight['compensation_amount_eur'] = compensation
                            
                            # Add to eligible flights list
                            all_eligible_flights.append(formatted_flight)
                            
                            # Save to storage for future reference
                            storage.add_flight(formatted_flight, source="AviationStack")
                
                airports_checked += 1
                
            except Exception as e:
                print(f"Error processing airport {airport}: {e}")
                errors += 1
                continue
        
        # Return results with both fresh AviationStack data and cached data
        return jsonify({
            'flights': all_eligible_flights,
            'count': len(all_eligible_flights),
            'airports_checked': airports_checked,
            'source': 'AviationStack API',
            'errors': errors
        })
    
    except Exception as e:
        print(f"Error in EU compensation eligible endpoint: {e}")
        return jsonify({
            'error': str(e),
            'flights': []
        }), 500


# Add this to test your AviationStack API key
@app.route('/test-aviationstack', methods=['GET'])
def test_aviationstack():
    """Test the AviationStack API connection."""
    try:
        api_key = os.environ.get('AVIATIONSTACK_API_KEY')
        
        if not api_key:
            return jsonify({
                'error': 'No AviationStack API key found in environment variables',
                'success': False
            }), 400
        
        # Initialize client
        client = AviationStackClient(api_key=api_key)
        
        # Make a simple test request
        test_flight = "LO282"
        result = client.get_flight_by_number(test_flight)
        
        return jsonify({
            'success': True,
            'message': f"Successfully connected to AviationStack API",
            'test_flight': test_flight,
            'results_count': len(result.get('data', [])),
            'sample_data': result.get('data', [])[0] if result.get('data') else None
        })
    
    except Exception as e:
        return jsonify({
            'error': str(e),
            'success': False
        }), 500
