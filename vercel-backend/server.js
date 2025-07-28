const express = require('express');
const cors = require('cors');
const sendEmailHandler = require('./api/sendEmail');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json({ limit: '10mb' })); // Support large attachments

// Routes
app.post('/api/sendEmail', sendEmailHandler);

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
  console.log(`🔍 Health check: http://localhost:${PORT}/health`);
});
