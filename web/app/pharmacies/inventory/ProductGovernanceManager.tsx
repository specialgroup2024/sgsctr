"use client";

import { useCallback, useEffect, useState } from "react";
import { useI18n } from "@/components/locale-provider";
import type { FormEvent } from "react";

type Family = { id: string; familyCode: string; reviewStatus: string; proposedAtUtc: string; proposedBySubject: string } | null;
type Identifier = { id: string; schemeCode: string; value: string; packagingLevel: string | null; verificationStatus: string; sourceUri: string | null; createdAtUtc: string };
type Evidence = { id: string; authorityCode: string; evidenceType: string; referenceNumber: string; documentUri: string | null; regulatoryDocumentId: string | null; publishedOn: string | null; effectiveFrom: string | null; expiresOn: string | null; verificationStatus: string; createdAtUtc: string };
type Lifecycle = { id: string; requestedAction: string; reviewStatus: string; reason: string; requestedAtUtc: string };
type Governance = { family: Family; identifiers: Identifier[]; evidence: Evidence[]; lifecycleRequests: Lifecycle[] };

async function readPayload<T>(response: Response): Promise<T> {
  const body = await response.json().catch(() => null);
  if (!response.ok) throw new Error(body?.error ?? body?.title ?? `Request failed (${response.status}).`);
  return body as T;
}

