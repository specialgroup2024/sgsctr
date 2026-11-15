import { NextRequest, NextResponse } from "next/server";
import { SESSION_COOKIE, apiBaseUrl, cookieOptions, readSession, refreshSession, seal } from "@/lib/auth";

function sameOrigin(request: NextRequest) {
  const origin = request.headers.get("origin");
  return origin === (process.env.WEB_BASE_URL ?? "http://localhost:3000").replace(/\/$/, "");
}

export async function proxyReceiptDrafts(request: NextRequest, method: "GET" | "POST") {
  if (method === "POST" && !sameOrigin(request))
    return NextResponse.json({ error: "Cross-origin request rejected." }, { status: 403 });
  const session = await readSession();
  if (!session) return NextResponse.json({ error: "Authentication required." }, { status: 401 });
  const valid = await refreshSession(session);
  if (!valid) {
    const response = NextResponse.json({ error: "Session expired." }, { status: 401 });
    response.cookies.delete(SESSION_COOKIE);
    return response;
  }
  let body: unknown;
  if (method === "POST") {
    body = await request.json().catch(() => null);
    if (!body) return NextResponse.json({ error: "Invalid request body." }, { status: 400 });
  }
  let upstream: Response;
  try {
    upstream = await fetch(`${apiBaseUrl}/api/v1/pharmacy/inventory/receipt-drafts/`, {
      method,
      headers: {
        authorization: `Bearer ${valid.accessToken}`,
        ...(method === "POST" ? { "content-type": "application/json" } : {})
      },
      ...(method === "POST" ? { body: JSON.stringify(body) } : {}),
      cache: "no-store",
      signal: AbortSignal.timeout(8000)
    });
  } catch {
    return NextResponse.json({ error: "The inventory API is unavailable." }, { status: 503 });
  }
  const payload = upstream.status === 204 ? null : await upstream.json().catch(() => null);
  const response = payload === null ? new NextResponse(null, { status: upstream.status }) :
    NextResponse.json(payload, { status: upstream.status });
  if (valid.accessToken !== session.accessToken)
    response.cookies.set(SESSION_COOKIE, await seal(valid as unknown as Record<string, unknown>, 8 * 60 * 60), cookieOptions(8 * 60 * 60));
  return response;
}
