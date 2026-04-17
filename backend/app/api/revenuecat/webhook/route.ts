import { NextRequest, NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";

export const runtime = "nodejs";

/**
 * RevenueCat webhook receiver.
 *
 * Setup in RevenueCat dashboard:
 *   Project settings → Integrations → Webhooks → Add new webhook
 *     URL: https://<your-vercel-domain>/api/revenuecat/webhook
 *     Authorization header: Bearer <some-long-random-secret>
 *
 * Set REVENUECAT_WEBHOOK_SECRET on Vercel to the same secret so we can
 * authenticate incoming requests.
 *
 * Event reference: https://www.revenuecat.com/docs/webhooks
 */
export async function POST(req: NextRequest) {
  // 1. Verify the shared secret in the Authorization header.
  const expected = process.env.REVENUECAT_WEBHOOK_SECRET;
  if (!expected) {
    console.error("REVENUECAT_WEBHOOK_SECRET not configured");
    return NextResponse.json({ error: "server_misconfigured" }, { status: 500 });
  }
  const header = req.headers.get("authorization") ?? req.headers.get("Authorization");
  if (header !== `Bearer ${expected}`) {
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  }

  // 2. Parse the event.
  type RCEvent = {
    type: string;
    app_user_id: string;
    original_app_user_id?: string;
    product_id?: string;
    expiration_at_ms?: number;
    entitlement_ids?: string[];
  };
  type RCPayload = { event: RCEvent; api_version?: string };

  let body: RCPayload;
  try {
    body = (await req.json()) as RCPayload;
  } catch {
    return NextResponse.json({ error: "invalid_json" }, { status: 400 });
  }
  const event = body.event;
  if (!event || !event.type || !event.app_user_id) {
    return NextResponse.json({ error: "invalid_event" }, { status: 400 });
  }

  // The `app_user_id` is what we passed to `Purchases.shared.logIn(userId)` on
  // the iOS side, which is our backend User.id.
  const userId = event.app_user_id;

  const user = await prisma.user.findUnique({ where: { id: userId } });
  if (!user) {
    // Event for a user we don't know — likely a test or a user that was deleted.
    // Log and 200 so RevenueCat doesn't keep retrying.
    console.warn(`RC webhook for unknown user: ${userId} (${event.type})`);
    return NextResponse.json({ ok: true, ignored: true });
  }

  // 3. Map event type → subscription state change.
  const expiresAt = event.expiration_at_ms ? new Date(event.expiration_at_ms) : null;

  let isPremium = user.isPremium;
  let premiumExpiresAt = user.premiumExpiresAt;

  switch (event.type) {
    case "INITIAL_PURCHASE":
    case "RENEWAL":
    case "UNCANCELLATION":
    case "PRODUCT_CHANGE":
      isPremium = true;
      premiumExpiresAt = expiresAt;
      break;

    case "EXPIRATION":
    case "CANCELLATION": // CANCELLATION means user turned off auto-renew; they keep access until expiry.
      // For CANCELLATION we leave access enabled until expiresAt; for EXPIRATION we cut immediately.
      if (event.type === "EXPIRATION") {
        isPremium = false;
        premiumExpiresAt = expiresAt;
      } else {
        // Keep premium flag; expiry date updates so /me can compute the effective state.
        premiumExpiresAt = expiresAt;
      }
      break;

    case "BILLING_ISSUE":
    case "SUBSCRIPTION_PAUSED":
      // Grace period — trust RevenueCat's expiresAt. If expired, /me will treat as not premium.
      premiumExpiresAt = expiresAt;
      break;

    case "TRANSFER":
      // A subscription moved to a different app_user_id. Nothing to do here for the
      // old user; the new user will get their own INITIAL_PURCHASE or RENEWAL event.
      break;

    case "TEST":
      // RevenueCat "Send test event" button. Accept and move on.
      break;

    default:
      // Unknown event — log but accept so RC stops retrying.
      console.warn("Unhandled RC event type:", event.type);
  }

  await prisma.$transaction([
    prisma.user.update({
      where: { id: userId },
      data: { isPremium, premiumExpiresAt },
    }),
    prisma.subscriptionEvent.create({
      data: {
        userId,
        eventType: event.type,
        productId: event.product_id ?? null,
        payload: body as unknown as object,
      },
    }),
  ]);

  return NextResponse.json({ ok: true });
}
