import { NextRequest } from "next/server";
import { proxyCatalogue } from "@/lib/pharmacy-catalogue";

export const dynamic = "force-dynamic";

export async function GET(request: NextRequest) {
  return proxyCatalogue(request, "/test-readiness", "GET");
}

export async function POST(request: NextRequest) {
  return proxyCatalogue(request, "/test-readiness/executions", "POST");
}
