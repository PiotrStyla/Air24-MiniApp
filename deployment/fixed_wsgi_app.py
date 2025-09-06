# fixed_wsgi_app.py - Updated WSGI application with fixes for 500 errors
import json
import os
import logging
from datetime import datetime, timedelta
import urllib.parse
import sys

# Import EU airports module
try:
    from eu_airports import is_eligible_for_eu261, calculate_eu261_compensation, is_airport_in_eu
    EU_AIRPORTS_MODULE_LOADED = True
except ImportError:
    logging.warning("EU airports module not found. Using basic eligibility checks.")
    EU_AIRPORTS_MODULE_LOADED = False

# Helper: check if any provided timestamp is within the last N hours
def _is_within_hours(hours, *iso_timestamps):
    try:
        cutoff = datetime.utcnow() - timedelta(hours=hours)
    except Exception:
        return True  # If we cannot compute, do not over-filter
    for ts in iso_timestamps:
        try:
            if not ts:
                continue
            s = str(ts).replace('Z', '+00:00')
            dt = datetime.fromisoformat(s)
            if dt.tzinfo is not None:
                # Normalize to UTC
                dt_utc = dt.astimezone(tz=None).replace(tzinfo=None)
            else:
                dt_utc = dt
            if dt_utc >= cutoff:
                return True
        except Exception:
            continue
    return False

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
        
        # FIX: Check flight status for cancellations - handle None status safely
        status = flight.get('status')
        # First check if status is None or empty, then call .lower() only if it's a valid string
        status_lower = status.lower() if status else ""
        is_cancelled = 'cancel' in status_lower  # Check if status contains 'cancelled' or similar
        
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
    try:
        data = load_flight_data()
        
        # Add source information
        flight_data["source"] = source
        flight_data["added_at"] = datetime.now().isoformat()
        
        # Check if flight already exists to avoid duplicates
        flight_exists = False
        for existing_flight in data["flights"]:
            if (existing_flight.get("flight") == flight_data.get("flight") and
                existing_flight.get("departure", {}).get("scheduledTime") == 
                flight_data.get("departure", {}).get("scheduledTime")):
                flight_exists = True
                break
                
        if not flight_exists:
            data["flights"].append(flight_data)
            save_flight_data(data)
            return True
        return False
    except Exception as e:
        logger.error(f"Error adding flight: {str(e)}")
        return False

# Map AviationStack API flight object to this app's internal storage format
def _map_avstack_to_internal(flight):
    try:
        status = (flight.get('flight_status') or flight.get('status') or '').upper()
        dep = flight.get('departure') or {}
        arr = flight.get('arrival') or {}
        airline = flight.get('airline') or {}
        flight_field = flight.get('flight') or {}

        # Determine delay minutes from API if present (prefer arrival, then departure)
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
                # Prefer arrival delay for EU261
                delay_minutes = max(delay_minutes, a)
        except Exception:
            pass

        mapped = {
            'flight': flight_field.get('iata') or flight.get('flight_iata') or '',
            'airline': {
                'iata': airline.get('iata', 'Unknown'),
                'name': airline.get('name', 'Unknown'),
            },
            'departure': {
                'airport': {
                    'iata': dep.get('iata') or '',
                    'name': dep.get('airport') or '',
                },
                'scheduledTime': dep.get('scheduled') or '',
            },
            'arrival': {
                'airport': {
                    'iata': arr.get('iata') or '',
                    'name': arr.get('airport') or '',
                },
                'scheduledTime': arr.get('scheduled') or '',
            },
            'status': status,
            # Internal code expects 'delay' in minutes
            'delay': delay_minutes,
            # Distance may be absent; default to 2000 for compensation banding
            'distance_km': flight.get('distance_km', 2000),
        }
        return mapped
    except Exception as e:
        logger.error(f"Error mapping AviationStack flight: {str(e)}")
        return None

