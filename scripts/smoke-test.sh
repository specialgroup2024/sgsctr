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
curl --connect-timeout 3 --max-time 3 --silent --show-error --fail "${BASE_URL}/health/ready"
echo
curl --connect-timeout 3 --max-time 3 --silent --show-error --fail "${BASE_URL}/api/v1/system/info"
echo

echo "Checking protected API rejects anonymous requests..."
AUTH_STATUS="$(curl --connect-timeout 3 --max-time 3 --silent --output /dev/null --write-out '%{http_code}' "${BASE_URL}/api/v1/auth/me")"
if [[ "$AUTH_STATUS" != "401" ]]; then echo "ERROR: Expected 401 for anonymous request, got ${AUTH_STATUS}." >&2; exit 1; fi

echo "Checking public account registration is disabled..."
REGISTER_STATUS="$(curl --connect-timeout 3 --max-time 3 --silent --output /dev/null --write-out '%{http_code}' -H 'Content-Type: application/json' -d '{"email":"public@example.test","password":"NotAllowed-123!"}' "${BASE_URL}/api/v1/auth/register")"
if [[ "$REGISTER_STATUS" != "404" ]]; then echo "ERROR: Expected 404 for public registration, got ${REGISTER_STATUS}." >&2; exit 1; fi

echo "Waiting for Next.js web UI at ${WEB_URL} ..."
for ((i=1; i<=ATTEMPTS; i++)); do
  if curl --connect-timeout 3 --max-time 3 --silent --location --fail "${WEB_URL}/login" | grep -q "Sign in to SGSCTR"; then break; fi
  if [[ "$i" -eq "$ATTEMPTS" ]]; then echo "ERROR: Web UI did not become ready. Check: docker compose logs web" >&2; exit 1; fi
  sleep 2
done

echo "Checking protected organization and sector pages redirect to login..."
for ROUTE in organization pharmacies contracting; do
  ROUTE_STATUS="$(curl --connect-timeout 3 --max-time 3 --silent --output /dev/null --write-out '%{http_code}' "${WEB_URL}/${ROUTE}")"
  if [[ "$ROUTE_STATUS" != "307" && "$ROUTE_STATUS" != "302" ]]; then echo "ERROR: Expected /${ROUTE} to redirect to login, got ${ROUTE_STATUS}." >&2; exit 1; fi
done

echo "Checking anonymous BFF session and organization endpoints reject access..."
for ROUTE in /api/auth/session /api/organization; do
  STATUS="$(curl --connect-timeout 3 --max-time 3 --silent --output /dev/null --write-out '%{http_code}' "${WEB_URL}${ROUTE}")"
  if [[ "$STATUS" != "401" ]]; then echo "ERROR: Expected 401 for ${ROUTE}, got ${STATUS}." >&2; exit 1; fi
done

echo "Native authentication boundary smoke tests passed."
