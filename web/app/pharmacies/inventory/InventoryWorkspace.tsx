"use client";

import Link from "next/link";
import { useCallback, useEffect, useMemo, useState } from "react";
import { AppShell } from "@/components/app-shell";
import CatalogueManager from "./CatalogueManager";

type Location = { id: string; code: string; name: string; sectorCode: string; locationType: string; isActive: boolean; recordStatus: string };
type Organization = { locations: Location[] };
type ProductSummary = { id: string; status: string };
type SystemStatus = { api: string; database: string; checkedAt: string };
type Tab = "overview" | "products" | "receiving" | "transfers" | "batches" | "reports";

const tabs: Array<{ id: Tab; label: string }> = [
  { id: "overview", label: "Overview" }, { id: "products", label: "Product catalogue" },
  { id: "receiving", label: "Receiving" }, { id: "transfers", label: "Stock transfers" },
  { id: "batches", label: "Batches & expiry" }, { id: "reports", label: "Reports" }
];
const locationLabels: Record<string, string> = { MainWarehouse: "Main warehouse", Branch: "Hospital branch", Office: "Office", ProjectSite: "Project site" };

function Connection({ label, value }: { label: string; value: string }) {
  const ok = value === "online" || value === "connected";
  const pending = value === "not_verified";
  const state = ok ? "is-ok" : pending ? "is-pending" : "is-down";
  const text = ok ? (label === "API" ? "Online" : "Connected") : pending ? "Not verified" : "Unavailable";
  return <span className={"inventory-connection " + state}><i />{label}: {text}</span>;
}
function GateNotice({ title, detail }: { title: string; detail: string }) {
  return <div className="inventory-gate" role="note"><span className="inventory-gate-icon">!</span><div><strong>{title}</strong><p>{detail}</p></div></div>;
}