# Refresh eligible flights from AviationStack and persist to local JSON cache
def _refresh_eu_eligible_flights_from_aviationstack(hours=72):
    try:
        sys.path.append(os.path.dirname(__file__))
        from aviationstack_client import AviationStackClient
        client = AviationStackClient()
    except Exception as e:
        logger.error(f"Cannot initialize AviationStack client: {str(e)}")
        return {'refreshed': False, 'added': 0, 'errors': 1, 'message': str(e)}

    eu_airports = ['FRA', 'CDG', 'AMS', 'MAD', 'FCO', 'LHR', 'MUC', 'BCN', 'LIS', 'VIE', 'WAW']
    added = 0
    errors = 0

    logger.info(f"Refreshing eligible flights from AviationStack for {len(eu_airports)} airports")

    for airport in eu_airports:
        try:
            # 1) Arrivals to EU airport (captures inbound disruptions)
            params_arr = {
                'arr_iata': airport,
                'flight_status': 'active,landed,cancelled,diverted',
                'limit': 100,
            }
            flights = client.get_flights(params=params_arr) or []

            for f in flights:
                mapped = _map_avstack_to_internal(f)
                if not mapped:
                    continue

                status_lower = (mapped.get('status') or '').lower()
                is_cancelled = 'cancel' in status_lower
                is_diverted = 'divert' in status_lower
                delay = mapped.get('delay') or 0

                # Time window filter (use both dep/arr scheduled)
                dep_time = mapped.get('departure', {}).get('scheduledTime')
                arr_time = mapped.get('arrival', {}).get('scheduledTime')
                if not _is_within_hours(hours, dep_time, arr_time):
                    continue

                # EU route-aware eligibility if module is available
                try:
                    if EU_AIRPORTS_MODULE_LOADED:
                        mapped_for_check = {
                            'airline': mapped.get('airline'),
                            'departure': mapped.get('departure'),
                            'arrival': mapped.get('arrival'),
                            'status': mapped.get('status'),
                            'delay': mapped.get('delay'),
                        }
                        eligible = is_eligible_for_eu261(mapped_for_check)
                    else:
                        eligible = (delay >= 180) or is_cancelled or is_diverted
                except Exception:
                    eligible = (delay >= 180) or is_cancelled or is_diverted

                if eligible:
                    mapped['eligible_for_compensation'] = True
                    if add_flight(mapped, source="AviationStack"):
                        added += 1
        except Exception as e:
            errors += 1
            logger.error(f"Error processing airport {airport}: {str(e)}")

        # 2) Departures from EU airport (captures outbound EU flights that later arrive with delay)
        try:
            params_dep = {
                'dep_iata': airport,
                'flight_status': 'active,landed,cancelled,diverted',
                'limit': 100,
            }
            flights_dep = client.get_flights(params=params_dep) or []

            for f in flights_dep:
                mapped = _map_avstack_to_internal(f)
                if not mapped:
                    continue

                status_lower = (mapped.get('status') or '').lower()
                is_cancelled = 'cancel' in status_lower
                is_diverted = 'divert' in status_lower
                delay = mapped.get('delay') or 0

                dep_time = mapped.get('departure', {}).get('scheduledTime')
                arr_time = mapped.get('arrival', {}).get('scheduledTime')
                if not _is_within_hours(hours, dep_time, arr_time):
                    continue

                # Route must depart from EU; this loop ensures dep EU. Let eligibility logic handle disruption rule.
                try:
                    if EU_AIRPORTS_MODULE_LOADED:
                        mapped_for_check = {
                            'airline': mapped.get('airline'),
                            'departure': mapped.get('departure'),
                            'arrival': mapped.get('arrival'),
                            'status': mapped.get('status'),
                            'delay': mapped.get('delay'),
                        }
                        eligible = is_eligible_for_eu261(mapped_for_check)
                    else:
                        eligible = (delay >= 180) or is_cancelled or is_diverted
                except Exception:
                    eligible = (delay >= 180) or is_cancelled or is_diverted

                if eligible:
                    mapped['eligible_for_compensation'] = True
                    if add_flight(mapped, source="AviationStack"):
                        added += 1
        except Exception as e:
            errors += 1
            logger.error(f"Error processing departures for airport {airport}: {str(e)}")

    logger.info(f"AviationStack refresh complete. Added {added} eligible flights, errors: {errors}")
    return {'refreshed': True, 'added': added, 'errors': errors}

