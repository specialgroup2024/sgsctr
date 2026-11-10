import { NextRequest, NextResponse } from "next/server";
import { SESSION_COOKIE, getOidcConfiguration, webBaseUrl } from "@/lib/auth";

export const dynamic = "force-dynamic";

export async function GET(_request: NextRequest) {
  let destination = new URL("/login?signed_out=1", webBaseUrl);
  try {
    const oidc = await getOidcConfiguration();
    if (oidc.end_session_endpoint) {
      destination = new URL(oidc.end_session_endpoint);
      destination.searchParams.set("post_logout_redirect_uri", `${webBaseUrl}/login?signed_out=1`);
      destination.searchParams.set("client_id", process.env.KEYCLOAK_WEB_CLIENT_ID ?? "sgsctr-web");
    }
  } catch {
    // Local sign-out still clears the BFF session if the identity provider is unavailable.
  }
  const response = NextResponse.redirect(destination);
  response.cookies.set(SESSION_COOKIE, "", { httpOnly: true, sameSite: "lax", path: "/", maxAge: 0 });
  return response;
}
