const functions = require('firebase-functions');
const admin = require('firebase-admin');
const OpenAI = require('openai');
const sgMail = require('@sendgrid/mail');

admin.initializeApp();

// Helper function to get OpenAI client (lazy initialization)
function getOpenAIClient() {
  return new OpenAI({
    apiKey: process.env.OPENAI_API_KEY || functions.config().openai?.api_key,
  });
}

// Helper function to get SendGrid client (lazy initialization)
function getSendGridClient() {
  const client = sgMail;
  client.setApiKey(process.env.RESEND_API_KEY || functions.config().resend?.api_key);
  return client;
}

/**
 * Parse incoming email using GPT-4 to extract claim status updates
 * Webhook endpoint: https://us-central1-flightcompensation-d059a.cloudfunctions.net/ingestEmail
 */
exports.ingestEmail = functions.https.onRequest(async (req, res) => {
  try {
    console.log('📧 Email ingestion started');
    console.log('Headers:', JSON.stringify(req.headers));
    console.log('Body type:', req.headers['content-type']);

    // Handle both JSON and multipart/form-data from SendGrid
    let from, to, subject, text, html;
    
    if (req.headers['content-type']?.includes('multipart/form-data')) {
      // Parse multipart data (SendGrid with "POST raw MIME" checked or unchecked but still sending multipart)
      console.log('📦 Parsing multipart/form-data');
      const Busboy = require('busboy');
      const busboy = Busboy({ headers: req.headers });
      const fields = {};
      
      await new Promise((resolve, reject) => {
        busboy.on('field', (fieldname, val) => {
          fields[fieldname] = val;
        });
        busboy.on('finish', resolve);
        busboy.on('error', reject);
        busboy.end(req.rawBody || req.body);
      });
      
      // Extract email data from parsed fields
      from = fields.from;
      to = fields.to;
      subject = fields.subject;
      text = fields.text;
      html = fields.html;
      
      console.log('Parsed fields:', Object.keys(fields));
    } else {
      // JSON format (expected when "POST raw MIME" is unchecked)
      ({ from, to, subject, text, html } = req.body);
    }

    if (!from || !text) {
      console.error('❌ Missing required email fields');
      console.error('Available data:', { from, to, subject, hasText: !!text, hasHtml: !!html });
      return res.status(400).send('Missing required fields');
    }

    console.log(`📬 Processing email from: ${from}`);
    console.log(`📝 Subject: ${subject}`);

    // Use GPT-4 to parse the email content
    const openai = getOpenAIClient();
    const completion = await openai.chat.completions.create({
      model: 'gpt-4',
      messages: [
        {
          role: 'system',
          content: `You are an AI assistant that extracts claim status information from airline emails.
Extract the following information if available:
- claim_id: The claim reference number
- status: One of: pending, approved, rejected, needs_info
- airline: The airline name
- compensation_amount: Amount if mentioned
- reason: Brief reason for status
- next_steps: What the user needs to do

Respond ONLY with valid JSON. If information is not found, use null.`
        },
        {
          role: 'user',
          content: `Email Subject: ${subject}\n\nEmail Body:\n${text}`
        }
      ],
      temperature: 0.3,
      max_tokens: 500
    });

    const parsedData = JSON.parse(completion.choices[0].message.content);
    console.log('🤖 GPT-4 parsed data:', JSON.stringify(parsedData));

    // Find the claim in Firestore
    if (parsedData.claim_id) {
      const claimsRef = admin.firestore().collection('claims');
      const snapshot = await claimsRef.where('claimId', '==', parsedData.claim_id).get();

      if (!snapshot.empty) {
        const claimDoc = snapshot.docs[0];
        const claimData = claimDoc.data();

        // Update claim status
        await claimDoc.ref.update({
          status: parsedData.status || 'pending',
          lastUpdated: admin.firestore.FieldValue.serverTimestamp(),
          airlineResponse: {
            receivedAt: admin.firestore.FieldValue.serverTimestamp(),
            from: from,
            subject: subject,
            parsedData: parsedData
          }
        });

        console.log(`✅ Updated claim ${parsedData.claim_id}`);

        // Send push notification to user
        if (claimData.userId) {
          try {
            const userDoc = await admin.firestore().collection('users').doc(claimData.userId).get();
            const userData = userDoc.data();

            if (userData && userData.fcmToken) {
              // Create user-friendly notification message
              const statusMessages = {
                approved: '✅ Great news! Your claim has been approved',
                rejected: '❌ Your claim was rejected',
                pending: '⏳ Your claim is being reviewed',
                needs_info: 'ℹ️ Action required: Additional information needed'
              };
              
              const notificationTitle = statusMessages[parsedData.status] || 'Claim Update';
              const notificationBody = parsedData.compensation_amount
                ? `Claim ${parsedData.claim_id}: ${parsedData.compensation_amount} compensation`
                : `Claim ${parsedData.claim_id} status updated. Tap to view details.`;
              
              const message = {
                notification: {
                  title: notificationTitle,
                  body: notificationBody
                },
                data: {
                  type: 'claim_update',
                  claimId: parsedData.claim_id,
                  status: parsedData.status || 'unknown',
                  timestamp: new Date().toISOString()
                },
                token: userData.fcmToken,
                android: {
                  priority: 'high',
                  notification: {
                    channelId: 'claim_updates',
                    priority: 'high',
                    defaultSound: true,
                    defaultVibrateTimings: true
                  }
                },
                apns: {
                  payload: {
                    aps: {
                      sound: 'default',
                      badge: 1
                    }
                  }
                }
              };

              await admin.messaging().send(message);
              console.log('🔔 Push notification sent successfully');
            }
          } catch (notifError) {
            console.error('❌ Push notification failed:', notifError);
          }
        }
      } else {
        console.warn(`⚠️ Claim ${parsedData.claim_id} not found`);
      }
    } else {
      console.warn('⚠️ No claim_id found in email');
    }

    res.status(200).send('Email processed successfully');
  } catch (error) {
    console.error('❌ Error processing email:', error);
    res.status(500).send('Internal server error');
  }
});

/**
 * Health check endpoint
 */
exports.healthCheck = functions.https.onRequest((req, res) => {
  res.status(200).json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    service: 'flight-compensation-functions'
  });
});
