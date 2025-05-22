"""
Diagnostics script for checking EU261 eligibility system on PythonAnywhere.
This script ONLY checks the existing database without adding mock/test data.
"""

# Simple diagnostics for PythonAnywhere
print("EU261 Eligibility Diagnostics")
print("-----------------------------")
print("This script will check if your enhanced EU261 detection system is")
print("correctly configured on PythonAnywhere.")

# Commands to run on PythonAnywhere console
commands = [
    "# 1. Check if EU airports module is found",
    "python -c \"try: from eu_airports import is_eligible_for_eu261; print('SUCCESS: EU airports module found'); except ImportError: print('ERROR: EU airports module not found')\"",
    "",
    "# 2. Check if EU airports database exists",
    "python -c \"import os; print('SUCCESS: EU airports database found') if os.path.exists('data/eu_airports.json') else print('ERROR: EU airports database not found')\"",
    "",
    "# 3. Check flight database statistics", 
    "python -c \"import json; data=json.load(open('data/flight_compensation_data.json')); flights=data['flights']; print(f'Total flights: {len(flights)}'); eligible=sum(1 for f in flights if f.get('delay_minutes', 0) >= 180 or 'cancel' in str(f.get('status', '')).lower()); print(f'Eligible flights (basic check): {eligible}'); print(f'Cancelled flights: {sum(1 for f in flights if \\'cancel\\' in str(f.get(\\'status\\', \\'\\').lower()))}')\"",
    "",
    "# 4. Test EU261 eligibility function on a sample flight",
    "python -c \"from eu_airports import is_eligible_for_eu261; test_flight = {'flight_number': 'LO123', 'departure_airport': 'WAW', 'arrival_airport': 'LHR', 'delay_minutes': 180}; print(f'Test flight eligible: {is_eligible_for_eu261(test_flight)}')\"",
    "",
    "# 5. Check wsgi_app.py imports EU airports module",
    "python -c \"with open('wsgi_app.py', 'r') as f: content = f.read(); print('SUCCESS: wsgi_app.py imports EU airports module') if 'from eu_airports import' in content else print('ERROR: wsgi_app.py does not import EU airports module')\"",
]

print("\nRun these commands on your PythonAnywhere console:")
print("---------------------------------------------------")
for cmd in commands:
    print(cmd)

print("\nAfter running the diagnostics:")
print("1. If all checks pass: Refresh your EU-wide Compensation screen in the app")
print("2. If any checks fail: Fix the issues then reload your web app")
