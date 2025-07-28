"""
WSGI configuration file for PythonAnywhere
This file should be deployed to /var/www/piotrs_pythonanywhere_com_wsgi.py
"""
import sys

# Add the directory containing your Flask application to the Python path
path = '/home/PiotrS/mysite'
if path not in sys.path:
    sys.path.insert(0, path)

# Import the flask_app module which contains the 'application' object
# Note: Not importing 'app as application', but directly importing 'application'
from flask_app import application  # This is the correct import for our setup
