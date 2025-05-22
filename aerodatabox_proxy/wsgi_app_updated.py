# wsgi_app.py - Updated WSGI application with AviationStack integration
import json
import os
import logging
from datetime import datetime
import urllib.parse
import sys

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Path for flight data storage
DATA_FILE = "./data/flight_compensation_data.json"

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
        return {"flights": []}

# Save flight data
def save_flight_data(data):
    with open(DATA_FILE, "w") as f:
        json.dump(data, f, indent=2)
        
# Process flights and return formatted JSON response
def process_and_return_flights(raw_flights, start_response):
    # Transform flight data to match what the app expects
    transformed_flights = []
    for flight in raw_flights:
        # Skip flights without required fields
        if not flight.get('flight') or not flight.get('departure') or not flight.get('arrival'):
            continue
            
        # Calculate if this flight is eligible for compensation (3+ hour delay or cancellation)
        delay_minutes = flight.get('delay', 0)
        
        # Check flight status for cancellations
        status = flight.get('status', '').lower()
        is_cancelled = 'cancel' in status  # Check if status contains 'cancelled' or similar
        
        # Flight is eligible if it has 3+ hour delay, is cancelled, or was already marked eligible
        is_eligible = delay_minutes >= 180 or is_cancelled or flight.get('eligible_for_compensation', False)
        
        # Calculate compensation amount based on distance
        compensation_amount = 0
        if is_eligible:
            distance_km = flight.get('distance_km', 2000)  # Default to medium haul if not specified
            if distance_km <= 1500:
                compensation_amount = 250  # Short haul
            elif distance_km <= 3500:
                compensation_amount = 400  # Medium haul
            else:
                compensation_amount = 600  # Long haul
            
        transformed = {
            'flight_number': flight.get('flight'),
            'airline': flight.get('airline', {}).get('iata', 'Unknown'),
            'departure_airport': flight.get('departure', {}).get('airport', {}).get('iata', 'Unknown'),
            'arrival_airport': flight.get('arrival', {}).get('airport', {}).get('iata', 'Unknown'),
            'departure_date': flight.get('departure', {}).get('scheduledTime', ''),
            'arrival_date': flight.get('arrival', {}).get('scheduledTime', ''),
            'status': 'Delayed' if delay_minutes > 0 else flight.get('status', 'Unknown'),
            'delay_minutes': delay_minutes,
            'eligible_for_compensation': is_eligible,
            'compensation_amount_eur': compensation_amount,
            'distance_km': flight.get('distance_km', 2000)
        }
        transformed_flights.append(transformed)
    
    # Return results
    response = json.dumps({
        "flights": transformed_flights,
        "count": len(transformed_flights),
        "source": "database"
    }).encode('utf-8')
    
    start_response('200 OK', [('Content-Type', 'application/json'),
                            ('Access-Control-Allow-Origin', '*')])
    return [response]

# Add a flight to storage
def add_flight(flight_data, source="API"):
    data = load_flight_data()
    
    # Add timestamp and source info
    flight_data["added_at"] = datetime.utcnow().isoformat()
    flight_data["source"] = source
    
    # Check if flight already exists to avoid duplicates
    flight_exists = False
    for existing in data["flights"]:
        if (existing.get("flight_number") == flight_data.get("flight_number") and
            existing.get("departure_date") == flight_data.get("departure_date")):
            flight_exists = True
            # Update with new data
            existing.update(flight_data)
            break
    
    # Add if it's a new flight
    if not flight_exists:
        data["flights"].append(flight_data)
    
    save_flight_data(data)
    return flight_data

