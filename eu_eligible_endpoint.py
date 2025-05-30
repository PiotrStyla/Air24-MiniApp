"""
EU-Wide Compensation Eligible Flights Endpoint
This file contains the code to add to your PythonAnywhere server to implement 
the EU-wide eligible flights endpoint that uses AviationStack API.
"""

# Code to add to your PythonAnywhere wsgi_app.py file:

@app.route('/eu-compensation-eligible', methods=['GET'])
def eu_compensation_eligible():
    """Endpoint to get EU-wide compensation eligible flights using AviationStack API."""
    try:
        # Get query parameters
        hours = request.args.get('hours', '72')
        refresh_data = request.args.get('refreshData', 'false').lower() == 'true'
        source = request.args.get('source', 'aviationstack')

        # Ensure hours is an integer
        try:
            hours = int(hours)
        except ValueError:
            hours = 72

        # Initialize AviationStack client with API key from environment
        from aviationstack_client import AviationStackClient
        aviationstack_client = AviationStackClient(api_key=os.environ.get('AVIATIONSTACK_API_KEY'))

        # List of major EU airports to check
        eu_airports = ['FRA', 'CDG', 'AMS', 'MAD', 'FCO', 'LHR', 'MUC', 'BCN', 'LIS', 'VIE', 'WAW']
        
        all_eligible_flights = []
        processing_errors = 0
        
        # If refresh is requested, fetch fresh data from AviationStack
        if refresh_data:
            print(f"Fetching fresh data from AviationStack for {len(eu_airports)} airports")
            
            for airport in eu_airports:
                try:
                    # Get flights for this airport using AviationStack
                    print(f"Getting flight data for {airport} via AviationStack")
                    
                    # Query AviationStack for arrival flights at this airport
                    airport_data = aviationstack_client.get_airport_flights(
                        airport_code=airport,
                        flight_type='arrival',
                        limit=100
                    )
                    
                    if 'data' in airport_data and airport_data['data']:
                        flights = airport_data['data']
                        print(f"Found {len(flights)} flights for {airport}")
                        
                        for flight in flights:
                            # Process flight data
                            formatted_flight = aviationstack_client.format_flight_for_storage(flight)
                            
                            # Check if eligible for compensation (3+ hour delay)
                            delay_minutes = formatted_flight.get('delay_minutes', 0)
                            if delay_minutes >= 180:  # 3 hours or more
                                formatted_flight['eligible_for_compensation'] = True
                                # Calculate compensation amount based on flight distance
                                distance = formatted_flight.get('distance_km', 0)
                                if distance <= 1500:
                                    compensation = 250
                                elif distance <= 3500:
                                    compensation = 400
                                else:
                                    compensation = 600
                                formatted_flight['compensation_amount_eur'] = compensation
                                
                                # Add to eligible flights list
                                all_eligible_flights.append(formatted_flight)
                                
                                # Save to storage
                                if 'storage' in globals():
                                    storage.add_flight(formatted_flight, source="AviationStack")
                    
                except Exception as e:
                    print(f"Error processing airport {airport}: {e}")
                    processing_errors += 1
        
        # If no fresh data requested or if errors occurred, fallback to database
        if not all_eligible_flights or not refresh_data:
            print("Using stored flight data")
            if 'storage' in globals():
                # Get flights from storage that are eligible for compensation
                all_flights = storage.get_all_flights()
                all_eligible_flights = [
                    flight for flight in all_flights 
                    if flight.get('eligible_for_compensation', False)
                ]
        
        # Return the results
        return jsonify({
            'flights': all_eligible_flights,
            'count': len(all_eligible_flights),
            'refreshed': refresh_data,
            'source': source,
            'errorCount': processing_errors,
            'airports': eu_airports
        })
    
    except Exception as e:
        print(f"Error in EU compensation eligible endpoint: {e}")
        return jsonify({
            'error': str(e),
            'flights': [],
            'count': 0
        }), 500

# Add this to your PythonAnywhere wsgi_app.py file to test the AviationStack connection:
@app.route('/test-aviationstack', methods=['GET'])
def test_aviationstack():
    """Test the AviationStack API connection."""
    try:
        from aviationstack_client import AviationStackClient
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
