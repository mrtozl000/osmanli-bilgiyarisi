import { NextRequest, NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";
import { getSessionFromRequest } from "@/lib/session";

export const runtime = "nodejs";

export async function GET(req: NextRequest) {
  const session = getSessionFromRequest(req);
  if (!session) {
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  }

  const user = await prisma.user.findUnique({
    where: { id: session.uid },
    select: { id: true, email: true, name: true, isPremium: true, premiumExpiresAt: true },
  });

  if (!user) {
    return NextResponse.json({ error: "user_not_found" }, { status: 404 });
  }

  // If the cached premiumExpiresAt is in the past, treat as not premium regardless
  // of the boolean flag (defence-in-depth against stale webhook data).
  const stillPremium =
    user.isPremium &&
    (user.premiumExpiresAt === null || user.premiumExpiresAt > new Date());

  return NextResponse.json({
    userId: user.id,
    email: user.email,
    name: user.name,
    isPremium: stillPremium,
  });
}
