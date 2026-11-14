import { NextRequest } from "next/server";
import { proxyCatalogue } from "@/lib/pharmacy-catalogue";

export const dynamic = "force-dynamic";

export async function GET(request: NextRequest) {
  const query = request.nextUrl.searchParams.get("q");
  const path = query ? `/products?q=${encodeURIComponent(query)}` : "/products";
  return proxyCatalogue(request, path, "GET");
}

export async function POST(request: NextRequest) {
  return proxyCatalogue(request, "/products", "POST");
}
