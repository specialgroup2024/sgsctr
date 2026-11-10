import { NextResponse } from "next/server";
import { SESSION_COOKIE, cookieOptions, readSession, refreshSession, seal } from "@/lib/auth";
export const dynamic = "force-dynamic";
export async function GET() {
  const session = await readSession(); if (!session) return NextResponse.json({ authenticated: false }, { status: 401 });
  const valid = await refreshSession(session);
  if (!valid) { const response = NextResponse.json({ authenticated: false }, { status: 401 }); response.cookies.delete(SESSION_COOKIE); return response; }
  const response = NextResponse.json({ authenticated: true, user: { subject: valid.subject, displayName: valid.displayName, email: valid.email } });
  if (valid.accessToken !== session.accessToken) response.cookies.set(SESSION_COOKIE, await seal(valid, 8 * 60 * 60), cookieOptions(8 * 60 * 60));
  return response;
}
