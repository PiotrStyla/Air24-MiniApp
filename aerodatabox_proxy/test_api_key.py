"""
Test AviationStack API Connection
---------------------------------
Simple script to test the AviationStack API connection and verify the API key.
"""

import os
import sys
import requests
import logging

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger("test_api_key")

def test_aviationstack_api():
    """Test the AviationStack API with the provided API key."""
    
    # Your AviationStack API key
    api_key = "9cb5db4ba59f1e5005591c572d8b5f1c"
    
    # Set API key in environment variables and print to verify
    os.environ['AVIATIONSTACK_API_KEY'] = api_key
    logger.info(f"API key set in environment: {api_key[:5]}...")
    
    # API endpoint
    base_url = "http://api.aviationstack.com/v1"
    endpoint = "flights"
    
    # Request parameters
    params = {
        'access_key': api_key,
        'limit': 1  # Just get one flight to test
    }
    
    # Make direct request without going through client
    url = f"{base_url}/{endpoint}"
    logger.info(f"Making direct request to: {url}")
    logger.info(f"With parameters: {params}")
    
    try:
        response = requests.get(url, params=params, timeout=30)
        logger.info(f"Response status code: {response.status_code}")
        
        if response.status_code == 200:
            data = response.json()
            logger.info("API connection successful!")
            
            if 'data' in data and len(data['data']) > 0:
                # Show a sample of the data
                logger.info(f"Sample flight data: Flight {data['data'][0].get('flight', {}).get('iata')}")
                return True
            else:
                logger.error("API returned empty data array")
                logger.info(f"Full API response: {data}")
                return False
        else:
            logger.error(f"API request failed with status code: {response.status_code}")
            logger.info(f"Response body: {response.text}")
            return False
    except Exception as e:
        logger.error(f"Exception during API request: {e}")
        return False
        
if __name__ == "__main__":
    logger.info("Testing AviationStack API connection...")
    success = test_aviationstack_api()
    if success:
        logger.info("✅ API test successful!")
        sys.exit(0)
    else:
        logger.error("❌ API test failed!")
        sys.exit(1)
