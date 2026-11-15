"use client";

import { useCallback, useEffect, useState } from "react";
import { useI18n } from "@/components/locale-provider";
import SupplierOnboardingIntake from "./SupplierOnboardingIntake";
import SupplierAssuranceWorkflows from "./SupplierAssuranceWorkflows";
import type { FormEvent } from "react";

type Supplier = {
  id: string; code: string; displayName: string; status: string; version: number;
  createdAtUtc: string; evidenceCount: number; pendingReviewCount: number;
};
type Evidence = {
  id: string; evidenceKind: string; title: string; issuer: string | null;
  referenceNumber: string | null; sourceReference: string | null;
  issuedOn: string | null; expiresOn: string | null; verificationStatus: string;
  addedAtUtc: string; changeReason: string;
};
type SupplierDetail = {
  id: string; code: string; displayName: string; status: string; version: number;
  createdAtUtc: string; updatedAtUtc: string; changeReason: string; evidence: Evidence[];
  declarations: Array<{ id: string; claimType: string; declaredValue: string; provenance: string; reviewStatus: string; addedAtUtc: string; changeReason: string }>;
  businessContacts: Array<{ id: string; channelType: string; channelValue: string; departmentLabel: string; addedAtUtc: string; changeReason: string }>;
  dueDiligenceCases: Array<{ id: string; status: string; requestedAtUtc: string; requestReason: string }>;
  reviewRequests: Array<{ id: string; status: string; requestedAtUtc: string; reason: string }>;
};
type ReviewItem = { id: string; supplierId: string; supplierCode: string; supplierName: string; requestedAtUtc: string; reason: string };
type Permission = { canManage: boolean };

async function payload<T>(response: Response): Promise<T> {
  const body = await response.json().catch(() => null);
  if (!response.ok) throw new Error(body?.error ?? body?.title ?? `Request failed (${response.status}).`);
  return body as T;
}

