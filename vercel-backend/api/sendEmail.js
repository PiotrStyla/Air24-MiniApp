const { Resend } = require('resend');

// Initialize Resend with API key from environment variables
const resend = new Resend(process.env.RESEND_API_KEY);

/**
 * Secure email sending endpoint using Resend API
 * Handles flight compensation claim emails with attachment support
 */
module.exports = async (req, res) => {
  // Set CORS headers
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  // Handle preflight OPTIONS request
  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  // Only allow POST requests
  if (req.method !== 'POST') {
    return res.status(405).json({
      error: 'Method not allowed. Use POST.',
      code: 'METHOD_NOT_ALLOWED'
    });
  }

  try {
    // Validate request body
    const { to, subject, body, cc, bcc, replyTo, attachments, userEmail } = req.body;

    if (!to || !subject || !body) {
      return res.status(400).json({
        error: 'Missing required fields: to, subject, body',
        code: 'MISSING_FIELDS'
      });
    }

    // If userEmail is provided, use it as reply-to (unless replyTo is explicitly set)
    const finalReplyTo = replyTo || userEmail;

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
        code: 'INVALID_CC_EMAIL'
      });
    }

    if (bcc && !emailRegex.test(bcc)) {
      return res.status(400).json({
        error: 'Invalid BCC email address',
        code: 'INVALID_BCC_EMAIL'
      });
    }

    if (finalReplyTo && !emailRegex.test(finalReplyTo)) {
      return res.status(400).json({
        error: 'Invalid reply-to email address',
        code: 'INVALID_REPLY_TO_EMAIL'
      });
    }

    // Prepare email data
    const emailData = {
      from: 'onboarding@resend.dev',
      to: [to],
      subject: subject,
      html: body,
      text: body.replace(/<[^>]*>/g, ''), // Strip HTML for text version
    };

    // Add optional fields
    if (cc) emailData.cc = [cc];
    if (bcc) emailData.bcc = [bcc];
    if (finalReplyTo) emailData.reply_to = [finalReplyTo];

    // Add attachments if provided
    if (attachments && Array.isArray(attachments) && attachments.length > 0) {
      emailData.attachments = attachments.map(attachment => ({
        filename: attachment.filename,
        content: attachment.content, // Base64 encoded content
        content_type: attachment.contentType || 'application/octet-stream'
      }));
    }

    console.log('📧 Sending email via Resend API...');
    console.log('To:', to);
    console.log('Subject:', subject);
    console.log('Reply-To:', finalReplyTo || 'Not set');
    console.log('Has attachments:', !!(attachments && attachments.length > 0));

    // Send email using Resend
    const emailResult = await resend.emails.send(emailData);

    if (emailResult.error) {
      console.error('❌ Resend API error:', emailResult.error);
      return res.status(500).json({
        error: 'Failed to send email via Resend API',
        code: 'RESEND_API_ERROR',
        details: emailResult.error
      });
    }

    console.log('✅ Email sent successfully via Resend');
    console.log('Email ID:', emailResult.data.id);

    // Log successful email to console (in production, you might want to log to a database)
    const emailLog = {
      emailId: emailResult.data.id,
      to: to,
      subject: subject,
      timestamp: new Date().toISOString(),
      hasAttachments: !!(attachments && attachments.length > 0),
      attachmentCount: attachments ? attachments.length : 0
    };
    console.log('📝 Email log:', JSON.stringify(emailLog, null, 2));

    // Return success response
    return res.status(200).json({
      success: true,
      emailId: emailResult.data.id,
      message: 'Email sent successfully',
      timestamp: new Date().toISOString()
    });

  } catch (error) {
    console.error('❌ Error sending email:', error);
    
    // Handle specific Resend API errors
    if (error.name === 'ResendError') {
      return res.status(400).json({
        error: 'Resend API error',
        code: 'RESEND_ERROR',
        message: error.message
      });
    }

    // Handle general errors
    return res.status(500).json({
      error: 'Internal server error',
      code: 'INTERNAL_ERROR',
      message: 'An unexpected error occurred while sending email'
    });
  }
};
