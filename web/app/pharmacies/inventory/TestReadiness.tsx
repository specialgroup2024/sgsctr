"use client";

import { useCallback, useEffect, useState } from "react";
import { useI18n } from "@/components/locale-provider";

type Execution = {
  status: "Passed" | "Failed" | "Blocked";
  environment: string;
  evidenceReference: string | null;
  notes: string | null;
  executedAtUtc: string;
  executedBySubject: string;
};
type TestCase = {
  id: string;
  gateCode: string;
  testCode: string;
  title: string;
  objective: string;
  expectedResult: string;
  testMode: "Automated" | "Manual";
  executionBlocked: boolean;
  blockReason: string | null;
  latestExecution: Execution | null;
};
type Payload = { canRecordResults: boolean; testCases: TestCase[] };
type Draft = { status: "Passed" | "Failed" | "Blocked"; evidenceReference: string; notes: string };

const initialDraft: Draft = { status: "Passed", evidenceReference: "", notes: "" };

export default function TestReadiness() {
  const { t, locale } = useI18n();
  const [payload, setPayload] = useState<Payload | null>(null);
  const [drafts, setDrafts] = useState<Record<string, Draft>>({});
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState("");
  const [error, setError] = useState("");
  const [message, setMessage] = useState("");

  const load = useCallback(async () => {
    setLoading(true);
    setError("");
    try {
      const response = await fetch("/api/pharmacy/test-readiness", { cache: "no-store" });
      if (response.status === 401) { window.location.assign("/login"); return; }
      const body = await response.json().catch(() => null);
      if (!response.ok) throw new Error(body?.error ?? "Test readiness could not be loaded.");
      setPayload(body as Payload);
    } catch (e) {
      setError(e instanceof Error ? e.message : "Test readiness could not be loaded.");
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => { void load(); }, [load]);

  const save = async (test: TestCase) => {
    const draft = drafts[test.id] ?? initialDraft;
    setSaving(test.id); setError(""); setMessage("");
    try {
      const response = await fetch("/api/pharmacy/test-readiness", {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({
          testCaseId: test.id, status: test.executionBlocked ? "Blocked" : draft.status,
          evidenceReference: draft.evidenceReference, notes: draft.notes
        })
      });
      const body = await response.json().catch(() => null);
      if (!response.ok) throw new Error(body?.detail ?? body?.error ?? "Test result could not be recorded.");
      setMessage("Test execution recorded in PostgreSQL. Approval statuses were not changed.");
      await load();
    } catch (e) {
      setError(e instanceof Error ? e.message : "Test result could not be recorded.");
    } finally {
      setSaving("");
    }
  };

  const cases = payload?.testCases ?? [];
  const passed = cases.filter(x => x.latestExecution?.status === "Passed").length;
  const failed = cases.filter(x => x.latestExecution?.status === "Failed").length;
  const blocked = cases.filter(x => x.executionBlocked || x.latestExecution?.status === "Blocked").length;

  return <section className="inventory-workspace-panel">
    <div className="inventory-section-heading">
      <div>
        <p className="eyebrow">{t("QUALITY · TEST EXECUTION")}</p>
        <h2>{t("Test readiness" )}</h2>
        <p>{t("Version-controlled test cases are stored in PostgreSQL. Results are append-only and separate from professional approvals.")}</p>
      </div>
      <button className="inventory-refresh" type="button" onClick={() => void load()} disabled={loading}>{t("Refresh")}</button>
    </div>
    <div className="inventory-gate" role="note">
      <span className="inventory-gate-icon">!</span>
      <div>
        <strong>{t("A passed test is not a professional approval or release authorization.")}</strong>
        <p>{t("Blocked tests cannot be marked Passed or Failed. Results can be recorded only by an Administrator in Development; production approval decisions remain in the separate approval register.")}</p>
      </div>
    </div>
    <div className="inventory-kpi-grid test-readiness-summary">
      <article className="inventory-kpi"><span>{t("Test cases" )}</span><strong>{loading ? "…" : cases.length}</strong><small>{t("Across platform and seven approval gates")}</small></article>
      <article className="inventory-kpi"><span>{t("Latest passed" )}</span><strong>{passed}</strong><small>{t("Requires evidence reference" )}</small></article>
      <article className="inventory-kpi"><span>{t("Latest failed" )}</span><strong>{failed}</strong><small>{t("Needs corrective action" )}</small></article>
      <article className="inventory-kpi"><span>{t("Blocked" )}</span><strong>{blocked}</strong><small>{t("Professional, owner or implementation gate" )}</small></article>
    </div>
    {error && <p className="form-error" role="alert">{t(error)}</p>}
    {message && <p className="catalogue-id-note" role="status">{message}</p>}
    {loading && <p className="loading-state">{t("Loading test cases from PostgreSQL…" )}</p>}
    {!loading && !error && <div className="test-readiness-list">
      {cases.map(test => {
        const draft = drafts[test.id] ?? initialDraft;
        const latest = test.latestExecution;
        return <article className="inventory-panel test-readiness-card" key={test.testCode}>
          <div className="inventory-panel-heading">
            <div><p className="eyebrow">{test.gateCode} · {test.testCode}</p><h3>{test.title}</h3></div>
            <span className={"inventory-status-chip " + (latest?.status === "Passed" ? "approval-recorded" : latest?.status === "Failed" ? "approval-pending" : "approval-pending")}>{t(latest?.status ?? (test.executionBlocked ? "Blocked" : "Not run"))}</span>
          </div>
          <p>{test.objective}</p>
          <p><strong>{t("Expected result:" )}</strong> {test.expectedResult}</p>
          <p className="catalogue-footer-note"><strong>{t("Test type:" )}</strong> {t(test.testMode)}</p>
          {test.executionBlocked && <div className="inventory-gate"><span className="inventory-gate-icon">!</span><div><strong>{t("Execution blocked" )}</strong><p>{test.blockReason}</p></div></div>}
          {latest && <div className="catalogue-id-note">
            <strong>{t("Latest execution:" )}</strong> {t(latest.status)} · {latest.environment} · {new Date(latest.executedAtUtc).toLocaleString(locale === "ar" ? "ar-EG" : "en-GB")}
            <p>{t("Executed by subject:")} <code>{latest.executedBySubject}</code></p>
            {latest.evidenceReference && <p>{t("Evidence:")} <code>{latest.evidenceReference}</code></p>}
            {latest.notes && <p>{latest.notes}</p>}
          </div>}
          {payload?.canRecordResults && <form className="test-readiness-form" onSubmit={event => { event.preventDefault(); void save(test); }}>
            <label>Result
              <select value={test.executionBlocked ? "Blocked" : draft.status} disabled={test.executionBlocked}
                onChange={event => setDrafts(current => ({ ...current, [test.id]: { ...draft, status: event.target.value as Draft["status"] } }))}>
                <option value="Passed">{t("Passed" )}</option><option value="Failed">{t("Failed" )}</option><option value="Blocked">{t("Blocked" )}</option>
              </select>
            </label>
            <label>{t("Evidence reference")}
              <input maxLength={500} value={draft.evidenceReference} placeholder={t("CI run, test report or evidence ID")}
                onChange={event => setDrafts(current => ({ ...current, [test.id]: { ...draft, evidenceReference: event.target.value } }))} />
            </label>
            <label>{t("Notes")}
              <textarea maxLength={2000} rows={2} value={draft.notes} placeholder={t("Required for failed or blocked tests")}
                onChange={event => setDrafts(current => ({ ...current, [test.id]: { ...draft, notes: event.target.value } }))} />
            </label>
            <button className="inventory-refresh" type="submit" disabled={saving === test.id}>{saving === test.id ? "Recording…" : "Record test result"}</button>
          </form>}
        </article>;
      })}
    </div>}
    {!payload?.canRecordResults && !loading && <p className="catalogue-footer-note">{t("Result entry is available to an authenticated Administrator only in the Development environment. This view remains read-only otherwise.")}</p>}
  </section>;
}
