#!/usr/bin/env bash
set -euo pipefail
BASE_URL="${1:-http://localhost:8080}"
WEB_URL="${2:-http://localhost:3000}"
ATTEMPTS=30

echo "Waiting for API and PostgreSQL readiness at ${BASE_URL} ..."
for ((i=1; i<=ATTEMPTS; i++)); do
  if curl --connect-timeout 3 --max-time 3 --silent --fail "${BASE_URL}/health/ready" >/dev/null; then break; fi
  if [[ "$i" -eq "$ATTEMPTS" ]]; then echo "ERROR: API did not become ready. Check: docker compose logs api db" >&2; exit 1; fi
  sleep 2
done

echo "Checking API liveness, readiness and public system information..."
curl --connect-timeout 3 --max-time 3 --silent --show-error --fail "${BASE_URL}/health/live"
echo

READINESS="$(curl --connect-timeout 3 --max-time 3 --silent --show-error --fail "${BASE_URL}/health/ready")"
printf '%s\n' "$READINESS"
if ! printf '%s' "$READINESS" | jq -e '.status == "ok" and .database == "connected" and .applicationContext == "connected" and .identityContext == "connected"' >/dev/null; then
  echo "ERROR: API readiness did not confirm both application and Identity contexts connected to PostgreSQL." >&2

  exit 1
fi
echo
curl --connect-timeout 3 --max-time 3 --silent --show-error --fail "${BASE_URL}/api/v1/system/info"
echo


echo "Waiting for Next.js web UI at ${WEB_URL} ..."
for ((i=1; i<=ATTEMPTS; i++)); do
  if curl --connect-timeout 3 --max-time 3 --silent --location --fail "${WEB_URL}/login" | grep -q "Sign in to SGSCTR"; then break; fi
  if [[ "$i" -eq "$ATTEMPTS" ]]; then echo "ERROR: Web UI did not become ready. Check: docker compose logs web" >&2; exit 1; fi
  sleep 2
done

echo "Checking dashboard reports live API and PostgreSQL connectivity..."
SYSTEM_STATUS="$(curl --connect-timeout 3 --max-time 10 --silent --show-error --fail "${WEB_URL}/api/system-status")"
printf '%s\n' "$SYSTEM_STATUS"
if ! printf '%s' "$SYSTEM_STATUS" | jq -e '.api == "online" and .database == "connected"' >/dev/null; then
  echo "ERROR: Dashboard did not confirm both API and PostgreSQL as online/connected." >&2
  exit 1
fi


echo "Checking protected API rejects anonymous requests..."
REGULATORY_STATUS="$(curl --connect-timeout 3 --max-time 3 --silent --output /dev/null --write-out '%{http_code}' "${BASE_URL}/api/v1/pharmacy/regulatory-intelligence/overview")"
if [[ "$REGULATORY_STATUS" != "401" ]]; then echo "ERROR: Regulatory intelligence overview must reject anonymous access (HTTP ${REGULATORY_STATUS})." >&2; exit 1; fi
AUTH_STATUS="$(curl --connect-timeout 3 --max-time 3 --silent --output /dev/null --write-out '%{http_code}' "${BASE_URL}/api/v1/auth/me")"
if [[ "$AUTH_STATUS" != "401" ]]; then echo "ERROR: Expected 401 for anonymous request, got ${AUTH_STATUS}." >&2; exit 1; fi

echo "Checking public account registration is disabled..."
REGISTER_STATUS="$(curl --connect-timeout 3 --max-time 3 --silent --output /dev/null --write-out '%{http_code}' -H 'Content-Type: application/json' -d '{"email":"public@example.test","password":"NotAllowed-123!"}' "${BASE_URL}/api/v1/auth/register")"
if [[ "$REGISTER_STATUS" != "404" ]]; then echo "ERROR: Expected 404 for public registration, got ${REGISTER_STATUS}." >&2; exit 1; fi

