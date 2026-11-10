#!/usr/bin/env bash
set -euo pipefail
BASE_URL="${1:-http://localhost:8080}"
WEB_URL="${2:-http://localhost:3000}"
KEYCLOAK_URL="${3:-http://localhost:8180}"
ATTEMPTS=30

echo "Waiting for API and PostgreSQL readiness at ${BASE_URL} ..."
for ((i=1; i<=ATTEMPTS; i++)); do
  if curl --connect-timeout 3 --max-time 3 --silent --fail "${BASE_URL}/health/ready" >/dev/null; then break; fi
  if [[ "$i" -eq "$ATTEMPTS" ]]; then
    echo "ERROR: API did not become ready. Check: docker compose logs api db" >&2
    exit 1
  fi
  sleep 2
done

echo "Checking API liveness..."
curl --connect-timeout 3 --max-time 3 --silent --show-error --fail "${BASE_URL}/health/live"
echo
echo "Checking database readiness..."
curl --connect-timeout 3 --max-time 3 --silent --show-error --fail "${BASE_URL}/health/ready"
echo
echo "Checking public system information..."
curl --connect-timeout 3 --max-time 3 --silent --show-error --fail "${BASE_URL}/api/v1/system/info"
echo

echo "Waiting for Keycloak OIDC discovery at ${KEYCLOAK_URL} ..."
for ((i=1; i<=ATTEMPTS; i++)); do
  if curl --connect-timeout 3 --max-time 3 --silent --fail "${KEYCLOAK_URL}/realms/sgsctr/.well-known/openid-configuration" | grep -q '"issuer"'; then break; fi
  if [[ "$i" -eq "$ATTEMPTS" ]]; then
    echo "ERROR: Keycloak realm 'sgsctr' is not configured or not ready." >&2
    echo "Create the realm using docs/security/keycloak-local-setup.md." >&2
    exit 1
  fi
  sleep 2
done

echo "Checking protected API rejects anonymous requests..."
AUTH_STATUS="$(curl --connect-timeout 3 --max-time 3 --silent --output /dev/null --write-out '%{http_code}' "${BASE_URL}/api/v1/auth/me")"
if [[ "$AUTH_STATUS" != "401" ]]; then
  echo "ERROR: Expected 401 for anonymous request, got ${AUTH_STATUS}." >&2
  exit 1
fi

echo "Checking protected API rejects malformed bearer tokens..."
INVALID_STATUS="$(curl --connect-timeout 3 --max-time 3 --silent --output /dev/null --write-out '%{http_code}' -H 'Authorization: Bearer not-a-valid-jwt' "${BASE_URL}/api/v1/auth/me")"
if [[ "$INVALID_STATUS" != "401" ]]; then
  echo "ERROR: Expected 401 for malformed bearer token, got ${INVALID_STATUS}." >&2
  exit 1
fi

echo "Waiting for Next.js web UI at ${WEB_URL} ..."
for ((i=1; i<=ATTEMPTS; i++)); do
  if curl --connect-timeout 3 --max-time 3 --silent --location --fail "${WEB_URL}/" | grep -q "Sign in to SGSCTR"; then break; fi
  if [[ "$i" -eq "$ATTEMPTS" ]]; then
    echo "ERROR: Web UI did not become ready. Check: docker compose logs web" >&2
    exit 1
  fi
  sleep 2
done

echo "Checking protected organization route redirects to login..."
ORG_PAGE_STATUS="$(curl --connect-timeout 3 --max-time 3 --silent --output /dev/null --write-out '%{http_code}' "${WEB_URL}/organization")"
if [[ "$ORG_PAGE_STATUS" != "307" && "$ORG_PAGE_STATUS" != "302" ]]; then
  echo "ERROR: Expected unauthenticated organization page to redirect to login, got ${ORG_PAGE_STATUS}." >&2
  exit 1
fi

echo "Checking protected sector routes redirect to login..."
for ROUTE in pharmacies contracting; do
  ROUTE_STATUS="$(curl --connect-timeout 3 --max-time 3 --silent --output /dev/null --write-out '%{http_code}' "${WEB_URL}/${ROUTE}")"
  if [[ "$ROUTE_STATUS" != "307" && "$ROUTE_STATUS" != "302" ]]; then
    echo "ERROR: Expected /${ROUTE} to redirect to login, got ${ROUTE_STATUS}." >&2
    exit 1
  fi
done

echo "Checking protected BFF session and organization endpoints reject anonymous requests..."
SESSION_STATUS="$(curl --connect-timeout 3 --max-time 3 --silent --output /dev/null --write-out '%{http_code}' "${WEB_URL}/api/auth/session")"
if [[ "$SESSION_STATUS" != "401" ]]; then
  echo "ERROR: Expected 401 for anonymous BFF session, got ${SESSION_STATUS}." >&2
  exit 1
fi
ORG_API_STATUS="$(curl --connect-timeout 3 --max-time 3 --silent --output /dev/null --write-out '%{http_code}' "${WEB_URL}/api/organization")"
if [[ "$ORG_API_STATUS" != "401" ]]; then
  echo "ERROR: Expected 401 for anonymous organization access, got ${ORG_API_STATUS}." >&2
  exit 1
fi

echo "Checking login route redirects to Keycloak..."
LOGIN_STATUS="$(curl --connect-timeout 3 --max-time 3 --silent --output /dev/null --write-out '%{http_code}' "${WEB_URL}/api/auth/login")"
if [[ "$LOGIN_STATUS" != "307" && "$LOGIN_STATUS" != "302" ]]; then
  echo "ERROR: Expected a redirect from the login route, got ${LOGIN_STATUS}." >&2
  exit 1
fi
echo "Authentication boundary and organization route smoke tests passed."
