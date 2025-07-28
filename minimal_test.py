"""
Absolute Minimal Flask Test App
"""

from flask import Flask

# Create Flask application - this name must match what PythonAnywhere expects
app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello from Flight Compensation API! If you can see this, the Flask server is working.'

# PythonAnywhere looks for an 'application' variable by default
application = app

if __name__ == '__main__':
    app.run(debug=True)
