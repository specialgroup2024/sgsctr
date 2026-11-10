import { NextRequest, NextResponse } from "next/server";
import { apiBaseUrl, readSession, refreshSession } from "@/lib/auth";

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
  if (upstream.status === 204) return new NextResponse(null, { status: 204 });
  const payload = await upstream.json().catch(() => null);
  return NextResponse.json(payload, { status: upstream.status });
}

export async function PUT(request: NextRequest, context: { params: Promise<{ id: string }> }) {
  const { id } = await context.params;
  return proxy(request, id, "PUT");
}
export async function DELETE(request: NextRequest, context: { params: Promise<{ id: string }> }) {
  const { id } = await context.params;
  return proxy(request, id, "DELETE");
}
