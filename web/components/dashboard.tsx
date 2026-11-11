"use client";
import { useEffect, useState } from "react";
import Link from "next/link";
import { AppShell } from "@/components/app-shell";
type SystemStatus = { api: string; database: string; checkedAt: string };
const locations = [
  { code: "WH-01", name: "Mokattam", type: "Main warehouse", detail: "Central stock location" },
  { code: "PH-02", name: "Student Hospital", type: "Pharmacy branch", detail: "Branch inventory workspace" },
  { code: "PH-03", name: "Qasr El-Aini Hospital", type: "Pharmacy branch", detail: "Branch inventory workspace" },
  { code: "PH-04", name: "Manial Hospital", type: "Pharmacy branch", detail: "Branch inventory workspace" }
];
function Dot({ ok }: { ok: boolean }) { return <span className={`status-dot ${ok ? "is-ok" : "is-warn"}`} aria-hidden="true" />; }
export default function Dashboard() {
  const [status, setStatus] = useState<SystemStatus | null>(null);
  useEffect(() => {
    let active = true;
    const check = async () => {
      try { const response = await fetch("/api/system-status", { cache: "no-store" }); const data = await response.json(); if (active) setStatus(data); }
      catch { if (active) setStatus({ api: "unreachable", database: "not_verified", checkedAt: new Date().toISOString() }); }
    };
    void check();
    const timer = window.setInterval(check, 15000);
    return () => { active = false; window.clearInterval(timer); };
  }, []);
  return <AppShell><div className="content">
    <section className="welcome-row"><div><p className="eyebrow">SPECIAL GROUP · BUSINESS OPERATIONS</p><h1>Welcome back. <span>Your workspace is ready.</span></h1><p className="welcome-copy">A connected starting point for Pharmacies and Specialized Contracting.</p></div><div className="date-chip"><span className="date-dot" />AUTHENTICATED WORKSPACE</div></section>
    <section className="status-banner"><div className="status-banner-icon">⌁</div><div className="status-banner-copy"><strong>Platform foundation</strong><span>PostgreSQL is a required API dependency. The API is the only application path to PostgreSQL; readiness verifies both application and Identity data contexts.</span></div><div className="connection-list"><div><Dot ok={status?.api === "online"} /><span>API</span><strong>{status?.api ?? "Checking"}</strong></div><div><Dot ok={status?.database === "connected"} /><span>Database</span><strong>{status?.database === "not_verified" ? "Not verified (API offline)" : status?.database ?? "Checking"}</strong></div></div></section>
    <div className="section-heading"><div><p className="eyebrow">YOUR ORGANIZATION</p><h2>Business sectors</h2></div><Link className="text-link" href="/organization">Manage organization ↗</Link></div>
    <section className="sector-grid">
      <article className="sector-card pharmacy-card"><div className="sector-top"><span className="sector-symbol">✚</span><span className="sector-tag">SECTOR 01</span></div><h3>Pharmacies</h3><p>Organization reference data and future pharmacy operations in one workspace.</p><div className="sector-meta"><span>4 initial locations</span><Link className="text-link" href="/pharmacies">Open workspace ↗</Link></div></article>
      <article className="sector-card contracting-card"><div className="sector-top"><span className="sector-symbol">⌂</span><span className="sector-tag">SECTOR 02</span></div><h3>Specialized Contracting</h3><p>A separate business domain with its own future project and commercial controls.</p><div className="sector-meta"><span>Foundation only</span><Link className="text-link" href="/contracting">Open workspace ↗</Link></div></article>
    </section>
    <section className="locations-section"><div className="section-heading compact"><div><p className="eyebrow">PHARMACY NETWORK</p><h2>Registered locations</h2></div><Link className="text-link" href="/organization">Open location register ↗</Link></div><div className="location-grid">{locations.map(loc => <article className="location-card" key={loc.code}><div className="location-icon">{loc.code.startsWith("WH") ? "▤" : "✚"}</div><div className="location-info"><strong>{loc.name}</strong><span>{loc.type}</span><small>{loc.detail}</small></div><span className="location-code">{loc.code}</span></article>)}</div></section>
    <section className="bottom-grid"><article className="info-card"><div className="info-card-heading"><span>◈</span><strong>Organization workspace</strong></div><p className="muted">View the owner-provided sectors and locations, add or edit location records when your account has the separately configured organization-manager permission, and deactivate records without deleting history.</p><Link className="text-link" href="/organization">Open organization workspace ↗</Link></article><article className="info-card"><div className="info-card-heading"><span>◷</span><strong>Operational safety</strong></div><p className="muted">No inventory movements, patient records, financial calculations or accounting postings are enabled in this phase.</p><span className="safe-label">CONTROLLED FOUNDATION</span></article></section>
    <footer className="footer"><span>© {new Date().getFullYear()} Special Group</span><span>SGSCTR · ASP.NET Core 10 · Next.js</span></footer>
  </div></AppShell>;
}
