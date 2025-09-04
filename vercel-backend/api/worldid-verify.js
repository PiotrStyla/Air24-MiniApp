// World ID verification endpoint (Vercel Serverless Function)
// - Proxies verification to Worldcoin Developer API
// - Keeps secrets (API key if used) on the server side
// - CORS-enabled for browser requests from the Flutter Web app

/**
 * Expected request body (from IDKit response):
 * {
 *   nullifier_hash: string,
 *   merkle_root: string,
 *   proof: string,
 *   verification_level: 'orb' | 'device' | 'phone',
 *   action: string, // your action slug
 *   signal_hash?: string
 * }
 */

const BASE_URL = 'https://developer.worldcoin.org/api/v2/verify';

module.exports = async (req, res) => {
  // CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed. Use POST.', code: 'METHOD_NOT_ALLOWED' });
  }

  const appId = process.env.WLD_APP_ID;
  const maybeApiKey = process.env.WLD_API_KEY; // optional; not strictly required for verify

  if (!appId) {
    return res.status(500).json({ error: 'Server not configured: missing WLD_APP_ID', code: 'MISSING_APP_ID' });
  }

  try {
    const {
      nullifier_hash,
      merkle_root,
      proof,
      verification_level,
      action,
      signal_hash
    } = req.body || {};

    // Basic validation
    if (!nullifier_hash || !merkle_root || !proof || !verification_level || !action) {
      return res.status(400).json({
        error: 'Missing required fields',
        code: 'MISSING_FIELDS',
        required: ['nullifier_hash', 'merkle_root', 'proof', 'verification_level', 'action']
      });
    }

    const url = `${BASE_URL}/${encodeURIComponent(appId)}`;

    const headers = {
      'Content-Type': 'application/json',
      'User-Agent': 'FlightCompensation/1.0'
    };

    // If provided, include API key (mainly for authenticated endpoints; verify typically does not require it)
    if (maybeApiKey) {
      headers['Authorization'] = `Bearer ${maybeApiKey}`;
    }

    const body = {
      nullifier_hash,
      merkle_root,
      proof,
      verification_level,
      action,
      ...(signal_hash ? { signal_hash } : {})
    };

    const response = await fetch(url, {
      method: 'POST',
      headers,
      body: JSON.stringify(body)
    });

    const data = await response.json().catch(() => ({ success: false, error: 'Invalid JSON from Worldcoin API' }));

    if (!response.ok) {
      // Forward error details from Worldcoin API
      return res.status(400).json({
        success: false,
        code: 'WORLDCOIN_VERIFY_FAILED',
        status: response.status,
        data
      });
    }

    // Successful verification
    return res.status(200).json({ success: true, ...data });
  } catch (err) {
    console.error('❌ World ID verification error:', err);
    return res.status(500).json({ error: 'Internal server error', code: 'INTERNAL_ERROR' });
  }
};
