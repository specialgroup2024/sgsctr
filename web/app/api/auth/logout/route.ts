import { NextRequest, NextResponse } from "next/server";
import { SESSION_COOKIE, getOidcConfiguration, readSession, webBaseUrl } from "@/lib/auth";

export const dynamic = "force-dynamic";

export async function POST(request: NextRequest) {
  if (request.headers.get("origin") !== webBaseUrl) {
    return NextResponse.json({ error: "Cross-origin sign-out rejected." }, { status: 403 });
  }

  const session = await readSession();
  try {
    if (session?.refreshToken) {
      const oidc = await getOidcConfiguration();
      await fetch(oidc.end_session_endpoint ?? "", {
        method: "POST",
        headers: { "content-type": "application/x-www-form-urlencoded" },
        body: new URLSearchParams({
          client_id: process.env.KEYCLOAK_WEB_CLIENT_ID ?? "sgsctr-web",
          refresh_token: session.refreshToken
        }),
        cache: "no-store"
      });
    }
  } catch {
    // Always clear the local session even if the identity provider is unavailable.
  }

  const response = NextResponse.redirect(new URL("/login?signed_out=1", webBaseUrl), 303);
  response.cookies.set(SESSION_COOKIE, "", { httpOnly: true, sameSite: "lax", path: "/", maxAge: 0 });
  return response;
}
