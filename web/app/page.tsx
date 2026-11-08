"use client";
import { useEffect, useState } from "react";
type SystemStatus = { api: string; database: string; checkedAt: string };
const locations = [
  { code: "WH-01", name: "Mokattam", type: "Main warehouse", detail: "Central stock location" },
  { code: "PH-02", name: "Student Hospital", type: "Pharmacy branch", detail: "Branch inventory workspace" },
  { code: "PH-03", name: "Qasr El-Aini Hospital", type: "Pharmacy branch", detail: "Branch inventory workspace" },
  { code: "PH-04", name: "Manial Hospital", type: "Pharmacy branch", detail: "Branch inventory workspace" },
];
function Dot({ ok }: { ok: boolean }) { return <span className={`status-dot ${ok ? "is-ok" : "is-warn"}`} />; }
export default function Home() {
  const [status, setStatus] = useState<SystemStatus | null>(null);
  useEffect(() => {
    let active = true;
    const check = async () => {
      try { const r = await fetch("/api/system-status", { cache: "no-store" }); const d = await r.json(); if (active) setStatus(d); }
      catch { if (active) setStatus({ api: "unreachable", database: "unknown", checkedAt: new Date().toISOString() }); }
    };
    void check(); const timer = window.setInterval(check, 15000);
    return () => { active = false; window.clearInterval(timer); };
  }, []);
  return <main className="app-shell">
    <aside className="sidebar">
      <a className="brand" href="#overview"><span className="brand-mark">SG</span><span><strong>SPECIAL GROUP</strong><small>OPERATIONS PLATFORM</small></span></a>
      <div className="nav-label">WORKSPACE</div>
      <nav className="nav-list" aria-label="Main navigation">
        <a className="nav-item active" href="#overview"><span className="nav-icon">▦</span>Overview</a>
        <a className="nav-item" href="#pharmacies"><span className="nav-icon">✚</span>Pharmacies</a>
        <a className="nav-item" href="#contracting"><span className="nav-icon">⌂</span>Specialized Contracting</a>
        <a className="nav-item" href="#system"><span className="nav-icon">◈</span>System status</a>
      </nav>
      <div className="sidebar-bottom"><div className="environment-card"><span className="environment-indicator" /><div><strong>LOCAL ENVIRONMENT</strong><small>Development workspace</small></div></div><small className="sidebar-foot">SGSCTR · Foundation UI</small></div>
    </aside>
    <section className="main-panel">
      <header className="topbar"><div className="breadcrumb">Workspace <span>/</span> Overview</div><div className="topbar-right"><span className="local-pill">LOCAL TEST</span><div className="avatar">SG</div></div></header>
      <div className="content">
        <section className="welcome-row" id="overview"><div><p className="eyebrow">SPECIAL GROUP · BUSINESS OPERATIONS</p><h1>Good day. <span>Your workspace is ready.</span></h1><p className="welcome-copy">A unified starting point for the Pharmacies and Specialized Contracting sectors.</p></div><div className="date-chip"><span className="date-dot" />DEVELOPMENT BUILD</div></section>
        <section className="status-banner" id="system"><div className="status-banner-icon">⌁</div><div className="status-banner-copy"><strong>Platform foundation</strong><span>Live connection checks against ASP.NET Core API and PostgreSQL.</span></div><div className="connection-list"><div><Dot ok={status?.api === "online"} /><span>API</span><strong>{status?.api ?? "Checking"}</strong></div><div><Dot ok={status?.database === "connected"} /><span>Database</span><strong>{status?.database ?? "Checking"}</strong></div></div></section>
        <div className="section-heading"><div><p className="eyebrow">YOUR ORGANIZATION</p><h2>Business sectors</h2></div><span className="section-note">Initial workspace · No operational data loaded</span></div>
        <section className="sector-grid">
          <article className="sector-card pharmacy-card"><div className="sector-top"><span className="sector-symbol">✚</span><span className="sector-tag">SECTOR 01</span></div><h3>Pharmacies</h3><p>Manage the pharmacy network, locations and future inventory operations from one connected workspace.</p><div className="sector-meta"><span>4 registered locations</span><span className="arrow">↗</span></div></article>
          <article className="sector-card contracting-card" id="contracting"><div className="sector-top"><span className="sector-symbol">⌂</span><span className="sector-tag">SECTOR 02</span></div><h3>Specialized Contracting</h3><p>A dedicated workspace for future projects, contracts, procurement, execution and cost control.</p><div className="sector-meta"><span>Module foundation only</span><span className="arrow">↗</span></div></article>
        </section>
        <section className="locations-section" id="pharmacies"><div className="section-heading compact"><div><p className="eyebrow">PHARMACY NETWORK</p><h2>Locations</h2></div><span className="section-note">Location register · Read-only preview</span></div><div className="location-grid">
          {locations.map((loc) => <article className="location-card" key={loc.code}><div className="location-icon">{loc.code.startsWith("WH") ? "▤" : "✚"}</div><div className="location-info"><strong>{loc.name}</strong><span>{loc.type}</span><small>{loc.detail}</small></div><span className="location-code">{loc.code}</span></article>)}
        </div></section>
        <section className="bottom-grid">
          <article className="info-card"><div className="info-card-heading"><span>◷</span><strong>Implementation progress</strong></div><p className="progress-title">Foundation stage</p><div className="progress-track"><span /></div><p className="muted">The UI is connected to the API. Business workflows remain disabled until their approval gates are complete.</p></article>
          <article className="info-card"><div className="info-card-heading"><span>◈</span><strong>Scope and safety</strong></div><p className="muted safety-copy">This is a local development interface. It contains no live stock balances, patient records, financial postings, authentication or production data.</p><span className="safe-label">DEVELOPMENT ONLY</span></article>
        </section>
        <footer className="footer"><span>© {new Date().getFullYear()} Special Group</span><span>SGSCTR · ASP.NET Core 10 · Next.js</span></footer>
      </div>
    </section>
  </main>;
}
