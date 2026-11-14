import { NextRequest } from "next/server";
import { proxyCatalogue } from "@/lib/pharmacy-catalogue";

export const dynamic = "force-dynamic";

export async function PUT(request: NextRequest, context: { params: Promise<{ id: string }> }) {
  const { id } = await context.params;
  return proxyCatalogue(request, `/products/${encodeURIComponent(id)}`, "PUT");
}
