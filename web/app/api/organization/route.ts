import { NextRequest, NextResponse } from "next/server";
import { SESSION_COOKIE, apiBaseUrl, cookieOptions, readSession, refreshSession, seal } from "@/lib/auth";

export const dynamic = "force-dynamic";

function sameOrigin(request: NextRequest) {
  const origin = request.headers.get("origin");
  return origin === (process.env.WEB_BASE_URL ?? "http://localhost:3000").replace(/\/$/, "");
}

export async function GET() {
  const session = await readSession();
  if (!session) return NextResponse.json({ error: "Authentication required." }, { status: 401 });
  const valid = await refreshSession(session);
  if (!valid) {
    const response = NextResponse.json({ error: "Session expired." }, { status: 401 });
    response.cookies.delete(SESSION_COOKIE);
    return response;
  }
  const [dataResponse, accessResponse] = await Promise.all([
    fetch(`${apiBaseUrl}/api/v1/organization`, { headers: { authorization: `Bearer ${valid.accessToken}` }, cache: "no-store" }),
    fetch(`${apiBaseUrl}/api/v1/organization/access`, { headers: { authorization: `Bearer ${valid.accessToken}` }, cache: "no-store" })
  ]);
  if (!dataResponse.ok) return NextResponse.json({ error: "Organization data could not be loaded." }, { status: dataResponse.status });
  const data = await dataResponse.json();
  const access = accessResponse.ok ? await accessResponse.json() : { canManage: false };
  const response = NextResponse.json({ ...data, canManage: access.canManage === true });
  if (valid.accessToken !== session.accessToken) response.cookies.set(SESSION_COOKIE, await seal(valid as unknown as Record<string, unknown>, 8 * 60 * 60), cookieOptions(8 * 60 * 60));
  return response;
}

export async function POST(request: NextRequest) {
  if (!sameOrigin(request)) return NextResponse.json({ error: "Cross-origin request rejected." }, { status: 403 });
  const session = await readSession();
  if (!session) return NextResponse.json({ error: "Authentication required." }, { status: 401 });
  const valid = await refreshSession(session);
  if (!valid) return NextResponse.json({ error: "Session expired." }, { status: 401 });
  const body = await request.json().catch(() => null);
  if (!body) return NextResponse.json({ error: "Invalid request body." }, { status: 400 });
  const upstream = await fetch(`${apiBaseUrl}/api/v1/organization/locations`, {
    method: "POST",
    headers: { authorization: `Bearer ${valid.accessToken}`, "content-type": "application/json" },
    body: JSON.stringify(body),
    cache: "no-store"
  });
  const payload = upstream.status === 204 ? null : await upstream.json().catch(() => null);
  const response = NextResponse.json(payload, { status: upstream.status });
  if (valid.accessToken !== session.accessToken) response.cookies.set(SESSION_COOKIE, await seal(valid as unknown as Record<string, unknown>, 8 * 60 * 60), cookieOptions(8 * 60 * 60));
  return response;
}
