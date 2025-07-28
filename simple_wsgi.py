"""
Ultra-simple WSGI application for Flight Compensation API
Uses only standard Python libraries - no Flask dependency
Place this at /var/www/piotrs_pythonanywhere_com_wsgi.py
"""
import sys
import os
import json
import logging
from datetime import datetime, timedelta
import urllib.parse

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.StreamHandler(sys.stdout)
    ]
)
logger = logging.getLogger(__name__)

# Path for flight data storage
DATA_FILE = "/home/PiotrS/data/flight_compensation_data.json"

# Create data directory if it doesn't exist
os.makedirs(os.path.dirname(DATA_FILE), exist_ok=True)

# Initialize empty data if file doesn't exist
if not os.path.exists(DATA_FILE):
    with open(DATA_FILE, "w") as f:
        json.dump({"flights": []}, f)

# Load flight data
def load_flight_data():
    try:
        with open(DATA_FILE, "r") as f:
            return json.load(f)
    except (json.JSONDecodeError, FileNotFoundError):
        logger.warning("Error reading data file or empty data file. Starting with empty flight list.")
        return {"flights": []}

# Save flight data
def save_flight_data(data):
    with open(DATA_FILE, "w") as f:
        json.dump(data, f, indent=2)

# SAFE status processing - explicit None handling
def get_status_lower(flight_record):
    """Safely get lowercase status from flight record, handling None values"""
    if flight_record is None:
        return ""
    
    status = flight_record.get('status')
    if status is None:
        return ""
    
    return status.lower()

# Check if a flight is eligible for compensation based on EU261
def is_eligible_for_compensation(flight, hours_ago=None):
    """
    Determines if a flight is eligible for compensation under EU261 rules
    with explicit handling of None values and missing fields
    """
    try:
        # Safe status processing with None handling
        status_lower = get_status_lower(flight)
        
        # Default values
        delay_minutes = flight.get('delayMinutes', 0)
        if delay_minutes is None:
            delay_minutes = 0
            
        # Only delayed or cancelled flights are eligible
        if "cancel" in status_lower or delay_minutes >= 180:  # 3+ hours delay
            # Check if airports are in EU
            departure_airport = flight.get('departure', {}).get('airport', {}).get('iata', '')
            arrival_airport = flight.get('arrival', {}).get('airport', {}).get('iata', '')
            
            # Simple check - in a real app would use a proper EU airport database
            eu_airports = ['MAD', 'CDG', 'FRA', 'AMS', 'FCO', 'LHR', 'MUC', 'BCN', 'ATH', 'VIE', 'WAW', 'DUB', 'BRU', 'LIS', 'HEL', 'PRG', 'CPH', 'BUD', 'ARN', 'TXL', 'OTP', 'SOF', 'LJU', 'RIX', 'VNO', 'TLL']
            
            # Either departure or arrival airport must be in the EU
            is_eu_flight = departure_airport in eu_airports or arrival_airport in eu_airports
            
            return is_eu_flight
        return False
    except Exception as e:
        logger.warning(f"Error determining eligibility: {str(e)}. Defaulting to not eligible.")
        return False

# Calculate compensation amount based on flight distance and delay
def calculate_compensation_amount(flight):
    """Calculate compensation amount in EUR with safe handling of None values"""
    try:
        distance_km = flight.get('distance_km', 0)
        if distance_km is None:
            distance_km = 0
            
        if distance_km <= 1500:
            return 250
        elif distance_km <= 3500:
            return 400
        else:
            return 600
    except Exception as e:
        logger.warning(f"Error calculating compensation: {str(e)}. Using default value.")
        return 0

