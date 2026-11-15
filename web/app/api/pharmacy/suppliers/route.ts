import { NextRequest } from "next/server";
import { proxySupplier } from "@/lib/pharmacy-suppliers";

export const dynamic = "force-dynamic";

export async function GET(request: NextRequest) {
  const path = request.nextUrl.searchParams.get("resource") === "permissions" ? "/permissions" : "";
  return proxySupplier(request, path, "GET");
}

export async function POST(request: NextRequest) {
  return proxySupplier(request, "", "POST");
}
