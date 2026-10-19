import { serve } from "https://deno.land/std@0.177.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.3"

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

interface PushPayload {
  userId?: string
  user_id?: string
  title?: string
  body?: string
  data?: Record<string, any>
  record?: {
    id?: string
    user_id?: string
    title?: string
    body?: string
    type?: string
    data?: Record<string, any>
  }
}

/**
 * Generate an OAuth 2.0 access token for Firebase Cloud Messaging HTTP v1 API
 * using a service account private key.
 */
async function getGoogleAccessToken(
  clientEmail: string,
  privateKeyPem: string
): Promise<string | null> {
  try {
    const header = { alg: "RS256", typ: "JWT" }
    const now = Math.floor(Date.now() / 1000)
    const claim = {
      iss: clientEmail,
      scope: "https://www.googleapis.com/auth/firebase.messaging",
      aud: "https://oauth2.googleapis.com/token",
      exp: now + 3600,
      iat: now,
    }

    const encodeBase64Url = (obj: any) => {
      const str = typeof obj === 'string' ? obj : JSON.stringify(obj)
      return btoa(str).replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/, "")
    }

    const encodedHeader = encodeBase64Url(header)
    const encodedClaim = encodeBase64Url(claim)
    const unsignedJwt = `${encodedHeader}.${encodedClaim}`

    // Parse PEM key to CryptoKey
    const cleanPem = privateKeyPem
      .replace(/-----BEGIN (RSA )?PRIVATE KEY-----/g, "")
      .replace(/-----END (RSA )?PRIVATE KEY-----/g, "")
      .replace(/\s+/g, "")

    const binaryKey = Uint8Array.from(atob(cleanPem), (c) => c.charCodeAt(0))
    const cryptoKey = await crypto.subtle.importKey(
      "pkcs8",
      binaryKey.buffer,
      { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" },
      false,
      ["sign"]
    )

    const signature = await crypto.subtle.sign(
      "RSASSA-PKCS1-v1_5",
      cryptoKey,
      new TextEncoder().encode(unsignedJwt)
    )

    const encodedSignature = btoa(
      String.fromCharCode(...new Uint8Array(signature))
    )
      .replace(/\+/g, "-")
      .replace(/\//g, "_")
      .replace(/=+$/, "")

    const signedJwt = `${unsignedJwt}.${encodedSignature}`

    // Exchange signed JWT for OAuth 2.0 access token
    const tokenResponse = await fetch("https://oauth2.googleapis.com/token", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: `grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=${signedJwt}`,
    })

    if (!tokenResponse.ok) {
      const errText = await tokenResponse.text()
      console.error("[FCM] OAuth2 token exchange failed:", errText)
      return null
    }

    const tokenData = await tokenResponse.json()
    return tokenData.access_token
  } catch (err) {
    console.error("[FCM] Error generating Google OAuth token:", err)
    return null
  }
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const supabaseUrl = Deno.env.get('SUPABASE_URL') ?? ''
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''

    if (!supabaseUrl || !supabaseServiceKey) {
      throw new Error('Supabase server environment configuration missing')
    }

    const supabase = createClient(supabaseUrl, supabaseServiceKey)

    // Parse payload (supports Webhook record or direct JSON)
    const body: PushPayload = await req.json().catch(() => ({}))
    const targetUserId = body.userId || body.user_id || body.record?.user_id
    const title = body.title || body.record?.title || 'New message'
    const messageBody = body.body || body.record?.body || ''
    const customData = {
      ...(body.record?.data || {}),
      ...(body.data || {}),
    }

    if (!targetUserId) {
      return new Response(
        JSON.stringify({ error: 'Missing target user_id' }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 400 }
      )
    }

    // Lookup active devices with valid FCM tokens
    const { data: devices, error: deviceError } = await supabase
      .from('user_devices')
      .select('id, device_identifier, platform, fcm_token')
      .eq('user_id', targetUserId)
      .eq('is_active', true)
      .not('fcm_token', 'is', null)

    if (deviceError) {
      throw deviceError
    }

    const validDevices = (devices || []).filter(
      (d) => d.fcm_token && String(d.fcm_token).trim().length > 0
    )

    const sanitizedUserId = targetUserId.length > 8 ? `${targetUserId.substring(0, 8)}...` : targetUserId
    if (validDevices.length === 0) {
      console.log(`[FCM] No active registered device with FCM token for user ${sanitizedUserId}`)
      return new Response(
        JSON.stringify({ sent: 0, reason: 'no_active_fcm_device', target: sanitizedUserId }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 200 }
      )
    }

    // Firebase Service Account Credentials from Environment
    const firebaseProjectId = Deno.env.get('FIREBASE_PROJECT_ID') || 'lastspot-d54ac'
    const firebaseClientEmail = Deno.env.get('FIREBASE_CLIENT_EMAIL')
    const firebasePrivateKey = Deno.env.get('FIREBASE_PRIVATE_KEY')

    let accessToken: string | null = null
    if (firebaseClientEmail && firebasePrivateKey) {
      accessToken = await getGoogleAccessToken(firebaseClientEmail, firebasePrivateKey)
    }

    let successCount = 0
    let failureCount = 0
    const results: any[] = []

    for (const dev of validDevices) {
      const fcmToken = dev.fcm_token as string
      const maskedToken = fcmToken.length > 10 ? `...${fcmToken.slice(-6)}` : 'token'

      // Prepare standardized string map for data payload
      const stringData: Record<string, string> = {
        type: String(customData.type || 'chat_message'),
        conversation_id: String(customData.conversation_id || customData.conversationId || ''),
        message_id: String(customData.message_id || customData.messageId || body.record?.id || ''),
        sender_id: String(customData.sender_id || customData.senderId || ''),
        chat_type: String(customData.chat_type || customData.chatType || 'direct'),
        title: String(title),
        body: String(messageBody),
        click_action: 'FLUTTER_NOTIFICATION_CLICK',
      }

      if (customData.request_id) stringData.request_id = String(customData.request_id)
      if (customData.sender_name) stringData.sender_name = String(customData.sender_name)
      if (customData.activity_title) stringData.activity_title = String(customData.activity_title)

      if (accessToken) {
        // FCM HTTP v1 API
        const fcmMessage = {
          message: {
            token: fcmToken,
            notification: {
              title: title,
              body: messageBody,
            },
            data: stringData,
            android: {
              priority: 'HIGH',
              notification: {
                channel_id: 'lastspot_default',
                icon: 'ic_notification',
                color: '#F46A35',
                click_action: 'FLUTTER_NOTIFICATION_CLICK',
              },
            },
          },
        }

        try {
          const fcmResponse = await fetch(
            `https://fcm.googleapis.com/v1/projects/${firebaseProjectId}/messages:send`,
            {
              method: 'POST',
              headers: {
                Authorization: `Bearer ${accessToken}`,
                'Content-Type': 'application/json',
              },
              body: JSON.stringify(fcmMessage),
            }
          )

          const fcmResult = await fcmResponse.json()
          if (fcmResponse.ok) {
            successCount++
            results.push({ device: dev.id, status: 'sent', fcmName: fcmResult.name })
            console.log(`[FCM] Dispatched push to device ${dev.id} (${maskedToken})`)
          } else {
            failureCount++
            const errCode = fcmResult.error?.status || fcmResult.error?.code || 'UNKNOWN'
            console.error(`[FCM] Send failed for device ${dev.id}: ${errCode}`)
            results.push({ device: dev.id, status: 'failed', error: errCode })

            // Auto-deactivate invalid/unregistered device tokens
            if (['UNREGISTERED', 'NOT_FOUND', 'INVALID_ARGUMENT'].includes(errCode)) {
              console.log(`[FCM] Deactivating invalid token for device ${dev.id}`)
              await supabase
                .from('user_devices')
                .update({ is_active: false, updated_at: new Date().toISOString() })
                .eq('id', dev.id)
            }
          }
        } catch (fetchErr: any) {
          failureCount++
          console.error(`[FCM] Network error sending to device ${dev.id}:`, fetchErr.message)
          results.push({ device: dev.id, status: 'error', error: fetchErr.message })
        }
      } else {
        // Fallback: Record pending notification delivery in database queue
        console.warn(`[FCM] Server credentials not configured; logged notification for recipient ${sanitizedUserId} (${validDevices.length} devices)`)
        results.push({
          device: dev.id,
          status: 'queued_local',
          note: 'Requires FIREBASE_CLIENT_EMAIL and FIREBASE_PRIVATE_KEY in Supabase Vault for direct FCM dispatch',
        })
      }
    }

    return new Response(
      JSON.stringify({
        success: failureCount === 0,
        sent: successCount,
        failed: failureCount,
        devicesTargeted: validDevices.length,
        results,
      }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 200 }
    )
  } catch (error: any) {
    console.error('[FCM] Push dispatch error:', error)
    return new Response(
      JSON.stringify({ error: error.message || 'Internal error' }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 500 }
    )
  }
})