# Process flights with ROBUST error handling
def process_flights(flights, hours_ago=None):
    """
    Process flight data with comprehensive error handling and None safety
    Returns eligible flights based on EU261 rules
    """
    eligible_flights = []
    processed_count = 0
    error_count = 0
    
    for flight in flights:
        try:
            # Process each flight with full error handling
            is_eligible = is_eligible_for_compensation(flight, hours_ago)
            
            # Only consider flights from specified time period if hours_ago is provided
            if hours_ago is not None:
                # Extract scheduled departure time
                departure_time_str = flight.get('departure', {}).get('scheduled', '')
                
                if not departure_time_str:
                    continue
                    
                try:
                    # Parse ISO format datetime
                    departure_time = datetime.fromisoformat(departure_time_str.replace('Z', '+00:00'))
                    
                    # Check if flight is within the specified time period
                    cutoff_time = datetime.now() - timedelta(hours=hours_ago)
                    if departure_time < cutoff_time:
                        continue
                except (ValueError, TypeError):
                    # Skip if datetime parsing fails
                    continue
            
            # Update flight with compensation information
            flight_copy = flight.copy()  # Don't modify original
            flight_copy['eligible_for_compensation'] = is_eligible
            
            if is_eligible:
                flight_copy['compensation_amount_eur'] = calculate_compensation_amount(flight)
                eligible_flights.append(flight_copy)
            
            processed_count += 1
            
        except Exception as e:
            # Log error but continue processing other flights
            error_count += 1
            logger.warning(f"Could not process a flight record due to an unexpected error: {str(e)}. Record: {json.dumps(flight)}")
            continue
    
    logger.info(f"Processed {processed_count} flights with {error_count} errors. Found {len(eligible_flights)} eligible flights to return.")
    return eligible_flights

def parse_query_string(query_string):
    """Parse query string into a dictionary"""
    if not query_string:
        return {}
    
    params = {}
    for param in query_string.split('&'):
        if '=' in param:
            key, value = param.split('=', 1)
            params[key] = urllib.parse.unquote_plus(value)
    
    return params

def json_response(data, status="200 OK"):
    """Return a JSON response with the given status"""
    response_body = json.dumps(data).encode('utf-8')
    return [response_body]

# Main WSGI application
def application(environ, start_response):
    """WSGI application function"""
    path = environ.get('PATH_INFO', '').rstrip('/')
    method = environ.get('REQUEST_METHOD', 'GET')
    query_string = environ.get('QUERY_STRING', '')
    params = parse_query_string(query_string)
    
    logger.info(f"Received {method} request to {path} with params: {params}")
    
    # Route requests based on path
    try:
        if path == '' or path == '/':
            # Root path - health check
            start_response('200 OK', [('Content-Type', 'text/html')])
            return [b'Flight Compensation API is running']
            
        elif path == '/api/flights':
            # Get all flights
            data = load_flight_data()
            flights = data.get("flights", [])
            
            start_response('200 OK', [('Content-Type', 'application/json')])
            return json_response({"flights": flights})
            
        elif path == '/api/eligible_flights':
            # Get eligible flights
            hours_ago = None
            if 'hours_ago' in params:
                try:
                    hours_ago = int(params['hours_ago'])
                except ValueError:
                    pass
                
            data = load_flight_data()
            flights = data.get("flights", [])
            eligible_flights = process_flights(flights, hours_ago)
            
            start_response('200 OK', [('Content-Type', 'application/json')])
            return json_response({"flights": eligible_flights})
            
        elif path.startswith('/api/flights/'):
            # Get specific flight
            flight_id = path.split('/')[-1]
            data = load_flight_data()
            flights = data.get("flights", [])
            
            for flight in flights:
                if flight.get('id') == flight_id:
                    start_response('200 OK', [('Content-Type', 'application/json')])
                    return json_response({"flight": flight})
            
            start_response('404 Not Found', [('Content-Type', 'application/json')])
            return json_response({"error": "Flight not found"})
            
        elif path == '/health':
            # Health check
            start_response('200 OK', [('Content-Type', 'application/json')])
            return json_response({
                "status": "healthy", 
                "timestamp": datetime.now().isoformat()
            })
            
        else:
            # Not found
            start_response('404 Not Found', [('Content-Type', 'application/json')])
            return json_response({"error": "Resource not found"})
            
    except Exception as e:
        # Log the error
        logger.error(f"Error processing request: {str(e)}")
        
        # Return an error response
        start_response('500 Internal Server Error', [('Content-Type', 'application/json')])
        return json_response({
            "error": "Internal server error", 
            "details": str(e)
        })
