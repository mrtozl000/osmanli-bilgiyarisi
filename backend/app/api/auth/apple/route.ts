import { NextRequest, NextResponse } from "next/server";
import { createRemoteJWKSet, jwtVerify } from "jose";
import crypto from "crypto";
import { prisma } from "@/lib/prisma";
import { issueSession } from "@/lib/session";

// Apple publishes rotating JWKS at this well-known URL. `createRemoteJWKSet`
// caches keys and handles rotation transparently.
const APPLE_JWKS = createRemoteJWKSet(new URL("https://appleid.apple.com/auth/keys"));

export const runtime = "nodejs"; // we need Node crypto for SHA-256 + jsonwebtoken

interface SignInBody {
  idToken: string;
  nonce: string;            // raw nonce — the JWT's `nonce` claim is SHA256(this)
  fullName?: string | null; // only provided on first sign-in by Apple
  email?: string | null;    // only provided on first sign-in (or if user hides email, a private relay)
}

export async function POST(req: NextRequest) {
  let body: SignInBody;
  try {
    body = (await req.json()) as SignInBody;
  } catch {
    return NextResponse.json({ error: "invalid_json" }, { status: 400 });
  }

  const { idToken, nonce, fullName, email } = body;
  if (!idToken || !nonce) {
    return NextResponse.json({ error: "missing_fields" }, { status: 400 });
  }

  const bundleId = process.env.APPLE_BUNDLE_ID;
  if (!bundleId) {
    console.error("APPLE_BUNDLE_ID not configured");
    return NextResponse.json({ error: "server_misconfigured" }, { status: 500 });
  }

  // 1. Verify the JWT signature + issuer + audience + expiry.
  let payload: Record<string, unknown>;
  try {
    const result = await jwtVerify(idToken, APPLE_JWKS, {
      issuer: "https://appleid.apple.com",
      audience: bundleId,
    });
    payload = result.payload as Record<string, unknown>;
  } catch (err) {
    console.warn("Apple JWT verification failed:", err);
    return NextResponse.json({ error: "invalid_token" }, { status: 401 });
  }

  // 2. Verify nonce. Apple stores SHA256(rawNonce) in the `nonce` claim;
  //    we recompute it and compare.
  const expectedNonce = crypto.createHash("sha256").update(nonce).digest("hex");
  if (payload.nonce !== expectedNonce) {
    return NextResponse.json({ error: "nonce_mismatch" }, { status: 401 });
  }

  const appleSub = payload.sub as string | undefined;
  if (!appleSub) {
    return NextResponse.json({ error: "missing_sub" }, { status: 401 });
  }

  const appleEmail = (payload.email as string | undefined) ?? email ?? null;

  // 3. Upsert the user. On repeat logins Apple won't send name/email, so we
  //    keep whatever we stored the first time via `update: {}`.
  const user = await prisma.user.upsert({
    where: { appleSub },
    update: {},
    create: {
      appleSub,
      email: appleEmail,
      name: fullName ?? null,
    },
  });

  // 4. Issue our own session JWT. The iOS app sends this back via
  //    `Authorization: Bearer ...` on every subsequent request.
  const sessionToken = issueSession(user.id);

  return NextResponse.json({
    sessionToken,
    userId: user.id,
  });
}
