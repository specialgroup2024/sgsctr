import { NextRequest } from "next/server";
import { proxyStockTransfers } from "@/lib/pharmacy-stock-transfers";

export const dynamic = "force-dynamic";

export async function POST(request: NextRequest) {
  return proxyStockTransfers(request, "POST");
}
