import { NextRequest } from "next/server";
import { proxyReceiptDrafts } from "@/lib/pharmacy-inventory";

export const dynamic = "force-dynamic";

export async function GET(request: NextRequest) {
  return proxyReceiptDrafts(request, "GET");
}

export async function POST(request: NextRequest) {
  return proxyReceiptDrafts(request, "POST");
}
