import { NextRequest } from "next/server";
import { proxySupplier } from "@/lib/pharmacy-suppliers";

export const dynamic = "force-dynamic";

export async function GET(request: NextRequest) {
  return proxySupplier(request, "/review-requests", "GET");
}
