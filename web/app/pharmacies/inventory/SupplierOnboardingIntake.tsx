"use client";

import { useState } from "react";
import { useI18n } from "@/components/locale-provider";

type Props = { supplierId: string; canManage: boolean; onSaved: () => Promise<void> };
async function send(url: string, body: unknown) {
  const response = await fetch(url, { method: "POST", headers: { "content-type": "application/json" }, body: JSON.stringify(body) });
  const result = await response.json().catch(() => null);
  if (!response.ok) throw new Error(result?.error ?? result?.title ?? `Request failed (${response.status}).`);
  return result;
}

export default function SupplierOnboardingIntake({ supplierId, canManage, onSaved }: Props) {
  const { t } = useI18n();
  const [claimType, setClaimType] = useState("LegalName");
  const [declaredValue, setDeclaredValue] = useState("");
  const [declarationReason, setDeclarationReason] = useState("");
  const [channelType, setChannelType] = useState("DepartmentEmail");
  const [channelValue, setChannelValue] = useState("");
  const [departmentLabel, setDepartmentLabel] = useState("General");
  const [businessUseConfirmed, setBusinessUseConfirmed] = useState(false);
  const [contactReason, setContactReason] = useState("");
  const [diligenceReason, setDiligenceReason] = useState("");
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState("");
  const [notice, setNotice] = useState("");

  async function submit(event: React.FormEvent<HTMLFormElement>, action: () => Promise<void>) {
    event.preventDefault(); setBusy(true); setError(""); setNotice("");
    try { await action(); await onSaved(); setNotice(t("Supplier intake saved. All declarations remain unverified and due diligence remains pending.")); }
    catch (e) { setError(e instanceof Error ? e.message : t("Supplier intake could not be saved.")); }
    finally { setBusy(false); }
  }

  return <section className="inventory-panel" style={{ marginTop: 18 }}>
    <div className="inventory-panel-heading"><div><p className="eyebrow">{t("SUPPLIER ONBOARDING INTAKE")}</p><h3>{t("Declared identity, business channels and due diligence")}</h3></div></div>
    <p className="catalogue-footer-note">{t("Supplier-provided information only. Nothing here verifies identity or licences, qualifies the supplier, or enables purchasing or receiving. Do not enter a person's name or personal contact details.")}</p>
    {error && <p className="form-error" role="alert">{t(error)}</p>}
    {notice && <p className="form-success" role="status">{notice}</p>}
    {canManage ? <>
      <form className="location-form catalogue-form" onSubmit={event => submit(event, async () => {
        await send(`/api/pharmacy/suppliers/${encodeURIComponent(supplierId)}/declarations`, { claimType, declaredValue, changeReason: declarationReason });
        setDeclaredValue(""); setDeclarationReason("");
      })}>
        <div className="form-heading"><strong>{t("Supplier-declared identity or licence detail")}</strong><span className="inventory-state-tag">{t("UNVERIFIED")}</span></div>
        <div className="form-grid">
          <label>{t("Declaration field")}<select value={claimType} onChange={e => setClaimType(e.target.value)}>
            <option value="LegalName">{t("Legal name")}</option><option value="TradingName">{t("Trading name")}</option>
            <option value="LegalForm">{t("Legal form")}</option><option value="Jurisdiction">{t("Jurisdiction")}</option>
            <option value="RegistrationAuthority">{t("Registration authority")}</option><option value="RegistrationNumber">{t("Registration number")}</option>
            <option value="TaxReference">{t("Tax reference")}</option><option value="RegisteredAddress">{t("Registered address")}</option>
            <option value="LicenceCategory">{t("Licence category")}</option><option value="LicenceHolder">{t("Licence holder")}</option>
            <option value="LicenceNumber">{t("Licence number")}</option><option value="LicenceIssuingAuthority">{t("Licence issuing authority")}</option>
            <option value="LicenceScope">{t("Licence scope")}</option><option value="LicenceIssueDate">{t("Licence issue date (declared)")}</option>
            <option value="LicenceExpiryDate">{t("Licence expiry date (declared)")}</option>
          </select></label>
          <label>{t("Supplier-declared value")}<input required maxLength={500} value={declaredValue} onChange={e => setDeclaredValue(e.target.value)} /></label>
          <label className="wide-field">{t("Change reason")}<input required maxLength={500} value={declarationReason} onChange={e => setDeclarationReason(e.target.value)} /></label>
        </div>
        <button className="primary-button" type="submit" disabled={busy}>{t("Save unverified declaration")}</button>
      </form>
      <form className="location-form catalogue-form" onSubmit={event => submit(event, async () => {
        await send(`/api/pharmacy/suppliers/${encodeURIComponent(supplierId)}/business-contacts`, { channelType, channelValue, departmentLabel, businessUseConfirmed, changeReason: contactReason });
        setChannelValue(""); setContactReason(""); setBusinessUseConfirmed(false);
      })}>
        <div className="form-heading"><strong>{t("Business contact channel")}</strong></div>
        <div className="form-grid">
          <label>{t("Channel type")}<select value={channelType} onChange={e => setChannelType(e.target.value)}>
            <option value="DepartmentEmail">{t("Department email")}</option><option value="BusinessPhone">{t("Business phone / switchboard")}</option><option value="BusinessWebsite">{t("Business website")}</option>
          </select></label>
          <label>{t("Department")}<select value={departmentLabel} onChange={e => setDepartmentLabel(e.target.value)}>
            <option value="General">{t("General")}</option><option value="Procurement">{t("Procurement")}</option><option value="Sales">{t("Sales")}</option>
            <option value="Accounts">{t("Accounts")}</option><option value="Regulatory">{t("Regulatory")}</option><option value="Quality">{t("Quality")}</option>
          </select></label>
          <label>{t("Business channel value")}<input required maxLength={320} value={channelValue} onChange={e => setChannelValue(e.target.value)} /></label>
          <label>{t("Change reason")}<input required maxLength={500} value={contactReason} onChange={e => setContactReason(e.target.value)} /></label>
          <label className="wide-field"><input type="checkbox" required checked={businessUseConfirmed} onChange={e => setBusinessUseConfirmed(e.target.checked)} /> {t("I confirm this is a shared business channel, not a person's personal contact detail.")}</label>
        </div>
        <button className="primary-button" type="submit" disabled={busy}>{t("Save business channel")}</button>
      </form>
      <form className="location-form catalogue-form" onSubmit={event => submit(event, async () => {
        await send(`/api/pharmacy/suppliers/${encodeURIComponent(supplierId)}/due-diligence-cases`, { reason: diligenceReason });
        setDiligenceReason("");
      })}>
        <div className="form-heading"><strong>{t("Due-diligence intake case")}</strong><span className="inventory-state-tag">{t("PENDING")}</span></div>
        <label>{t("Request reason")}<input required maxLength={500} value={diligenceReason} onChange={e => setDiligenceReason(e.target.value)} /></label>
        <button className="primary-button" type="submit" disabled={busy}>{t("Create pending intake case")}</button>
      </form>
    </> : <p className="inventory-empty">{t("Supplier changes require the Administrator role. Your account currently has read-only access.")}</p>}
  </section>;
}
