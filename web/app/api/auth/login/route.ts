import { NextResponse } from "next/server";
import { createHash, randomBytes } from "node:crypto";
import { LOGIN_COOKIE, cookieOptions, publicRealmUrl, seal, webBaseUrl } from "@/lib/auth";

export const dynamic = "force-dynamic";

export async function GET() {
  const clientId = process.env.KEYCLOAK_WEB_CLIENT_ID ?? "sgsctr-web";
  const state = randomBytes(32).toString("base64url");
  const nonce = randomBytes(32).toString("base64url");
  const verifier = randomBytes(48).toString("base64url");
  const challenge = createHash("sha256").update(verifier).digest("base64url");
  const redirectUri = `${webBaseUrl}/api/auth/callback`;
  const authorizationUrl = new URL(`${publicRealmUrl}/protocol/openid-connect/auth`);
  authorizationUrl.search = new URLSearchParams({
    client_id: clientId,
    response_type: "code",
    scope: "openid profile email",
    redirect_uri: redirectUri,
    state,
    nonce,
    code_challenge: challenge,
    code_challenge_method: "S256"
  }).toString();

  const response = NextResponse.redirect(authorizationUrl);
  response.cookies.set(LOGIN_COOKIE, await seal({ state, nonce, verifier, redirectUri }, 600), cookieOptions(600));
  return response;
}
