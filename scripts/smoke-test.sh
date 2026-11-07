#!/usr/bin/env bash
set -euo pipefail
BASE_URL="${1:-http://localhost:8080}"
ATTEMPTS=30
echo "Waiting for API and PostgreSQL readiness at ${BASE_URL} ..."
for ((i=1; i<=ATTEMPTS; i++)); do
  if curl --silent --fail "${BASE_URL}/health/ready" >/dev/null; then break; fi
  if [[ "$i" -eq "$ATTEMPTS" ]]; then
    echo "ERROR: API did not become ready. Check: docker compose logs api db" >&2
    exit 1
  fi
  sleep 2
done
echo "Checking liveness..."
curl --silent --show-error --fail "${BASE_URL}/health/live"
echo
echo "Checking database readiness..."
curl --silent --show-error --fail "${BASE_URL}/health/ready"
echo
echo "Checking API system information..."
curl --silent --show-error --fail "${BASE_URL}/api/v1/system/info"
echo
echo "Smoke test passed."
