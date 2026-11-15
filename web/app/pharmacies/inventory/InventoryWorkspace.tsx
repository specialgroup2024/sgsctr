"use client";

import Link from "next/link";
import { useCallback, useEffect, useState } from "react";
import { AppShell } from "@/components/app-shell";
import { useI18n } from "@/components/locale-provider";
import CatalogueManager from "./CatalogueManager";
import ApprovalRegister from "./ApprovalRegister";
import TestReadiness from "./TestReadiness";

type Location = { id: string; code: string; name: string; sectorCode: string; locationType: string; isActive: boolean; recordStatus: string };
type Organization = { locations: Location[] };
type ProductSummary = { id: string; status: string };
type SystemStatus = { api: string; database: string; checkedAt: string };
type Tab = "overview" | "products" | "receiving" | "transfers" | "batches" | "reports" | "approvals" | "readiness";

const tabs: Array<{ id: Tab; label: string }> = [
  { id: "overview", label: "Overview" }, { id: "products", label: "Product catalogue" },
  { id: "receiving", label: "Receiving" }, { id: "transfers", label: "Stock transfers" },
  { id: "batches", label: "Batches & expiry" }, { id: "reports", label: "Reports" },
  { id: "approvals", label: "Approvals" }, { id: "readiness", label: "Test readiness" }
];
const locationLabels: Record<string, string> = { MainWarehouse: "Main warehouse", Branch: "Hospital branch", Office: "Office", ProjectSite: "Project site" };

function Connection({ label, value }: { label: string; value: string }) {
  const { t } = useI18n();
  const ok = value === "online" || value === "connected";
  const pending = value === "not_verified";
  const state = ok ? "is-ok" : pending ? "is-pending" : "is-down";
  const text = ok ? (label === "API" ? "Online" : "Connected") : pending ? "Not verified" : "Unavailable";
  return <span className={"inventory-connection " + state}><i />{t(label)}: {t(text)}</span>;
}
function GateNotice({ title, detail }: { title: string; detail: string }) {
  const { t } = useI18n();
  return <div className="inventory-gate" role="note"><span className="inventory-gate-icon">!</span><div><strong>{t(title)}</strong><p>{t(detail)}</p></div></div>;
}

