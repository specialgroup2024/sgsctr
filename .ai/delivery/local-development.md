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
