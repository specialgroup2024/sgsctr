import { NextRequest } from "next/server";
import { proxySupplier } from "@/lib/pharmacy-suppliers";

export const dynamic = "force-dynamic";

export async function POST(request: NextRequest, context: { params: Promise<{ id: string }> }) {
  const { id } = await context.params;
  return proxySupplier(request, `/${encodeURIComponent(id)}/review-requests`, "POST");
}
