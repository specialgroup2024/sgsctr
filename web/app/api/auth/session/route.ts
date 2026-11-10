import { NextResponse } from "next/server";
import { SESSION_COOKIE, cookieOptions, readSession, refreshSession, seal } from "@/lib/auth";

export const dynamic = "force-dynamic";

export async function GET() {
  const session = await readSession();
  if (!session) return NextResponse.json({ authenticated: false }, { status: 401 });
  const refreshed = await refreshSession(session);
  if (!refreshed) {
    const response = NextResponse.json({ authenticated: false }, { status: 401 });
    response.cookies.delete(SESSION_COOKIE);
    return response;
  }
  const response = NextResponse.json({
    authenticated: true,
    user: { subject: refreshed.subject, displayName: refreshed.displayName, email: refreshed.email }
  });
  if (refreshed.accessToken !== session.accessToken) {
    response.cookies.set(SESSION_COOKIE, await seal(refreshed as unknown as Record<string, unknown>, 8 * 60 * 60), cookieOptions(8 * 60 * 60));
  }
  return response;
}
