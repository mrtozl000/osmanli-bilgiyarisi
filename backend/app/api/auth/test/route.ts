import { NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";
import { issueSession } from "@/lib/session";

// Only available when NODE_ENV is not "production"
export async function POST() {
  if (process.env.ENABLE_TEST_AUTH !== "true") {
    return NextResponse.json({ error: "Not found" }, { status: 404 });
  }

  const user = await prisma.user.upsert({
    where: { appleSub: "test_user_001" },
    update: {},
    create: {
      appleSub: "test_user_001",
      email: "test@osmanli.app",
      name: "Test Kullanıcı",
    },
  });

  const sessionToken = issueSession(user.id);
  return NextResponse.json({ sessionToken, userId: user.id });
}
