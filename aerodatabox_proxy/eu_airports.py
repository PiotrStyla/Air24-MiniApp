"""
EU Airports Module for Flight Compensation System

This module provides EU airport data and utility functions to determine
if flights are eligible for EU261 compensation based on their route.

References:
- EU261 regulation: https://europa.eu/youreurope/citizens/travel/passenger-rights/air/index_en.htm
"""

import json
import logging
import os
from typing import Dict, List, Set, Any, Optional

# Configure logging
logger = logging.getLogger(__name__)

# EU countries list
EU_COUNTRIES = {
    "Austria", "Belgium", "Bulgaria", "Croatia", "Cyprus", "Czech Republic", 
    "Denmark", "Estonia", "Finland", "France", "Germany", "Greece", "Hungary", 
    "Ireland", "Italy", "Latvia", "Lithuania", "Luxembourg", "Malta", 
    "Netherlands", "Poland", "Portugal", "Romania", "Slovakia", "Slovenia", 
    "Spain", "Sweden"
}

# Path to EU airports data file
EU_AIRPORTS_FILE = os.path.join(os.path.dirname(__file__), "data", "eu_airports.json")

# Caches for faster lookups
_eu_airport_cache: Dict[str, bool] = {}
_eu_carrier_cache: Dict[str, bool] = {}

# EU airlines (major ones)
EU_AIRLINES = {
    "LH": "Lufthansa",
    "AF": "Air France",
    "BA": "British Airways",
    "KL": "KLM",
    "IB": "Iberia",
    "LO": "LOT Polish Airlines",
    "LX": "SWISS",
    "OS": "Austrian Airlines",
    "SK": "SAS",
    "AZ": "Alitalia",
    "TP": "TAP Air Portugal",
    "BT": "airBaltic",
    "A3": "Aegean Airlines",
    "FR": "Ryanair",
    "U2": "easyJet",
    "W6": "Wizz Air",
    "V7": "Volotea"
}

# Load EU airports data
def load_eu_airports() -> Dict[str, Any]:
    """Load EU airports data from JSON file"""
    try:
        if os.path.exists(EU_AIRPORTS_FILE):
            with open(EU_AIRPORTS_FILE, 'r', encoding='utf-8') as f:
                return json.load(f)
        else:
            logger.warning(f"EU airports file not found: {EU_AIRPORTS_FILE}")
            # Create directory if it doesn't exist
            os.makedirs(os.path.dirname(EU_AIRPORTS_FILE), exist_ok=True)
            # Create default data
            default_data = {
                "metadata": {
                    "version": "1.0.0",
                    "lastUpdated": "2025-05-22",
                    "description": "EU airports database"
                },
                "eu_countries": list(EU_COUNTRIES),
                "airports": []
            }
            # Save default data
            with open(EU_AIRPORTS_FILE, 'w', encoding='utf-8') as f:
                json.dump(default_data, f, indent=2)
            return default_data
    except Exception as e:
        logger.error(f"Error loading EU airports data: {e}")
        return {
            "metadata": {"version": "1.0.0"},
            "eu_countries": list(EU_COUNTRIES),
            "airports": []
        }

