// =================================================================
// EMAIL INGESTION CODE FOR FIREBASE FUNCTIONS
// =================================================================
// Add this code to: backend/functions/index.js
// Add it AFTER the healthCheck function (at the end of the file)
// =================================================================

const OpenAI = require('openai');

// Initialize OpenAI
const openai = new OpenAI({
  apiKey: functions.config().openai.api_key
});

/**
 * Email Ingestion Endpoint
 * Receives forwarded emails from SendGrid/Mailgun
 * Parses airline responses with AI
 * Updates claim status automatically
 */
exports.ingestEmail = functions.https.onRequest(async (req, res) => {
  return cors(req, res, async () => {
    console.log('📧 Email ingestion started');
    
    if (req.method !== 'POST') {
      return res.status(405).json({ error: 'Method not allowed' });
    }

    try {
      const { from, to, subject, text, html } = req.body;
      
      // Extract claim ID from email address (format: claims+ABC123@air24.app)
      const claimIdMatch = to.match(/claims\+([A-Z0-9]+)@/);
      if (!claimIdMatch) {
        console.error('❌ Invalid claim ID in email address:', to);
        return res.status(400).json({ error: 'Invalid claim ID' });
      }
      
      const claimId = claimIdMatch[1];
      console.log(`📋 Processing email for claim: ${claimId}`);
      
      // Parse email body with GPT-4
      const emailBody = text || html;
      const parsed = await parseAirlineResponse(emailBody);
      
      console.log('🤖 AI parsing result:', JSON.stringify(parsed));
      
      // Update Firestore
      await admin.firestore().collection('claims').doc(claimId).update({
        status: parsed.status,
        airlineResponse: emailBody,
        airlineResponseParsed: parsed,
        lastUpdated: admin.firestore.FieldValue.serverTimestamp(),
        responseReceivedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
      
      console.log('✅ Claim updated in Firestore');
      
      // Send push notification to user
      await sendClaimUpdateNotification(claimId, parsed);
      
      return res.status(200).json({ 
        success: true, 
        claimId,
        status: parsed.status 
      });
      
    } catch (error) {
      console.error('❌ Error in email ingestion:', error);
      return res.status(500).json({ 
        error: 'Internal error', 
        details: error.message 
      });
    }
  });
});

/**
 * Parse airline response email using OpenAI GPT-4
 */
async function parseAirlineResponse(emailBody) {
  try {
    const prompt = `Analyze this airline response email and extract:
1. status: "accepted" | "rejected" | "pending" | "needs_info"
2. reason: string (if rejected or pending, explain why)
3. offered_amount: number (compensation offered in EUR, or 0)
4. required_actions: string[] (what user needs to do, if any)

Email content:
${emailBody}

Return ONLY valid JSON with these exact fields.`;

    const response = await openai.chat.completions.create({
      model: 'gpt-4',
      messages: [{ role: 'user', content: prompt }],
      response_format: { type: 'json_object' },
      temperature: 0.3,
    });

    const result = JSON.parse(response.choices[0].message.content);
    
    // Ensure all required fields exist
    return {
      status: result.status || 'pending',
      reason: result.reason || '',
      offered_amount: result.offered_amount || 0,
      required_actions: result.required_actions || [],
    };
  } catch (error) {
    console.error('❌ AI parsing error:', error);
    // Return safe default
    return {
      status: 'pending',
      reason: 'Could not parse email automatically',
      offered_amount: 0,
      required_actions: ['Check email manually'],
    };
  }
}

/**
 * Send push notification about claim update
 */
async function sendClaimUpdateNotification(claimId, parsed) {
  try {
    // Get claim data
    const claimDoc = await admin.firestore().collection('claims').doc(claimId).get();
    if (!claimDoc.exists) {
      console.warn('⚠️ Claim not found:', claimId);
      return;
    }
    
    const claim = claimDoc.data();
    const userId = claim.userId;
    
    // Get user's FCM token
    const userDoc = await admin.firestore().collection('users').doc(userId).get();
    if (!userDoc.exists) {
      console.warn('⚠️ User not found:', userId);
      return;
    }
    
    const fcmToken = userDoc.data()?.fcmToken;
    if (!fcmToken) {
      console.warn('⚠️ No FCM token for user:', userId);
      return;
    }
    
    // Prepare notification message
    let title = '✈️ Claim Update!';
    let body = '';
    
    switch (parsed.status) {
      case 'accepted':
        title = '🎉 Claim Accepted!';
        body = `Your claim for flight ${claim.flightNumber} was accepted! €${parsed.offered_amount} compensation.`;
        break;
      case 'rejected':
        title = '❌ Claim Rejected';
        body = `Your claim was rejected. Reason: ${parsed.reason}`;
        break;
      case 'pending':
        title = '⏳ Claim Pending';
        body = `Update on flight ${claim.flightNumber}. ${parsed.reason}`;
        break;
      case 'needs_info':
        title = '📝 Action Required';
        body = `More info needed for your claim. Check the app.`;
        break;
    }
    
    // Send notification
    await admin.messaging().send({
      token: fcmToken,
      notification: { title, body },
      data: {
        type: 'claim_update',
        claimId: claimId,
        status: parsed.status,
      },
    });
    
    console.log('✅ Push notification sent to user:', userId);
  } catch (error) {
    console.error('❌ Error sending notification:', error);
    // Don't throw - notification failure shouldn't break email ingestion
  }
}

// =================================================================
// END OF CODE TO ADD
// =================================================================
