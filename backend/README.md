# Secure Email Service Backend Setup

This document provides complete setup instructions for the secure email sending backend using Firebase Cloud Functions and Resend API.

## Architecture Overview

```
Flutter App → HTTP Request → Firebase Cloud Function → Resend API → Email Delivery
```

## Prerequisites

1. **Firebase Project**: Set up a Firebase project for your app
2. **Resend Account**: Sign up for a Resend account (https://resend.com)
3. **Domain Verification**: Verify your sending domain with Resend
4. **Node.js**: Install Node.js 18+ for Firebase Functions

## Setup Instructions

### 1. Firebase Setup

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize Firebase in your project
firebase init functions

# Select your Firebase project
# Choose JavaScript/TypeScript (we'll use JavaScript)
# Install dependencies
```

### 2. Install Dependencies

```bash
cd functions
npm install firebase-functions firebase-admin resend cors
```

### 3. Configure Resend API Key

```bash
# Set the Resend API key as a Firebase environment variable
firebase functions:config:set resend.api_key="your-resend-api-key-here"
```

### 4. Update Domain Configuration

Edit `functions/index.js` and replace:
```javascript
from: 'Flight Compensation <noreply@your-domain.com>'
```

With your verified domain:
```javascript
from: 'Flight Compensation <noreply@yourdomain.com>'
```

### 5. Deploy Functions

```bash
# Deploy the functions
firebase deploy --only functions

# Note the function URL (will be something like):
# https://us-central1-your-project-id.cloudfunctions.net/sendEmail
```

### 6. Update Flutter App Configuration

In `lib/services/secure_email_service.dart`, update the backend URL:

```dart
static const String _backendUrl = 'https://us-central1-your-project-id.cloudfunctions.net/sendEmail';
```

## SPF/DKIM Setup for Deliverability

### 1. SPF Record
Add this TXT record to your domain's DNS:
```
v=spf1 include:_spf.resend.com ~all
```

### 2. DKIM Setup
Resend will provide DKIM records during domain verification. Add them to your DNS.

### 3. DMARC (Optional but Recommended)
Add a DMARC policy:
```
v=DMARC1; p=quarantine; rua=mailto:dmarc@yourdomain.com
```

## Testing

### 1. Test the Backend Function
```bash
curl -X POST https://your-function-url/sendEmail \
  -H "Content-Type: application/json" \
  -d '{
    "to": "test@example.com",
    "subject": "Test Email",
    "body": "This is a test email from the secure email service."
  }'
```

### 2. Expected Response
```json
{
  "success": true,
  "emailId": "resend-email-id",
  "message": "Email sent successfully"
}
```

## Error Handling

The backend handles various error scenarios:

- **400**: Invalid email addresses, missing fields
- **401/403**: Authentication errors
- **429**: Rate limiting
- **500**: Server errors

## Security Features

1. **CORS Protection**: Only allows requests from your app
2. **Input Validation**: Validates all email addresses and required fields
3. **API Key Security**: Resend API key is stored securely in Firebase environment
4. **Request Logging**: All email sends are logged to Firestore for tracking
5. **Rate Limiting**: Resend provides built-in rate limiting

## Monitoring

### Firebase Console
- View function logs in Firebase Console → Functions
- Monitor function performance and errors

### Resend Dashboard
- Track email delivery rates
- Monitor bounce and complaint rates
- View detailed email logs

## Cost Considerations

### Resend Pricing
- Free tier: 3,000 emails/month
- Paid plans start at $20/month for 50,000 emails

### Firebase Functions Pricing
- Free tier: 2M invocations/month
- $0.40 per million invocations after that

## Troubleshooting

### Common Issues

1. **CORS Errors**
   - Ensure your app domain is properly configured
   - Check Firebase hosting configuration

2. **Email Not Delivered**
   - Verify SPF/DKIM records
   - Check Resend dashboard for bounce/complaint rates
   - Ensure sender domain is verified

3. **Function Timeout**
   - Default timeout is 60 seconds
   - Increase if needed in Firebase console

4. **Rate Limiting**
   - Implement exponential backoff in Flutter app
   - Consider upgrading Resend plan

### Debug Logs

Enable debug logging in Flutter:
```dart
debugPrint('🚀 SecureEmailService: Starting sendEmail...');
```

View Firebase function logs:
```bash
firebase functions:log
```

## Production Deployment

1. **Environment Variables**: Use different Resend API keys for dev/prod
2. **Domain Setup**: Use production domain for email sending
3. **Monitoring**: Set up alerts for function errors
4. **Backup**: Consider backup email service (SendGrid, Mailgun)

## Support

For issues with:
- **Firebase Functions**: Firebase Support
- **Resend API**: Resend Support (support@resend.com)
- **DNS/Domain**: Your domain registrar support

---

## PythonAnywhere Simple WSGI API (EU Eligible Flights)

This repository also contains a minimal, framework-free WSGI backend used to serve eligible EU compensation flights to the Flutter app.

- File: `backend/simple_wsgi_app.py`
- Purpose: Provide the endpoint the app calls for EU-wide eligible flights.
- Endpoints:
  - `GET /eligible_flights?hours=24` (canonical)
  - `GET /eu-compensation-eligible?hours=24` (temporary alias for older builds)
  - `GET /api/flights` (normalized raw flights)
  - `GET /health`, `GET /status`, `GET /check_data_file`, `GET /debug_flight_data` (debug/health)
- Response: A list of normalized flight objects with keys the app expects (`flight_iata`, `airline_name`, `airline_iata`, `departure_airport_iata`, `arrival_airport_iata`, `status`, `delay_minutes`, `departure_scheduled_time`, ...).

### Deploying on PythonAnywhere

1. Open the PythonAnywhere web app WSGI configuration (e.g., `/var/www/piotrs_pythonanywhere_com_wsgi.py`).
2. Paste the contents of `backend/simple_wsgi_app.py` into that WSGI file, or import it from a small loader.
3. Reload the PythonAnywhere web app.
4. Verify:
   - `https://<your-domain>.pythonanywhere.com/eligible_flights?hours=24` returns a non-empty JSON list (when data is present)
   - `https://<your-domain>.pythonanywhere.com/check_data_file` shows file health and counts

Notes:
- The app uses a 24-hour window coherently across UI, service, and tests.
- Keep the alias `/eu-compensation-eligible` until all deployed frontends use `/eligible_flights`, then remove it.
