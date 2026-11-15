import { NextResponse } from "next/server";

export const dynamic = "force-dynamic";

type ApiResponse = Response | null;

async function requestApi(path: string): Promise<ApiResponse> {
  const baseUrl = process.env.API_BASE_URL ?? "http://localhost:8080";
  try {
    return await fetch(`${baseUrl}${path}`, { cache: "no-store", signal: AbortSignal.timeout(5000) });
  } catch {
    return null;
  }
}

async function readJson(response: ApiResponse): Promise<Record<string, unknown> | null> {
  if (!response) return null;
  try { return await response.json() as Record<string, unknown>; }
  catch { return null; }
}

export async function GET() {
  // A non-2xx response still proves that the API process answered.
  // PostgreSQL readiness is reported independently through the API.
  const [live, ready, info] = await Promise.all([
    requestApi("/health/live"),
    requestApi("/health/ready"),
    requestApi("/api/v1/system/info"),
  ]);
  const readyBody = await readJson(ready);
  const api = live?.ok ? "online" : live ? "degraded" : "unreachable";
  const database = ready?.ok ? "connected" : ready ? String(readyBody?.database ?? "unavailable") : "not_verified";
  return NextResponse.json({
    api, database,
    apiHttpStatus: live?.status ?? null,
    readinessHttpStatus: ready?.status ?? null,
    info: info?.ok ? await readJson(info) : null,
    checkedAt: new Date().toISOString(),
  });
}