# Check if airport is in EU
def is_airport_in_eu(airport_code: str) -> bool:
    """
    Check if an airport is in the EU based on its IATA code
    
    Args:
        airport_code: IATA airport code (e.g., 'WAW' for Warsaw)
        
    Returns:
        bool: True if airport is in an EU country
    """
    # First check the cache
    if airport_code in _eu_airport_cache:
        return _eu_airport_cache[airport_code]
    
    # Load airport data if needed
    airport_data = load_eu_airports()
    
    # Check the airports list
    for airport in airport_data.get("airports", []):
        if airport.get("iata") == airport_code:
            result = airport.get("is_eu", False)
            _eu_airport_cache[airport_code] = result
            return result
    
    # Major EU airports hardcoded as fallback
    major_eu_airports = {
        # Poland
        "WAW", "KRK", "GDN", "WRO", "POZ", "RZE", "KTW", "LUZ", "SZZ", "BZG", "LCJ", "IEG",
        # Germany
        "FRA", "MUC", "DUS", "TXL", "BER", "HAM", "STR", "CGN", "HAJ",
        # France
        "CDG", "ORY", "LYS", "MRS", "NCE", "TLS", "BVA", "NTE", "BOD",
        # Spain
        "MAD", "BCN", "PMI", "AGP", "ALC", "LPA", "TFS", "IBZ", "VLC", "BIO",
        # Italy
        "FCO", "MXP", "LIN", "VCE", "NAP", "CTA", "PSA", "BLQ", "BRI", "CAG",
        # Netherlands
        "AMS", "RTM", "EIN",
        # Belgium
        "BRU", "CRL",
        # Sweden
        "ARN", "GOT", "MMX",
        # Denmark
        "CPH", "BLL", "AAL",
        # Greece
        "ATH", "HER", "RHO", "SKG", "CFU", "JMK", "JTR",
        # Austria
        "VIE", "SZG", "INN", "GRZ",
        # Finland
        "HEL", "TMP", "OUL",
        # Ireland
        "DUB", "SNN", "ORK",
        # Portugal
        "LIS", "OPO", "FAO", "FNC",
        # Czech Republic
        "PRG", "BRQ",
        # Romania
        "OTP", "CLJ", "TSR", "IAS",
        # Hungary
        "BUD", "DEB",
        # Croatia
        "ZAG", "SPU", "DBV", "ZAD"
    }
    
    result = airport_code in major_eu_airports
    _eu_airport_cache[airport_code] = result
    return result

# Get major EU airports for API queries
def get_major_eu_airports(limit: int = 30) -> List[str]:
    """
    Get a list of major EU airports for API queries
    
    This function returns a list of important EU airports sorted by passenger volume,
    making it ideal for data collection tasks that need to prioritize major airports.
    
    Args:
        limit: Maximum number of airports to return (default: 30)
        
    Returns:
        List[str]: List of IATA codes for major EU airports
    """
    try:
        # Load airport data
        airport_data = load_eu_airports()
        
        # Extract airports and sort by passenger volume (if available)
        airports = []
        for airport in airport_data.get("airports", []):
            if airport.get("is_eu", False):
                airports.append({
                    "iata": airport.get("iata"),
                    "size": airport.get("size", 1),  # Default to 1 if size not available
                    "is_hub": airport.get("is_hub", False)  # Check if it's a major hub
                })
        
        # Sort airports by size (descending) and hub status
        airports.sort(key=lambda x: (x.get("is_hub", False), x.get("size", 1)), reverse=True)
        
        # Return IATA codes of top airports up to the limit
        return [airport["iata"] for airport in airports[:limit]]
    except Exception as e:
        logger.error(f"Error getting major EU airports: {e}")
        # Fallback to hardcoded list of major EU airports
        return [
            "FRA", "CDG", "AMS", "MAD", "FCO", "LHR", "MUC", "BCN", "LIS", "VIE", "WAW",
            "BRU", "CPH", "DUB", "HEL", "ATH", "PRG", "BUD", "ARN", "MXP", "ORY", 
            "TXL", "HAM", "AGP", "PMI", "OTP", "ZAG", "SKG", "BLQ", "NAP"
        ][:limit]

# Check if airline is an EU carrier
def is_eu_carrier(airline_code: str) -> bool:
    """
    Check if an airline is an EU carrier based on its IATA code
    
    Args:
        airline_code: IATA airline code (e.g., 'LO' for LOT Polish Airlines)
        
    Returns:
        bool: True if airline is an EU carrier
    """
    # First check the cache
    if airline_code in _eu_carrier_cache:
        return _eu_carrier_cache[airline_code]
    
    # Check against the hardcoded list
    result = airline_code in EU_AIRLINES
    _eu_carrier_cache[airline_code] = result
    return result

