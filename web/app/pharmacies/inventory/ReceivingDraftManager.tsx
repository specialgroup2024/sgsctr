"use client";

import { useCallback, useEffect, useState, type FormEvent } from "react";
import { useI18n } from "@/components/locale-provider";

type Location = { id: string; code: string; name: string; sectorCode: string; isActive: boolean };
type Product = { id: string; displayName: string; status: string };
type Unit = { id: string; code: string; name: string; symbol: string | null };
type ReceiptLine = { id: string; productId: string; productName: string; unitId: string; unitCode: string; quantity: number; supplierItemReference: string | null };
type Receipt = { id: string; locationId: string; locationName: string; supplierReference: string; deliveryReference: string | null; status: string; createdAtUtc: string; createdBySubject: string; changeReason: string; lines: ReceiptLine[] };
type DraftLineInput = { productId: string; unitId: string; quantity: string; supplierItemReference: string };
type ReceiptObservation = { id: string; actorSubject: string; occurredAtUtc: string; note: string };

const emptyLine = (): DraftLineInput => ({ productId: "", unitId: "", quantity: "1", supplierItemReference: "" });

export default function ReceivingDraftManager() {
  const { t, formatDate } = useI18n();
  const [locations, setLocations] = useState<Location[]>([]);
  const [products, setProducts] = useState<Product[]>([]);
  const [units, setUnits] = useState<Unit[]>([]);
  const [receipts, setReceipts] = useState<Receipt[]>([]);
  const [locationId, setLocationId] = useState("");
  const [supplierReference, setSupplierReference] = useState("");
  const [deliveryReference, setDeliveryReference] = useState("");
  const [changeReason, setChangeReason] = useState("");
  const [lines, setLines] = useState<DraftLineInput[]>([emptyLine()]);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState("");
  const [notice, setNotice] = useState("");
  const [selectedReceiptId, setSelectedReceiptId] = useState("");
  const [observations, setObservations] = useState<ReceiptObservation[]>([]);
  const [observationNote, setObservationNote] = useState("");
  const [observationBusy, setObservationBusy] = useState(false);
  const [observationNotice, setObservationNotice] = useState("");

  const load = useCallback(async () => {
    setLoading(true);
    setError("");
    try {
      const [orgResponse, productResponse, unitResponse, receiptResponse] = await Promise.all([
        fetch("/api/organization", { cache: "no-store" }),
        fetch("/api/pharmacy/catalogue", { cache: "no-store" }),
        fetch("/api/pharmacy/catalogue/units", { cache: "no-store" }),
        fetch("/api/pharmacy/inventory/receipt-drafts", { cache: "no-store" })
      ]);
      if ([orgResponse, productResponse, unitResponse, receiptResponse].some(x => x.status === 401)) {
        window.location.assign("/login");
        return;
      }
      if (![orgResponse, productResponse, unitResponse, receiptResponse].every(x => x.ok))
        throw new Error(t("Could not load receiving reference data or receipt drafts."));
      const [org, productRows, unitRows, receiptRows] = await Promise.all([
        orgResponse.json() as Promise<{ locations?: Location[] }>,
        productResponse.json() as Promise<Product[]>,
        unitResponse.json() as Promise<Unit[]>,
        receiptResponse.json() as Promise<Receipt[]>
      ]);
      const activeLocations = (org.locations ?? []).filter(x => x.sectorCode === "PHARMACIES" && x.isActive);
      const draftProducts = productRows.filter(x => x.status === "Draft");
      setLocations(activeLocations);
      setProducts(draftProducts);
      setUnits(unitRows);
      setReceipts(receiptRows);
      setLocationId(current => current || activeLocations[0]?.id || "");
      setLines(current => current.map(line => ({
        ...line,
        productId: line.productId || draftProducts[0]?.id || "",
        unitId: line.unitId || unitRows[0]?.id || ""
      })));
    } catch (cause) {
      setError(cause instanceof Error ? cause.message : t("Could not load receiving reference data or receipt drafts."));
    } finally {
      setLoading(false);
    }
  }, [t]);

  useEffect(() => { void load(); }, [load]);

  function updateLine(index: number, patch: Partial<DraftLineInput>) {
    setLines(current => current.map((line, i) => i === index ? { ...line, ...patch } : line));
  }

  async function createDraft(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setError("");
    setNotice("");
    if (!locationId || !supplierReference.trim() || !changeReason.trim() ||
        lines.some(line => !line.productId || !line.unitId || !Number.isFinite(Number(line.quantity)) || Number(line.quantity) <= 0)) {
      setError(t("Complete the required fields and enter a positive quantity for every line."));
      return;
    }
    setSaving(true);
    try {
      const response = await fetch("/api/pharmacy/inventory/receipt-drafts", {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({
          locationId,
          supplierReference: supplierReference.trim(),
          deliveryReference: deliveryReference.trim() || null,
          changeReason: changeReason.trim(),
          lines: lines.map(line => ({
            productId: line.productId,
            unitId: line.unitId,
            quantity: Number(line.quantity),
            supplierItemReference: line.supplierItemReference.trim() || null
          }))
        })
      });
      if (response.status === 401) { window.location.assign("/login"); return; }
      const payload = await response.json().catch(() => null) as { error?: string; message?: string; stockPosted?: boolean } | null;
      if (!response.ok) throw new Error(payload?.error ?? t("Receipt draft could not be saved."));
      setSupplierReference("");
      setDeliveryReference("");
      setChangeReason("");
      setLines([emptyLine()]);
      setNotice(payload?.message ?? t("Receipt draft saved. No stock was posted."));
      await load();
    } catch (cause) {
      setError(cause instanceof Error ? cause.message : t("Receipt draft could not be saved."));
    } finally {
      setSaving(false);
    }
  }

  async function openObservations(receiptId: string) {
    setSelectedReceiptId(receiptId);
    setObservationNote("");
    setObservationNotice("");
    setError("");
    const response = await fetch(`/api/pharmacy/inventory/receipt-drafts/${encodeURIComponent(receiptId)}/observations`, { cache: "no-store" });
    if (response.status === 401) { window.location.assign("/login"); return; }
    if (!response.ok) throw new Error(t("Receipt observations could not be loaded."));
    setObservations(await response.json() as ReceiptObservation[]);
  }

  async function addObservation(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    if (!selectedReceiptId || !observationNote.trim()) return;
    setObservationBusy(true); setError(""); setNotice("");
    try {
      const response = await fetch(`/api/pharmacy/inventory/receipt-drafts/${encodeURIComponent(selectedReceiptId)}/observations`, {
        method: "POST", headers: { "content-type": "application/json" },
        body: JSON.stringify({ note: observationNote.trim() })
      });
      const payload = await response.json().catch(() => null) as { error?: string; title?: string } | null;
      if (response.status === 401) { window.location.assign("/login"); return; }
      if (!response.ok) throw new Error(payload?.error ?? payload?.title ?? t("Receipt observation could not be saved."));
      setObservationNote("");
      await openObservations(selectedReceiptId);
      setObservationNotice(t("Observation saved and reloaded from the draft audit trail. No receipt status or stock was changed."));
    } catch (cause) {
      setError(cause instanceof Error ? cause.message : t("Receipt observation could not be saved."));
    } finally { setObservationBusy(false); }
  }

  const canCreate = !loading && locations.length > 0 && products.length > 0 && units.length > 0;

  return <section className="inventory-workspace-panel receiving-draft-workspace">
    <div className="inventory-section-heading">
      <div><p className="eyebrow">{t("INBOUND STOCK")}</p><h2>{t("Receiving & inspection")}</h2><p>{t("Capture delivery references as draft evidence only. This does not receive or release stock.")}</p></div>
      <span className="inventory-status-chip">{t("Draft only · no stock effect")}</span>
    </div>
    <div className="inventory-panel" role="note" style={{ marginBottom: 16 }}>
      <div className="inventory-panel-heading"><div><p className="eyebrow">{t("UI-02 WORKFLOW GUIDE")}</p><h3>{t("How to save and verify a receiving observation")}</h3></div></div>
      <ol className="inventory-check-list">
        <li><span className="check-pending">1</span><div><strong>{t("Create a draft receipt")}</strong><small>{t("Complete the receiving draft form and select Save draft receipt. It will appear under Recent receipt drafts.")}</small></div></li>
        <li><span className="check-pending">2</span><div><strong>{t("Open its review notes")}</strong><small>{t("Find the receipt in Recent receipt drafts and select View / add notes.")}</small></div></li>
        <li><span className="check-pending">3</span><div><strong>{t("Add and verify an observation")}</strong><small>{t("Enter a note and select Add note. The saved note appears in the observations table; reload the page and reopen the same receipt to verify persistence.")}</small></div></li>
      </ol>
      <p className="catalogue-footer-note">{t("If there are no receipt drafts, create a draft first. A note changes neither receipt status nor stock balances.")}</p>
    </div>
    <div className="inventory-gate" role="note"><span className="inventory-gate-icon">!</span><div><strong>{t("Quality release remains disabled.")}</strong><p>{t("This workspace records a draft receipt reference only. It does not verify suppliers, inspect or accept goods, record batches or expiry, or change stock balances. Approved pharmacy and quality procedures are still required.")}</p></div></div>
    {error && <p className="form-error" role="alert">{error}</p>}
    {notice && <p className="form-success" role="status">{notice}</p>}
    <form className="receiving-draft-form" onSubmit={createDraft}>
      <div className="receiving-draft-fields">
        <label>{t("Receiving location")}<select value={locationId} onChange={event => setLocationId(event.target.value)} required disabled={!canCreate}><option value="">{t("Select pharmacy location")}</option>{locations.map(location => <option key={location.id} value={location.id}>{location.name} · {location.code}</option>)}</select></label>
        <label>{t("Supplier / declaration reference")}<input value={supplierReference} onChange={event => setSupplierReference(event.target.value)} maxLength={200} required disabled={!canCreate} /></label>
        <label>{t("Delivery reference (optional)")}<input value={deliveryReference} onChange={event => setDeliveryReference(event.target.value)} maxLength={160} disabled={!canCreate} /></label>
        <label>{t("Reason for draft record")}<input value={changeReason} onChange={event => setChangeReason(event.target.value)} maxLength={500} required disabled={!canCreate} /></label>
      </div>
      <div className="receiving-lines-heading"><h3>{t("Draft receipt lines")}</h3><button type="button" className="subtle-button" disabled={!canCreate || lines.length >= 20} onClick={() => setLines(current => [...current, { ...emptyLine(), productId: products[0]?.id ?? "", unitId: units[0]?.id ?? "" }])}>{t("Add line")}</button></div>
      {lines.map((line, index) => <div className="receiving-draft-line" key={index}>
        <label>{t("Draft product")}<select value={line.productId} onChange={event => updateLine(index, { productId: event.target.value })} required disabled={!canCreate}><option value="">{t("Select draft product")}</option>{products.map(product => <option key={product.id} value={product.id}>{product.displayName}</option>)}</select></label>
        <label>{t("Unit")}<select value={line.unitId} onChange={event => updateLine(index, { unitId: event.target.value })} required disabled={!canCreate}><option value="">{t("Select unit")}</option>{units.map(unit => <option key={unit.id} value={unit.id}>{unit.code} · {unit.name}</option>)}</select></label>
        <label>{t("Declared quantity")}<input type="number" inputMode="decimal" min="0" step="any" value={line.quantity} onChange={event => updateLine(index, { quantity: event.target.value })} required disabled={!canCreate} /></label>
        <label>{t("Supplier item reference (optional)")}<input value={line.supplierItemReference} onChange={event => updateLine(index, { supplierItemReference: event.target.value })} maxLength={160} disabled={!canCreate} /></label>
        <button type="button" className="receiving-remove-line" aria-label={t("Remove line")} disabled={lines.length === 1} onClick={() => setLines(current => current.filter((_, i) => i !== index))}>×</button>
      </div>)}
      <div className="receiving-draft-actions"><small>{t("Only Draft catalogue products can be selected. Supplier references are declarations, not verified supplier records.")}</small><button type="submit" className="primary-button" disabled={!canCreate || saving}>{saving ? t("Saving…") : t("Save draft receipt")}</button></div>
      {!loading && (!locations.length || !products.length || !units.length) && <p className="inventory-empty">{t("Add an active pharmacy location, a Draft catalogue product and a unit before creating a receipt draft.")}</p>}
    </form>
    <div className="receiving-draft-list-heading"><h3>{t("Recent receipt drafts")}</h3><button type="button" className="subtle-button" onClick={() => void load()} disabled={loading}>{t("Refresh")}</button></div>
    {loading ? <p className="loading-state">{t("Loading receipt drafts…")}</p> : receipts.length ? <div className="register-table-wrap"><table className="register-table"><thead><tr><th>{t("Created")}</th><th>{t("Location")}</th><th>{t("Supplier reference")}</th><th>{t("Lines")}</th><th>{t("Status")}</th><th>{t("Review notes")}</th></tr></thead><tbody>{receipts.map(receipt => <tr key={receipt.id}><td>{formatDate(receipt.createdAtUtc)}</td><td>{receipt.locationName}</td><td>{receipt.supplierReference}</td><td>{receipt.lines.length}</td><td><span className="inventory-status-chip">{t(receipt.status)}</span></td><td><button type="button" className="table-action" onClick={() => void openObservations(receipt.id).catch(cause => setError(cause instanceof Error ? cause.message : t("Receipt observations could not be loaded.")))}>{t("View / add notes")}</button></td></tr>)}</tbody></table></div> : <div className="inventory-empty-state compact-empty"><h3>{t("No receipt drafts yet")}</h3><p>{t("Saved draft evidence will appear here. No stock balance or movement is created.")}</p></div>}
    {selectedReceiptId && <section className="inventory-panel" style={{ marginTop: 16 }}><div className="inventory-panel-heading"><div><p className="eyebrow">{t("DRAFT REVIEW NOTES")}</p><h3>{t("Observations and discrepancies")}</h3></div><button type="button" className="subtle-button" onClick={() => setSelectedReceiptId("")}>{t("Close")}</button></div><p className="catalogue-footer-note">{t("Record factual observations against this draft only. Notes do not accept or reject goods, change receipt status, create stock, or authorize quality release.")}</p>{observationNotice && <p className="form-success" role="status" aria-live="polite">{observationNotice}</p>}<form className="location-form catalogue-form" onSubmit={addObservation}><label>{t("Observation / discrepancy note")}<input required maxLength={500} value={observationNote} onChange={event => setObservationNote(event.target.value)} /></label><button className="primary-button" type="submit" disabled={observationBusy || !observationNote.trim()}>{observationBusy ? t("Saving…") : t("Add note")}</button></form>{observations.length ? <div className="register-table-wrap"><table className="register-table"><thead><tr><th>{t("Recorded")}</th><th>{t("Actor")}</th><th>{t("Observation")}</th></tr></thead><tbody>{observations.map(item => <tr key={item.id}><td>{formatDate(item.occurredAtUtc)}</td><td>{item.actorSubject}</td><td>{item.note}</td></tr>)}</tbody></table></div> : <p className="inventory-empty">{t("No observations have been recorded for this draft.")}</p>}</section>}
  </section>;
}
