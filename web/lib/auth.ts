import "server-only";
import { createHash } from "node:crypto";
import { cookies } from "next/headers";
import { EncryptJWT, jwtDecrypt } from "jose";
export const SESSION_COOKIE = "sgsctr_session";
export type UserSession = { accessToken: string; refreshToken: string; expiresAt: number; subject: string; displayName: string; email: string };
export const apiBaseUrl = process.env.API_BASE_URL ?? "http://api:8080";
const webBaseUrl = (process.env.WEB_BASE_URL ?? "http://localhost:3000").replace(/\/$/, "");
function encryptionKey(): Uint8Array { const secret = process.env.AUTH_SESSION_SECRET; if (!secret || secret.length < 32) throw new Error("AUTH_SESSION_SECRET must contain at least 32 characters."); return new Uint8Array(createHash("sha256").update(secret).digest()); }
export function cookieOptions(maxAge: number) { return { httpOnly: true, secure: process.env.COOKIE_SECURE === "true" || webBaseUrl.startsWith("https://"), sameSite: "lax" as const, path: "/", maxAge }; }
export async function seal(payload: Record<string, unknown>, lifetimeSeconds: number) { return new EncryptJWT(payload).setProtectedHeader({ alg: "dir", enc: "A256GCM" }).setIssuedAt().setExpirationTime(`${lifetimeSeconds}s`).encrypt(encryptionKey()); }
export async function unseal<T>(token: string): Promise<T | null> { try { const { payload } = await jwtDecrypt(token, encryptionKey()); return payload as T; } catch { return null; } }
export async function readSession(): Promise<UserSession | null> { const token = (await cookies()).get(SESSION_COOKIE)?.value; return token ? unseal<UserSession>(token) : null; }
export async function refreshSession(session: UserSession): Promise<UserSession | null> {
  if (session.expiresAt > Math.floor(Date.now() / 1000) + 60) return session;
  try { const response = await fetch(`${apiBaseUrl}/api/v1/auth/refresh`, { method: "POST", headers: { "content-type": "application/json" }, body: JSON.stringify({ refreshToken: session.refreshToken }), cache: "no-store" }); if (!response.ok) return null; const tokens = await response.json() as { accessToken: string; refreshToken: string; expiresIn: number }; if (!tokens.accessToken || !tokens.refreshToken || !Number.isFinite(tokens.expiresIn)) return null; return { ...session, accessToken: tokens.accessToken, refreshToken: tokens.refreshToken, expiresAt: Math.floor(Date.now() / 1000) + tokens.expiresIn }; } catch { return null; }
}
