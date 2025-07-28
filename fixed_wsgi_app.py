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
        eligible_flights = process_flights(flights, hours_ago)
        
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
