"use client";
import { useCallback, useEffect, useState } from "react";
import { AppShell } from "@/components/app-shell";
import { useI18n } from "@/components/locale-provider";

type Location = {
  id: string; code: string; name: string; sectorCode: string; locationType: string;
  notes?: string | null; recordStatus: string; isActive: boolean; updatedAtUtc: string;
};
type Workspace = {
  organizationName: string; legalIdentityStatus: string; canManage: boolean;
  sectors: Array<{ code: string; name: string; recordStatus: string }>;
  locations: Location[];
};
type Draft = { code: string; name: string; sectorCode: string; locationType: string; notes: string };
const emptyDraft: Draft = { code: "", name: "", sectorCode: "PHARMACIES", locationType: "Branch", notes: "" };

export default function OrganizationWorkspace() {
  const { t } = useI18n();
  const [data, setData] = useState<Workspace | null>(null);
  const [subject, setSubject] = useState("");
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState("");
  const [notice, setNotice] = useState("");
  const [editing, setEditing] = useState<string | null>(null);
  const [draft, setDraft] = useState<Draft>(emptyDraft);

  const load = useCallback(async () => {
    setLoading(true); setError("");
    try {
      const [orgResponse, sessionResponse] = await Promise.all([
        fetch("/api/organization", { cache: "no-store" }),
        fetch("/api/auth/session", { cache: "no-store" })
      ]);
      if (orgResponse.status === 401 || sessionResponse.status === 401) { window.location.assign("/login"); return; }
      if (!orgResponse.ok) throw new Error("Could not load organization records.");
      const org = await orgResponse.json() as Workspace;
      const session = await sessionResponse.json() as { user?: { subject?: string } };
      setData(org); setSubject(session.user?.subject ?? "");
    } catch (e) { setError(e instanceof Error ? e.message : "Unexpected error loading organization."); }
    finally { setLoading(false); }
  }, []);

  useEffect(() => { void load(); }, [load]);

  function beginEdit(location: Location) {
    setEditing(location.id);
    setDraft({ code: location.code, name: location.name, sectorCode: location.sectorCode, locationType: location.locationType, notes: location.notes ?? "" });
    setNotice("");
  }
  function beginCreate() { setEditing("new"); setDraft(emptyDraft); setNotice(""); }
  function cancelEdit() { setEditing(null); setDraft(emptyDraft); }

  async function save(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault(); setSaving(true); setError(""); setNotice("");
    try {
      const response = await fetch(editing === "new" ? "/api/organization" : `/api/organization/locations/${editing}`, {
        method: editing === "new" ? "POST" : "PUT",
        headers: { "content-type": "application/json" },
        body: JSON.stringify(draft)
      });
      const payload = await response.json().catch(() => null);
      if (!response.ok) {
        const validationMessage = Object.values(payload?.errors ?? {}).flat().join(" ");
        const message = (payload?.error ?? validationMessage) || (response.status === 403
          ? "Your account cannot manage organization locations."
          : `Save failed (HTTP ${response.status}).`);
        throw new Error(message);
      }
      cancelEdit(); setNotice("Location record saved."); await load();
    } catch (e) { setError(e instanceof Error ? e.message : "Could not save location."); }
    finally { setSaving(false); }
  }

  async function deactivate(location: Location) {
    if (!window.confirm(`Deactivate ${location.name}? The record will be retained, not deleted.`)) return;
    setError(""); setNotice("");
    const response = await fetch(`/api/organization/locations/${location.id}`, { method: "DELETE" });
    if (!response.ok) { setError(`Could not deactivate location (HTTP ${response.status}).`); return; }
    setNotice("Location deactivated. Its record remains in the register."); await load();
  }

  return <AppShell><div className="content">
    <section className="welcome-row"><div><p className="eyebrow">{t("ORGANIZATION DIRECTORY" )}</p><h1>{t("Organization")} <span>workspace</span></h1><p className="welcome-copy">{t("Manage reference records for the sectors and their operating locations." )}</p></div><span className="read-only-pill">{t("LEGAL IDENTITY UNVERIFIED" )}</span></section>
    <section className="notice-panel"><strong>{t("Legal identity remains unverified." )}</strong><p>{t("The workspace stores owner-provided operating names only. It does not create or certify a legal entity, company registration, licensing, ownership or tax identity. Changes to legal identity are deliberately excluded.")}</p></section>
    {error && <p className="form-error" role="alert">{t(error)}</p>}
    {notice && <p className="form-success" role="status">{notice}</p>}
    <div className="section-heading"><div><p className="eyebrow">{t("ORGANIZATION STRUCTURE" )}</p><h2>{t("Business sectors" )}</h2></div></div>
    <section className="sector-grid">{(data?.sectors ?? []).map(sector => <article className="sector-card" key={sector.code}><div className="sector-top"><span className="sector-tag">{sector.code}</span><span className="record-status">{t("Owner provided")}</span></div><h3>{sector.name}</h3><p>{t("Separate operating domain. Business permissions and financial authority are not granted by this register.")}</p></article>)}</section>
    <div className="section-heading"><div><p className="eyebrow">{t("LOCATION REGISTER" )}</p><h2>{t("Warehouses, branches and sites" )}</h2></div>{data?.canManage && <button className="primary-button" onClick={beginCreate}>+ Add location</button>}</div>
    {!data?.canManage && <section className="permission-panel"><strong>{t("Read access is active; editing is restricted.")}</strong><p>{t("Location changes require an explicitly authorized organization manager. No default administrator or business role has been invented. Your authenticated subject identifier is:")}</p><code>{subject || "Loading…"}</code><small>{t("The owner can authorize the approved manager by adding this exact subject to")} <code>ORGANIZATION_MANAGER_SUBJECTS</code> {t("in the VM's ignored")} <code>.env</code> {t("file, then recreating the API container. Do not grant this to an unverified account.")}</small></section>}
    {editing && data?.canManage && <form className="location-form" onSubmit={save}>
      <div className="form-heading"><strong>{editing === "new" ? "Add location record" : "Edit location record"}</strong><button type="button" className="subtle-button" onClick={cancelEdit}>{t("Cancel" )}</button></div>
      <div className="form-grid">
        <label>{t("Location code" )}<input required maxLength={24} value={draft.code} onChange={e => setDraft({ ...draft, code: e.target.value })} placeholder={t("e.g. PH-05")} /></label>
        <label>{t("Location name" )}<input required maxLength={160} value={draft.name} onChange={e => setDraft({ ...draft, name: e.target.value })} placeholder={t("Operating location name")} /></label>
        <label>{t("Sector" )}<select value={draft.sectorCode} onChange={e => setDraft({ ...draft, sectorCode: e.target.value })}><option value="PHARMACIES">{t("Pharmacies")}</option><option value="SPECIALIZED_CONTRACTING">{t("Specialized Contracting")}</option></select></label>
        <label>{t("Location type" )}<select value={draft.locationType} onChange={e => setDraft({ ...draft, locationType: e.target.value })}><option value="MainWarehouse">{t("Main warehouse")}</option><option value="Branch">{t("Branch")}</option><option value="Office">{t("Office")}</option><option value="ProjectSite">{t("Project site")}</option></select></label>
        <label className="wide-field">{t("Notes (non-legal operational notes)" )}<textarea maxLength={500} rows={2} value={draft.notes} onChange={e => setDraft({ ...draft, notes: e.target.value })} /></label>
      </div>
      <div className="form-actions"><button className="primary-button" type="submit" disabled={saving}>{saving ? "Saving…" : "Save location"}</button><button className="subtle-button" type="button" onClick={cancelEdit}>{t("Cancel" )}</button></div>
    </form>}
    {loading ? <p className="loading-state">{t("Loading organization records…" )}</p> : <section className="register-table-wrap"><table className="register-table"><thead><tr><th>{t("Location" )}</th><th>{t("Sector" )}</th><th>{t("Type" )}</th><th>{t("Reference" )}</th><th>{t("Status" )}</th>{data?.canManage && <th>{t("Actions")}</th>}</tr></thead><tbody>{(data?.locations ?? []).map(location => <tr key={location.id} className={!location.isActive ? "inactive-row" : ""}><td><strong>{location.name}</strong></td><td>{location.sectorCode === "PHARMACIES" ? "Pharmacies" : "Specialized Contracting"}</td><td>{location.locationType}</td><td><code>{location.code}</code></td><td><span className={location.isActive ? "record-status" : "inactive-status"}>{location.isActive ? "Active · Owner provided" : "Inactive"}</span></td>{data?.canManage && <td><div className="table-actions"><button className="table-action" onClick={() => beginEdit(location)}>{t("Edit" )}</button>{location.isActive && <button className="table-action danger-action" onClick={() => void deactivate(location)}>{t("Deactivate" )}</button>}</div></td>}</tr>)}</tbody></table></section>}
    <section className="notice-panel secondary-notice"><strong>{t("Operational boundaries" )}</strong><p>This workspace manages reference records only. It does not execute inventory transfers, stock adjustments, purchasing, dispensing, contracting transactions, accounting or financial postings. Direct branch-to-branch transfer remains an owner-confirmed requirement for a separately approved workflow.</p></section>
    <footer className="footer"><span>{t("SGSCTR · Organization workspace")}</span><span>{t("Authenticated · Server-enforced access")}</span></footer>
  </div></AppShell>;
}
