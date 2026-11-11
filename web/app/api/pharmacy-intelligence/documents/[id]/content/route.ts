import { NextRequest, NextResponse } from "next/server";
import { SESSION_COOKIE, apiBaseUrl, cookieOptions, readSession, refreshSession, seal } from "@/lib/auth";

export const dynamic = "force-dynamic";

export async function GET(_request: NextRequest, context: { params: Promise<{ id: string }> }) {
  const session = await readSession();
  if (!session) return NextResponse.json({ error: "Authentication required." }, { status: 401 });
  const valid = await refreshSession(session);
  if (!valid) { const response = NextResponse.json({ error: "Session expired." }, { status: 401 }); response.cookies.delete(SESSION_COOKIE); return response; }
  const { id } = await context.params;
  if (!/^[0-9a-f-]{36}$/i.test(id)) return NextResponse.json({ error: "Invalid document identifier." }, { status: 400 });
  const upstream = await fetch(`${apiBaseUrl}/api/v1/pharmacy/regulatory-intelligence/documents/${id}/content`, {
    headers: { authorization: `Bearer ${valid.accessToken}` }, cache: "no-store"
  });
  if (!upstream.ok) return NextResponse.json({ error: "Stored document could not be retrieved." }, { status: upstream.status });
  const bytes = await upstream.arrayBuffer();
  const type = upstream.headers.get("content-type") ?? "application/octet-stream";
  const extension = type.includes("pdf") ? "pdf" : "html";
  const response = new NextResponse(bytes, {
    headers: {
      "content-type": type,
      "content-disposition": `attachment; filename="eda-document-${id}.${extension}"`,
      "cache-control": "private, no-store"
    }
  });
  if (valid.accessToken !== session.accessToken) response.cookies.set(SESSION_COOKIE, await seal(valid as unknown as Record<string, unknown>, 8 * 60 * 60), cookieOptions(8 * 60 * 60));
  return response;
}
