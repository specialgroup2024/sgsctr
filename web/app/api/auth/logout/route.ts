import { NextRequest, NextResponse } from "next/server";
import { SESSION_COOKIE, getOidcConfiguration, readSession, webBaseUrl } from "@/lib/auth";

export const dynamic = "force-dynamic";

export async function GET(request: NextRequest) {
  const session = await readSession();
  const response = NextResponse.redirect(new URL("/login?signed_out=1", webBaseUrl));
  response.cookies.set(SESSION_COOKIE, "", { httpOnly: true, sameSite: "lax", path: "/", maxAge: 0 });
  try {
    const oidc = await getOidcConfiguration();
    if (oidc.end_session_endpoint && session?.idToken) {
      const logoutUrl = new URL(oidc.end_session_endpoint);
      logoutUrl.searchParams.set("id_token_hint", session.idToken);
      logoutUrl.searchParams.set("post_logout_redirect_uri", `${webBaseUrl}/login?signed_out=1`);
      logoutUrl.searchParams.set("client_id", process.env.KEYCLOAK_WEB_CLIENT_ID ?? "sgsctr-web");
      return NextResponse.redirect(logoutUrl);
    }
  } catch {
    // Local sign-out still clears the BFF session if the identity provider is unavailable.
  }
  return response;
}
