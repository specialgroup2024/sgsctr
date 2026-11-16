#!/usr/bin/env bash
# Diagnose runtime AppDbContext model drift against the committed EF snapshot.
# This is read-only with respect to PostgreSQL: it does not start the API or apply migrations.
set -Eeuo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

project="src/Sgsctr.Api/Sgsctr.Api.csproj"
snapshot="src/Sgsctr.Api/Data/Migrations/AppDbContextModelSnapshot.cs"
probe_dir="src/Sgsctr.Api/Data/ModelParityProbe"
report_dir="${TMPDIR:-/tmp}/sgsctr-appdbcontext-parity-$(date +%Y%m%d-%H%M%S)"
tool_version="10.0.4"

if [[ ! -f "$snapshot" ]]; then
  echo "ERROR: Expected snapshot not found: $snapshot" >&2
  exit 2
fi
mkdir -p "$report_dir"
snapshot_backup="$report_dir/AppDbContextModelSnapshot.cs"
cp "$snapshot" "$snapshot_backup"

restore_snapshot() {
  cp "$snapshot_backup" "$snapshot"
  rm -rf "$probe_dir"
}
trap restore_snapshot EXIT

echo "Report directory: $report_dir"
echo "Restoring and building API project..."
dotnet restore "$project"
dotnet build "$project" --configuration Release --no-restore

if ! dotnet tool list --global | grep -q "dotnet-ef"; then
  dotnet tool install --global dotnet-ef --version "$tool_version"
fi
export PATH="$PATH:$HOME/.dotnet/tools"

echo "Scaffolding a temporary migration from the runtime AppDbContext..."
set +e
dotnet ef migrations add AppDbContextModelParityProbe \
  --context AppDbContext \
  --project "$project" \
  --startup-project "$project" \
  --configuration Release \
  --output-dir Data/ModelParityProbe \
  >"$report_dir/scaffold.log" 2>&1
scaffold_status=$?
set -e

{
  echo "AppDbContext model/snapshot diagnostic"
  echo "Scaffold exit code: $scaffold_status"
  echo
  echo "=== EF output ==="
  cat "$report_dir/scaffold.log"
  echo
  echo "=== Snapshot delta (committed -> runtime-generated) ==="
  git diff --no-index -- "$snapshot_backup" "$snapshot" || true
  echo
  echo "=== Generated migration source ==="
  while IFS= read -r file; do
    echo
    echo "--- $file ---"
    cat "$file"
  done < <(find "$probe_dir" -maxdepth 1 -type f -name '*.cs' -print 2>/dev/null | sort)
} | tee "$report_dir/report.txt"

echo
echo "Diagnostic evidence saved to: $report_dir"
echo "Snapshot restored and temporary probe files removed."

if [[ $scaffold_status -ne 0 ]]; then
  exit "$scaffold_status"
fi
