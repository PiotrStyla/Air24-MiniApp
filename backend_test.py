"""
PythonAnywhere Backend Diagnostic Test File

This is a minimal Flask application to diagnose issues with the PythonAnywhere deployment.
Upload this file as flask_app.py to your PythonAnywhere account and test the endpoints.
"""

import os
import json
import logging
import traceback
from datetime import datetime
from flask import Flask, jsonify

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger('backend_diagnostic')

# Create Flask application
application = Flask(__name__)

# Global variables
VERSION = "1.0.0"
START_TIME = datetime.now().isoformat()

@application.route('/')
def root():
    """Root endpoint that returns basic server information"""
    try:
        logger.info("Root endpoint accessed")
        return jsonify({
            'status': 'healthy',
            'service': 'Flight Compensation API Diagnostic',
            'version': VERSION,
            'uptime': str(datetime.now() - datetime.fromisoformat(START_TIME)),
            'timestamp': datetime.now().isoformat()
        })
    except Exception as e:
        logger.error(f"Error in root endpoint: {str(e)}")
        logger.error(traceback.format_exc())
        return jsonify({
            'status': 'error',
            'error': str(e),
            'traceback': traceback.format_exc()
        }), 500

@application.route('/environment')
def environment():
    """Returns information about the server environment"""
    try:
        logger.info("Environment endpoint accessed")
        safe_environ = {k: v for k, v in os.environ.items() 
                      if not any(secret in k.lower() for secret in ['key', 'secret', 'password', 'token'])}
        
        return jsonify({
            'python_version': os.sys.version,
            'environment': safe_environ,
            'working_directory': os.getcwd(),
            'directory_contents': os.listdir(),
            'timestamp': datetime.now().isoformat()
        })
    except Exception as e:
        logger.error(f"Error in environment endpoint: {str(e)}")
        logger.error(traceback.format_exc())
        return jsonify({
            'status': 'error',
            'error': str(e),
            'traceback': traceback.format_exc()
        }), 500

@application.route('/eligible_flights_test')
def eligible_flights_test():
    """Simplified version of the eligible_flights endpoint to test functionality"""
    try:
        logger.info("Test flights endpoint accessed")
        
        # Create a simple test flight object
        test_flights = [
            {
                'flight_id': 'TEST001',
                'airline': 'Test Airline',
                'flight_number': 'TA123',
                'departure': {
                    'airport': 'WAW',
                    'scheduled': '2025-07-24T08:00:00Z',
                    'actual': '2025-07-24T09:30:00Z'
                },
                'arrival': {
                    'airport': 'LHR',
                    'scheduled': '2025-07-24T10:00:00Z',
                    'actual': '2025-07-24T11:30:00Z'
                },
                'status': 'landed',
                'delay_minutes': 90,
                'is_eu_flight': True,
                'compensation_amount_eur': 400
            }
        ]
        
        return jsonify({
            'count': len(test_flights),
            'flights': test_flights,
            'timestamp': datetime.now().isoformat(),
            'source': 'diagnostic_test'
        })
    except Exception as e:
        logger.error(f"Error in test flights endpoint: {str(e)}")
        logger.error(traceback.format_exc())
        return jsonify({
            'status': 'error',
            'error': str(e),
            'traceback': traceback.format_exc()
        }), 500

@application.route('/check_data_file')
def check_data_file():
    """Checks if the data file exists and can be loaded"""
    try:
        logger.info("Data file check endpoint accessed")
        data_paths_to_check = [
            './data/flight_compensation_data.json',
            '../data/flight_compensation_data.json',
            '/home/PiotrS/mysite/data/flight_compensation_data.json',
            '/home/PiotrS/data/flight_compensation_data.json',
        ]
        
        results = {}
        
        for path in data_paths_to_check:
            try:
                if os.path.exists(path):
                    with open(path, 'r') as f:
                        # Just try to load the first few items to verify it's valid JSON
                        data = json.load(f)
                        flight_count = len(data) if isinstance(data, list) else 0
                        
                        results[path] = {
                            'exists': True,
                            'size_bytes': os.path.getsize(path),
                            'is_valid_json': True,
                            'flight_count': flight_count
                        }
                else:
                    results[path] = {
                        'exists': False
                    }
            except Exception as path_error:
                results[path] = {
                    'exists': os.path.exists(path),
                    'error': str(path_error)
                }
        
        return jsonify({
            'working_directory': os.getcwd(),
            'data_file_checks': results,
            'timestamp': datetime.now().isoformat()
        })
    except Exception as e:
        logger.error(f"Error in data file check endpoint: {str(e)}")
        logger.error(traceback.format_exc())
        return jsonify({
            'status': 'error',
            'error': str(e),
            'traceback': traceback.format_exc()
        }), 500

if __name__ == '__main__':
    # This is only used when running locally, not on PythonAnywhere
    application.run(debug=True, host='0.0.0.0', port=5000)
