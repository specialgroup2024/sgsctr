import { NextRequest } from "next/server";
import { proxyReceiptDrafts } from "@/lib/pharmacy-inventory";

export const dynamic = "force-dynamic";

export async function GET(request: NextRequest, context: { params: Promise<{ id: string }> }) {
  const { id } = await context.params;
  return proxyReceiptDrafts(request, "GET", `/${encodeURIComponent(id)}/observations`);
}

export async function POST(request: NextRequest, context: { params: Promise<{ id: string }> }) {
  const { id } = await context.params;
  return proxyReceiptDrafts(request, "POST", `/${encodeURIComponent(id)}/observations`);
}
