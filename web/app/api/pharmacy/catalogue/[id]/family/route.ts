import { NextRequest } from "next/server";
import { proxyCatalogue } from "@/lib/pharmacy-catalogue";

export const dynamic = "force-dynamic";

export async function POST(request: NextRequest, context: { params: Promise<{ id: string }> }) {
  const { id } = await context.params;
  return proxyCatalogue(request, `/products/${encodeURIComponent(id)}/family`, "POST");
}
