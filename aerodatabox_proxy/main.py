from fastapi import FastAPI, Query, HTTPException, Request, Depends
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
import requests
import os
import json
import traceback
from datetime import datetime, timedelta
from dotenv import load_dotenv
import logging
from functools import lru_cache
import time
from typing import Dict, Any, Optional

# Configure logging
logging.basicConfig(
    level=logging.DEBUG,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Load environment variables from .env file
load_dotenv()

app = FastAPI(title="AeroDataBox API Proxy", 
              description="A proxy service for AeroDataBox API with flight compensation eligibility detection")

# Get allowed origins from environment or use default
allowed_origins = os.getenv("ALLOWED_ORIGINS", "*").split(",")
logger.info(f"Configured CORS with allowed origins: {allowed_origins}")

# Allow all origins for development
app.add_middleware(
    CORSMiddleware,
    allow_origins=allowed_origins,
    allow_credentials=True,
    allow_methods=["*"],  # Allow all methods
    allow_headers=["*"],
)

# Get API credentials from environment variables
API_KEY = os.getenv("AERODATABOX_API_KEY")
if not API_KEY:
    raise ValueError("AERODATABOX_API_KEY environment variable is required")
API_HOST = "aerodatabox.p.rapidapi.com"

# Cache configuration
CACHE_TTL = int(os.getenv("CACHE_TTL_SECONDS", "300"))  # Default cache TTL: 5 minutes

# Simple time-based cache implementation
class APICache:
    def __init__(self, ttl_seconds=300):
        self.cache: Dict[str, Dict[str, Any]] = {}
        self.ttl_seconds = ttl_seconds
        logger.info(f"Initialized API cache with TTL of {ttl_seconds} seconds")
    
    def get(self, key: str) -> Optional[Any]:
        """Get a value from cache if it exists and is not expired"""
        if key not in self.cache:
            return None
        
        entry = self.cache[key]
        if time.time() - entry["timestamp"] > self.ttl_seconds:
            # Entry has expired
            del self.cache[key]
            return None
        
        logger.debug(f"Cache hit for key: {key}")
        return entry["data"]
    
    def set(self, key: str, value: Any) -> None:
        """Set a value in the cache with current timestamp"""
        self.cache[key] = {
            "timestamp": time.time(),
            "data": value
        }
        logger.debug(f"Cached data for key: {key}")
    
    def clear(self) -> None:
        """Clear all cache entries"""
        self.cache.clear()
        logger.info("Cache cleared")

# Initialize cache
api_cache = APICache(ttl_seconds=CACHE_TTL)

# Add global exception handler
@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    logger.error(f"Global exception handler caught: {str(exc)}")
    logger.error(traceback.format_exc())
    return JSONResponse(
        status_code=500,
        content={"detail": f"Internal server error: {str(exc)}"}
    )

def parse_datetime(dt_str):
    """Parse datetime string from AeroDataBox API.
    
    The API returns datetime strings in ISO 8601 format, typically like:
    '2023-05-10 14:30Z' or '2023-05-10T14:30:00.000Z'
    """
    if not dt_str:
        return None
    
    try:
        # Try ISO format with T separator
        if 'T' in dt_str:
            # Remove milliseconds and Z if present
            dt_str = dt_str.split('.')[0].replace('Z', '')
            return datetime.fromisoformat(dt_str)
        # Try space separator format
        else:
            # Remove Z if present
            dt_str = dt_str.replace('Z', '')
            return datetime.strptime(dt_str, "%Y-%m-%d %H:%M")
    except Exception as ex:
        logger.error(f"Date parse error: {ex} for string: {dt_str}")
        return None

@app.get("/recent-arrivals")
async def recent_arrivals(icao: str = Query(..., description="Airport ICAO code")):
    logger.info(f"Handler called for airport ICAO: {icao}")
    try:
        # Generate cache key
        cache_key = f"arrivals:{icao}"
        
        # Try to get from cache first
        cached_data = api_cache.get(cache_key)
        if cached_data:
            logger.info(f"Using cached data for airport ICAO: {icao}")
            return cached_data
            
        # Cache miss, need to call the API
        # Use the correct endpoint for flights at an airport
        url = f"https://{API_HOST}/flights/airports/icao/{icao}"
        params = {
            "offsetMinutes": -120,
            "durationMinutes": 720,
            "withLeg": True,
            "direction": "Arrival",  # Only get arrivals
            "withCancelled": True,
            "withCodeshared": True,
            "withCargo": True,
            "withPrivate": True,
            "withLocation": False
        }
        
        headers = {
            "X-RapidAPI-Key": API_KEY,
            "X-RapidAPI-Host": API_HOST
        }
        
        logger.debug(f"Making request to AeroDataBox API: {url}")
        response = requests.get(url, headers=headers, params=params)
        logger.info(f"AeroDataBox API status: {response.status_code}")
        
        if response.status_code != 200:
            logger.error(f"AeroDataBox raw error response: {response.text}")
            raise HTTPException(
                status_code=response.status_code,
                detail=f"AeroDataBox API error: {response.text}"
            )
            
        data = response.json()
        logger.info("AeroDataBox arrivals response received successfully")
        logger.debug(f"Raw response data: {json.dumps(data)[:200]}...")

        # Extract arrivals and detect delays
        arrivals = []
        allowed_statuses = {"Landed", "Arrived", "Delayed", "Expected", "Boarding"}
        
        # Check if arrivals key exists in response
        if "arrivals" not in data:
            logger.warning(f"No 'arrivals' key in response. Keys found: {list(data.keys())}")
            # Try to handle different response formats
            flights = data.get("arrivals", []) or data.get("flights", []) or []
            logger.info(f"Found {len(flights)} flights to process")
        else:
            flights = data.get("arrivals", [])
            logger.info(f"Found {len(flights)} arrivals to process")
        
        # Process arrivals
        for flight in flights:
            arr = flight.get("arrival", {})
            if not arr:
                logger.debug(f"Skipping flight without arrival data: {flight.get('number', 'Unknown')}")
                continue
                
            status = flight.get("status", "")
            scheduled = arr.get("scheduledTime", {}).get("utc") if isinstance(arr.get("scheduledTime"), dict) else arr.get("scheduledTime")
            revised = arr.get("revisedTime", {}).get("utc") if isinstance(arr.get("revisedTime"), dict) else arr.get("revisedTime")
            actual = arr.get("actualTime", {}).get("utc") if isinstance(arr.get("actualTime"), dict) else arr.get("actualTime")
            
            # Prefer actual > revised > scheduled for delay detection
            delay = False
            delay_minutes = 0
            
            sched_dt = parse_datetime(scheduled)
            actual_dt = parse_datetime(actual)
            revised_dt = parse_datetime(revised)
            
            # Use the most accurate time available for delay calculation
            ref_dt = actual_dt or revised_dt
            
            if sched_dt and ref_dt and ref_dt > sched_dt:
                delay = True
                delay_minutes = int((ref_dt - sched_dt).total_seconds() // 60)
                
            flight_number = flight.get('number', 'Unknown')
            logger.debug(f"Flight {flight_number}: status={status}, delayed={delay}, delay_minutes={delay_minutes}")
            
            # Only include flights with allowed statuses or detected as delayed
            if status in allowed_statuses or delay:
                # Extract departure ICAO if present
                dep_icao = None
                if 'departure' in flight and 'airport' in flight.get('departure', {}):
                    dep_icao = flight['departure']['airport'].get('icao')
                    
                # Calculate EU261 compensation eligibility
                # Flight must be delayed by at least 3 hours (180 minutes)
                compensation_eligible = delay_minutes >= 180
                
                arrivals.append({
                    "flightNumber": flight_number,
                    "airline": flight.get("airline", {}).get("name"),
                    "aircraft": flight.get("aircraft", {}).get("model"),
                    "scheduledArrivalUtc": scheduled,
                    "revisedArrivalUtc": revised,
                    "actualArrivalUtc": actual,
                    "terminal": arr.get("terminal"),
                    "gate": arr.get("gate"),
                    "status": status,
                    "delayed": delay,
                    "delayMinutes": delay_minutes,
                    "compensationEligible": compensation_eligible,
                    "departureIcao": dep_icao
                })
        
        logger.info(f"Returning {len(arrivals)} processed arrivals")
        result = {"arrivals": arrivals}
        
        # Store in cache
        api_cache.set(cache_key, result)
        
        return result

    except HTTPException as he:
        # Re-raise HTTP exceptions
        logger.error(f"HTTP Exception: {str(he)}")
        raise he
    except requests.RequestException as re:
        # Handle network/request errors
        logger.error(f"Request exception: {str(re)}")
        logger.error(traceback.format_exc())
        raise HTTPException(
            status_code=503,
            detail=f"Error connecting to AeroDataBox API: {str(re)}"
        )
    except Exception as e:
        # Handle all other exceptions
        logger.error(f"Exception in recent_arrivals: {str(e)}")
        logger.error(traceback.format_exc())
        raise HTTPException(
            status_code=500,
            detail=f"Internal server error: {str(e)}"
        )


@app.get("/flight-status")
async def flight_status(flight_number: str = Query(..., description="Flight number (e.g., BA123)", alias="flight_number"), date: str = Query(None, description="Flight date in YYYY-MM-DD format", alias="date")):
    """Get status for a specific flight by flight number"""
    logger.info(f"Handler called for flight number: {flight_number}, date: {date}")
    try:
        # Generate cache key
        cache_key = f"flight:{flight_number}:{date if date else 'today'}"
        
        # Try to get from cache first
        cached_data = api_cache.get(cache_key)
        if cached_data:
            logger.info(f"Using cached data for flight: {flight_number}, date: {date}")
            return cached_data
            
        # Cache miss, need to call the API
        # Use the flight number endpoint
        url = f"https://{API_HOST}/flights/number/{flight_number}"
        
        params = {}
        if date:
            params["date"] = date
        
        headers = {
            "X-RapidAPI-Key": API_KEY,
            "X-RapidAPI-Host": API_HOST
        }
        
        logger.debug(f"Making request to AeroDataBox API: {url} with params: {params}")
        response = requests.get(url, headers=headers, params=params)
        logger.info(f"AeroDataBox API status: {response.status_code}")
        
        if response.status_code != 200:
            logger.error(f"AeroDataBox raw error response: {response.text}")
            raise HTTPException(
                status_code=response.status_code,
                detail=f"AeroDataBox API error: {response.text}"
            )
            
        data = response.json()
        logger.info("AeroDataBox flight status response received successfully")
        
        # Process flight data
        flights = []
        for flight in data:
            # Extract departure and arrival information
            departure = flight.get("departure", {})
            arrival = flight.get("arrival", {})
            
            # Calculate delay information
            dep_delay = False
            dep_delay_minutes = 0
            arr_delay = False
            arr_delay_minutes = 0
            
            # Departure delay calculation
            dep_scheduled = departure.get("scheduledTime", {}).get("utc") if isinstance(departure.get("scheduledTime"), dict) else departure.get("scheduledTime")
            dep_actual = departure.get("actualTime", {}).get("utc") if isinstance(departure.get("actualTime"), dict) else departure.get("actualTime")
            dep_revised = departure.get("revisedTime", {}).get("utc") if isinstance(departure.get("revisedTime"), dict) else departure.get("revisedTime")
            
            dep_sched_dt = parse_datetime(dep_scheduled)
            dep_actual_dt = parse_datetime(dep_actual)
            dep_revised_dt = parse_datetime(dep_revised)
            
            # Use the most accurate time available for delay calculation
            dep_ref_dt = dep_actual_dt or dep_revised_dt
            
            if dep_sched_dt and dep_ref_dt and dep_ref_dt > dep_sched_dt:
                dep_delay = True
                dep_delay_minutes = int((dep_ref_dt - dep_sched_dt).total_seconds() // 60)
            
            # Arrival delay calculation
            arr_scheduled = arrival.get("scheduledTime", {}).get("utc") if isinstance(arrival.get("scheduledTime"), dict) else arrival.get("scheduledTime")
            arr_actual = arrival.get("actualTime", {}).get("utc") if isinstance(arrival.get("actualTime"), dict) else arrival.get("actualTime")
            arr_revised = arrival.get("revisedTime", {}).get("utc") if isinstance(arrival.get("revisedTime"), dict) else arrival.get("revisedTime")
            
            arr_sched_dt = parse_datetime(arr_scheduled)
            arr_actual_dt = parse_datetime(arr_actual)
            arr_revised_dt = parse_datetime(arr_revised)
            
            # Use the most accurate time available for delay calculation
            arr_ref_dt = arr_actual_dt or arr_revised_dt
            
            if arr_sched_dt and arr_ref_dt and arr_ref_dt > arr_sched_dt:
                arr_delay = True
                arr_delay_minutes = int((arr_ref_dt - arr_sched_dt).total_seconds() // 60)
            
            # Calculate EU261 compensation eligibility
            # Flight must be delayed by at least 3 hours (180 minutes)
            compensation_eligible = arr_delay_minutes >= 180
            
            # Format the flight data
            formatted_flight = {
                "flightNumber": flight.get("number"),
                "status": flight.get("status"),
                "airline": flight.get("airline", {}).get("name"),
                "aircraft": flight.get("aircraft", {}).get("model"),
                "departure": {
                    "airport": departure.get("airport", {}).get("name"),
                    "iata": departure.get("airport", {}).get("iata"),
                    "icao": departure.get("airport", {}).get("icao"),
                    "terminal": departure.get("terminal"),
                    "gate": departure.get("gate"),
                    "scheduledTime": dep_scheduled,
                    "actualTime": dep_actual,
                    "revisedTime": dep_revised,
                    "delayed": dep_delay,
                    "delayMinutes": dep_delay_minutes
                },
                "arrival": {
                    "airport": arrival.get("airport", {}).get("name"),
                    "iata": arrival.get("airport", {}).get("iata"),
                    "icao": arrival.get("airport", {}).get("icao"),
                    "terminal": arrival.get("terminal"),
                    "gate": arrival.get("gate"),
                    "scheduledTime": arr_scheduled,
                    "actualTime": arr_actual,
                    "revisedTime": arr_revised,
                    "delayed": arr_delay,
                    "delayMinutes": arr_delay_minutes
                },
                "compensationEligible": compensation_eligible
            }
            
            flights.append(formatted_flight)
        
        result = {"flights": flights}
        
        # Store in cache
        api_cache.set(cache_key, result)
        
        return result
    
    except HTTPException as he:
        # Re-raise HTTP exceptions
        logger.error(f"HTTP Exception: {str(he)}")
        raise he
    except requests.RequestException as re:
        # Handle network/request errors
        logger.error(f"Request exception: {str(re)}")
        logger.error(traceback.format_exc())
        raise HTTPException(
            status_code=503,
            detail=f"Error connecting to AeroDataBox API: {str(re)}"
        )
    except Exception as e:
        # Handle all other exceptions
        logger.error(f"Exception in flight_status: {str(e)}")
        logger.error(traceback.format_exc())
        raise HTTPException(
            status_code=500,
            detail=f"Internal server error: {str(e)}"
        )

@app.get("/ping")
async def ping():
    """Health check endpoint"""
    return {"message": "pong", "status": "ok"}


@app.get("/compensation-check")
async def compensation_check(
    flight_number: str = Query(..., description="Flight number (e.g., BA123)", alias="flight_number"),
    date: str = Query(None, description="Flight date in YYYY-MM-DD format", alias="date")
):
    """Check if a flight is eligible for EU261 compensation"""
    logger.info(f"Compensation check called for flight: {flight_number}, date: {date}")
    
    try:
        # Generate cache key
        cache_key = f"compensation:{flight_number}:{date if date else 'today'}"
        
        # Try to get from cache first
        cached_data = api_cache.get(cache_key)
        if cached_data:
            logger.info(f"Using cached compensation data for flight: {flight_number}, date: {date}")
            return cached_data
        
        # Cache miss, need to call the API
        # First get the flight status
        url = f"https://{API_HOST}/flights/number/{flight_number}"
        
        params = {}
        if date:
            params["date"] = date
        
        headers = {
            "X-RapidAPI-Key": API_KEY,
            "X-RapidAPI-Host": API_HOST
        }
        
        logger.debug(f"Making request to AeroDataBox API: {url} with params: {params}")
        response = requests.get(url, headers=headers, params=params)
        
        if response.status_code != 200:
            logger.error(f"AeroDataBox raw error response: {response.text}")
            raise HTTPException(
                status_code=response.status_code,
                detail=f"AeroDataBox API error: {response.text}"
            )
        
        data = response.json()
        
        # Process the flight data to determine compensation eligibility
        eligibility_results = []
        
        for flight in data:
            # Extract flight details
            flight_number = flight.get("number")
            airline = flight.get("airline", {}).get("name")
            status = flight.get("status")
            
            # Extract arrival information
            arrival = flight.get("arrival", {})
            arr_scheduled = arrival.get("scheduledTime", {}).get("utc") if isinstance(arrival.get("scheduledTime"), dict) else arrival.get("scheduledTime")
            arr_actual = arrival.get("actualTime", {}).get("utc") if isinstance(arrival.get("actualTime"), dict) else arrival.get("actualTime")
            arr_revised = arrival.get("revisedTime", {}).get("utc") if isinstance(arrival.get("revisedTime"), dict) else arrival.get("revisedTime")
            
            # Parse datetime objects
            arr_sched_dt = parse_datetime(arr_scheduled)
            arr_actual_dt = parse_datetime(arr_actual)
            arr_revised_dt = parse_datetime(arr_revised)
            
            # Use the most accurate time available
            arr_ref_dt = arr_actual_dt or arr_revised_dt
            
            # Calculate delay
            arr_delay = False
            arr_delay_minutes = 0
            
            if arr_sched_dt and arr_ref_dt and arr_ref_dt > arr_sched_dt:
                arr_delay = True
                arr_delay_minutes = int((arr_ref_dt - arr_sched_dt).total_seconds() // 60)
            
            # Extract departure and arrival airports for distance calculation
            dep_airport = flight.get("departure", {}).get("airport", {})
            arr_airport = arrival.get("airport", {})
            
            # EU261 eligibility rules:
            # 1. Flight must be delayed by at least 3 hours (180 minutes)
            delay_eligible = arr_delay_minutes >= 180
            
            # 2. Flight must be within EU jurisdiction (departing from EU or arriving in EU on EU carrier)
            # This is a simplified check - in a real system you'd have a database of EU airports and carriers
            eu_jurisdiction = False
            eu_airports = ["EGLL", "LFPG", "EDDF", "EHAM", "LEMD", "LIRF", "LOWW", "LSZH", "EKCH", "EIDW"]  # Sample EU airport ICAOs
            eu_carriers = ["BA", "AF", "LH", "KL", "IB", "AZ", "OS", "LX", "SK"]  # Sample EU carrier codes
            
            # Check if departure or arrival is in EU
            dep_in_eu = dep_airport.get("icao") in eu_airports
            arr_in_eu = arr_airport.get("icao") in eu_airports
            
            # Check if carrier is EU-based (simplified)
            carrier_code = flight_number[:2] if flight_number else ""
            eu_carrier = carrier_code in eu_carriers
            
            # EU jurisdiction applies if:
            # - Flight departs from EU, or
            # - Flight arrives in EU AND is operated by EU carrier
            eu_jurisdiction = dep_in_eu or (arr_in_eu and eu_carrier)
            
            # 3. Determine compensation amount based on flight distance
            # This would require calculating the distance between airports
            # For this example, we'll use a simplified approach based on flight time
            flight_duration_minutes = 0
            if arr_sched_dt and arr_sched_dt:
                dep_scheduled = flight.get("departure", {}).get("scheduledTime", {}).get("utc") if isinstance(flight.get("departure", {}).get("scheduledTime"), dict) else flight.get("departure", {}).get("scheduledTime")
                dep_sched_dt = parse_datetime(dep_scheduled)
                if dep_sched_dt:
                    flight_duration_minutes = int((arr_sched_dt - dep_sched_dt).total_seconds() // 60)
            
            # Determine compensation amount (in EUR)
            compensation_amount = 0
            if flight_duration_minutes <= 120:  # Short flights (<= 2 hours)
                compensation_amount = 250
            elif flight_duration_minutes <= 210:  # Medium flights (2-3.5 hours)
                compensation_amount = 400
            else:  # Long flights (> 3.5 hours)
                compensation_amount = 600
            
            # Final eligibility determination
            is_eligible = delay_eligible and eu_jurisdiction
            
            # Prepare the result
            result = {
                "flightNumber": flight_number,
                "airline": airline,
                "status": status,
                "departureAirport": dep_airport.get("name"),
                "arrivalAirport": arr_airport.get("name"),
                "scheduledArrival": arr_scheduled,
                "actualArrival": arr_actual or arr_revised,
                "delayMinutes": arr_delay_minutes,
                "isDelayedOver3Hours": delay_eligible,
                "isUnderEuJurisdiction": eu_jurisdiction,
                "isEligibleForCompensation": is_eligible,
                "potentialCompensationAmount": compensation_amount if is_eligible else 0,
                "currency": "EUR" if is_eligible else None
            }
            
            eligibility_results.append(result)
        
        result = {"results": eligibility_results}
        
        # Store in cache
        api_cache.set(cache_key, result)
        
        return result
        
    except HTTPException as he:
        logger.error(f"HTTP Exception: {str(he)}")
        raise he
    except requests.RequestException as re:
        logger.error(f"Request exception: {str(re)}")
        logger.error(traceback.format_exc())
        raise HTTPException(
            status_code=503,
            detail=f"Error connecting to AeroDataBox API: {str(re)}"
        )
    except Exception as e:
        logger.error(f"Exception in compensation_check: {str(e)}")
        logger.error(traceback.format_exc())
        raise HTTPException(
            status_code=500,
            detail=f"Internal server error: {str(e)}"
        )

@app.get("/")
async def root():
    """Root endpoint with API information"""
    return {
        "name": "AeroDataBox API Proxy",
        "version": "1.0.0",
        "endpoints": [
            "/recent-arrivals?icao=XXXX",
            "/flight-status?flight_number=XXX&date=YYYY-MM-DD",
            "/compensation-check?flight_number=XXX&date=YYYY-MM-DD",
            "/ping"
        ]
    }