import { NextRequest, NextResponse } from "next/server";
import { SESSION_COOKIE } from "@/lib/auth";
export const dynamic = "force-dynamic";
export async function POST(request: NextRequest) { const base = (process.env.WEB_BASE_URL ?? "http://localhost:3000").replace(/\/$/, ""); if (request.headers.get("origin") !== base) return NextResponse.json({ error: "Cross-origin sign-out rejected." }, { status: 403 }); const response = NextResponse.redirect(new URL("/login?signed_out=1", base), 303); response.cookies.set(SESSION_COOKIE, "", { httpOnly: true, sameSite: "lax", path: "/", maxAge: 0 }); return response; }
