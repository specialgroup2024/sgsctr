"use client";
import { useEffect, useState } from "react";
import { AppShell } from "@/components/app-shell";
type SystemStatus = { api: string; database: string; checkedAt: string };
const locations = [
  { code: "WH-01", name: "Mokattam", type: "Main warehouse", detail: "Central stock location" },
  { code: "PH-02", name: "Student Hospital", type: "Pharmacy branch", detail: "Branch inventory workspace" },
  { code: "PH-03", name: "Qasr El-Aini Hospital", type: "Pharmacy branch", detail: "Branch inventory workspace" },
  { code: "PH-04", name: "Manial Hospital", type: "Pharmacy branch", detail: "Branch inventory workspace" },
];
function Dot({ ok }: { ok: boolean }) { return <span className={`status-dot ${ok ? "is-ok" : "is-warn"}`} aria-hidden="true" />; }
export default function Home() {
  const [status, setStatus] = useState<SystemStatus | null>(null);
  useEffect(() => {
    let active = true;
    const check = async () => {
      try { const response = await fetch("/api/system-status", { cache: "no-store" }); const data = await response.json(); if (active) setStatus(data); }
      catch { if (active) setStatus({ api: "unreachable", database: "unknown", checkedAt: new Date().toISOString() }); }
    };
    void check();
    const timer = window.setInterval(check, 15000);
    return () => { active = false; window.clearInterval(timer); };
  }, []);
  return <AppShell><div className="content">
    <section className="welcome-row" id="overview"><div><p className="eyebrow">SPECIAL GROUP · BUSINESS OPERATIONS</p><h1>Good day. <span>Your workspace is ready.</span></h1><p className="welcome-copy">A unified starting point for the Pharmacies and Specialized Contracting sectors.</p></div><div className="date-chip"><span className="date-dot" />DEVELOPMENT BUILD</div></section>
    <section className="status-banner" id="system"><div className="status-banner-icon" aria-hidden="true">⌁</div><div className="status-banner-copy"><strong>Platform foundation</strong><span>Live connection checks against ASP.NET Core API and PostgreSQL.</span></div>
      <div className="connection-list"><div><Dot ok={status?.api === "online"} /><span>API</span><strong>{status?.api ?? "Checking"}</strong></div><div><Dot ok={status?.database === "connected"} /><span>Database</span><strong>{status?.database ?? "Checking"}</strong></div></div>
    </section>
    <div className="section-heading"><div><p className="eyebrow">YOUR ORGANIZATION</p><h2>Business sectors</h2></div><span className="section-note">Initial workspace · No operational data loaded</span></div>
    <section className="sector-grid">
      <article className="sector-card pharmacy-card"><div className="sector-top"><span className="sector-symbol">✚</span><span className="sector-tag">SECTOR 01</span></div><h3>Pharmacies</h3><p>Manage the pharmacy network, locations and future inventory operations from one connected workspace.</p><div className="sector-meta"><span>4 owner-identified locations</span><a className="text-link" href="/pharmacies">Open workspace ↗</a></div></article>
      <article className="sector-card contracting-card"><div className="sector-top"><span className="sector-symbol">⌂</span><span className="sector-tag">SECTOR 02</span></div><h3>Specialized Contracting</h3><p>A dedicated workspace for future projects, contracts, procurement, execution and cost control.</p><div className="sector-meta"><span>Module foundation only</span><a className="text-link" href="/contracting">Open workspace ↗</a></div></article>
    </section>
    <section className="locations-section"><div className="section-heading compact"><div><p className="eyebrow">PHARMACY NETWORK</p><h2>Locations</h2></div><a className="text-link" href="/organization">View organization register ↗</a></div>
      <div className="location-grid">{locations.map((loc) => <article className="location-card" key={loc.code}><div className="location-icon">{loc.code.startsWith("WH") ? "▤" : "✚"}</div><div className="location-info"><strong>{loc.name}</strong><span>{loc.type}</span><small>{loc.detail}</small></div><span className="location-code">{loc.code}</span></article>)}</div>
    </section>
    <section className="bottom-grid">
      <article className="info-card"><div className="info-card-heading"><span>◷</span><strong>Implementation progress</strong></div><p className="progress-title">Foundation stage</p><div className="progress-track"><span /></div><p className="muted">The UI is connected to the API. Business workflows remain disabled until their approval gates are complete.</p></article>
      <article className="info-card"><div className="info-card-heading"><span>◈</span><strong>Scope and safety</strong></div><p className="muted safety-copy">This is a local development interface. It contains no live stock balances, patient records, financial postings or production data.</p><span className="safe-label">DEVELOPMENT ONLY</span></article>
    </section>
    <footer className="footer"><span>© {new Date().getFullYear()} Special Group</span><span>SGSCTR · ASP.NET Core 10 · Next.js</span></footer>
  </div></AppShell>;
}