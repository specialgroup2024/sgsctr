"use client";

import { useCallback, useEffect, useState } from "react";
import { useI18n } from "@/components/locale-provider";

type AssuranceCase = {
  id: string;
  caseType: string;
  status: string;
  requestedAtUtc: string;
  reason: string;
  scopeReference: string | null;
  evidenceId: string | null;
  blockerCode: string | null;
  requestedBySubject: string;
};

const caseTypes = [
  ["LegalLicenceVerification", "Legal / licence verification"],
  ["DueDiligenceExecution", "Due-diligence execution"],
  ["ReviewerAuthorityApplication", "Reviewer authority application"],
  ["QualificationReview", "Supplier qualification review"],
  ["PurchasingEligibilityEvaluation", "Purchasing eligibility evaluation"],
  ["ReceivingEligibilityEvaluation", "Receiving eligibility evaluation"]
] as const;

type EvidenceReference = { id: string; title: string; evidenceKind: string; verificationStatus: string; expiresOn: string | null };
type Props = { supplierId: string; canManage: boolean; evidence: EvidenceReference[] };

export default function SupplierAssuranceWorkflows({ supplierId, canManage, evidence }: Props) {
  const { t } = useI18n();
  const [items, setItems] = useState<AssuranceCase[]>([]);
  const [caseType, setCaseType] = useState<string>(caseTypes[0][0]);
  const [reason, setReason] = useState("");
  const [scopeReference, setScopeReference] = useState("");
  const [evidenceId, setEvidenceId] = useState("");
  const [busy, setBusy] = useState(false);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [notice, setNotice] = useState("");

  const load = useCallback(async () => {
    setLoading(true);
    setError("");
    try {
      const response = await fetch(`/api/pharmacy/suppliers/${encodeURIComponent(supplierId)}/assurance-cases`, { cache: "no-store" });
      if (response.status === 401) { window.location.assign("/login"); return; }
      if (!response.ok) throw new Error(`Assurance queue could not be loaded (${response.status}).`);
      setItems(await response.json() as AssuranceCase[]);
    } finally {
      setLoading(false);
    }
  }, [supplierId]);

  useEffect(() => {
    void load().catch(e => setError(e instanceof Error ? e.message : "Unable to load assurance queue."));
  }, [load]);

  async function submit(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault(); setBusy(true); setError(""); setNotice("");
    try {
      const response = await fetch(`/api/pharmacy/suppliers/${encodeURIComponent(supplierId)}/assurance-cases`, {
        method: "POST", headers: { "content-type": "application/json" },
        body: JSON.stringify({ caseType, reason, scopeReference: scopeReference || null, evidenceId: evidenceId || null })
      });
      const payload = await response.json().catch(() => null);
      if (!response.ok) throw new Error(payload?.error ?? payload?.title ?? `Request failed (${response.status}).`);
      setReason(""); setScopeReference(""); setEvidenceId("");
      await load();
      setNotice(t("Supplier assurance work request saved. No verification, qualification or eligibility decision was made."));
    } catch (e) { setError(e instanceof Error ? e.message : "Assurance request could not be saved."); }
    finally { setBusy(false); }
  }

  return <section className="inventory-panel" style={{ marginTop: 18 }}>
    <div className="inventory-panel-heading"><div><p className="eyebrow">{t("SUPPLIER ASSURANCE")}</p><h3>{t("Verification, qualification and eligibility workflows")}</h3></div><div className="inventory-panel-heading-actions"><span className="inventory-count">{items.length}</span><button type="button" className="subtle-button" onClick={() => void load().catch(e => setError(e instanceof Error ? e.message : "Unable to load assurance queue."))} disabled={loading}>{t("Refresh")}</button></div></div>
    <p className="catalogue-footer-note">{t("These are controlled work requests, not approvals. Verification, qualification and reviewer authority remain pending until qualified reviewers, approved criteria and supporting evidence are recorded. Purchasing and receiving eligibility are deny-by-default. No PO, receipt, stock or financial transaction is triggered here.")}</p>
    {error && <p className="form-error" role="alert">{t(error)}</p>}
    {notice && <p className="form-success" role="status">{notice}</p>}
    {canManage && <form className="location-form catalogue-form" onSubmit={submit}>
      <div className="form-grid">
        <label>{t("Workflow")}<select value={caseType} onChange={e => setCaseType(e.target.value)}>
          {caseTypes.map(([value, label]) => <option key={value} value={value}>{t(label)}</option>)}
        </select></label>
        <label>{t("Scope reference (optional)")}<input maxLength={200} value={scopeReference} onChange={e => setScopeReference(e.target.value)} /></label>
        <label>{t("Related evidence (optional)")}<select value={evidenceId} onChange={e => setEvidenceId(e.target.value)}><option value="">{t("No evidence linked")}</option>{evidence.map(item => <option key={item.id} value={item.id}>{item.title} · {item.evidenceKind} · {t(item.verificationStatus)}{item.expiresOn ? " · " + item.expiresOn : ""}</option>)}</select></label>
        <label className="wide-field">{t("Reason")}<input required maxLength={500} value={reason} onChange={e => setReason(e.target.value)} /></label>
      </div>
      <button className="primary-button" type="submit" disabled={busy || loading}>{busy ? t("Saving…") : t("Create assurance work request")}</button>
    </form>}
    {loading ? <p className="loading-state">{t("Loading assurance work requests…")}</p> : items.length ? <div className="register-table-wrap"><table className="register-table">
      <thead><tr><th>{t("Workflow")}</th><th>{t("Status")}</th><th>{t("Requested")}</th><th>{t("Linked evidence")}</th><th>{t("Blocker")}</th><th>{t("Reason")}</th></tr></thead>
      <tbody>{items.map(item => <tr key={item.id}><td>{t(caseTypes.find(x => x[0] === item.caseType)?.[1] ?? item.caseType)}</td><td>{t(item.status)}</td><td>{new Date(item.requestedAtUtc).toLocaleString()}</td><td>{item.evidenceId ? evidence.find(reference => reference.id === item.evidenceId)?.title ?? t("Evidence reference unavailable") : "—"}</td><td>{item.blockerCode ? t("Policy and qualification approvals are not recorded.") : "—"}</td><td>{item.reason}</td></tr>)}</tbody>
    </table></div> : <p className="inventory-empty">{t("No assurance work requests have been created.")}</p>}
  </section>;
}
