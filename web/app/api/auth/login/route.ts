import { NextRequest, NextResponse } from "next/server";
import { SESSION_COOKIE, apiBaseUrl, cookieOptions, seal } from "@/lib/auth";
export const dynamic = "force-dynamic";
export async function POST(request: NextRequest) {
  const base = (process.env.WEB_BASE_URL ?? "http://localhost:3000").replace(/\/$/, "");
  if (request.headers.get("origin") !== base) return NextResponse.json({ error: "Cross-origin sign-in rejected." }, { status: 403 });
  const form = await request.formData(); const email = String(form.get("email") ?? "").trim(); const password = String(form.get("password") ?? "");
  if (!email || !password) return NextResponse.redirect(new URL("/login?error=missing_credentials", base), 303);
  try {
    const login = await fetch(`${apiBaseUrl}/api/v1/auth/login?useCookies=false`, { method: "POST", headers: { "content-type": "application/json" }, body: JSON.stringify({ email, password }), cache: "no-store" });
    if (!login.ok) return NextResponse.redirect(new URL("/login?error=invalid_credentials", base), 303);
    const tokens = await login.json() as { accessToken: string; expiresIn: number; refreshToken: string };
    if (!tokens.accessToken || !tokens.refreshToken || !Number.isFinite(tokens.expiresIn)) return NextResponse.redirect(new URL("/login?error=authentication_failed", base), 303);
    const me = await fetch(`${apiBaseUrl}/api/v1/auth/me`, { headers: { authorization: `Bearer ${tokens.accessToken}` }, cache: "no-store" });
    if (!me.ok) return NextResponse.redirect(new URL("/login?error=authentication_failed", base), 303);
    const identity = await me.json() as { subject: string; displayName?: string; email?: string };
    const session = { accessToken: tokens.accessToken, refreshToken: tokens.refreshToken, expiresAt: Math.floor(Date.now() / 1000) + tokens.expiresIn, subject: identity.subject, displayName: identity.displayName ?? email, email: identity.email ?? email };
    const response = NextResponse.redirect(new URL("/", base), 303); response.cookies.set(SESSION_COOKIE, await seal(session, 8 * 60 * 60), cookieOptions(8 * 60 * 60)); return response;
  } catch { return NextResponse.redirect(new URL("/login?error=authentication_failed", base), 303); }
}
