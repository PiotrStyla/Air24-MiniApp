# Deployment Guide for Flight Compensation API

This guide will help you deploy your hybrid server to a cloud provider, making it accessible from both WiFi and mobile data connections. This aligns with your centralized database architecture goals.

## Option 1: Deploy to Render.com (Free Tier)

1. Sign up at [Render.com](https://render.com/)
2. Create a new Web Service
3. Connect your GitHub repository (or deploy from local files)
4. Configure your deployment:
   - Build Command: `pip install -r requirements.txt`
   - Start Command: `python -m uvicorn hybrid_server:app --host 0.0.0.0 --port $PORT`
   - Add the environment variable `AVIATIONSTACK_API_KEY` with your API key

## Option 2: Deploy to DigitalOcean ($5/month)

1. Create a $5 Droplet on DigitalOcean
2. SSH into your server and install dependencies:
   ```bash
   apt update && apt install -y python3-pip git
   git clone <your-repo-url> /app
   cd /app
   pip install -r requirements.txt
   ```
3. Set up environment variables:
   ```bash
   echo "AVIATIONSTACK_API_KEY=9cb5db4ba59f1e5005591c572d8b5f1c" > .env
   ```
4. Set up a systemd service for auto-start:
   ```bash
   cat > /etc/systemd/system/flightcomp.service << EOF
   [Unit]
   Description=Flight Compensation API
   After=network.target

   [Service]
   User=root
   WorkingDirectory=/app
   ExecStart=/usr/bin/python3 -m uvicorn hybrid_server:app --host 0.0.0.0 --port 8001
   Restart=always
   Environment=PYTHONUNBUFFERED=1

   [Install]
   WantedBy=multi-user.target
   EOF
   ```
5. Enable and start the service:
   ```bash
   systemctl enable flightcomp.service
   systemctl start flightcomp.service
   ```

## Updating the Flutter App to Use the Public API

Once deployed, update the `AeroDataBoxService` class in your Flutter app:

```dart
static String _getDefaultApiBaseUrl() {
  // Replace with your deployed API URL
  String deployedApiUrl = "https://your-deployed-api.onrender.com";
  
  // For development/testing, use localhost or computer IP
  if (kDebugMode) {
    // For Android emulator, use 10.0.2.2 which routes to host's localhost
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8001';
    }
    
    // For iOS simulator, use localhost
    if (Platform.isIOS) {
      return 'http://localhost:8001';
    }
    
    // For physical devices in debug mode, use computer's IP
    return 'http://192.168.0.179:8001';
  }
  
  // In production/release mode, use deployed API
  return deployedApiUrl;
}
```

## Centralized Database Evolution

This deployment approach supports your planned centralized database architecture:

1. The server persistently stores flight data in json files (can be upgraded to PostgreSQL/MongoDB later)
2. All apps connect to the same central server
3. Over time, your database will accumulate real historical flight delay data
4. The mother/master application concept can be built on top of this API

## SSL/TLS Security

For production use, ensure your API has proper SSL/TLS certificates. Services like Render.com provide this automatically, but for self-hosted solutions, consider setting up Nginx with Let's Encrypt.