# WSGI application
def application(environ, start_response):
    path = environ.get('PATH_INFO', '').rstrip('/')
    
    # Log request for debugging
    logger.info(f"Request path: {path}")
    
    if path == '' or path == '/':
        # Parse query parameters to see if we need to return JSON instead of HTML
        query_string = environ.get('QUERY_STRING', '')
        params = urllib.parse.parse_qs(query_string)
        
        # Check if hours parameter exists - if so, treat as EU compensation request
        if 'hours' in params:
            logger.info("Root path with hours parameter - treating as EU compensation request")
            try:
                # Get hours parameter with default
                hours_param = params.get('hours', ['72'])[0]
                try:
                    hours = int(hours_param)
                except ValueError:
                    hours = 72
                # Optional onlyLive filter
                only_live_param = params.get('onlyLive', params.get('only_live', ['false']))[0].lower()
                only_live = only_live_param in ('true', '1', 'yes')
                
                # Process like /eu-compensation-eligible
                # Load all flights from the database
                all_flights = load_flight_data().get("flights", [])
                logger.info(f"Loaded {len(all_flights)} flights from database")
                if only_live:
                    before = len(all_flights)
                    all_flights = [f for f in all_flights if f.get('source') == 'AviationStack']
                    logger.info(f"Filtered to live flights only: {len(all_flights)} of {before} remain")
                
                # Add additional eligible flights based on delay criteria
                eligible_flights = []
                for flight in all_flights:
                    # Skip flights without required fields
                    if not flight.get('flight') or not flight.get('departure') or not flight.get('arrival'):
                        continue
                    # Time window filter (use dep or arr scheduledTime)
                    dep_time = flight.get('departure', {}).get('scheduledTime')
                    arr_time = flight.get('arrival', {}).get('scheduledTime')
                    if not _is_within_hours(hours, dep_time, arr_time):
                        continue
                    
                    # FIX: Safely handle None status
                    delay = flight.get('delay', 0)
                    # Check flight status for cancellations - fixed to handle None status
                    status = flight.get('status')
                    # First check if status is None or empty, then call .lower() only if it's a valid string
                    is_cancelled = False
                    if status:
                        is_cancelled = 'cancel' in status.lower()  # Check if status contains 'cancelled' or similar
                    
                    # Mark as eligible if 3+ hour delay, cancellation, or already marked
                    if delay >= 180 or is_cancelled or flight.get('eligible_for_compensation', False):
                        eligible_flights.append(flight)
                
                # Process and return the flights as JSON
                return process_and_return_flights(eligible_flights, start_response)
                
            except Exception as e:
                logger.error(f"Error processing root path as EU compensation request: {str(e)}")
                # Fall through to regular home page
        
        # Regular home page
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
                    <li><a href="/?hours=72">EU Compensation Eligible Flights (Alternative)</a></li>
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
        # Live ad-hoc eligibility check via AviationStack (server-side)
        # Parse query parameters
        query_string = environ.get('QUERY_STRING', '')
        params = urllib.parse.parse_qs(query_string)

        flight_number = (params.get('flight_number', [''])[0] or '').strip()
        date = (params.get('date', [''])[0] or '').strip()  # optional YYYY-MM-DD

        if not flight_number:
            response = json.dumps({
                "eligible": False,
                "message": "Missing flight number",
                "error": "missing_flight_number"
            }).encode('utf-8')
            start_response('400 Bad Request', [('Content-Type', 'application/json'), ('Access-Control-Allow-Origin', '*')])
            return [response]

        try:
            # Initialize AviationStack client
            try:
                sys.path.append(os.path.dirname(__file__))
                from aviationstack_client import AviationStackClient
                client = AviationStackClient()
            except Exception as e:
                logger.error(f"AviationStack client error: {e}")
                response = json.dumps({
                    "eligible": False,
                    "message": "AviationStack client not configured",
                    "error": str(e)
                }).encode('utf-8')
                start_response('500 Internal Server Error', [('Content-Type', 'application/json'), ('Access-Control-Allow-Origin', '*')])
                return [response]

            # Fetch flights by number
            flights = client.get_flight_by_number(flight_number) or []

            # Optionally filter by date (by flight_date or scheduled departure)
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
                response = json.dumps({
                    "eligible": False,
                    "message": "No flight found for given number/date"
                }).encode('utf-8')
                start_response('200 OK', [('Content-Type', 'application/json'), ('Access-Control-Allow-Origin', '*')])
                return [response]

            # Take the most relevant flight (first)
            f = flights[0]

            # Build a minimal structure for EU261 checks
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

            # Compose a normalized flight for EU261 helpers
            normalized = {
                'flight_number': flight_field.get('iata') or flight_number,
                'airline': airline.get('iata') or airline.get('name') or 'Unknown',
                'departure_airport': dep.get('iata') or '',
                'arrival_airport': arr.get('iata') or '',
                'status': status,
                'delay_minutes': delay_minutes,
            }

            # EU261 evaluation
            try:
                eu_applies = True  # Assume EU evaluation is applicable; helper determines specifics
                if EU_AIRPORTS_MODULE_LOADED:
                    eligible = is_eligible_for_eu261(normalized)
                    compensation = calculate_eu261_compensation(normalized) if eligible else 0
                else:
                    # Basic rule: 3+ hours delay or cancelled/diverted
                    is_cancelled = 'CANCEL' in status
                    is_diverted = 'DIVERT' in status
                    eligible = (delay_minutes >= 180) or is_cancelled or is_diverted
                    compensation = 400 if eligible else 0
            except Exception as e:
                logger.error(f"EU261 evaluation error: {e}")
                eligible = delay_minutes >= 180 or 'CANCEL' in status or 'DIVERT' in status
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

            response = json.dumps(result).encode('utf-8')
            start_response('200 OK', [('Content-Type', 'application/json'), ('Access-Control-Allow-Origin', '*')])
            return [response]

        except Exception as e:
            logger.error(f"Error in compensation check: {str(e)}")
            response = json.dumps({
                "eligible": False,
                "error": str(e),
                "message": "An error occurred while checking compensation eligibility."
            }).encode('utf-8')
            start_response('500 Internal Server Error', [('Content-Type', 'application/json'), ('Access-Control-Allow-Origin', '*')])
            return [response]
    
    elif path == '/eu-compensation-eligible' or path == '/eligible_flights' or path == '/eligible-flights':
        # New endpoint for EU-wide compensation eligible flights - optimized version
        try:
            # Parse query parameters
            query_string = environ.get('QUERY_STRING', '')
            params = urllib.parse.parse_qs(query_string)
            
            # Get hours parameter with default
            hours_param = params.get('hours', ['24'])[0]
            try:
                hours = int(hours_param)
            except ValueError:
                hours = 24
            
            # Optional: only live flights (AviationStack-sourced)
            only_live_param = params.get('onlyLive', params.get('only_live', ['false']))[0].lower()
            only_live = only_live_param in ('true', '1', 'yes')
            
            # Optional: refresh cache from AviationStack when requested
            refresh_param = params.get('refreshData', ['false'])[0].lower()
            if refresh_param in ('true', '1', 'yes'):
                logger.info("Refresh requested via query param: fetching from AviationStack before serving data")
                try:
                    _refresh_eu_eligible_flights_from_aviationstack(hours=hours)
                except Exception as e:
                    logger.error(f"Refresh failed: {str(e)}")

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
                        
                    # Use enhanced EU261 eligibility check if module is loaded
                    if EU_AIRPORTS_MODULE_LOADED:
                        # Check using the comprehensive EU airport database
                        is_eligible = is_eligible_for_eu261(flight)
                        
                        if is_eligible:
                            # Calculate compensation amount using the enhanced module
                            compensation_amount = calculate_eu261_compensation(flight)
                            # Add compensation amount to flight data if not already present
                            if 'compensation_amount_eur' not in flight:
                                flight['compensation_amount_eur'] = compensation_amount
                            # Mark as eligible
                            flight['eligible_for_compensation'] = True
                            eligible_flights.append(flight)
                    else:
                        # Fall back to basic eligibility check
                        delay = flight.get('delay', 0)
                        
                        # FIX: Safely handle None status
                        status = flight.get('status')
                        # First check if status is None or empty, then call .lower() only if it's a valid string
                        is_cancelled = False
                        if status:
                            is_cancelled = 'cancel' in status.lower()  # Check if status contains 'cancelled' or similar
                        
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
    
    # Added health check endpoint
    elif path == '/health' or path == '/ping':
        start_response('200 OK', [('Content-Type', 'application/json')])
        response = json.dumps({
            "status": "ok",
            "message": "API is healthy",
            "version": "1.1"
        }).encode('utf-8')
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

# For WSGI compatibility
flask_app = application
