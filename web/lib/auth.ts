import "server-only";
import { createHash } from "node:crypto";
import { cookies } from "next/headers";
import { EncryptJWT, jwtDecrypt, createRemoteJWKSet, jwtVerify } from "jose";

export const SESSION_COOKIE = "sgsctr_session";
export const LOGIN_COOKIE = "sgsctr_login";
export type UserSession = {
  accessToken: string;
  refreshToken: string;
  expiresAt: number;
  subject: string;
  displayName: string;
  email: string;
};

const clientId = process.env.KEYCLOAK_WEB_CLIENT_ID ?? "sgsctr-web";
const publicBase = (process.env.KEYCLOAK_PUBLIC_URL ?? "http://localhost:8180").replace(/\/$/, "");
const internalBase = (process.env.KEYCLOAK_INTERNAL_URL ?? "http://keycloak:8080").replace(/\/$/, "");
const realm = process.env.KEYCLOAK_REALM ?? "sgsctr";
export const publicRealmUrl = `${publicBase}/realms/${realm}`;
export const internalRealmUrl = `${internalBase}/realms/${realm}`;
export const webBaseUrl = (process.env.WEB_BASE_URL ?? "http://localhost:3000").replace(/\/$/, "");
export const apiBaseUrl = process.env.API_BASE_URL ?? "http://api:8080";

function encryptionKey(): Uint8Array {
  const secret = process.env.AUTH_SESSION_SECRET;
  if (!secret || secret.length < 32) {
    throw new Error("AUTH_SESSION_SECRET must contain at least 32 characters.");
  }
  return new Uint8Array(createHash("sha256").update(secret).digest());
}

export function cookieOptions(maxAge: number) {
  return {
    httpOnly: true,
    secure: process.env.COOKIE_SECURE === "true" || webBaseUrl.startsWith("https://"),
    sameSite: "lax" as const,
    path: "/",
    maxAge
  };
}

export async function seal(payload: Record<string, unknown>, lifetimeSeconds: number) {
  return new EncryptJWT(payload)
    .setProtectedHeader({ alg: "dir", enc: "A256GCM" })
    .setIssuedAt()
    .setExpirationTime(`${lifetimeSeconds}s`)
    .encrypt(encryptionKey());
}

export async function unseal<T>(token: string): Promise<T | null> {
  try {
    const { payload } = await jwtDecrypt(token, encryptionKey());
    return payload as T;
  } catch {
    return null;
  }
}

export async function readSession(): Promise<UserSession | null> {
  const jar = await cookies();
  const token = jar.get(SESSION_COOKIE)?.value;
  return token ? unseal<UserSession>(token) : null;
}

export async function getOidcConfiguration() {
  const response = await fetch(`${internalRealmUrl}/.well-known/openid-configuration`, {
    cache: "no-store",
    signal: AbortSignal.timeout(8000)
  });
  if (!response.ok) throw new Error(`Keycloak discovery failed with HTTP ${response.status}.`);
  return await response.json() as {
    issuer: string;
    authorization_endpoint: string;
    token_endpoint: string;
    end_session_endpoint?: string;
    jwks_uri: string;
  };
}

export async function refreshSession(session: UserSession): Promise<UserSession | null> {
  if (session.expiresAt > Math.floor(Date.now() / 1000) + 60) return session;
  try {
    const oidc = await getOidcConfiguration();
    const response = await fetch(oidc.token_endpoint, {
      method: "POST",
      headers: { "content-type": "application/x-www-form-urlencoded" },
      body: new URLSearchParams({
        grant_type: "refresh_token",
        client_id: clientId,
        refresh_token: session.refreshToken
      }),
      cache: "no-store"
    });
    if (!response.ok) return null;
    const tokens = await response.json() as { access_token: string; refresh_token?: string; id_token?: string; expires_in: number };
    const check = await fetch(`${apiBaseUrl}/api/v1/auth/me`, {
      headers: { authorization: `Bearer ${tokens.access_token}` },
      cache: "no-store"
    });
    if (!check.ok) return null;
    const identity = await check.json() as { subject: string; displayName?: string; email?: string };
    return {
      ...session,
      accessToken: tokens.access_token,
      refreshToken: tokens.refresh_token ?? session.refreshToken,
      expiresAt: Math.floor(Date.now() / 1000) + tokens.expires_in,
      subject: identity.subject,
      displayName: identity.displayName ?? session.displayName,
      email: identity.email ?? session.email
    };
  } catch {
    return null;
  }
}

export async function verifyIdToken(idToken: string, expectedNonce: string) {
  const oidc = await getOidcConfiguration();
  const jwks = createRemoteJWKSet(new URL(oidc.jwks_uri));
  const { payload } = await jwtVerify(idToken, jwks, {
    issuer: [oidc.issuer, publicRealmUrl],
    audience: clientId
  });
  if (payload.nonce !== expectedNonce || typeof payload.sub !== "string") {
    throw new Error("ID token nonce or subject validation failed.");
  }
  return payload;
}