export default function InventoryWorkspace() {
  const [tab, setTab] = useState<Tab>("overview");
  const [locations, setLocations] = useState<Location[]>([]);
  const [system, setSystem] = useState<SystemStatus | null>(null);
  const [productCount, setProductCount] = useState<number | null>(null);
  const [loadingLocations, setLoadingLocations] = useState(true);
  const [locationError, setLocationError] = useState("");
  const [lastChecked, setLastChecked] = useState("");
  const load = useCallback(async () => {
    const [orgResult, statusResult, catalogueResult] = await Promise.allSettled([
      fetch("/api/organization", { cache: "no-store" }),
      fetch("/api/system-status", { cache: "no-store" }),
      fetch("/api/pharmacy/catalogue", { cache: "no-store" })
    ]);
    if (orgResult.status === "fulfilled") {
      if (orgResult.value.status === 401) { window.location.assign("/login"); return; }
      if (orgResult.value.ok) {
        const org = await orgResult.value.json() as Organization;
        setLocations((org.locations ?? []).filter(x => x.sectorCode === "PHARMACIES" && x.isActive));
        setLocationError("");
      } else setLocationError("The pharmacy location register could not be loaded.");
    } else setLocationError("The organization API could not be reached.");
    if (catalogueResult?.status === "fulfilled" && catalogueResult.value.ok) {
      const products = await catalogueResult.value.json() as ProductSummary[];
      setProductCount(products.length);
    } else setProductCount(null);
    if (statusResult.status === "fulfilled" && statusResult.value.ok) {
      const payload = await statusResult.value.json() as SystemStatus;
      setSystem(payload); setLastChecked(payload.checkedAt);
    } else setSystem({ api: "unreachable", database: "not_verified", checkedAt: new Date().toISOString() });
    setLoadingLocations(false);
  }, []);
  useEffect(() => { void load(); const timer = window.setInterval(() => void load(), 30000); return () => window.clearInterval(timer); }, [load]);
  const pageTitle = tabs.find(x => x.id === tab)?.label ?? "Overview";

  return <AppShell><div className="content inventory-content">
    <section className="welcome-row inventory-welcome"><div><p className="eyebrow">SECTOR 01 · PHARMACIES</p><h1>Pharmacy <span>inventory</span></h1><p className="welcome-copy">Inventory workspace foundation · reference visibility and workflow preparation.</p></div><span className="inventory-phase-pill">INV-00 · NON-POSTING</span></section>
    <section className="inventory-connection-bar" aria-label="Live service connections">
      <div><strong>Core service connections</strong><small>Checked through the application server; the browser never connects directly to PostgreSQL.</small></div>
      <div className="inventory-connection-list"><Connection label="API" value={system?.api ?? "unavailable"} /><Connection label="Database" value={system?.database ?? "unavailable"} /><button className="inventory-refresh" type="button" onClick={() => void load()}>Refresh</button></div>
    </section>
    <nav className="inventory-tabs" aria-label="Pharmacy inventory sections">
      {tabs.map(item => <button key={item.id} type="button" className={tab === item.id ? "active" : ""} aria-current={tab === item.id ? "page" : undefined} onClick={() => setTab(item.id)}>{item.label}</button>)}
    </nav>
    {tab === "overview" && <>
      <div className="inventory-section-heading"><div><p className="eyebrow">CURRENT CAPABILITY</p><h2>Inventory overview</h2><p>Pharmacy locations and generic draft catalogue records are persisted through the API. No stock figures are fabricated.</p></div><span className="inventory-status-chip">Reference mode</span></div>
      <section className="inventory-kpi-grid">
        <article className="inventory-kpi"><span>Active pharmacy locations</span><strong>{loadingLocations ? "…" : locations.length}</strong><small>From PostgreSQL-backed organization register</small></article>
        <article className="inventory-kpi"><span>Draft catalogue records</span><strong>{productCount === null ? "Unavailable" : productCount}</strong><small>Generic identities only · not activated</small></article>
        <article className="inventory-kpi"><span>Stock on hand</span><strong>Not available</strong><small>No inventory ledger or balances exist</small></article>
        <article className="inventory-kpi"><span>Stock movements</span><strong>Not enabled</strong><small>No receiving, transfer or adjustment posting</small></article>
      </section>
      <div className="inventory-main-grid">
        <section className="inventory-panel"><div className="inventory-panel-heading"><div><p className="eyebrow">SITE REGISTER</p><h3>Pharmacy locations</h3></div><span className="inventory-count">{loadingLocations ? "Loading" : locations.length + " active"}</span></div>
          {locationError && <p className="form-error" role="alert">{locationError}</p>}
          {loadingLocations ? <p className="loading-state">Loading locations from the organization service…</p> : locations.length ? <div className="inventory-location-list">{locations.map(location => <article className="inventory-location" key={location.id}><span className="inventory-location-mark">{location.locationType === "MainWarehouse" ? "WH" : "BR"}</span><div><strong>{location.name}</strong><small>{locationLabels[location.locationType] ?? location.locationType} · {location.code}</small></div><span className="inventory-live-label">Reference</span></article>)}</div> : <p className="inventory-empty">No active pharmacy locations are returned by the Organization API.</p>}
          <Link className="inventory-text-link" href="/organization">Manage organization reference records ↗</Link>
        </section>
        <section className="inventory-panel"><div className="inventory-panel-heading"><div><p className="eyebrow">INVENTORY CONTROL</p><h3>What is available now?</h3></div></div>
          <ul className="inventory-check-list">
            <li><span className="check-pending">○</span><div><strong>Generic product catalogue</strong><small>Implemented as draft-only reference data · Q38 family rules remain gated</small></div></li>
            <li><span className="check-pending">○</span><div><strong>Receiving and quality release</strong><small>Not implemented · SOP and role approvals required</small></div></li>
            <li><span className="check-pending">○</span><div><strong>Batch, expiry and FEFO</strong><small>Not implemented · pharmacist/quality approval required</small></div></li>
            <li><span className="check-pending">○</span><div><strong>Transfers and stock ledger</strong><small>Not implemented · workflow and custody approvals required</small></div></li>
          </ul><Link className="inventory-text-link" href="/pharmacies/regulatory-intelligence">Open Egypt regulatory intelligence ↗</Link>
        </section>
      </div>
      <GateNotice title="No live stock or valuation data is available yet." detail="Generic product identities, units and draft conversion references are persisted. Product-family classification, regulatory identifiers and activation remain gated; no inventory quantities, suppliers, receipts, transfers or costing records are stored or simulated." />
    </>}
    {tab === "products" && <CatalogueManager />}
    {tab === "receiving" && <section className="inventory-workspace-panel"><div className="inventory-section-heading"><div><p className="eyebrow">INBOUND STOCK</p><h2>Receiving & inspection</h2><p>Purchase-order matching, delivery checks and quality disposition.</p></div><button className="inventory-disabled-action" disabled>New receipt</button></div>
      <div className="inventory-flow-grid"><article><b>01</b><strong>Delivery evidence</strong><small>Supplier, documents, item, quantity and unit</small></article><article><b>02</b><strong>Batch inspection</strong><small>Lot, manufacture/expiry, packaging and transport evidence</small></article><article><b>03</b><strong>Disposition</strong><small>Accepted, rejected or quarantined quantities</small></article><article><b>04</b><strong>Authorized release</strong><small>Only approved release can make stock available</small></article></div>
      <div className="inventory-empty-state compact-empty"><h3>No receipts recorded</h3><p>Receiving is not connected to a purchasing or inventory ledger API. No receipt can be created, accepted or released in this phase.</p></div>
      <GateNotice title="Receiving is blocked pending approved SOPs." detail="Pharmacy/quality must approve receipt roles, evidence by product class, partial acceptance, quarantine, rejected deliveries and authorized release. No stock-changing endpoint exists." />
    </section>}
    {tab === "transfers" && <section className="inventory-workspace-panel"><div className="inventory-section-heading"><div><p className="eyebrow">LOCATION MOVEMENT</p><h2>Stock transfers</h2><p>Warehouse-to-branch and direct branch-to-branch movement.</p></div><button className="inventory-disabled-action" disabled>New transfer</button></div>
      <div className="inventory-transfer-route"><div><span>FROM</span><strong>Source location</strong><small>Approved location register</small></div><span className="inventory-route-arrow">→</span><div><span>TO</span><strong>Destination location</strong><small>Direct branch route supported by design</small></div></div>
      <div className="inventory-flow-grid"><article><b>01</b><strong>Request & approve</strong><small>Roles and limits await sign-off</small></article><article><b>02</b><strong>Pick & dispatch</strong><small>Lot-level custody and dispatch event</small></article><article><b>03</b><strong>In transit</strong><small>Partial receipt and discrepancies remain visible</small></article><article><b>04</b><strong>Receive & reconcile</strong><small>Authorized close; no silent loss</small></article></div>
      <div className="inventory-empty-state compact-empty"><h3>No transfer ledger exists</h3><p>The owner-confirmed direct branch-to-branch route is represented in this UI, but transfer requests, dispatch, receipt and reconciliation are not enabled.</p></div>
      <GateNotice title="Transfer posting remains disabled." detail="Pharmacy operations and the owner must approve custody, lifecycle states, approver separation, emergency transfers, partial receipt and discrepancy resolution. Accountant approval is also required before transfer valuation." />
    </section>}
    {tab === "batches" && <section className="inventory-workspace-panel"><div className="inventory-section-heading"><div><p className="eyebrow">QUALITY & TRACEABILITY</p><h2>Batches & expiry</h2><p>Lot traceability, FEFO candidate visibility, quarantine and recall controls.</p></div><span className="inventory-status-chip">Not connected</span></div>
      <div className="inventory-flow-grid"><article><b>LOT</b><strong>Batch identity</strong><small>Lot, serial and GTIN applicability by product</small></article><article><b>DATE</b><strong>Expiry & retest</strong><small>Product-specific expiry and retest evidence</small></article><article><b>FEFO</b><strong>Expiry rotation</strong><small>Candidate selection after pharmacist approval</small></article><article><b>HOLD</b><strong>Quarantine & recall</strong><small>Segregated status and authorized disposition</small></article></div>
      <div className="inventory-empty-state compact-empty"><h3>No batch records or expiry alerts</h3><p>There is no batch/lot inventory data source yet. This page deliberately does not invent stock, expiry dates, temperature readings or recall status.</p></div>
      <GateNotice title="Quality rules require qualified review." detail="A licensed pharmacist/quality lead must approve product-specific lot, expiry, FEFO, temperature, returns, recall and disposition requirements. Site licensing applicability is still open (Q37)." />
    </section>}
    {tab === "reports" && <section className="inventory-workspace-panel"><div className="inventory-section-heading"><div><p className="eyebrow">MANAGEMENT VISIBILITY</p><h2>Inventory reports</h2><p>Location, product, movement, expiry, discrepancy and valuation reporting.</p></div><span className="inventory-status-chip">Not connected</span></div>
      <div className="inventory-report-grid">{["Stock by location and product","Movement history","Near-expiry and expired stock","Quarantine and recall status","In-transit and transfer discrepancies","Inventory valuation and reconciliation"].map(label => <article key={label}><span>▥</span><strong>{label}</strong><small>Report becomes available after the relevant approved data source exists.</small></article>)}</div>
      <GateNotice title="Reports are not populated with sample numbers." detail="Inventory reports will be connected only to approved, persisted data and reconciled ledger queries. Valuation and financial reconciliation remain blocked until accountant-approved costing policy and examples are signed." />
    </section>}
    <footer className="inventory-footer"><span>SGSCTR · Pharmacy inventory workspace</span><span>{pageTitle} · Draft catalogue / non-posting inventory</span><span>Last service check: {lastChecked ? new Date(lastChecked).toLocaleTimeString() : "Not available"}</span></footer>
  </div></AppShell>;
}
