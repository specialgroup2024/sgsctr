import { NextRequest, NextResponse } from "next/server";
import { SESSION_COOKIE, apiBaseUrl, cookieOptions, readSession, refreshSession, seal, type UserSession } from "@/lib/auth";

export const dynamic = "force-dynamic";

function sameOrigin(request: NextRequest) {
  const origin = request.headers.get("origin");
  return origin === (process.env.WEB_BASE_URL ?? "http://localhost:3000").replace(/\/$/, "");
}

type AuthResult = { error: NextResponse } | { session: UserSession; valid: UserSession };

async function authorizedSession(): Promise<AuthResult> {
  const session = await readSession();
  if (!session) return { error: NextResponse.json({ error: "Authentication required." }, { status: 401 }) };
  const valid = await refreshSession(session);
  if (!valid) {
    const response = NextResponse.json({ error: "Session expired." }, { status: 401 });
    response.cookies.delete(SESSION_COOKIE);
    return { error: response };
  }
  return { session, valid };
}

export async function GET() {
  const auth = await authorizedSession();
  if ("error" in auth) return auth.error;
  const upstream = await fetch(`${apiBaseUrl}/api/v1/pharmacy/regulatory-intelligence/overview`, {
    headers: { authorization: `Bearer ${auth.valid.accessToken}` }, cache: "no-store"
  });
  const payload = await upstream.json().catch(() => ({ error: "Regulatory intelligence service unavailable." }));
  const response = NextResponse.json(payload, { status: upstream.status });
  if (auth.valid.accessToken !== auth.session.accessToken)
    response.cookies.set(SESSION_COOKIE, await seal(auth.valid as unknown as Record<string, unknown>, 8 * 60 * 60), cookieOptions(8 * 60 * 60));
  return response;
}

export async function POST(request: NextRequest) {
  if (!sameOrigin(request)) return NextResponse.json({ error: "Cross-origin request rejected." }, { status: 403 });
  const auth = await authorizedSession();
  if ("error" in auth) return auth.error;
  const body = await request.json().catch(() => null) as { action?: string; alertId?: string } | null;
  if (!body || !["scan", "acknowledge"].includes(body.action ?? ""))
    return NextResponse.json({ error: "Unsupported action." }, { status: 400 });
  const endpoint = body.action === "scan" ? "/scan" :
    `/alerts/${/^[0-9a-f-]{36}$/i.test(body.alertId ?? "") ? body.alertId : "invalid"}/acknowledge`;
  if (body.action === "acknowledge" && endpoint.includes("/invalid/"))
    return NextResponse.json({ error: "A valid alert identifier is required." }, { status: 400 });
  const upstream = await fetch(`${apiBaseUrl}/api/v1/pharmacy/regulatory-intelligence${endpoint}`, {
    method: "POST", headers: { authorization: `Bearer ${auth.valid.accessToken}` }, cache: "no-store"
  });
  const payload = upstream.status === 204 ? null : await upstream.json().catch(() => null);
  const response = upstream.status === 204
    ? new NextResponse(null, { status: 204 })
    : NextResponse.json(payload, { status: upstream.status });
  if (auth.valid.accessToken !== auth.session.accessToken)
    response.cookies.set(SESSION_COOKIE, await seal(auth.valid as unknown as Record<string, unknown>, 8 * 60 * 60), cookieOptions(8 * 60 * 60));
  return response;
}