# Check flight eligibility for EU261 compensation
def is_eligible_for_eu261(flight: Dict[str, Any]) -> bool:
    """
    Check if a flight is eligible for EU261 compensation based on:
    1. Flight operated by an EU airline, OR
    2. Flight departing from an EU airport
    3. AND flight has a delay of 3+ hours or is cancelled
    
    Args:
        flight: Flight data dictionary
        
    Returns:
        bool: True if flight is eligible for EU261 compensation
    """
    try:
        # Extract airline code
        airline_code = None
        if isinstance(flight.get('airline'), str):
            airline_code = flight['airline']
        elif isinstance(flight.get('airline'), dict) and 'iata' in flight['airline']:
            airline_code = flight['airline']['iata']
        
        # Extract departure airport
        departure_airport = None
        if isinstance(flight.get('departure_airport'), str):
            departure_airport = flight['departure_airport']
        elif isinstance(flight.get('departure'), dict) and isinstance(flight['departure'].get('airport'), dict):
            departure_airport = flight['departure']['airport'].get('iata') or flight['departure']['airport'].get('icao')
        
        # Extract arrival airport
        arrival_airport = None
        if isinstance(flight.get('arrival_airport'), str):
            arrival_airport = flight['arrival_airport']
        elif isinstance(flight.get('arrival'), dict) and isinstance(flight['arrival'].get('airport'), dict):
            arrival_airport = flight['arrival']['airport'].get('iata') or flight['arrival']['airport'].get('icao')
        
        # Check delay or cancellation
        delay_minutes = flight.get('delay_minutes', flight.get('delay', 0))
        status = str(flight.get('status', '')).lower()
        is_cancelled = 'cancel' in status
        is_delayed_enough = delay_minutes >= 180  # 3+ hours
        
        # A flight is eligible for EU261 if:
        # 1. It has a sufficient delay (3+ hours) or is cancelled, AND
        # 2a. It departs from an EU airport, OR
        # 2b. It arrives at an EU airport AND is operated by an EU carrier
        
        is_disrupted = is_delayed_enough or is_cancelled
        departs_from_eu = is_airport_in_eu(departure_airport) if departure_airport else False
        
        # Only check arrival airport if needed
        arrives_to_eu = False
        if not departs_from_eu and arrival_airport:
            arrives_to_eu = is_airport_in_eu(arrival_airport)
        
        is_eu_airline = is_eu_carrier(airline_code) if airline_code else False
        
        # Determine final eligibility
        route_eligible = departs_from_eu or (arrives_to_eu and is_eu_airline)
        
        logger.debug(f"EU261 eligibility check: disrupted={is_disrupted}, route_eligible={route_eligible}")
        logger.debug(f"  Details: delay={delay_minutes}, cancelled={is_cancelled}, "
                    f"dep_eu={departs_from_eu}, arr_eu={arrives_to_eu}, eu_airline={is_eu_airline}")
        
        return is_disrupted and route_eligible
        
    except Exception as e:
        logger.error(f"Error checking EU261 eligibility: {e}")
        return False

# Calculate compensation amount based on flight distance
def calculate_eu261_compensation(flight: Dict[str, Any]) -> int:
    """
    Calculate EU261 compensation amount based on flight distance:
    - €250 for flights ≤ 1500 km
    - €400 for flights > 1500 km and ≤ 3500 km
    - €600 for flights > 3500 km
    
    Args:
        flight: Flight data dictionary
        
    Returns:
        int: Compensation amount in EUR
    """
    try:
        # Get distance in km
        distance_km = None
        
        if 'distance_km' in flight:
            distance_km = flight['distance_km']
        elif 'distance' in flight:
            distance_km = flight['distance']
        
        # If we don't have the distance, estimate based on airports
        if not distance_km:
            # Default to medium-haul estimate
            distance_km = 2000
        
        # Apply EU261 compensation rules
        if distance_km <= 1500:
            return 250  # Short-haul
        elif distance_km <= 3500:
            return 400  # Medium-haul
        else:
            return 600  # Long-haul
            
    except Exception as e:
        logger.error(f"Error calculating EU261 compensation: {e}")
        return 400  # Default to medium-haul compensation
