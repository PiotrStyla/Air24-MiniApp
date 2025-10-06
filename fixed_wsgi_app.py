"""
Fixed WSGI application for Flight Compensation API
This file contains a robust implementation that handles None values in flight status
"""
import json
import os
import logging
from datetime import datetime, timedelta
import urllib.parse
import sys
from flask import Flask, jsonify, request

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Path for flight data storage
# Correct, absolute path for PythonAnywhere environment
DATA_FILE = "/home/PiotrS/flight_compensation/data/flight_compensation_data.json"

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
    Determines if a flight is eligible for compensation under EU261 rules.
    This function now uses the corrected, normalized data structure.
    """
    try:
        status_lower = get_status_lower(flight)
        delay_minutes = flight.get('delay_minutes', 0) or 0

        # A flight is eligible if it's cancelled or delayed by 3+ hours (180 minutes).
        is_eligible_status = "cancel" in status_lower or delay_minutes >= 180
        if not is_eligible_status:
            return False

        # Check if the flight involves an EU airport.
        # The data is already normalized, so we can access keys directly.
        departure_airport = flight.get('departure_airport_iata', '')
        arrival_airport = flight.get('arrival_airport_iata', '')
        
        # In a real app, this list would be more comprehensive or use a library.
        eu_airports = ['MAD', 'CDG', 'FRA', 'AMS', 'FCO', 'LHR', 'MUC', 'BCN', 'ATH', 'VIE', 'WAW', 'DUB', 'BRU', 'LIS', 'HEL', 'PRG', 'CPH', 'BUD', 'ARN', 'TXL', 'OTP', 'SOF', 'LJU', 'RIX', 'VNO', 'TLL']
        
        # EU261 applies if departure or arrival is in the EU.
        is_eu_flight = departure_airport in eu_airports or arrival_airport in eu_airports
        
        return is_eu_flight
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
                # Extract scheduled departure time from the normalized top-level key
                departure_time_str = flight.get('departure_scheduled_time', '')
                
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

# Initialize Flask application
app = Flask(__name__)
application = app  # For WSGI compatibility

@app.route('/')
def index():
    return "Flight Compensation API is running"

@app.route('/api/flights', methods=['GET'])
def get_flights():
    """Get all flights from the database"""
    try:
        data = load_flight_data()
        flights = data.get("flights", [])
        return jsonify({"flights": flights})
    except Exception as e:
        logger.error(f"Error in /api/flights: {str(e)}")
        return jsonify({"error": "Internal server error", "details": str(e)}), 500

@app.route('/compensation-check', methods=['GET'])
def compensation_check():
    """Ad-hoc live eligibility check via AviationStack (server-side)."""
    flight_number = (request.args.get('flight_number') or '').strip()
    date = (request.args.get('date') or '').strip()  # optional YYYY-MM-DD

    if not flight_number:
        return jsonify({
            "eligible": False,
            "message": "Missing flight number",
            "error": "missing_flight_number"
        }), 400

    # Import AviationStack client from deployment folder
    try:
        sys.path.append(os.path.join(os.path.dirname(__file__), 'deployment'))
        from aviationstack_client import AviationStackClient  # type: ignore
        client = AviationStackClient()
    except Exception as e:
        logger.error(f"AviationStack client error: {e}")
        return jsonify({
            "eligible": False,
            "message": "AviationStack client not configured",
            "error": str(e),
        }), 500

    # Fetch flights by number
    flights = client.get_flight_by_number(flight_number) or []

    # Optionally filter by date
    if date:
        filtered = []
        for f in flights:
            try:
                if ((f.get('flight_date') and date in str(f.get('flight_date'))) or
                    (f.get('departure', {}).get('scheduled') and date in str(f['departure']['scheduled']))):
                    filtered.append(f)
            except Exception:
                continue
        flights = filtered

    if not flights:
        return jsonify({
            "eligible": False,
            "message": "No flight found for given number/date"
        })

    f = flights[0]

    dep = f.get('departure') or {}
    arr = f.get('arrival') or {}
    airline = f.get('airline') or {}
    flight_field = f.get('flight') or {}

    # Determine delay minutes
    delay_minutes = 0
    try:
        d = dep.get('delay')
        if isinstance(d, int):
            delay_minutes = max(delay_minutes, d)
    except Exception:
        pass
    try:
        a = arr.get('delay')
        if isinstance(a, int):
            delay_minutes = max(delay_minutes, a)
    except Exception:
        pass

    status = (f.get('flight_status') or '').upper()

    # Build minimal normalized structure
    normalized = {
        'flight_number': flight_field.get('iata') or flight_number,
        'airline': airline.get('iata') or airline.get('name') or 'Unknown',
        'departure_airport': dep.get('iata') or '',
        'arrival_airport': arr.get('iata') or '',
        'status': status,
        'delay_minutes': delay_minutes,
    }

    # Eligibility
    try:
        # Use local helper if available
        eligible = is_eligible_for_compensation({
            'status': status,
            'delayMinutes': delay_minutes,
            'departure': {'airport': {'iata': normalized['departure_airport']}},
            'arrival': {'airport': {'iata': normalized['arrival_airport']}},
        })
        compensation = calculate_compensation_amount({
            'distance_km': 2000  # default banding; refine if you add distance calc
        }) if eligible else 0
    except Exception:
        is_cancelled = 'CANCEL' in status
        is_diverted = 'DIVERT' in status
        eligible = (delay_minutes >= 180) or is_cancelled or is_diverted
        compensation = 400 if eligible else 0

    result = {
        'flight_number': normalized['flight_number'],
        'airline': airline.get('name') or normalized['airline'],
        'status': status,
        'departure_airport': normalized['departure_airport'],
        'arrival_airport': normalized['arrival_airport'],
        'delay_minutes': delay_minutes,
        'is_eligible': bool(eligible),
        'compensation_amount_eur': int(compensation) if isinstance(compensation, int) else 0,
        'currency': 'EUR',
        'eu_regulation_applies': True,
    }

    return jsonify(result)

@app.route('/api/eligible_flights', methods=['GET'])
def get_eligible_flights():
    """Get flights eligible for compensation"""
    try:
        # Get hours_ago parameter (optional)
        hours_ago = request.args.get('hours_ago', default=None, type=int)
        if hours_ago is not None:
            logger.info(f"Received request for eligible flights within the last {hours_ago} hours.")
        else:
            logger.info("Received request for all eligible flights.")
            
        # Load and process flights
        data = load_flight_data()
        flights = data.get("flights", [])
        logger.info(f"Loaded {len(flights)} flights from data file.")

        # Log the first flight record if available, to check structure
        if flights:
            logger.info(f"First flight record sample: {json.dumps(flights[0])}")

        eligible_flights = process_flights(flights, hours_ago)
        logger.info(f"[DIAGNOSTIC] After processing, found {len(eligible_flights)} eligible flights to return.")

        # Add a final diagnostic log
        if not eligible_flights and flights:
            logger.warning("[DIAGNOSTIC] Loaded flights from file but none were deemed eligible by the filter criteria.")
        elif not flights:
            logger.warning("[DIAGNOSTIC] The data file was loaded, but it contained no flight records.")

        return jsonify({"flights": eligible_flights})
    except Exception as e:
        logger.error(f"Error in /api/eligible_flights: {str(e)}")
        return jsonify({"error": "Internal server error", "details": str(e)}), 500

@app.route('/api/flights/<flight_id>', methods=['GET'])
def get_flight(flight_id):
    """Get a specific flight by ID"""
    try:
        data = load_flight_data()
        flights = data.get("flights", [])
        
        # Find flight with matching ID
        for flight in flights:
            if flight.get('id') == flight_id:
                return jsonify({"flight": flight})
        
        return jsonify({"error": "Flight not found"}), 404
    except Exception as e:
        logger.error(f"Error in /api/flights/{flight_id}: {str(e)}")
        return jsonify({"error": "Internal server error", "details": str(e)}), 500

# Health check endpoint
@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({"status": "healthy", "timestamp": datetime.now().isoformat()})

# Error handlers
@app.errorhandler(404)
def not_found(error):
    return jsonify({"error": "Resource not found"}), 404

@app.errorhandler(500)
def server_error(error):
    return jsonify({"error": "Internal server error"}), 500

# Run the application
if __name__ == "__main__":
    app.run(debug=True)
