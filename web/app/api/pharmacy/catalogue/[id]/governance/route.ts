import { NextRequest } from "next/server";
import { proxyCatalogue } from "@/lib/pharmacy-catalogue";

export const dynamic = "force-dynamic";

export async function GET(request: NextRequest, context: { params: Promise<{ id: string }> }) {
  const { id } = await context.params;
  return proxyCatalogue(request, `/products/${encodeURIComponent(id)}/governance`, "GET");
}