export default function SupplierRegister() {
  const { t } = useI18n();
  const [suppliers, setSuppliers] = useState<Supplier[]>([]);
  const [selected, setSelected] = useState<SupplierDetail | null>(null);
  const [queue, setQueue] = useState<ReviewItem[]>([]);
  const [canManage, setCanManage] = useState(false);
  const [code, setCode] = useState("");
  const [displayName, setDisplayName] = useState("");
  const [changeReason, setChangeReason] = useState("");
  const [evidenceKind, setEvidenceKind] = useState("");
  const [evidenceTitle, setEvidenceTitle] = useState("");
  const [issuer, setIssuer] = useState("");
  const [referenceNumber, setReferenceNumber] = useState("");
  const [sourceReference, setSourceReference] = useState("");
  const [issuedOn, setIssuedOn] = useState("");
  const [expiresOn, setExpiresOn] = useState("");
  const [evidenceReason, setEvidenceReason] = useState("");
  const [reviewReason, setReviewReason] = useState("");
  const [loading, setLoading] = useState(true);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState("");
  const [notice, setNotice] = useState("");

  const load = useCallback(async () => {
    setLoading(true); setError("");
    try {
      const [s, q, p] = await Promise.all([
        fetch("/api/pharmacy/suppliers", { cache: "no-store" }),
        fetch("/api/pharmacy/suppliers/review-requests", { cache: "no-store" }),
        fetch("/api/pharmacy/suppliers/permissions", { cache: "no-store" })
      ]);
      if ([s, q, p].some(x => x.status === 401)) { window.location.assign("/login"); return; }
      const [supplierRows, reviewRows, access] = await Promise.all([
        payload<Supplier[]>(s), payload<ReviewItem[]>(q), payload<Permission>(p)
      ]);
      setSuppliers(supplierRows); setQueue(reviewRows); setCanManage(access.canManage === true);
    } catch (e) { setError(e instanceof Error ? e.message : t("Supplier records could not be loaded.")); }
    finally { setLoading(false); }
  }, [t]);

  useEffect(() => { void load(); }, [load]);

  async function openSupplier(id: string) {
    setError(""); setNotice("");
    try {
      const detail = await payload<SupplierDetail>(await fetch(`/api/pharmacy/suppliers/${encodeURIComponent(id)}`, { cache: "no-store" }));
      setSelected(detail);
    } catch (e) { setError(e instanceof Error ? e.message : t("Supplier details could not be loaded.")); }
  }

  async function createSupplier(event: FormEvent<HTMLFormElement>) {
    event.preventDefault(); setBusy(true); setError(""); setNotice("");
    try {
      const result = await payload<{ id: string }>(await fetch("/api/pharmacy/suppliers", {
        method: "POST", headers: { "content-type": "application/json" },
        body: JSON.stringify({ code, displayName, changeReason })
      }));
      setCode(""); setDisplayName(""); setChangeReason("");
      await load(); await openSupplier(result.id); setNotice(t("Supplier draft created. It is not qualified or approved."));
    } catch (e) { setError(e instanceof Error ? e.message : t("Supplier draft could not be saved.")); }
    finally { setBusy(false); }
  }

  async function addEvidence(event: FormEvent<HTMLFormElement>) {
    event.preventDefault(); if (!selected) return;
    setBusy(true); setError(""); setNotice("");
    try {
      await payload<{ id: string }>(await fetch(`/api/pharmacy/suppliers/${encodeURIComponent(selected.id)}/evidence`, {
        method: "POST", headers: { "content-type": "application/json" },
        body: JSON.stringify({
          evidenceKind, title: evidenceTitle, issuer: issuer || null,
          referenceNumber: referenceNumber || null, sourceReference: sourceReference || null,
          issuedOn: issuedOn || null, expiresOn: expiresOn || null, changeReason: evidenceReason
        })
      }));
      setEvidenceKind(""); setEvidenceTitle(""); setIssuer(""); setReferenceNumber("");
      setSourceReference(""); setIssuedOn(""); setExpiresOn(""); setEvidenceReason("");
      await openSupplier(selected.id); await load(); setNotice(t("Evidence reference saved as unverified."));
    } catch (e) { setError(e instanceof Error ? e.message : t("Evidence reference could not be saved.")); }
    finally { setBusy(false); }
  }

  async function requestReview(event: FormEvent<HTMLFormElement>) {
    event.preventDefault(); if (!selected) return;
    setBusy(true); setError(""); setNotice("");
    try {
      await payload<{ id: string }>(await fetch(`/api/pharmacy/suppliers/${encodeURIComponent(selected.id)}/review-requests`, {
        method: "POST", headers: { "content-type": "application/json" },
        body: JSON.stringify({ reason: reviewReason })
      }));
      setReviewReason(""); await openSupplier(selected.id); await load();
      setNotice(t("Review request queued. No qualification decision has been made."));
    } catch (e) { setError(e instanceof Error ? e.message : t("Review request could not be submitted.")); }
    finally { setBusy(false); }
  }

  return <div className="catalogue-manager">
    <div className="inventory-gate"><span className="inventory-gate-icon">!</span><div>
      <strong>{t("Supplier directory · draft and unverified only")}</strong>
      <p>{t("This register captures supplier names and evidence references only. It does not verify licences, approve suppliers, authorize purchasing or permit supplier transmission.")}</p>
    </div></div>
    {error && <p className="form-error" role="alert">{t(error)}</p>}
    {notice && <p className="form-success" role="status">{t(notice)}</p>}
    <section className="catalogue-layout">
      <div className="inventory-panel">
        <div className="inventory-panel-heading"><div><p className="eyebrow">{t("PERSISTENT REFERENCE DATA")}</p><h3>{t("Supplier records")}</h3></div><span className="inventory-count">{suppliers.length}</span></div>
        {loading ? <p className="loading-state">{t("Loading supplier records…")}</p> :
          suppliers.length ? <div className="register-table-wrap"><table className="register-table"><thead><tr><th>{t("Code")}</th><th>{t("Supplier name")}</th><th>{t("Status")}</th><th>{t("Evidence")}</th><th>{t("Action")}</th></tr></thead><tbody>
            {suppliers.map(row => <tr key={row.id} className={selected?.id === row.id ? "catalogue-selected-row" : ""}>
              <td><code>{row.code}</code></td><td><strong>{row.displayName}</strong></td>
              <td><span className="inventory-state-tag">{t("DRAFT")}</span></td><td>{row.evidenceCount}</td>
              <td><button type="button" className="table-action" onClick={() => void openSupplier(row.id)}>{t("View")}</button></td>
            </tr>)}
          </tbody></table></div> : <p className="inventory-empty">{t("No supplier drafts have been created.")}</p>}
      </div>
      <div className="inventory-panel">
        <div className="inventory-panel-heading"><div><p className="eyebrow">{t("CREATE REFERENCE")}</p><h3>{t("New supplier draft")}</h3></div></div>
        {canManage ? <form className="location-form catalogue-form" onSubmit={createSupplier}>
          <div className="form-grid">
            <label>{t("Supplier code")}<input required maxLength={32} value={code} onChange={e => setCode(e.target.value)} /></label>
            <label>{t("Supplier name")}<input required maxLength={200} value={displayName} onChange={e => setDisplayName(e.target.value)} /></label>
            <label className="wide-field">{t("Change reason")}<input required maxLength={500} value={changeReason} onChange={e => setChangeReason(e.target.value)} /></label>
          </div>
          <button className="primary-button" type="submit" disabled={busy}>{t("Create supplier draft")}</button>
        </form> : <p className="inventory-empty">{t("Supplier changes require the Administrator role. Your account currently has read-only access.")}</p>}
      </div>
    </section>

    {selected && <section className="inventory-panel" style={{ marginTop: 18 }}>
      <div className="inventory-panel-heading"><div><p className="eyebrow">{t("SUPPLIER RECORD")}</p><h3>{selected.code} · {selected.displayName}</h3></div><span className="inventory-state-tag">{t("DRAFT")}</span></div>
      <p className="catalogue-footer-note">{t("Supplier identity is a draft. Evidence is unverified. Review requests do not approve or qualify a supplier.")}</p>
      <div className="inventory-panel-heading" style={{ marginTop: 18 }}><div><p className="eyebrow">{t("EVIDENCE REFERENCES")}</p><h3>{t("Evidence")}</h3></div></div>
      {selected.evidence.length ? <div className="register-table-wrap"><table className="register-table"><thead><tr><th>{t("Evidence type")}</th><th>{t("Title")}</th><th>{t("Reference")}</th><th>{t("Verification")}</th></tr></thead><tbody>
        {selected.evidence.map(item => <tr key={item.id}><td>{item.evidenceKind}</td><td>{item.title}</td><td>{item.referenceNumber ?? item.sourceReference ?? "—"}</td><td>{t("UNVERIFIED")}</td></tr>)}
      </tbody></table></div> : <p className="inventory-empty">{t("No evidence references have been recorded.")}</p>}
      {canManage && <form className="location-form catalogue-form" onSubmit={addEvidence}>
        <div className="form-heading"><strong>{t("Add evidence reference")}</strong><span className="inventory-state-tag">{t("UNVERIFIED")}</span></div>
        <div className="form-grid">
          <label>{t("Evidence type")}<input required maxLength={80} value={evidenceKind} onChange={e => setEvidenceKind(e.target.value)} /></label>
          <label>{t("Evidence title")}<input required maxLength={200} value={evidenceTitle} onChange={e => setEvidenceTitle(e.target.value)} /></label>
          <label>{t("Issuer (optional)")}<input maxLength={200} value={issuer} onChange={e => setIssuer(e.target.value)} /></label>
          <label>{t("Reference number (optional)")}<input maxLength={120} value={referenceNumber} onChange={e => setReferenceNumber(e.target.value)} /></label>
          <label className="wide-field">{t("Source reference (URL or document reference)") }<input maxLength={1000} value={sourceReference} onChange={e => setSourceReference(e.target.value)} /></label>
          <label>{t("Issued on")}<input type="date" value={issuedOn} onChange={e => setIssuedOn(e.target.value)} /></label>
          <label>{t("Expires on")}<input type="date" value={expiresOn} onChange={e => setExpiresOn(e.target.value)} /></label>
          <label className="wide-field">{t("Change reason")}<input required maxLength={500} value={evidenceReason} onChange={e => setEvidenceReason(e.target.value)} /></label>
        </div>
        <button className="primary-button" type="submit" disabled={busy}>{t("Save unverified evidence")}</button>
      </form>}
      {selected.declarations.length > 0 && <>
        <div className="inventory-panel-heading" style={{ marginTop: 18 }}><div><p className="eyebrow">{t("OWNER-PROVIDED CLAIMS")}</p><h3>{t("Declared identity and licence details")}</h3></div></div>
        <div className="register-table-wrap"><table className="register-table"><thead><tr><th>{t("Field")}</th><th>{t("Declared value")}</th><th>{t("Review status")}</th></tr></thead><tbody>
          {selected.declarations.map(item => <tr key={item.id}><td>{t(item.claimType)}</td><td>{item.declaredValue}</td><td>{t("UNVERIFIED")}</td></tr>)}
        </tbody></table></div>
      </>}
      {selected.businessContacts.length > 0 && <>
        <div className="inventory-panel-heading" style={{ marginTop: 18 }}><div><p className="eyebrow">{t("BUSINESS CHANNELS")}</p><h3>{t("Department contact channels")}</h3></div></div>
        <div className="register-table-wrap"><table className="register-table"><thead><tr><th>{t("Department")}</th><th>{t("Channel type")}</th><th>{t("Business channel value")}</th></tr></thead><tbody>
          {selected.businessContacts.map(item => <tr key={item.id}><td>{t(item.departmentLabel)}</td><td>{t(item.channelType)}</td><td>{item.channelValue}</td></tr>)}
        </tbody></table></div>
      </>}
      {selected.dueDiligenceCases.length > 0 && <p className="catalogue-footer-note">{t("Due-diligence intake")}: {selected.dueDiligenceCases.map(item => t(item.status)).join(", ")}. {t("No checks or qualification decision have been performed.")}</p>}
      <SupplierOnboardingIntake supplierId={selected.id} canManage={canManage} onSaved={() => openSupplier(selected.id)} />
      <SupplierAssuranceWorkflows supplierId={selected.id} canManage={canManage} />
      <form className="location-form catalogue-form" onSubmit={requestReview}>
        <div className="form-heading"><strong>{t("Request supplier review")}</strong><span className="inventory-state-tag">{t("PENDING")}</span></div>
        <div className="form-grid"><label className="wide-field">{t("Review reason")}<input required maxLength={500} value={reviewReason} onChange={e => setReviewReason(e.target.value)} /></label></div>
        <button className="primary-button" type="submit" disabled={busy || !canManage || selected.reviewRequests.some(x => x.status === "Pending")}>{t("Queue review request")}</button>
        {selected.reviewRequests.some(x => x.status === "Pending") && <p className="catalogue-footer-note">{t("A review request is already pending.")}</p>}
      </form>
      {selected.reviewRequests.length > 0 && <p className="catalogue-footer-note">{t("Review history")}: {selected.reviewRequests.map(x => x.status).join(", ")}</p>}
    </section>}

    <section className="inventory-panel" style={{ marginTop: 18 }}>
      <div className="inventory-panel-heading"><div><p className="eyebrow">{t("REVIEW QUEUE")}</p><h3>{t("Supplier review requests")}</h3></div><span className="inventory-count">{queue.length}</span></div>
      {queue.length ? <div className="register-table-wrap"><table className="register-table"><thead><tr><th>{t("Supplier")}</th><th>{t("Requested")}</th><th>{t("Reason")}</th><th>{t("Status")}</th></tr></thead><tbody>
        {queue.map(item => <tr key={item.id}><td><strong>{item.supplierCode} · {item.supplierName}</strong></td><td>{new Date(item.requestedAtUtc).toLocaleDateString()}</td><td>{item.reason}</td><td>{t("PENDING")}</td></tr>)}
      </tbody></table></div> : <p className="inventory-empty">{t("No supplier review requests are pending.")}</p>}
    </section>
  </div>;
}
