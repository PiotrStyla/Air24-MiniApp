const functions = require('firebase-functions');
const admin = require('firebase-admin');
const { Resend } = require('resend');

// Initialize Firebase Admin
admin.initializeApp();

// Initialize Resend with API key from environment variables
const resend = new Resend(functions.config().resend.api_key);

// CORS configuration
const cors = require('cors')({
  origin: true,
  credentials: true,
});

/**
 * Secure email sending endpoint using Resend API
 * Handles flight compensation claim emails
 */
exports.sendEmail = functions.https.onRequest(async (req, res) => {
  return cors(req, res, async () => {
    // Only allow POST requests
    if (req.method !== 'POST') {
      return res.status(405).json({
        error: 'Method not allowed. Use POST.',
        code: 'METHOD_NOT_ALLOWED'
      });
    }

    try {
      // Validate request body
      const { to, subject, body, cc, bcc, replyTo } = req.body;

      if (!to || !subject || !body) {
        return res.status(400).json({
          error: 'Missing required fields: to, subject, body',
          code: 'MISSING_FIELDS'
        });
      }

      // Validate email addresses
      const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
      
      if (!emailRegex.test(to)) {
        return res.status(400).json({
          error: 'Invalid recipient email address',
          code: 'INVALID_EMAIL'
        });
      }

      if (cc && !emailRegex.test(cc)) {
        return res.status(400).json({
          error: 'Invalid CC email address',
          code: 'INVALID_EMAIL'
        });
      }

      if (bcc && !emailRegex.test(bcc)) {
        return res.status(400).json({
          error: 'Invalid BCC email address',
          code: 'INVALID_EMAIL'
        });
      }

      // Prepare email data for Resend
      const emailData = {
        from: 'Flight Compensation <noreply@your-domain.com>', // Replace with your verified domain
        to: [to],
        subject: subject,
        html: `
          <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
            <div style="background-color: #f8f9fa; padding: 20px; border-radius: 8px;">
              <h2 style="color: #333; margin-bottom: 20px;">Flight Compensation Claim</h2>
              <div style="background-color: white; padding: 20px; border-radius: 4px; white-space: pre-line;">
                ${body.replace(/\n/g, '<br>')}
              </div>
              <div style="margin-top: 20px; padding: 15px; background-color: #e3f2fd; border-radius: 4px;">
                <p style="margin: 0; font-size: 12px; color: #666;">
                  This email was sent securely through Flight Compensation App.<br>
                  Sent on: ${new Date().toISOString()}
                </p>
              </div>
            </div>
          </div>
        `,
        text: body, // Plain text version
      };

      // Add optional fields
      if (cc) {
        emailData.cc = [cc];
      }

      if (bcc) {
        emailData.bcc = [bcc];
      }

      if (replyTo) {
        emailData.reply_to = [replyTo];
      }

      console.log('📧 Sending email via Resend...', {
        to: emailData.to,
        subject: emailData.subject,
        timestamp: new Date().toISOString()
      });

      // Send email using Resend
      const result = await resend.emails.send(emailData);

      if (result.error) {
        console.error('❌ Resend API error:', result.error);
        return res.status(500).json({
          error: 'Failed to send email via Resend',
          code: 'RESEND_ERROR',
          details: result.error
        });
      }

      console.log('✅ Email sent successfully:', result.data);

      // Log to Firestore for tracking (optional)
      try {
        await admin.firestore().collection('email_logs').add({
          emailId: result.data.id,
          to: to,
          subject: subject,
          timestamp: admin.firestore.FieldValue.serverTimestamp(),
          status: 'sent',
          resendId: result.data.id
        });
      } catch (logError) {
        console.warn('⚠️ Failed to log email to Firestore:', logError);
        // Don't fail the request if logging fails
      }

      // Return success response
      return res.status(200).json({
        success: true,
        emailId: result.data.id,
        message: 'Email sent successfully'
      });

    } catch (error) {
      console.error('❌ Unexpected error in sendEmail function:', error);

      // Handle specific Resend errors
      if (error.name === 'ResendError') {
        return res.status(400).json({
          error: 'Email service error',
          code: 'RESEND_ERROR',
          details: error.message
        });
      }

      // Handle rate limiting
      if (error.status === 429) {
        return res.status(429).json({
          error: 'Rate limit exceeded. Please try again later.',
          code: 'RATE_LIMIT_EXCEEDED'
        });
      }

      // Generic error response
      return res.status(500).json({
        error: 'Internal server error',
        code: 'INTERNAL_ERROR',
        message: error.message
      });
    }
  });
});

/**
 * Health check endpoint
 */
exports.healthCheck = functions.https.onRequest((req, res) => {
  return cors(req, res, () => {
    res.status(200).json({
      status: 'healthy',
      timestamp: new Date().toISOString(),
      service: 'flight-compensation-email-service'
    });
  });
});
