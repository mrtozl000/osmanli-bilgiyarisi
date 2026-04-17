import jwt from "jsonwebtoken";
import type { NextRequest } from "next/server";

const SESSION_SECRET = process.env.SESSION_SECRET;

if (!SESSION_SECRET) {
  // Don't throw at import time in dev — but fail loudly the first time we try to use it.
  console.warn("SESSION_SECRET env var is not set");
}

export interface SessionClaims {
  uid: string;
  iat?: number;
  exp?: number;
}

export function issueSession(userId: string, ttlDays = 90): string {
  if (!SESSION_SECRET) throw new Error("SESSION_SECRET env var is required");
  return jwt.sign({ uid: userId } satisfies Omit<SessionClaims, "iat" | "exp">, SESSION_SECRET, {
    expiresIn: `${ttlDays}d`,
  });
}

export function verifySession(token: string): SessionClaims {
  if (!SESSION_SECRET) throw new Error("SESSION_SECRET env var is required");
  return jwt.verify(token, SESSION_SECRET) as SessionClaims;
}

/**
 * Extract + verify the session from the `Authorization: Bearer <jwt>` header.
 * Returns null if header is missing or token is invalid / expired.
 */
export function getSessionFromRequest(req: NextRequest): SessionClaims | null {
  const header = req.headers.get("authorization") ?? req.headers.get("Authorization");
  if (!header || !header.startsWith("Bearer ")) return null;
  const token = header.substring("Bearer ".length).trim();
  try {
    return verifySession(token);
  } catch {
    return null;
  }
}