if [[ -n "${BOOTSTRAP_ADMIN_EMAIL:-}" && -n "${BOOTSTRAP_ADMIN_PASSWORD:-}" && "${SKIP_AUTHENTICATION_SMOKE_TESTS:-false}" != "true" ]]; then
  echo "Checking native administrator sign-in and protected account provisioning..."
  ADMIN_PAYLOAD="$(jq -n --arg email "$BOOTSTRAP_ADMIN_EMAIL" --arg password "$BOOTSTRAP_ADMIN_PASSWORD" '{email:$email,password:$password}')"
  ADMIN_RESPONSE_FILE="$(mktemp)"
  ADMIN_HTTP_STATUS="$(curl --connect-timeout 3 --max-time 10 --silent --show-error --output "$ADMIN_RESPONSE_FILE" --write-out '%{http_code}' -H 'Content-Type: application/json' -d "$ADMIN_PAYLOAD" "${BASE_URL}/api/v1/auth/login?useCookies=false")"
  ADMIN_RESPONSE="$(cat "$ADMIN_RESPONSE_FILE")"
  rm -f "$ADMIN_RESPONSE_FILE"
  ADMIN_TOKEN="$(printf '%s' "$ADMIN_RESPONSE" | jq -r '.accessToken // empty')"
  if [[ -z "$ADMIN_TOKEN" ]]; then echo "ERROR: Native administrator login failed (HTTP ${ADMIN_HTTP_STATUS}). API response: ${ADMIN_RESPONSE}" >&2; exit 1; fi
  echo "Checking the persisted pharmacy approval register through the authenticated API..."
  APPROVALS_API_RESPONSE="$(curl --connect-timeout 3 --max-time 10 --silent --show-error --fail -H "Authorization: Bearer $ADMIN_TOKEN" "$BASE_URL/api/v1/pharmacy/catalogue/approvals")"
  printf '%s\n' "$APPROVALS_API_RESPONSE"
  if ! printf '%s' "$APPROVALS_API_RESPONSE" | jq -e 'length == 8 and ([.[] | select(.status == "Pending")] | length) == 7 and ([.[] | select(.approvalCode == "INV-OWN-001" and .status == "Approved")] | length) == 1 and ([.[] | select(.approvalCode == "INV-PRO-001" and .status == "Pending")] | length) == 1 and ([.[] | select((.approvalCode == "INV-REG-001" or .approvalCode == "INV-QLT-001" or .approvalCode == "INV-ACC-001" or .approvalCode == "INV-OWN-002" or .approvalCode == "INV-SEC-001" or .approvalCode == "INV-REL-001") and .status == "Pending")] | length) == 6' >/dev/null; then
    echo "ERROR: PostgreSQL approval register did not return the expected eight records and pending/approved statuses." >&2
    exit 1
  fi
  ME_STATUS="$(curl --connect-timeout 3 --max-time 5 --silent --output /dev/null --write-out '%{http_code}' -H "Authorization: Bearer ${ADMIN_TOKEN}" "${BASE_URL}/api/v1/auth/me")"
  if [[ "$ME_STATUS" != "200" ]]; then echo "ERROR: Native access token was not accepted by /me (HTTP ${ME_STATUS})." >&2; exit 1; fi

  TEMP_EMAIL="smoke-$(date +%s)-$@example.test"
  TEMP_PASSWORD="Smoke-Test-Only-123!"
  CREATE_PAYLOAD="$(jq -n --arg email "$TEMP_EMAIL" --arg password "$TEMP_PASSWORD" '{email:$email,password:$password}')"
  CREATE_STATUS="$(curl --connect-timeout 3 --max-time 10 --silent --output /dev/null --write-out '%{http_code}' -H "Authorization: Bearer ${ADMIN_TOKEN}" -H 'Content-Type: application/json' -d "$CREATE_PAYLOAD" "${BASE_URL}/api/v1/admin/users")"
  if [[ "$CREATE_STATUS" != "201" ]]; then echo "ERROR: Administrator could not provision a standard account (HTTP ${CREATE_STATUS})." >&2; exit 1; fi

  USER_PAYLOAD="$(jq -n --arg email "$TEMP_EMAIL" --arg password "$TEMP_PASSWORD" '{email:$email,password:$password}')"
  USER_RESPONSE="$(curl --connect-timeout 3 --max-time 10 --silent --show-error -H 'Content-Type: application/json' -d "$USER_PAYLOAD" "${BASE_URL}/api/v1/auth/login?useCookies=false")"
  USER_TOKEN="$(printf '%s' "$USER_RESPONSE" | jq -r '.accessToken // empty')"
  if [[ -z "$USER_TOKEN" ]]; then echo "ERROR: Newly provisioned standard user could not sign in." >&2; exit 1; fi
  FORBIDDEN_STATUS="$(curl --connect-timeout 3 --max-time 5 --silent --output /dev/null --write-out '%{http_code}' -H "Authorization: Bearer ${USER_TOKEN}" -H 'Content-Type: application/json' -d "$CREATE_PAYLOAD" "${BASE_URL}/api/v1/admin/users")"
  if [[ "$FORBIDDEN_STATUS" != "403" ]]; then echo "ERROR: Standard user should receive 403 for account provisioning, got ${FORBIDDEN_STATUS}." >&2; exit 1; fi

  echo "Checking BFF sign-in, session and sign-out..."
  COOKIE_JAR="$(mktemp)"
  ORIGIN="${WEB_BASE_URL:-http://localhost:3000}"
  BFF_STATUS="$(curl --connect-timeout 3 --max-time 10 --silent --output /dev/null --write-out '%{http_code}' -c "$COOKIE_JAR" -H "Origin: ${ORIGIN}" --data-urlencode "email=${BOOTSTRAP_ADMIN_EMAIL}" --data-urlencode "password=${BOOTSTRAP_ADMIN_PASSWORD}" "${WEB_URL}/api/auth/login")"
  if [[ "$BFF_STATUS" != "303" ]]; then echo "ERROR: BFF login should redirect after successful sign-in, got ${BFF_STATUS}." >&2; rm -f "$COOKIE_JAR"; exit 1; fi
  BFF_SESSION_STATUS="$(curl --connect-timeout 3 --max-time 5 --silent --output /dev/null --write-out '%{http_code}' -b "$COOKIE_JAR" "${WEB_URL}/api/auth/session")"
  if [[ "$BFF_SESSION_STATUS" != "200" ]]; then echo "ERROR: BFF session was not established (HTTP ${BFF_SESSION_STATUS})." >&2; rm -f "$COOKIE_JAR"; exit 1; fi
  echo "Checking approval register BFF data and authenticated Pharmacy Inventory UI..."
  APPROVALS_UI_RESPONSE="$(curl --connect-timeout 3 --max-time 10 --silent --show-error --fail -b "$COOKIE_JAR" "$WEB_URL/api/pharmacy/approvals")"
  if ! printf '%s' "$APPROVALS_UI_RESPONSE" | jq -e 'length == 8 and ([.[] | select(.status == "Pending")] | length) == 7 and ([.[] | select(.approvalCode == "INV-OWN-001" and .status == "Approved")] | length) == 1 and ([.[] | select(.approvalCode == "INV-PRO-001" and .status == "Pending")] | length) == 1' >/dev/null; then
    echo "ERROR: Pharmacy UI BFF did not return the expected persisted approval register." >&2
    rm -f "$COOKIE_JAR"
    exit 1
  fi
  INVENTORY_PAGE="$(curl --connect-timeout 3 --max-time 10 --silent --show-error --fail -b "$COOKIE_JAR" "$WEB_URL/pharmacies/inventory")"
  if ! printf '%s' "$INVENTORY_PAGE" | grep -q "Approvals"; then
    echo "ERROR: Authenticated Pharmacy Inventory page did not render the Approvals tab." >&2
    rm -f "$COOKIE_JAR"
    exit 1
  fi
  if ! printf '%s' "$INVENTORY_PAGE" | grep -q "Illustrative pharmacist review examples — demo only"; then
    echo "ERROR: Separate pharmacist demo examples were not rendered in the Approvals UI." >&2
    rm -f "$COOKIE_JAR"
    exit 1
  fi
  if ! printf '%s' "$INVENTORY_PAGE" | grep -q "These owner-supplied examples are kept separate from the real approval register"; then
    echo "ERROR: Pharmacist demo examples are missing their separation warning." >&2
    rm -f "$COOKIE_JAR"
    exit 1
  fi
  LOGOUT_STATUS="$(curl --connect-timeout 3 --max-time 10 --silent --output /dev/null --write-out '%{http_code}' -b "$COOKIE_JAR" -c "$COOKIE_JAR" -X POST -H "Origin: ${ORIGIN}" "${WEB_URL}/api/auth/logout")"
  if [[ "$LOGOUT_STATUS" != "303" ]]; then echo "ERROR: BFF sign-out did not complete (HTTP ${LOGOUT_STATUS})." >&2; rm -f "$COOKIE_JAR"; exit 1; fi
  AFTER_LOGOUT_STATUS="$(curl --connect-timeout 3 --max-time 5 --silent --output /dev/null --write-out '%{http_code}' -b "$COOKIE_JAR" "${WEB_URL}/api/auth/session")"
  rm -f "$COOKIE_JAR"
  if [[ "$AFTER_LOGOUT_STATUS" != "401" ]]; then echo "ERROR: BFF session remained active after sign-out (HTTP ${AFTER_LOGOUT_STATUS})." >&2; exit 1; fi
fi

echo "Checking protected organization and sector pages redirect to login..."
for ROUTE in organization pharmacies pharmacies/regulatory-intelligence contracting; do
  ROUTE_STATUS="$(curl --connect-timeout 3 --max-time 3 --silent --output /dev/null --write-out '%{http_code}' "${WEB_URL}/${ROUTE}")"
  if [[ "$ROUTE_STATUS" != "307" && "$ROUTE_STATUS" != "302" ]]; then echo "ERROR: Expected /${ROUTE} to redirect to login, got ${ROUTE_STATUS}." >&2; exit 1; fi
done

echo "Checking anonymous BFF session and organization endpoints reject access..."
for ROUTE in /api/auth/session /api/organization /api/pharmacy-intelligence /api/pharmacy/approvals; do
  STATUS="$(curl --connect-timeout 3 --max-time 3 --silent --output /dev/null --write-out '%{http_code}' "${WEB_URL}${ROUTE}")"
  if [[ "$STATUS" != "401" ]]; then echo "ERROR: Expected 401 for ${ROUTE}, got ${STATUS}." >&2; exit 1; fi
done

echo "Native authentication boundary smoke tests passed."
