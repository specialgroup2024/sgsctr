import { NextRequest, NextResponse } from "next/server";
import { LOGIN_COOKIE, SESSION_COOKIE, apiBaseUrl, cookieOptions, getOidcConfiguration, publicRealmUrl, seal, unseal, verifyIdToken, webBaseUrl, type UserSession } from "@/lib/auth";

export const dynamic = "force-dynamic";

type LoginState = { state: string; nonce: string; verifier: string; redirectUri: string };

export async function GET(request: NextRequest) {
  const params = request.nextUrl.searchParams;
  const error = params.get("error");
  if (error) return NextResponse.redirect(new URL(`/login?error=${encodeURIComponent(error)}`, webBaseUrl));

  const code = params.get("code");
  const returnedState = params.get("state");
  const sealedState = request.cookies.get(LOGIN_COOKIE)?.value;
  const loginState = sealedState ? await unseal<LoginState>(sealedState) : null;
  if (!code || !returnedState || !loginState || returnedState !== loginState.state) {
    return NextResponse.redirect(new URL("/login?error=invalid_state", webBaseUrl));
  }

  try {
    const oidc = await getOidcConfiguration();
    const tokenResponse = await fetch(oidc.token_endpoint, {
      method: "POST",
      headers: { "content-type": "application/x-www-form-urlencoded" },
      body: new URLSearchParams({
        grant_type: "authorization_code",
        client_id: process.env.KEYCLOAK_WEB_CLIENT_ID ?? "sgsctr-web",
        code,
        redirect_uri: loginState.redirectUri,
        code_verifier: loginState.verifier
      }),
      cache: "no-store"
    });
    if (!tokenResponse.ok) {
      const response = NextResponse.redirect(new URL("/login?error=token_exchange_failed", webBaseUrl));
      response.cookies.delete(LOGIN_COOKIE);
      return response;
    }

    const tokens = await tokenResponse.json() as {
      access_token: string; refresh_token: string; id_token: string; expires_in: number;
    };
    await verifyIdToken(tokens.id_token, loginState.nonce);

    const apiResponse = await fetch(`${apiBaseUrl}/api/v1/auth/me`, {
      headers: { authorization: `Bearer ${tokens.access_token}` },
      cache: "no-store"
    });
    if (!apiResponse.ok) {
      const response = NextResponse.redirect(new URL("/login?error=api_token_rejected", webBaseUrl));
      response.cookies.delete(LOGIN_COOKIE);
      return response;
    }
    const identity = await apiResponse.json() as { authenticated: boolean; subject: string; displayName?: string; email?: string };
    if (!identity.authenticated || !identity.subject) throw new Error("The API did not confirm the authenticated identity.");

    const session: UserSession = {
      accessToken: tokens.access_token,
      refreshToken: tokens.refresh_token,
      idToken: tokens.id_token,
      expiresAt: Math.floor(Date.now() / 1000) + tokens.expires_in,
      subject: identity.subject,
      displayName: identity.displayName ?? "Signed-in user",
      email: identity.email ?? ""
    };
    const response = NextResponse.redirect(new URL("/", webBaseUrl));
    response.cookies.set(SESSION_COOKIE, await seal(session as unknown as Record<string, unknown>, 8 * 60 * 60), cookieOptions(8 * 60 * 60));
    response.cookies.delete(LOGIN_COOKIE);
    return response;
  } catch {
    const response = NextResponse.redirect(new URL("/login?error=authentication_failed", webBaseUrl));
    response.cookies.delete(LOGIN_COOKIE);
    return response;
  }
}
