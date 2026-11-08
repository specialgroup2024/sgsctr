import { NextResponse } from "next/server";
export const dynamic = "force-dynamic";
export async function GET() {
  const baseUrl = process.env.API_BASE_URL ?? "http://localhost:8080";
  try {
    const [health, info] = await Promise.all([
      fetch(`${baseUrl}/health/ready`, { cache: "no-store", signal: AbortSignal.timeout(3500) }),
      fetch(`${baseUrl}/api/v1/system/info`, { cache: "no-store", signal: AbortSignal.timeout(3500) }),
    ]);
    return NextResponse.json({
      api: health.ok ? "online" : "unavailable",
      database: health.ok ? "connected" : "unavailable",
      info: info.ok ? await info.json() : null,
      checkedAt: new Date().toISOString(),
    });
  } catch {
    return NextResponse.json({ api: "unreachable", database: "unknown", info: null, checkedAt: new Date().toISOString() });
  }
}