export default function InventoryWorkspace() {
  const { t, formatDate } = useI18n();
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
    <section className="welcome-row inventory-welcome"><div><p className="eyebrow">{t("SECTOR 01 · PHARMACIES")}</p><h1>{t("Pharmacy")} <span>{t("inventory")}</span></h1><p className="welcome-copy">{t("Inventory workspace foundation · reference visibility and workflow preparation.")}</p></div><span className="inventory-phase-pill">{t("INV-01 · DRAFT CATALOGUE")}</span></section>
    <section className="inventory-connection-bar" aria-label={t("Live service connections")}>
      <div><strong>{t("Core service connections" )}</strong><small>{t("Checked through the application server; the browser never connects directly to PostgreSQL." )}</small></div>
      <div className="inventory-connection-list"><Connection label="API" value={system?.api ?? "unavailable"} /><Connection label="Database" value={system?.database ?? "unavailable"} /><button className="inventory-refresh" type="button" onClick={() => void load()}>{t("Refresh" )}</button></div>
    </section>
    <nav className="inventory-tabs" aria-label={t("Pharmacy inventory sections")}>
      {tabs.map(item => <button key={item.id} type="button" className={tab === item.id ? "active" : ""} aria-current={tab === item.id ? "page" : undefined} onClick={() => setTab(item.id)}>{t(item.label)}</button>)}
    </nav>
    {tab === "overview" && <>
      <div className="inventory-section-heading"><div><p className="eyebrow">{t("CURRENT CAPABILITY" )}</p><h2>{t("Inventory overview" )}</h2><p>{t("Pharmacy locations and generic draft catalogue records are persisted through the API. No stock figures are fabricated.")}</p></div><span className="inventory-status-chip">{t("Reference mode" )}</span></div>
      <section className="inventory-kpi-grid">
        <article className="inventory-kpi"><span>{t("Active pharmacy locations" )}</span><strong>{loadingLocations ? "…" : locations.length}</strong><small>{t("From PostgreSQL-backed organization register")}</small></article>
        <article className="inventory-kpi"><span>{t("Catalogue records loaded" )}</span><strong>{productCount === null ? "Unavailable" : productCount}</strong><small>{t("Up to 100 generic identities · all remain Draft")}</small></article>
        <article className="inventory-kpi"><span>{t("Stock on hand" )}</span><strong>{t("Not available" )}</strong><small>{t("No inventory ledger or balances exist")}</small></article>
        <article className="inventory-kpi"><span>{t("Stock movements" )}</span><strong>{t("Not enabled" )}</strong><small>{t("No receiving, transfer or adjustment posting")}</small></article>
      </section>
      <div className="inventory-main-grid">
        <section className="inventory-panel"><div className="inventory-panel-heading"><div><p className="eyebrow">{t("SITE REGISTER" )}</p><h3>{t("Pharmacy locations" )}</h3></div><span className="inventory-count">{loadingLocations ? "Loading" : locations.length + " active"}</span></div>
          {locationError && <p className="form-error" role="alert">{locationError}</p>}
          {loadingLocations ? <p className="loading-state">{t("Loading locations from the organization service…")}</p> : locations.length ? <div className="inventory-location-list">{locations.map(location => <article className="inventory-location" key={location.id}><span className="inventory-location-mark">{location.locationType === "MainWarehouse" ? "WH" : "BR"}</span><div><strong>{location.name}</strong><small>{t(locationLabels[location.locationType] ?? location.locationType)} · {location.code}</small></div><span className="inventory-live-label">{t("Reference")}</span></article>)}</div> : <p className="inventory-empty">{t("No active pharmacy locations are returned by the Organization API.")}</p>}
          <Link className="inventory-text-link" href="/organization">{t("Manage organization reference records ↗")}</Link>
        </section>
        <section className="inventory-panel"><div className="inventory-panel-heading"><div><p className="eyebrow">{t("INVENTORY CONTROL" )}</p><h3>{t("What is available now?" )}</h3></div></div>
          <ul className="inventory-check-list">
            <li><span className="check-pending">○</span><div><strong>{t("Generic product catalogue" )}</strong><small>{t("Implemented as draft-only reference data · Q38 family rules remain gated")}</small></div></li>
            <li><span className="check-pending">○</span><div><strong>{t("Receiving and quality release" )}</strong><small>{t("Not implemented · SOP and role approvals required")}</small></div></li>
            <li><span className="check-pending">○</span><div><strong>{t("Batch, expiry and FEFO" )}</strong><small>{t("Not implemented · pharmacist/quality approval required")}</small></div></li>
            <li><span className="check-pending">○</span><div><strong>{t("Transfers and stock ledger" )}</strong><small>{t("Not implemented · workflow and custody approvals required")}</small></div></li>
          </ul><Link className="inventory-text-link" href="/pharmacies/regulatory-intelligence">{t("Open Egypt regulatory intelligence ↗")}</Link>
        </section>
      </div>
      <GateNotice title={t("No live stock or valuation data is available yet.")} detail="Generic product identities, units and draft conversion references are persisted. Product-family classification, regulatory identifiers and activation remain gated; no inventory quantities, suppliers, receipts, transfers or costing records are stored or simulated." />
    </>}
    {tab === "products" && <CatalogueManager />}
    {tab === "approvals" && <ApprovalRegister />}
    {tab === "readiness" && <TestReadiness />}
    {tab === "receiving" && <section className="inventory-workspace-panel"><div className="inventory-section-heading"><div><p className="eyebrow">{t("INBOUND STOCK")}</p><h2>{t("Receiving & inspection" )}</h2><p>{t("Purchase-order matching, delivery checks and quality disposition." )}</p></div><button className="inventory-disabled-action" disabled>{t("New receipt" )}</button></div>
      <div className="inventory-flow-grid"><article><b>01</b><strong>{t("Delivery evidence")}</strong><small>{t("Supplier, documents, item, quantity and unit")}</small></article><article><b>02</b><strong>{t("Batch inspection")}</strong><small>{t("Lot, manufacture/expiry, packaging and transport evidence")}</small></article><article><b>03</b><strong>{t("Disposition")}</strong><small>{t("Accepted, rejected or quarantined quantities")}</small></article><article><b>04</b><strong>{t("Authorized release")}</strong><small>{t("Only approved release can make stock available")}</small></article></div>
      <div className="inventory-empty-state compact-empty"><h3>{t("No receipts recorded" )}</h3><p>{t("Receiving is not connected to a purchasing or inventory ledger API. No receipt can be created, accepted or released in this phase.")}</p></div>
      <GateNotice title={t("Receiving is blocked pending approved SOPs.")} detail="Pharmacy/quality must approve receipt roles, evidence by product class, partial acceptance, quarantine, rejected deliveries and authorized release. No stock-changing endpoint exists." />
    </section>}
    {tab === "transfers" && <section className="inventory-workspace-panel"><div className="inventory-section-heading"><div><p className="eyebrow">{t("LOCATION MOVEMENT")}</p><h2>{t("Stock transfers")}</h2><p>{t("Warehouse-to-branch and direct branch-to-branch movement." )}</p></div><button className="inventory-disabled-action" disabled>{t("New transfer" )}</button></div>
      <div className="inventory-transfer-route"><div><span>{t("FROM")}</span><strong>{t("Source location")}</strong><small>{t("Approved location register")}</small></div><span className="inventory-route-arrow">→</span><div><span>TO</span><strong>{t("Destination location")}</strong><small>{t("Direct branch route supported by design")}</small></div></div>
      <div className="inventory-flow-grid"><article><b>01</b><strong>{t("Request & approve")}</strong><small>{t("Roles and limits await sign-off")}</small></article><article><b>02</b><strong>{t("Pick & dispatch")}</strong><small>{t("Lot-level custody and dispatch event")}</small></article><article><b>03</b><strong>{t("In transit")}</strong><small>{t("Partial receipt and discrepancies remain visible")}</small></article><article><b>04</b><strong>{t("Receive & reconcile")}</strong><small>{t("Authorized close; no silent loss")}</small></article></div>
      <div className="inventory-empty-state compact-empty"><h3>{t("No transfer ledger exists" )}</h3><p>{t("The owner-confirmed direct branch-to-branch route is represented in this UI, but transfer requests, dispatch, receipt and reconciliation are not enabled.")}</p></div>
      <GateNotice title={t("Transfer posting remains disabled.")} detail="Pharmacy operations and the owner must approve custody, lifecycle states, approver separation, emergency transfers, partial receipt and discrepancy resolution. Accountant approval is also required before transfer valuation." />
    </section>}
    {tab === "batches" && <section className="inventory-workspace-panel"><div className="inventory-section-heading"><div><p className="eyebrow">{t("QUALITY & TRACEABILITY")}</p><h2>{t("Batches & expiry")}</h2><p>{t("Lot traceability, FEFO candidate visibility, quarantine and recall controls." )}</p></div><span className="inventory-status-chip">{t("Not connected")}</span></div>
      <div className="inventory-flow-grid"><article><b>{t("LOT")}</b><strong>{t("Batch identity")}</strong><small>{t("Lot, serial and GTIN applicability by product")}</small></article><article><b>{t("DATE")}</b><strong>{t("Expiry & retest")}</strong><small>{t("Product-specific expiry and retest evidence")}</small></article><article><b>{t("FEFO")}</b><strong>{t("Expiry rotation")}</strong><small>{t("Candidate selection after pharmacist approval")}</small></article><article><b>{t("HOLD")}</b><strong>{t("Quarantine & recall")}</strong><small>{t("Segregated status and authorized disposition")}</small></article></div>
      <div className="inventory-empty-state compact-empty"><h3>{t("No batch records or expiry alerts" )}</h3><p>{t("There is no batch/lot inventory data source yet. This page deliberately does not invent stock, expiry dates, temperature readings or recall status.")}</p></div>
      <GateNotice title={t("Quality rules require qualified review.")} detail="A licensed pharmacist/quality lead must approve product-specific lot, expiry, FEFO, temperature, returns, recall and disposition requirements. Site licensing applicability is still open (Q37)." />
    </section>}
    {tab === "reports" && <section className="inventory-workspace-panel"><div className="inventory-section-heading"><div><p className="eyebrow">{t("MANAGEMENT VISIBILITY" )}</p><h2>{t("Inventory reports" )}</h2><p>{t("Location, product, movement, expiry, discrepancy and valuation reporting." )}</p></div><span className="inventory-status-chip">{t("Not connected")}</span></div>
      <div className="inventory-report-grid">{["Stock by location and product","Movement history","Near-expiry and expired stock","Quarantine and recall status","In-transit and transfer discrepancies","Inventory valuation and reconciliation"].map(label => <article key={label}><span>▥</span><strong>{label}</strong><small>{t("Report becomes available after the relevant approved data source exists.")}</small></article>)}</div>
      <GateNotice title={t("Reports are not populated with sample numbers.")} detail="Inventory reports will be connected only to approved, persisted data and reconciled ledger queries. Valuation and financial reconciliation remain blocked until accountant-approved costing policy and examples are signed." />
    </section>}
    <footer className="inventory-footer"><span>{t("SGSCTR · Pharmacy inventory workspace")}</span><span>{t(pageTitle)} · {t("Draft catalogue / non-posting inventory")}</span><span>Last service check: {lastChecked ? new Date(lastChecked).toLocaleTimeString() : "Not available"}</span></footer>
  </div></AppShell>;
}
