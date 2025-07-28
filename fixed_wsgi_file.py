"""
WSGI configuration file for PythonAnywhere
This file should be placed at /var/www/piotrs_pythonanywhere_com_wsgi.py
"""
import sys
import os

# Add the directory containing your Flask application to the Python path
path = '/home/PiotrS'
if path not in sys.path:
    sys.path.insert(0, path)

# Import the application directly from fixed_wsgi_app.py
from fixed_wsgi_app import application