export default function ProductGovernanceManager({ productId, canManage }: { productId: string; canManage: boolean }) {
  const { t } = useI18n();
  const [data, setData] = useState<Governance | null>(null);
  const [familyCode, setFamilyCode] = useState("RegularMedicine");
  const [schemeCode, setSchemeCode] = useState("GTIN");
  const [identifierValue, setIdentifierValue] = useState("");
  const [packagingLevel, setPackagingLevel] = useState("");
  const [sourceUri, setSourceUri] = useState("");
  const [authorityCode, setAuthorityCode] = useState("EDA");
  const [evidenceType, setEvidenceType] = useState("Registration");
  const [referenceNumber, setReferenceNumber] = useState("");
  const [documentUri, setDocumentUri] = useState("");
  const [publishedOn, setPublishedOn] = useState("");
  const [effectiveFrom, setEffectiveFrom] = useState("");
  const [expiresOn, setExpiresOn] = useState("");
  const [lifecycleAction, setLifecycleAction] = useState("Activate");
  const [reason, setReason] = useState("");
  const [changeReason, setChangeReason] = useState("");
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState("");
  const [notice, setNotice] = useState("");

  const load = useCallback(async () => {
    if (!productId) { setData(null); return; }
    try {
      const response = await fetch(`/api/pharmacy/catalogue/${encodeURIComponent(productId)}/governance`, { cache: "no-store" });
      if (response.status === 401) { window.location.assign("/login"); return; }
      setData(await readPayload<Governance>(response));
    } catch (e) { setError(e instanceof Error ? e.message : "Product governance records could not be loaded."); }
  }, [productId]);

  useEffect(() => { void load(); }, [load]);

  async function submit(event: FormEvent<HTMLFormElement>, suffix: string, body: Record<string, unknown>, success: string) {
    event.preventDefault(); setBusy(true); setError(""); setNotice("");
    try {
      await readPayload(await fetch(`/api/pharmacy/catalogue/${encodeURIComponent(productId)}/${suffix}`, {
        method: "POST", headers: { "content-type": "application/json" }, body: JSON.stringify(body)
      }));
      await load(); setNotice(success);
    } catch (e) { setError(e instanceof Error ? e.message : "The record could not be saved."); }
    finally { setBusy(false); }
  }

  if (!productId) return <section className="inventory-panel"><h3>{t("Product regulatory profile")}</h3><p className="inventory-empty">{t("Select a product to manage its provisional family, identifiers and evidence.")}</p></section>;

  return <section className="inventory-panel">
    <div className="inventory-panel-heading"><div><p className="eyebrow">{t("REGULATORY PROFILE · REVIEW QUEUE")}</p><h3>{t("Family, identifiers and evidence")}</h3></div><span className="inventory-state-tag">{t("UNVERIFIED")}</span></div>
    <div className="inventory-gate"><span className="inventory-gate-icon">!</span><div><strong>{t("All entries are proposals, not regulatory approvals")}</strong><p>{t("Family assignment and evidence remain pending qualified review. GTIN, UDI-DI and EDA registration/notification references are kept distinct. EPTTS serials, UDI-PI, lots and expiry are not product-level identifiers.")}</p></div></div>
    {error && <p className="form-error" role="alert">{t(error)}</p>}
    {notice && <p className="form-success" role="status">{notice}</p>}
    {data?.family ? <p className="catalogue-id-note">{t("Provisional family:")} <strong>{data.family.familyCode}</strong> · {t(data.family.reviewStatus)}</p> :
      canManage ? <form className="location-form catalogue-form" onSubmit={e => submit(e, "family", { familyCode, changeReason: changeReason || null }, "Provisional family assignment recorded for review.")}>
        <div className="form-grid"><label>{t("Provisional family")}<select value={familyCode} onChange={e => setFamilyCode(e.target.value)}><option value="RegularMedicine">{t("Regular medicines")}</option><option value="Chemotherapy">{t("Chemotherapy medicines (operational tag only)")}</option><option value="MedicalDevice">{t("Medical devices")}</option><option value="MedicalSupply">{t("Medical supplies")}</option><option value="Cosmetic">{t("Cosmetics")}</option></select></label><label>{t("Change reason")}<input maxLength={500} value={changeReason} onChange={e => setChangeReason(e.target.value)} /></label></div>
        <button className="primary-button" type="submit" disabled={busy}>{t("Submit family for review")}</button>
      </form> : <p className="inventory-empty">{t("No provisional family assignment.")}</p>}

    <div className="catalogue-layout catalogue-units-layout">
      <div className="inventory-panel">
        <h4>{t("External identifiers")}</h4>
        {data?.identifiers.map(x => <p className="catalogue-id-note" key={x.id}><strong>{x.schemeCode}</strong>: <code>{x.value}</code> · {t(x.verificationStatus)}{x.packagingLevel ? ` · ${x.packagingLevel}` : ""}</p>)}
        {!data?.identifiers.length && <p className="inventory-empty">{t("No identifier proposals recorded.")}</p>}
        {canManage && <form className="location-form catalogue-form" onSubmit={e => submit(e, "identifiers", { schemeCode, value: identifierValue, packagingLevel: packagingLevel || null, sourceUri: sourceUri || null, changeReason: changeReason || null }, "Identifier proposal saved as pending verification.")}>
          <div className="form-grid">
            <label>{t("Identifier system")}<select value={schemeCode} onChange={e => setSchemeCode(e.target.value)}><option value="GTIN">GTIN</option><option value="UDI-DI">UDI-DI</option><option value="EDA-Registration">{t("EDA registration")}</option><option value="EDA-Cosmetics-Notification">{t("EDA cosmetics notification")}</option></select></label>
            <label>{t("Identifier value")}<input required maxLength={160} value={identifierValue} onChange={e => setIdentifierValue(e.target.value)} /></label>
            <label>{t("Packaging level (unverified)")}<input maxLength={64} value={packagingLevel} onChange={e => setPackagingLevel(e.target.value)} /></label>
            <label>{t("Source URL (HTTPS)")}<input type="url" value={sourceUri} onChange={e => setSourceUri(e.target.value)} /></label>
          </div>
          <button className="primary-button" type="submit" disabled={busy}>{t("Add identifier proposal")}</button>
        </form>}
      </div>
      <div className="inventory-panel">
        <h4>{t("Regulatory evidence")}</h4>
        {data?.evidence.map(x => <p className="catalogue-id-note" key={x.id}><strong>{x.authorityCode} · {t(x.evidenceType)}</strong>: {x.referenceNumber} · {x.verificationStatus}{x.expiresOn ? ` · expires ${x.expiresOn}` : ""}</p>)}
        {!data?.evidence.length && <p className="inventory-empty">{t("No evidence references recorded.")}</p>}
        {canManage && <form className="location-form catalogue-form" onSubmit={e => submit(e, "evidence", { authorityCode, evidenceType, referenceNumber, documentUri: documentUri || null, regulatoryDocumentId: null, publishedOn: publishedOn || null, effectiveFrom: effectiveFrom || null, expiresOn: expiresOn || null, changeReason: changeReason || null }, "Regulatory evidence recorded as pending review.")}>
          <div className="form-grid">
            <label>{t("Authority")}<input required maxLength={48} value={authorityCode} onChange={e => setAuthorityCode(e.target.value)} /></label>
            <label>{t("Evidence type")}<input required maxLength={48} value={evidenceType} onChange={e => setEvidenceType(e.target.value)} /></label>
            <label>{t("Reference number")}<input required maxLength={160} value={referenceNumber} onChange={e => setReferenceNumber(e.target.value)} /></label>
            <label>{t("Document URL (HTTPS)")}<input type="url" value={documentUri} onChange={e => setDocumentUri(e.target.value)} /></label>
            <label>{t("Published on")}<input type="date" value={publishedOn} onChange={e => setPublishedOn(e.target.value)} /></label>
            <label>{t("Effective from")}<input type="date" value={effectiveFrom} onChange={e => setEffectiveFrom(e.target.value)} /></label>
            <label>{t("Expires on")}<input type="date" value={expiresOn} onChange={e => setExpiresOn(e.target.value)} /></label>
          </div>
          <button className="primary-button" type="submit" disabled={busy}>{t("Add evidence reference")}</button>
        </form>}
      </div>
    </div>

    <div className="inventory-panel">
      <h4>{t("Lifecycle review requests")}</h4>
      {data?.lifecycleRequests.map(x => <p className="catalogue-id-note" key={x.id}><strong>{t(x.requestedAction)}</strong> · {t(x.reviewStatus)} · {x.reason}</p>)}
      {!data?.lifecycleRequests.length && <p className="inventory-empty">{t("No activation or retirement requests.")}</p>}
      {canManage && <form className="location-form catalogue-form" onSubmit={e => submit(e, "lifecycle-requests", { requestedAction: lifecycleAction, reason, changeReason: changeReason || null }, "Lifecycle request submitted. Product status remains Draft pending review.")}>
        <div className="form-grid"><label>{t("Request")}<select value={lifecycleAction} onChange={e => setLifecycleAction(e.target.value)}><option value="Activate">{t("Request activation")}</option><option value="Retire">{t("Request retirement")}</option></select></label><label>{t("Reason")}<input required maxLength={500} value={reason} onChange={e => setReason(e.target.value)} /></label></div>
        <button className="primary-button" type="submit" disabled={busy}>{t("Submit review request")}</button>
      </form>}
    </div>
    <p className="catalogue-footer-note">{t("This interface does not verify identifiers, grant regulatory approval, activate/retire products, or create clinical, handling, stock or financial permissions. Review and evidence verification remain external human gates.")}</p>
  </section>;
}
