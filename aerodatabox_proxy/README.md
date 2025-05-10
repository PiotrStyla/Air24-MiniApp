# AeroDataBox API Proxy

A proxy service for AeroDataBox API with flight compensation eligibility detection.

## Features

- Proxy for AeroDataBox API calls
- Caching to reduce API calls and improve performance
- Flight delay detection
- EU261 compensation eligibility checking
- Optimized for Flutter applications

## Endpoints

- `/recent-arrivals?icao=XXXX` - Get recent arrivals for an airport by ICAO code
- `/flight-status?flight_number=XXX&date=YYYY-MM-DD` - Get status for a specific flight
- `/compensation-check?flight_number=XXX&date=YYYY-MM-DD` - Check EU261 compensation eligibility
- `/ping` - Health check endpoint

## Environment Variables

- `AERODATABOX_API_KEY` - Your AeroDataBox API key (required)
- `ALLOWED_ORIGINS` - Comma-separated list of allowed origins for CORS (default: "*")
- `CACHE_TTL_SECONDS` - Cache time-to-live in seconds (default: 300)

## Installation

1. Clone the repository
2. Install dependencies: `pip install -r requirements.txt`
3. Create a `.env` file with your AeroDataBox API key
4. Run the server: `uvicorn main:app --reload`

## Deployment

This service is ready to be deployed to platforms like Heroku using the included Procfile.

```
web: uvicorn main:app --host=0.0.0.0 --port=${PORT:-5000}
```

## Integration with Flutter

See the companion Flutter app for integration examples.
