"use client";

import { useCallback, useEffect, useState } from "react";
import { AppShell } from "@/components/app-shell";
import { useI18n } from "@/components/locale-provider";

type DocumentItem = {
  id: string; title: string; sourceUrl: string; contentType: string; language: string;
  sourceClass: string; topic: string; modules: string; verificationStatus: string;
  reviewStatus: string; severity: string; publishedAtUtc: string | null; retrievedAtUtc: string;
};
type AlertItem = { id: string; alertType: string; status: string; createdAtUtc: string; documentTitle: string; documentId: string };
type SourceItem = { id: string; code: string; name: string; url: string; sourceClass: string; isEnabled: boolean; pollIntervalMinutes: number; lastCheckedAtUtc: string | null; lastSuccessAtUtc: string | null; lastError: string | null };
type Overview = { documents: DocumentItem[]; alerts: AlertItem[]; sources: SourceItem[]; lastRun: { startedAtUtc: string; completedAtUtc: string | null; status: string; discoveredCount: number; newDocumentCount: number; errorMessage: string | null } | null; monitoringEnabled: boolean; monitoringStatus: string; pollingIntervalMinutes: number; canTriggerScan: boolean; canAcknowledgeAlerts: boolean };

function date(value: string | null, locale: "en" | "ar", locale) { return value ? new Intl.DateTimeFormat(locale === "ar" ? "ar-EG" : "en-GB", { dateStyle: "medium", timeStyle: "short" }).format(new Date(value)) : (locale === "ar" ? "غير متاح" : "Not available"); }