# WSGI application
def application(environ, start_response):
    path = environ.get('PATH_INFO', '').rstrip('/')
    
    # Log request for debugging
    logger.info(f"Request path: {path}")
    
    if path == '' or path == '/':
        # Home page
        start_response('200 OK', [('Content-Type', 'text/html')])
        return [b"""
        <html>
            <head>
                <title>Flight Compensation API</title>
                <style>
                    body { font-family: Arial, sans-serif; margin: 40px; line-height: 1.6; }
                    h1 { color: #333; }
                    p { margin-bottom: 20px; }
                    .button {
                        display: inline-block;
                        padding: 10px 20px;
                        background-color: #4CAF50;
                        color: white;
                        text-decoration: none;
                        border-radius: 4px;
                        font-weight: bold;
                    }
                </style>
            </head>
            <body>
                <h1>Flight Compensation API</h1>
                <p>This is your centralized database for flight compensation data.</p>
                <p>To test the API directly, try these endpoints:</p>
                <ul>
                    <li><a href="/compensation-check?flight_number=LO282&date=2024-03-15">Test Compensation Check</a></li>
                    <li><a href="/flights">View All Flights</a></li>
                    <li><a href="/eu-compensation-eligible?hours=72">EU Compensation Eligible Flights</a></li>
                    <li><a href="/test-aviationstack">Test AviationStack Connection</a></li>
                </ul>
                <p>Your Flutter app will connect to this API for both WiFi and mobile data connections.</p>
            </body>
        </html>
        """]
    
    elif path == '/flights':
        # Get all flights
        data = load_flight_data()
        raw_flights = data.get("flights", [])
        
        # Transform flight data to match what the app expects
        transformed_flights = []
        for flight in raw_flights:
            # Skip flights without required fields
            if not flight.get('flight') or not flight.get('departure') or not flight.get('arrival'):
                continue
                
            transformed = {
                'flight_number': flight.get('flight'),
                'airline': flight.get('airline', {}).get('iata', 'Unknown'),
                'departure_airport': flight.get('departure', {}).get('airport', {}).get('iata', 'Unknown'),
                'arrival_airport': flight.get('arrival', {}).get('airport', {}).get('iata', 'Unknown'),
                'departure_date': flight.get('departure', {}).get('scheduledTime', ''),
                'arrival_date': flight.get('arrival', {}).get('scheduledTime', ''),
                'status': flight.get('status', 'Unknown'),
                'delay_minutes': flight.get('delay', 0),
                'eligible_for_compensation': flight.get('eligible_for_compensation', False),
                'compensation_amount_eur': flight.get('compensation_amount_eur', 0),
                'distance_km': flight.get('distance_km', 0)
            }
            transformed_flights.append(transformed)
        
        response = json.dumps({"flights": transformed_flights}).encode('utf-8')
        start_response('200 OK', [('Content-Type', 'application/json')])
        return [response]
    
    elif path == '/compensation-check':
        # Parse query parameters
        query_string = environ.get('QUERY_STRING', '')
        params = urllib.parse.parse_qs(query_string)
        
        flight_number = params.get('flight_number', [''])[0]
        date = params.get('date', [''])[0]
        
        if not flight_number or not date:
            response = json.dumps({
                "eligible": False,
                "message": "Missing flight number or date"
            }).encode('utf-8')
            start_response('400 Bad Request', [('Content-Type', 'application/json')])
            return [response]
        
        try:
            data = load_flight_data()
            flights = data.get("flights", [])
            
            # Find matching flights
            matching_flights = []
            for flight in flights:
                if flight.get("flight_number", "").upper() == flight_number.upper():
                    flight_date = flight.get("departure_date", "")
                    if date in flight_date:
                        matching_flights.append(flight)
            
            # Generate response
            if matching_flights:
                response = json.dumps({
                    "eligible": True,
                    "flights": matching_flights,
                    "message": "Flight is eligible for compensation!"
                }).encode('utf-8')
            else:
                response = json.dumps({
                    "eligible": False,
                    "message": "No matching flights found for compensation."
                }).encode('utf-8')
                
            start_response('200 OK', [('Content-Type', 'application/json')])
            return [response]
            
        except Exception as e:
            logger.error(f"Error in compensation check: {str(e)}")
            response = json.dumps({
                "eligible": False,
                "error": str(e),
                "message": "An error occurred while checking compensation eligibility."
            }).encode('utf-8')
            start_response('500 Internal Server Error', [('Content-Type', 'application/json')])
            return [response]
    
    elif path == '/eu-compensation-eligible':
        # New endpoint for EU-wide compensation eligible flights - optimized version
        try:
            # Parse query parameters
            query_string = environ.get('QUERY_STRING', '')
            params = urllib.parse.parse_qs(query_string)
            
            # Get hours parameter with default
            hours_param = params.get('hours', ['72'])[0]
            try:
                hours = int(hours_param)
            except ValueError:
                hours = 72
            
            logger.info(f"Processing EU compensation request for last {hours} hours")
            
            # Load all flights from the database 
            try:
                # Use direct file access for maximum speed
                all_flights = load_flight_data().get("flights", [])
                logger.info(f"Loaded {len(all_flights)} flights from database")
                
                # Add additional eligible flights based on delay criteria
                # This is faster than using the FlightDataStorage class
                eligible_flights = []
                for flight in all_flights:
                    # Skip flights without required fields
                    if not flight.get('flight') or not flight.get('departure') or not flight.get('arrival'):
                        continue
                        
                    # Check delay to see if eligible
                    delay = flight.get('delay', 0)
                    # Check flight status for cancellations
                    status = flight.get('status', '').lower()
                    is_cancelled = 'cancel' in status  # Check if status contains 'cancelled' or similar
                    
                    # Mark as eligible if 3+ hour delay, cancellation, or already marked
                    if delay >= 180 or is_cancelled or flight.get('eligible_for_compensation', False):
                        eligible_flights.append(flight)
                
                logger.info(f"Found {len(eligible_flights)} eligible flights in database")
                
                # Process and return the flights
                return process_and_return_flights(eligible_flights, start_response)
                
            except Exception as e:
                logger.error(f"Error accessing flight database: {str(e)}")
                response = json.dumps({
                    "error": str(e),
                    "flights": [],
                    "message": "Error accessing flight database. Please try again later."
                }).encode('utf-8')
                start_response('500 Internal Server Error', [
                    ('Content-Type', 'application/json'),
                    ('Access-Control-Allow-Origin', '*')
                ])
                return [response]
        
        except Exception as e:
            logger.error(f"Error in EU compensation endpoint: {str(e)}")
            response = json.dumps({
                "error": str(e),
                "flights": []
            }).encode('utf-8')
            start_response('500 Internal Server Error', [
                ('Content-Type', 'application/json'),
                ('Access-Control-Allow-Origin', '*')
            ])
            return [response]
    
    elif path == '/test-aviationstack':
        # Test endpoint for AviationStack API
        try:
            # Import AviationStack client
            try:
                sys.path.append(os.path.dirname(__file__))  # Ensure module is in path
                from aviationstack_client import AviationStackClient
                client = AviationStackClient()
            except ImportError as e:
                logger.error(f"Error importing AviationStack client: {e}")
                response = json.dumps({
                    "success": False,
                    "error": f"AviationStack client not available: {str(e)}"
                }).encode('utf-8')
                start_response('500 Internal Server Error', [('Content-Type', 'application/json')])
                return [response]
            
            # Make a test request
            test_flight = "LO282"
            result = client.get_flight_by_number(test_flight)
            
            response = json.dumps({
                "success": True,
                "message": "Successfully connected to AviationStack API",
                "test_flight": test_flight,
                "results_count": len(result),
                "sample_data": result[0] if result else None
            }).encode('utf-8')
            
            start_response('200 OK', [('Content-Type', 'application/json')])
            return [response]
            
        except Exception as e:
            logger.error(f"Error testing AviationStack API: {str(e)}")
            response = json.dumps({
                "success": False,
                "error": str(e)
            }).encode('utf-8')
            start_response('500 Internal Server Error', [('Content-Type', 'application/json')])
            return [response]
    
    else:
        # 404 Not Found
        start_response('404 Not Found', [('Content-Type', 'text/html')])
        return [b"""
        <html>
            <head>
                <title>404 Not Found</title>
                <style>
                    body { font-family: Arial, sans-serif; margin: 40px; line-height: 1.6; }
                    h1 { color: #333; }
                </style>
            </head>
            <body>
                <h1>404 Not Found</h1>
                <p>The requested URL was not found on this server.</p>
                <p><a href="/">Return to home page</a></p>
            </body>
        </html>
        """]
