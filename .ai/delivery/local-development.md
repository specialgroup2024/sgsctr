# Local development and test runbook

- Status: API, PostgreSQL and Next.js local foundation.
- Branch: `master`.
- Scope: responsive development dashboard and live API/database connectivity only.

## Prerequisites

Linux workstation or VM with Git, Docker Engine and Docker Compose v2. Internet access
is needed for first image/package downloads.

## Start

For a fresh clone:

    git clone https://github.com/specialgroup2024/sgsctr.git
    cd sgsctr
    cp .env.example .env
    # Edit .env: set unique local secrets and WEB_BASE_URL to the URL clients use.
    docker compose up --build -d

If the repository is already cloned:

    git fetch origin
    git checkout master
    git pull --ff-only
    # Merge/update local .env manually; do not overwrite existing credentials or secrets.
    docker compose up --build -d

## Open the application

- On the VM: `http://localhost:3000` only when WEB_BASE_URL is configured for localhost.
- From another LAN computer: `http://<VM-LAN-IP>:3000`.
- Set `WEB_BASE_URL` in the VM's ignored `.env` to the exact LAN origin, for example
  `http://192.168.88.72:3000`, including scheme and port. The Next.js BFF checks
  this origin for sign-in, sign-out and write requests. A mismatch can load the
  page but reject those requests with HTTP 403.
- Set `WEB_BIND_ADDRESS=127.0.0.1` to restrict the web UI to the VM, or
  `WEB_BIND_ADDRESS=0.0.0.0` to publish it on all VM interfaces.
- Set `WEB_HOST_PORT` if host port 3000 is already occupied; update
  `WEB_BASE_URL` to the corresponding port.
- If you want to browse the bare address `http://<VM-LAN-IP>` with no `:port`,
  first confirm host TCP port 80 is unused, then set `WEB_HOST_PORT=80` and
  `WEB_BASE_URL=http://<VM-LAN-IP>` (no trailing slash). Allow TCP 80 only from
  the trusted LAN subnet. This is optional; the default remains port 3000.

The web container listens on 0.0.0.0:3000 internally. Compose publishes only
the web UI to the host/LAN. API (8080), PostgreSQL (5433) and pgAdmin (5051)
remain bound to 127.0.0.1 and are not exposed to other computers. The browser
does not connect directly to PostgreSQL.

## Verify

    docker compose config --quiet
    docker compose ps
    docker compose logs --tail=100 web
    bash scripts/smoke-test.sh http://localhost:8080 http://localhost:3000

Expected: db is healthy, api and web are running, API readiness reports the
database reachable, and the web page contains the Special Group dashboard.
From a second computer, verify TCP reachability and load the configured LAN URL.

## Network troubleshooting

### NuGet restore fails with NU1301

The API image restores packages during the Docker build. A failure to reach
`https://api.nuget.org/v3/index.json` is a build-network/DNS/proxy problem until
evidence shows otherwise; it is not evidence of a PostgreSQL or application defect.

First test the VM host network:

    getent hosts api.nuget.org
    curl -fsSI --connect-timeout 10 https://api.nuget.org/v3/index.json

If either command fails, repair the VM's DNS, outbound HTTPS access or required
corporate/network proxy before rebuilding. Do not change package versions or
disable TLS validation to work around a connectivity failure.

If the VM must use an HTTP(S) proxy, export the proxy in the shell that runs
Compose. Use the actual proxy URL supplied by the network administrator; do not
commit it to `.env`, source control or logs:

    export HTTPS_PROXY=http://proxy.example:3128
    export HTTP_PROXY=http://proxy.example:3128
    export NO_PROXY=localhost,127.0.0.1,.local
    docker compose build --no-cache --progress plain api

Compose forwards optional upper- and lower-case proxy variables to the API
image build only. They are Docker's predefined proxy build arguments and are
not declared in the Dockerfile or persisted as runtime container environment.
If the host has no proxy, leave these variables unset.

If host connectivity works but restore still fails in BuildKit, compare DNS and
egress from a disposable SDK container:

    docker run --rm --entrypoint sh mcr.microsoft.com/dotnet/sdk:10.0 -lc 'getent hosts api.nuget.org'

If container DNS fails while host DNS works, investigate Docker daemon/BuildKit
DNS, firewall and outbound networking. Do not switch to host networking or
weaken TLS as a default workaround. After correcting the network path, retry:

    docker compose build --no-cache --progress plain api
    docker compose up -d

