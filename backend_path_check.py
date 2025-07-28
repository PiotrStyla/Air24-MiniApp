"""
Flight Compensation PythonAnywhere Backend Path Checker

This script verifies the existence and content of the populate_flight_data.py file
and provides diagnostic information about the backend setup.
"""

import os
import sys
import json
import traceback
from flask import Flask, jsonify, request
from datetime import datetime
import importlib.util
import logging

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger('backend_path_checker')

# Create Flask application
app = Flask(__name__)
application = app  # PythonAnywhere looks for 'application' variable

# Paths to check
PATHS_TO_CHECK = [
    '/home/PiotrS/flight_compensation/populate_flight_data.py',
    '/home/PiotrS/mysite/populate_flight_data.py',
    './populate_flight_data.py',
    '../flight_compensation/populate_flight_data.py'
]

def check_path(path):
    """Check if a file exists and return its metadata"""
    result = {
        'path': path,
        'exists': os.path.exists(path),
        'size_bytes': 0,
        'is_file': False,
        'is_readable': False,
        'last_modified': None,
        'content_preview': None
    }
    
    if result['exists']:
        result['is_file'] = os.path.isfile(path)
        if result['is_file']:
            try:
                result['size_bytes'] = os.path.getsize(path)
                result['is_readable'] = os.access(path, os.R_OK)
                result['last_modified'] = datetime.fromtimestamp(os.path.getmtime(path)).isoformat()
                
                # Get first few lines as preview
                if result['is_readable'] and result['size_bytes'] > 0:
                    with open(path, 'r') as f:
                        lines = [next(f, '').strip() for _ in range(5)]
                        result['content_preview'] = '\n'.join(line for line in lines if line)
            except Exception as e:
                result['error'] = str(e)
    
    return result

def try_import_module(path):
    """Attempt to import the module from the given path and extract information"""
    result = {
        'path': path,
        'import_successful': False,
        'functions': [],
        'variables': [],
        'classes': [],
        'error': None
    }
    
    if os.path.exists(path) and os.path.isfile(path):
        try:
            # Get module name from filename
            module_name = os.path.splitext(os.path.basename(path))[0]
            
            # Load module from file path
            spec = importlib.util.spec_from_file_location(module_name, path)
            if spec and spec.loader:
                module = importlib.util.module_from_spec(spec)
                spec.loader.exec_module(module)
                
                # Extract module information
                result['import_successful'] = True
                result['functions'] = [name for name, obj in vars(module).items() 
                                      if callable(obj) and not name.startswith('__')]
                result['variables'] = [name for name, obj in vars(module).items() 
                                     if not callable(obj) and not name.startswith('__')]
                result['classes'] = [name for name, obj in vars(module).items() 
                                   if isinstance(obj, type) and not name.startswith('__')]
                
                # Check if there's a Flask app in the module
                if hasattr(module, 'app') and isinstance(getattr(module, 'app'), Flask):
                    result['has_flask_app'] = True
                    result['flask_routes'] = [str(rule) for rule in module.app.url_map.iter_rules()]
                elif hasattr(module, 'application') and isinstance(getattr(module, 'application'), Flask):
                    result['has_flask_app'] = True
                    result['flask_routes'] = [str(rule) for rule in module.application.url_map.iter_rules()]
                else:
                    result['has_flask_app'] = False
        except Exception as e:
            result['error'] = str(e)
            result['traceback'] = traceback.format_exc()
    
    return result

@app.route('/')
def root():
    """Root diagnostic endpoint"""
    try:
        # Current environment info
        env_info = {
            'working_directory': os.getcwd(),
            'python_version': sys.version,
            'python_path': sys.executable,
            'sys_path': sys.path
        }
        
        # Check all possible paths
        path_checks = [check_path(path) for path in PATHS_TO_CHECK]
        
        # Try to import modules for existing files
        module_checks = []
        for path_check in path_checks:
            if path_check['exists'] and path_check['is_file'] and path_check['is_readable']:
                module_checks.append(try_import_module(path_check['path']))
        
        # Directory listings to help with troubleshooting
        dir_listings = {}
        dirs_to_check = [
            os.getcwd(),
            '/home/PiotrS',
            '/home/PiotrS/mysite',
            '/home/PiotrS/flight_compensation'
        ]
        
        for dir_path in dirs_to_check:
            try:
                if os.path.exists(dir_path) and os.path.isdir(dir_path):
                    dir_listings[dir_path] = os.listdir(dir_path)
                else:
                    dir_listings[dir_path] = f"Directory doesn't exist or is not accessible"
            except Exception as e:
                dir_listings[dir_path] = f"Error listing directory: {str(e)}"
        
        # Build response
        response = {
            'status': 'diagnostic_complete',
            'timestamp': datetime.now().isoformat(),
            'environment': env_info,
            'path_checks': path_checks,
            'module_checks': module_checks,
            'directory_listings': dir_listings
        }
        
        return jsonify(response)
    except Exception as e:
        logger.error(f"Error in diagnostic: {str(e)}")
        logger.error(traceback.format_exc())
        return jsonify({
            'status': 'error',
            'error': str(e),
            'traceback': traceback.format_exc()
        }), 500

if __name__ == '__main__':
    # For local testing only
    app.run(debug=True)
