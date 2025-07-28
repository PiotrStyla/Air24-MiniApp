"""
Flask application entry point for PythonAnywhere WSGI configuration
This file serves as the entry point required by PythonAnywhere's WSGI configuration
which expects a Flask application object named 'application'.
"""
from fixed_wsgi_app import application

# This file exists solely to provide the 'application' object that PythonAnywhere expects.
# The actual application logic is in fixed_wsgi_app.py

if __name__ == '__main__':
    # For local testing only - this won't be used by PythonAnywhere
    import logging
    logging.basicConfig(level=logging.INFO)
    
    # Create a simple test server when run directly
    from wsgiref.simple_server import make_server
    
    logging.info("Starting test server on port 8000...")
    with make_server('', 8000, application) as httpd:
        logging.info("Test server ready - http://localhost:8000/")
        httpd.serve_forever()
