#!/usr/bin/env bash
set -euo pipefail
BASE_URL="${1:-http://localhost:8080}"
WEB_URL="${2:-http://localhost:3000}"
KEYCLOAK_URL="${3:-http://localhost:8180}"
ATTEMPTS=60

echo "Waiting for API and PostgreSQL readiness at ${BASE_URL} ..."
for ((i=1; i<=ATTEMPTS; i++)); do
  if curl --silent --fail "${BASE_URL}/health/ready" >/dev/null; then break; fi
  if [[ "$i" -eq "$ATTEMPTS" ]]; then
    echo "ERROR: API did not become ready. Check: docker compose logs api db" >&2
    exit 1
  fi
  sleep 2
done

echo "Checking API liveness..."
curl --silent --show-error --fail "${BASE_URL}/health/live"
echo
echo "Checking database readiness..."
curl --silent --show-error --fail "${BASE_URL}/health/ready"
echo
echo "Checking public system information..."
curl --silent --show-error --fail "${BASE_URL}/api/v1/system/info"
echo

echo "Waiting for Keycloak OIDC discovery at ${KEYCLOAK_URL} ..."
for ((i=1; i<=ATTEMPTS; i++)); do
  if curl --silent --fail "${KEYCLOAK_URL}/realms/sgsctr/.well-known/openid-configuration" | grep -q '"issuer"'; then break; fi
  if [[ "$i" -eq "$ATTEMPTS" ]]; then
    echo "ERROR: Keycloak realm 'sgsctr' is not configured or not ready." >&2
    echo "Create the realm using docs/security/keycloak-local-setup.md." >&2
    exit 1
  fi
  sleep 2
done

echo "Checking protected API rejects anonymous requests..."
AUTH_STATUS="$(curl --silent --output /dev/null --write-out '%{http_code}' "${BASE_URL}/api/v1/auth/me")"
if [[ "$AUTH_STATUS" != "401" ]]; then
  echo "ERROR: Expected 401 for anonymous request, got ${AUTH_STATUS}." >&2
  exit 1
fi

echo "Checking protected API rejects malformed bearer tokens..."
INVALID_STATUS="$(curl --silent --output /dev/null --write-out '%{http_code}' -H 'Authorization: Bearer not-a-valid-jwt' "${BASE_URL}/api/v1/auth/me")"
if [[ "$INVALID_STATUS" != "401" ]]; then
  echo "ERROR: Expected 401 for malformed bearer token, got ${INVALID_STATUS}." >&2
  exit 1
fi

echo "Waiting for Next.js web UI at ${WEB_URL} ..."
for ((i=1; i<=ATTEMPTS; i++)); do
  if curl --silent --fail "${WEB_URL}/" | grep -q "SPECIAL GROUP"; then break; fi
  if [[ "$i" -eq "$ATTEMPTS" ]]; then
    echo "ERROR: Web UI did not become ready. Check: docker compose logs web" >&2
    exit 1
  fi
  sleep 2
done

echo "Web UI responded with the expected application content."
echo "Foundation and authentication-boundary smoke tests passed."
