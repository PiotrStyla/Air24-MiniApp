const express = require('express');
const cors = require('cors');
const worldIdVerifyHandler = require('./api/worldid-verify');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json({ limit: '10mb' })); // Support large attachments
// Serve static assets (Mini App lives in /public)
app.use(express.static('public'));

// Routes
if (process.env.RESEND_API_KEY) {
  const sendEmailHandler = require('./api/sendEmail');
  app.post('/api/sendEmail', sendEmailHandler);
} else {
  console.warn('RESEND_API_KEY not set; /api/sendEmail disabled');
}
app.post('/api/worldid-verify', worldIdVerifyHandler);

// Health check
app.get('/health', (req, res) => {
  res.json({ 
    status: 'healthy', 
    timestamp: new Date().toISOString(),
    service: 'Flight Compensation Email Backend'
  });
});

// Start server
app.listen(PORT, () => {
  console.log(`🚀 Email backend server running on http://localhost:${PORT}`);
  console.log(`📧 Email endpoint: http://localhost:${PORT}/api/sendEmail`);
  console.log(`🪪 World ID verify endpoint: http://localhost:${PORT}/api/worldid-verify`);
  console.log(`🧪 Mini App: http://localhost:${PORT}/miniapp`);
  console.log(`🔍 Health check: http://localhost:${PORT}/health`);
});
