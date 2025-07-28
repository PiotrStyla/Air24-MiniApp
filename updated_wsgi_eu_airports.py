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
            
            # EXPANDED EU AIRPORT LIST - Much more comprehensive coverage of European airports
            eu_airports = [
                # Major Western European hubs
                'MAD', 'BCN', 'AGP', 'PMI', 'ALC', 'IBZ',  # Spain
                'CDG', 'ORY', 'NCE', 'LYS', 'MRS', 'TLS', 'BOD',  # France
                'FRA', 'MUC', 'DUS', 'TXL', 'SXF', 'HAM', 'STR', 'CGN',  # Germany
                'AMS', 'RTM', 'EIN',  # Netherlands
                'BRU', 'CRL',  # Belgium
                'LHR', 'LGW', 'LTN', 'STN', 'MAN', 'EDI', 'GLA', 'BHX', 'BFS',  # UK
                'DUB', 'ORK', 'SNN',  # Ireland
                
                # Southern Europe
                'FCO', 'MXP', 'LIN', 'VCE', 'BLQ', 'NAP', 'CTA', 'PSA',  # Italy
                'LIS', 'OPO', 'FAO',  # Portugal
                'ATH', 'SKG', 'HER', 'RHO', 'CFU',  # Greece
                
                # Northern Europe
                'CPH', 'BLL', 'AAL',  # Denmark
                'ARN', 'GOT', 'MMX',  # Sweden
                'OSL', 'BGO', 'TRD', 'SVG',  # Norway
                'HEL', 'TMP', 'OUL',  # Finland
                
                # Eastern Europe
                'WAW', 'KRK', 'GDN', 'WRO', 'POZ', 'KTW',  # Poland
                'PRG', 'BRQ',  # Czech Republic
                'BUD', 'DEB',  # Hungary
                'OTP', 'CLJ', 'TSR',  # Romania
                'SOF',  # Bulgaria
                'LJU',  # Slovenia
                'ZAG', 'SPU', 'DBV',  # Croatia
                'RIX',  # Latvia
                'VNO', 'KUN',  # Lithuania
                'TLL',  # Estonia
                'BTS', 'KSC',  # Slovakia
                
                # Central Europe
                'VIE', 'SZG', 'INN', 'GRZ',  # Austria
                'GVA', 'ZRH', 'BSL',  # Switzerland
                
                # Other significant EU/EEA airports
                'KEF',  # Iceland
                'LUX',  # Luxembourg
                'MLT', 'MLA',  # Malta
                'LCA', 'PFO',  # Cyprus
                
                # Additional airports from your flight data
                'IST',  # Istanbul - Turkey (partial EU membership status)
            ]
            
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
            
            # Format the data to match what the app expects
            normalized_flight = {
                'flight_iata': flight_copy.get('flight', ''),
                'airline_name': flight_copy.get('airline', {}).get('name', 'Unknown Airline'),
                'airline_iata': flight_copy.get('airline', {}).get('iata', ''),
                'departure_airport_iata': flight_copy.get('departure', {}).get('airport', {}).get('iata', ''),
                'arrival_airport_iata': flight_copy.get('arrival', {}).get('airport', {}).get('iata', ''),
                'status': flight_copy.get('status', 'UNKNOWN'),
                'delay_minutes': flight_copy.get('delayMinutes', 0),
                'departure_scheduled_time': flight_copy.get('departure', {}).get('scheduled', ''),
                'arrival_scheduled_time': flight_copy.get('arrival', {}).get('scheduled', ''),
                'distance_km': flight_copy.get('distance_km', 0),
                'eligible_for_compensation': is_eligible,
            }
            
            if is_eligible:
                compensation_amount = calculate_compensation_amount(flight)
                normalized_flight['potentialCompensationAmount'] = compensation_amount
                normalized_flight['eligibility_details'] = {
                    'isEligible': True,
                    'estimatedCompensation': compensation_amount,
                    'reason': f"Flight {'delayed by ' + str(flight_copy.get('delayMinutes', 0)) + ' minutes' if flight_copy.get('delayMinutes', 0) >= 180 else 'cancelled'} (EU regulation EC 261/2004)"
                }
                eligible_flights.append(normalized_flight)
            
            processed_count += 1
            
        except Exception as e:
            # Log error but continue processing other flights
            error_count += 1
            logger.warning(f"Could not process a flight record due to an unexpected error: {str(e)}. Record: {json.dumps(flight)[:500]}")
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
    
    # Set CORS headers for all responses
    headers = [
        ('Content-Type', 'application/json'),
        ('Access-Control-Allow-Origin', '*'),
        ('Access-Control-Allow-Methods', 'GET, POST, OPTIONS'),
        ('Access-Control-Allow-Headers', 'Content-Type')
    ]
    
    # Route requests based on path
    try:
        if path == '' or path == '/':
            # Root path - health check
            start_response('200 OK', [('Content-Type', 'text/plain')])
            return [b'Flight Compensation API is running...']
            
        # NEW ENDPOINT: match what the Flutter app is looking for
        elif path == '/eligible_flights':
            # Get eligible flights (ENDPOINT THAT FLUTTER APP EXPECTS)
            hours = 72  # Default
            if 'hours' in params:
                try:
                    hours = int(params['hours'])
                except ValueError:
                    pass
                
            data = load_flight_data()
            flights = data.get("flights", [])
            eligible_flights = process_flights(flights, hours)
            
            # Return as a list as expected by the Flutter app
            start_response('200 OK', headers)
            return json_response(eligible_flights)
            
        # Maintain compatibility with the /api prefixed routes
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
            
            start_response('200 OK', headers)
            return json_response({"flights": eligible_flights})
            
        # NEW ENDPOINT: environment information
        elif path == '/environment':
            # Get environment information
            environment_info = {
                "python_version": sys.version,
                "platform": sys.platform,
                "data_file_path": DATA_FILE,
                "data_file_exists": os.path.exists(DATA_FILE),
                "timestamp": datetime.now().isoformat(),
                "hostname": os.environ.get('HOSTNAME', 'unknown'),
                "user": os.environ.get('USER', 'unknown'),
                "home": os.environ.get('HOME', 'unknown'),
                "path": os.environ.get('PATH', 'unknown'),
            }
            
            start_response('200 OK', headers)
            return json_response(environment_info)
            
        # NEW ENDPOINT: check data file
        elif path == '/check_data_file':
            # Check if data file exists and get stats
            file_info = {
                "exists": os.path.exists(DATA_FILE),
                "path": DATA_FILE,
            }
            
            if file_info["exists"]:
                # Add file stats
                file_stats = os.stat(DATA_FILE)
                file_info.update({
                    "size_bytes": file_stats.st_size,
                    "last_modified": datetime.fromtimestamp(file_stats.st_mtime).isoformat(),
                    "created": datetime.fromtimestamp(file_stats.st_ctime).isoformat(),
                })
                
                # Add flight count
                try:
                    data = load_flight_data()
                    flights = data.get("flights", [])
                    file_info["flight_count"] = len(flights)
                    file_info["eligible_flight_count"] = len(process_flights(flights))
                except Exception as e:
                    file_info["error"] = f"Error reading flight data: {str(e)}"
            
            start_response('200 OK', headers)
            return json_response(file_info)

        # DEBUG ENDPOINT: Get raw flight data structure
        elif path == '/debug_flight_data':
            data = load_flight_data()
            flights = data.get("flights", [])
            
            # Return first 2 flights exactly as they are in the file
            sample_data = {
                "total_flights": len(flights),
                "sample_flights": flights[:2] if len(flights) > 0 else []
            }
            
            start_response('200 OK', headers)
            return json_response(sample_data)
            
        # DEBUG ENDPOINT: Check eligibility criteria for each flight
        elif path == '/debug_eligibility':
            data = load_flight_data()
            flights = data.get("flights", [])
            results = []
            
            # EXPANDED EU AIRPORT LIST - Same as in is_eligible_for_compensation
            eu_airports = [
                # Major Western European hubs
                'MAD', 'BCN', 'AGP', 'PMI', 'ALC', 'IBZ',  # Spain
                'CDG', 'ORY', 'NCE', 'LYS', 'MRS', 'TLS', 'BOD',  # France
                'FRA', 'MUC', 'DUS', 'TXL', 'SXF', 'HAM', 'STR', 'CGN',  # Germany
                'AMS', 'RTM', 'EIN',  # Netherlands
                'BRU', 'CRL',  # Belgium
                'LHR', 'LGW', 'LTN', 'STN', 'MAN', 'EDI', 'GLA', 'BHX', 'BFS',  # UK
                'DUB', 'ORK', 'SNN',  # Ireland
                
                # Southern Europe
                'FCO', 'MXP', 'LIN', 'VCE', 'BLQ', 'NAP', 'CTA', 'PSA',  # Italy
                'LIS', 'OPO', 'FAO',  # Portugal
                'ATH', 'SKG', 'HER', 'RHO', 'CFU',  # Greece
                
                # Northern Europe
                'CPH', 'BLL', 'AAL',  # Denmark
                'ARN', 'GOT', 'MMX',  # Sweden
                'OSL', 'BGO', 'TRD', 'SVG',  # Norway
                'HEL', 'TMP', 'OUL',  # Finland
                
                # Eastern Europe
                'WAW', 'KRK', 'GDN', 'WRO', 'POZ', 'KTW',  # Poland
                'PRG', 'BRQ',  # Czech Republic
                'BUD', 'DEB',  # Hungary
                'OTP', 'CLJ', 'TSR',  # Romania
                'SOF',  # Bulgaria
                'LJU',  # Slovenia
                'ZAG', 'SPU', 'DBV',  # Croatia
                'RIX',  # Latvia
                'VNO', 'KUN',  # Lithuania
                'TLL',  # Estonia
                'BTS', 'KSC',  # Slovakia
                
                # Central Europe
                'VIE', 'SZG', 'INN', 'GRZ',  # Austria
                'GVA', 'ZRH', 'BSL',  # Switzerland
                
                # Other significant EU/EEA airports
                'KEF',  # Iceland
                'LUX',  # Luxembourg
                'MLT', 'MLA',  # Malta
                'LCA', 'PFO',  # Cyprus
                
                # Additional airports from your flight data
                'IST',  # Istanbul - Turkey (partial EU membership status)
            ]
            
            for i, flight in enumerate(flights[:10]):  # Check first 10 flights
                status = flight.get('status', '')
                delay_minutes = flight.get('delayMinutes', 0)
                dep_airport = flight.get('departure', {}).get('airport', {}).get('iata', '')
                arr_airport = flight.get('arrival', {}).get('airport', {}).get('iata', '')
                
                results.append({
                    "index": i,
                    "flight": flight.get('flight', ''),
                    "status": status,
                    "status_lower": status.lower() if status else "",
                    "delay_minutes": delay_minutes,
                    "departure_airport": dep_airport,
                    "arrival_airport": arr_airport,
                    "status_check": "cancel" in status.lower() if status else False,
                    "delay_check": delay_minutes >= 180 if delay_minutes else False,
                    "airport_check": dep_airport in eu_airports or arr_airport in eu_airports,
                    "is_eligible": is_eligible_for_compensation(flight)
                })
            
            debug_info = {
                "total_flights": len(flights),
                "eligible_count": len(process_flights(flights)),
                "flight_samples": results
            }
            
            start_response('200 OK', headers)
            return json_response(debug_info)

        elif path == '/api/flights':
            # Get all flights
            data = load_flight_data()
            flights = data.get("flights", [])
            
            start_response('200 OK', headers)
            return json_response({"flights": flights})
            
        elif path.startswith('/api/flights/'):
            # Get specific flight
            flight_id = path.split('/')[-1]
            data = load_flight_data()
            flights = data.get("flights", [])
            
            for flight in flights:
                if flight.get('id') == flight_id:
                    start_response('200 OK', headers)
                    return json_response({"flight": flight})
            
            start_response('404 Not Found', headers)
            return json_response({"error": "Flight not found"})
            
        elif path == '/health' or path == '/status':
            # Health check
            start_response('200 OK', headers)
            return json_response({
                "status": "healthy", 
                "timestamp": datetime.now().isoformat(),
                "data_file": {
                    "exists": os.path.exists(DATA_FILE),
                    "path": DATA_FILE,
                    "size_bytes": os.path.getsize(DATA_FILE) if os.path.exists(DATA_FILE) else 0
                }
            })
            
        else:
            # Not found
            logger.warning(f"Endpoint not found: {path}")
            start_response('404 Not Found', headers)
            return json_response({"error": "Resource not found"})
            
    except Exception as e:
        # Log the error
        logger.error(f"Error processing request: {str(e)}")
        
        # Return an error response
        start_response('500 Internal Server Error', headers)
        return json_response({
            "error": "Internal server error", 
            "details": str(e)
        })
