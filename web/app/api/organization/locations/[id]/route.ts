import { NextRequest, NextResponse } from "next/server";
import { SESSION_COOKIE, apiBaseUrl, cookieOptions, readSession, refreshSession, seal } from "@/lib/auth";

export const dynamic = "force-dynamic";

function sameOrigin(request: NextRequest) {
  return request.headers.get("origin") === (process.env.WEB_BASE_URL ?? "http://localhost:3000").replace(/\/$/, "");
}

async function proxy(request: NextRequest, id: string, method: "PUT" | "DELETE") {
  if (!sameOrigin(request)) return NextResponse.json({ error: "Cross-origin request rejected." }, { status: 403 });
  const session = await readSession();
  if (!session) return NextResponse.json({ error: "Authentication required." }, { status: 401 });
  const valid = await refreshSession(session);
  if (!valid) return NextResponse.json({ error: "Session expired." }, { status: 401 });
  const body = method === "PUT" ? await request.json().catch(() => null) : undefined;
  if (method === "PUT" && !body) return NextResponse.json({ error: "Invalid request body." }, { status: 400 });
  const upstream = await fetch(`${apiBaseUrl}/api/v1/organization/locations/${encodeURIComponent(id)}`, {
    method,
    headers: { authorization: `Bearer ${valid.accessToken}`, ...(body ? { "content-type": "application/json" } : {}) },
    ...(body ? { body: JSON.stringify(body) } : {}),
    cache: "no-store"
  });
  const response = upstream.status === 204
    ? new NextResponse(null, { status: 204 })
    : NextResponse.json(await upstream.json().catch(() => null), { status: upstream.status });
  if (valid.accessToken !== session.accessToken) response.cookies.set(SESSION_COOKIE, await seal(valid as unknown as Record<string, unknown>, 8 * 60 * 60), cookieOptions(8 * 60 * 60));
  return response;
}

export async function PUT(request: NextRequest, context: { params: Promise<{ id: string }> }) {
  const { id } = await context.params;
  return proxy(request, id, "PUT");
}
export async function DELETE(request: NextRequest, context: { params: Promise<{ id: string }> }) {
  const { id } = await context.params;
  return proxy(request, id, "DELETE");
}