export default function RegulatoryIntelligencePage() {
  const { t, locale } = useI18n();
  const [data, setData] = useState<Overview | null>(null);
  const [loading, setLoading] = useState(true);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState("");
  const [message, setMessage] = useState("");

  const load = useCallback(async () => {
    try {
      const response = await fetch("/api/pharmacy-intelligence", { cache: "no-store" });
      const payload = await response.json();
      if (!response.ok) throw new Error(payload.error ?? "Could not load regulatory intelligence.");
      setData(payload); setError("");
    } catch (cause) { setError(cause instanceof Error ? cause.message : "Service unavailable."); }
    finally { setLoading(false); }
  }, []);

  useEffect(() => { void load(); const timer = window.setInterval(() => void load(), 60000); return () => window.clearInterval(timer); }, [load]);

  async function act(body: { action: "scan" } | { action: "acknowledge"; alertId: string }) {
    setBusy(true); setMessage(""); setError("");
    try {
      const response = await fetch("/api/pharmacy-intelligence", {
        method: "POST", headers: { "content-type": "application/json" }, body: JSON.stringify(body)
      });
      const payload = response.status === 204 ? null : await response.json().catch(() => null);
      if (!response.ok) throw new Error(payload?.error ?? (response.status === 403 ? "Administrator permission is required." : "Action failed."));
      setMessage(body.action === "scan" ? `Scan completed: ${payload?.newDocuments ?? 0} new documents from ${payload?.sourcesChecked ?? 0} sources.` : "Alert acknowledged.");
      await load();
    } catch (cause) { setError(cause instanceof Error ? cause.message : "Action failed."); }
    finally { setBusy(false); }
  }

  return <AppShell><div className="content">
    <section className="welcome-row">
      <div><p className="eyebrow">{t("PHARMACIES · REGULATORY INTELLIGENCE")}</p><h1>{t("Egypt market &")} <span>{t("regulatory updates" )}</span></h1>
      <p className="welcome-copy">{t("Automatic monitoring of published EDA notices, guidance, safety alerts and regulatory documents." )}</p></div>
      <div className="date-chip"><span className="date-dot" />{data?.monitoringEnabled ? t("SOURCE CHECKS ACTIVE") : t(data?.monitoringStatus?.toUpperCase() ?? "MONITOR STATUS UNAVAILABLE")}</div>
    </section>

    <section className="status-banner">
      <div className="status-banner-icon">◷</div>
      <div className="status-banner-copy"><strong>{t("Automatic EDA source checks" )}</strong><span>{t("Background worker checks configured EDA pages every 15 minutes and scans each source on its configured six-hour interval. New linked HTML/PDF material is retained with a SHA-256 fingerprint and creates an in-app review alert.")}</span></div>
      {data?.canTriggerScan && <button className="primary-button" disabled={busy} onClick={() => void act({ action: "scan" })}>{busy ? "Scanning…" : "Scan EDA now"}</button>}
    </section>

    {error && <section className="notice-panel" role="alert"><strong>{t("Monitoring issue")}</strong><p>{t(error)}</p></section>}
    {message && <section className="notice-panel"><strong>{t(message)}</strong></section>}
    <section className="bottom-grid">
      <article className="info-card"><div className="info-card-heading"><span>◈</span><strong>{t("Latest scan" )}</strong></div>
        <p className="muted">{data?.lastRun ? `${data.lastRun.status} · ${date(data.lastRun.completedAtUtc, locale)}` : "No completed scan recorded yet."}</p>
        <p className="muted">{data?.lastRun ? `${data.lastRun.discoveredCount} candidate links · ${data.lastRun.newDocumentCount} new documents` : "The first background scan runs when the API starts."}</p>
      </article>
      <article className="info-card"><div className="info-card-heading"><span>!</span><strong>{t("Unread alerts" )}</strong></div><p className="muted">{data?.alerts.length ?? 0} {t("alerts awaiting acknowledgement.")}</p><span className="safe-label">{t("HUMAN REVIEW REQUIRED")}</span></article>
    </section>

    <div className="section-heading"><div><p className="eyebrow">{t("SOURCE COVERAGE" )}</p><h2>{t("Configured EDA sources" )}</h2></div></div>
    <section className="sector-grid">
      {(data?.sources ?? []).map(source => <article className="sector-card" key={source.id}>
        <div className="sector-top"><span className="sector-symbol">◎</span><span className="sector-tag">SOURCE CLASS {source.sourceClass}</span></div>
        <h3>{source.name}</h3><p>Last checked: {date(source.lastCheckedAtUtc, locale)}</p>
        <p>{source.lastError ? `Last error: ${source.lastError}` : source.lastSuccessAtUtc ? `Last successful check: ${date(source.lastSuccessAtUtc, locale)}` : "Awaiting first successful check."}</p>
        <a className="text-link" href={source.url} target="_blank" rel="noreferrer">{t("Open official source ↗")}</a>
      </article>)}
    </section>

    <div className="section-heading"><div><p className="eyebrow">{t("REVIEW QUEUE" )}</p><h2>{t("New regulatory alerts" )}</h2></div></div>
    {loading ? <p className="muted">{t("Loading regulatory records…")}</p> : data?.alerts.length ? <section className="notice-panel">
      {data.alerts.map(alert => <div key={alert.id} style={{ display: "flex", justifyContent: "space-between", gap: 16, alignItems: "center", padding: "12px 0", borderBottom: "1px solid var(--border, #ddd)" }}>
        <div><strong>{alert.documentTitle}</strong><p className="muted">{alert.alertType} · {date(alert.createdAtUtc, locale)}</p></div>
        {data?.canAcknowledgeAlerts ? <button className="subtle-button" disabled={busy} onClick={() => void act({ action: "acknowledge", alertId: alert.id })}>{t("Acknowledge" )}</button> : <span className="muted">{t("Administrator review access required")}</span>}
      </div>)}
    </section> : <p className="muted">{t("No unread alerts currently recorded." )}</p>}

    <div className="section-heading"><div><p className="eyebrow">{t("INGESTED EVIDENCE" )}</p><h2>{t("Recent documents" )}</h2></div></div>
    <section className="notice-panel">
      {(data?.documents ?? []).length ? data!.documents.map(doc => <article key={doc.id} style={{ padding: "14px 0", borderBottom: "1px solid var(--border, #ddd)" }}>
        <strong>{doc.title}</strong><p className="muted">{doc.topic} · Class {doc.sourceClass} · {doc.language.toUpperCase()} · {doc.reviewStatus} · {doc.severity}</p>
        <p className="muted">Modules: {doc.modules} · Retrieved: {date(doc.retrievedAtUtc, locale)}</p>
        <a className="text-link" href={`/api/pharmacy-intelligence/documents/${doc.id}/content`}>{t("Download ingested copy ↓")}</a> · <a className="text-link" href={doc.sourceUrl} target="_blank" rel="noreferrer">{t("Open source publication ↗")}</a>
      </article>) : <p className="muted">{t("No documents ingested yet. Check source connectivity and scan history.")}</p>}
    </section>
    <section className="notice-panel"><strong>{t("Important: ingestion is not approval." )}</strong><p>{t("Every imported item starts unverified and pending review. This feature does not determine legal applicability, make clinical decisions, or change medicine prices, dispensing, stock, reimbursement or accounting. EDA page structure and access may change; failed sources remain visible for follow-up.")}</p></section>
  </div></AppShell>;
}