The API Docker build also uses NuGet enhanced network retries (bounded so a
dead feed fails fast instead of stalling the build for many minutes) and a
BuildKit cache mount for `/root/.nuget/packages`, so packages downloaded by one
successful restore are reused by later rebuilds even if the feed is briefly
unreachable afterwards. Retries cannot repair blocked DNS, blocked outbound
HTTPS or a missing proxy.

When container DNS itself is broken — `getent hosts api.nuget.org` hangs or
returns nothing inside a test container while image pulls still work — no
retry/proxy setting fixes the build. Use the offline seed instead: on any
networked machine run `./scripts/nuget-offline.sh`, copy the resulting
`nuget-seed.tar.gz` to the repo root on the VM, unpack it (`tar -xzf
nuget-seed.tar.gz`) and rebuild. The Dockerfile mounts `./nuget-seed/` into the
restore step; when present it populates the package cache and `dotnet restore`
completes with zero outbound traffic. Without the seed the build falls back to
a live restore and prints these instructions on failure. As an alternative,
repair daemon DNS first (`"dns": ["1.1.1.1", "8.8.8.8"]` in
`/etc/docker/daemon.json`, then `sudo systemctl restart docker`).

When host checks pass but the container still reports NU1301 "Resource
temporarily unavailable", the usual culprits are broken container DNS or
IPv6-only resolution inside BuildKit (the resolver returns AAAA records that
cannot connect). Test both directly:

    docker run --rm mcr.microsoft.com/dotnet/sdk:10.0 sh -lc 'curl -fsS --ipv4 -m 20 -o /dev/null https://api.nuget.org/v3/index.json && echo IPV4_OK'
    cat /etc/resolv.conf   # inside the same container, check nameserver reachability

If the IPv4 test succeeds where the default failed, the issue is IPv6/DNS in
Docker; pin daemon DNS (`"dns": ["1.1.1.1", "8.8.8.8"]` in
`/etc/docker/daemon.json`, then `sudo systemctl restart docker`) or disable
broken IPv6 egress. If it fails too, outbound HTTPS from Docker's bridge
network is being blocked (firewall/iptables/nftables on the VM) even though the
host itself works — repair that path before rebuilding.

### VM/LAN connectivity

On the VM:

    ip -br address
    docker compose ps
    sudo ss -lntp | grep -E ':(3000|8080|5433|5051)\\b'
    curl -I --connect-timeout 5 http://127.0.0.1:3000
    curl -I --connect-timeout 5 http://<VM-LAN-IP>:3000

Confirm the LAN IP is assigned to the VM NIC and that the VM network adapter
is bridged or otherwise reachable from the client network. If the VM is behind
NAT, configure the hypervisor/router port-forwarding deliberately; Docker
port publication cannot override hypervisor NAT.

Inspect the host firewall before changing it:

    sudo ufw status verbose

If a firewall is active, allow TCP 3000 only from the actual trusted LAN
subnet; determine the subnet from the VM/client network configuration rather
than assuming a CIDR. Do not disable the firewall as a workaround. Also check
the hypervisor firewall, VLAN/client isolation and Wi-Fi guest-network rules.

From the client computer, test:

    curl -v --connect-timeout 5 http://<VM-LAN-IP>:3000/

A timeout usually indicates routing/firewall filtering; connection refused
usually indicates no listener/published port at that address, a stopped web
container, or an explicit reject. Check `docker compose ps` and `ss` before
changing firewall rules.

## API endpoints (VM-local diagnostics)

- API root: http://localhost:8080/
- API liveness: http://localhost:8080/health/live
- API/database readiness: http://localhost:8080/health/ready
- API system information: http://localhost:8080/api/v1/system/info

The dashboard polls its server-side status endpoint every 15 seconds. The
Next.js container reaches the API using the internal Docker address
http://api:8080.

## Stop and reset

    docker compose down

Destructive local reset (removes the development database volume and its test data):

    docker compose down --volumes

## Phase boundary

The dashboard is a read-only foundation. No authentication, business migrations,
pharmacy inventory tables, stock movements, contracting workflows, claims,
patient data, costing or financial postings are implemented. Do not infer
business acceptance or production readiness from a successful health check.
