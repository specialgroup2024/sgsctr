"use client";

import { useCallback, useEffect, useMemo, useState } from "react";
import { useI18n } from "@/components/locale-provider";
import type { FormEvent } from "react";
import ProductGovernanceManager from "./ProductGovernanceManager";

type Product = {
  id: string; displayName: string; status: string;
  version: number; createdAtUtc: string; updatedAtUtc: string;
};
type Unit = { id: string; code: string; name: string; symbol: string | null };
type Conversion = {
  id: string; productId: string; fromUnitId: string; fromUnitName: string;
  toUnitId: string; toUnitName: string; numerator: number; denominator: number; status: string;
};
type Permission = { canManage: boolean };
type AuditEvent = { id: string; actorSubject: string; action: string; resourceType: string; resourceId: string; occurredAtUtc: string; reason: string | null; correlationId: string };

async function payload<T>(response: Response): Promise<T> {
  const body = await response.json().catch(() => null);
  if (!response.ok) throw new Error(body?.error ?? body?.title ?? `Request failed (${response.status}).`);
  return body as T;
}

export default function CatalogueManager() {
  const { t } = useI18n();
  const [products, setProducts] = useState<Product[]>([]);
  const [units, setUnits] = useState<Unit[]>([]);
  const [conversions, setConversions] = useState<Conversion[]>([]);
  const [auditEvents, setAuditEvents] = useState<AuditEvent[]>([]);
  const [canManage, setCanManage] = useState(false);
  const [selectedId, setSelectedId] = useState("");
  const [search, setSearch] = useState("");
  const [displayName, setDisplayName] = useState("");
  const [changeReason, setChangeReason] = useState("");
  const [editing, setEditing] = useState<Product | null>(null);
  const [unitCode, setUnitCode] = useState("");
  const [unitName, setUnitName] = useState("");
  const [unitSymbol, setUnitSymbol] = useState("");
  const [fromUnitId, setFromUnitId] = useState("");
  const [toUnitId, setToUnitId] = useState("");
  const [numerator, setNumerator] = useState("1");
  const [denominator, setDenominator] = useState("1");
  const [loading, setLoading] = useState(true);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState("");
  const [notice, setNotice] = useState("");

  const load = useCallback(async () => {
    setLoading(true);
    setError("");
    try {
      const [p, u, permissions] = await Promise.all([
        fetch("/api/pharmacy/catalogue", { cache: "no-store" }),
        fetch("/api/pharmacy/catalogue/units", { cache: "no-store" }),
        fetch("/api/pharmacy/catalogue/permissions", { cache: "no-store" })
      ]);
      if ([p, u, permissions].some(x => x.status === 401)) {
        window.location.assign("/login");
        return;
      }
      const [productRows, unitRows, access] = await Promise.all([
        payload<Product[]>(p), payload<Unit[]>(u), payload<Permission>(permissions)
      ]);
      setProducts(productRows);
      setUnits(unitRows);
      setCanManage(access.canManage === true);
      setSelectedId(current => current && productRows.some(x => x.id === current) ? current : productRows[0]?.id ?? "");
    } catch (e) {
      setError(e instanceof Error ? e.message : "Catalogue data could not be loaded.");
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => { void load(); }, [load]);

  useEffect(() => {
    if (!selectedId) { setConversions([]); return; }
    let active = true;
    fetch(`/api/pharmacy/catalogue/${encodeURIComponent(selectedId)}/conversions`, { cache: "no-store" })
      .then(response => payload<Conversion[]>(response))
      .then(rows => { if (active) setConversions(rows); })
      .catch(e => { if (active) setError(e instanceof Error ? e.message : "Conversions could not be loaded."); });
    return () => { active = false; };
  }, [selectedId]);

  useEffect(() => {
    if (!canManage) { setAuditEvents([]); return; }
    let active = true;
    fetch("/api/pharmacy/catalogue/audit", { cache: "no-store" })
      .then(response => payload<AuditEvent[]>(response))
      .then(rows => { if (active) setAuditEvents(rows); })
      .catch(e => { if (active) setError(e instanceof Error ? e.message : "Audit history could not be loaded."); });
    return () => { active = false; };
  }, [canManage]);

  const filteredProducts = useMemo(() => {
    const q = search.trim().toLocaleLowerCase();
    return q ? products.filter(x => x.displayName.toLocaleLowerCase().includes(q)) : products;
  }, [products, search]);

  function resetProduct() {
    setEditing(null); setDisplayName(""); setChangeReason("");
  }

  function editProduct(product: Product) {
    setEditing(product); setSelectedId(product.id);
    setDisplayName(product.displayName);
    setChangeReason("");
  }

  async function saveProduct(event: FormEvent<HTMLFormElement>) {
    event.preventDefault(); setBusy(true); setError(""); setNotice("");
    try {
      const response = await fetch(editing ? `/api/pharmacy/catalogue/${encodeURIComponent(editing.id)}` : "/api/pharmacy/catalogue", {
        method: editing ? "PUT" : "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({
          displayName, changeReason: changeReason || null,
          ...(editing ? { version: editing.version } : {})
        })
      });
      const saved = await payload<Product>(response);
      await load();
      setSelectedId(saved.id);
      resetProduct();
      setNotice(editing ? "Draft product updated." : "Draft product created.");
    } catch (e) { setError(e instanceof Error ? e.message : "Product could not be saved."); }
    finally { setBusy(false); }
  }

  async function saveUnit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault(); setBusy(true); setError(""); setNotice("");
    try {
      await payload<Unit>(await fetch("/api/pharmacy/catalogue/units", {
        method: "POST", headers: { "content-type": "application/json" },
        body: JSON.stringify({ code: unitCode, name: unitName, symbol: unitSymbol || null })
      }));
      setUnitCode(""); setUnitName(""); setUnitSymbol("");
      await load(); setNotice("Unit of measure added.");
    } catch (e) { setError(e instanceof Error ? e.message : "Unit could not be saved."); }
    finally { setBusy(false); }
  }

  async function saveConversion(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    if (!selectedId) return;
    setBusy(true); setError(""); setNotice("");
    try {
      await payload<Conversion>(await fetch(`/api/pharmacy/catalogue/${encodeURIComponent(selectedId)}/conversions`, {
        method: "POST", headers: { "content-type": "application/json" },
        body: JSON.stringify({
          fromUnitId, toUnitId, numerator: Number(numerator), denominator: Number(denominator)
        })
      }));
      setFromUnitId(""); setToUnitId(""); setNumerator("1"); setDenominator("1");
      const response = await fetch(`/api/pharmacy/catalogue/${encodeURIComponent(selectedId)}/conversions`, { cache: "no-store" });
      setConversions(await payload<Conversion[]>(response));
      setNotice("Draft conversion added. It is reference data only and is not used in stock calculations.");
    } catch (e) { setError(e instanceof Error ? e.message : "Conversion could not be saved."); }
    finally { setBusy(false); }
  }

  return <div className="catalogue-manager">
    <div className="inventory-gate"><span className="inventory-gate-icon">!</span><div><strong>{t("Generic catalogue only · Q38 professional review remains pending")}</strong><p>{t("Records and conversions remain drafts. Family and identifier entries are provisional only; no verified classification, product activation, stock, dispensing or valuation is enabled.")}</p></div></div>
    {error && <p className="form-error" role="alert">{t(error)}</p>}
    {notice && <p className="form-success" role="status">{notice}</p>}
    <section className="catalogue-layout">
      <div className="inventory-panel">
        <div className="inventory-panel-heading"><div><p className="eyebrow">{t("PERSISTENT REFERENCE DATA")}</p><h3>{t("Product records")}</h3></div><span className="inventory-count">{products.length} drafts</span></div>
        <div className="inventory-toolbar"><label htmlFor="catalogue-search">{t("Search")}</label><input id="catalogue-search" value={search} onChange={e => setSearch(e.target.value)} placeholder={t("Search product names…")} /></div>
        {loading ? <p className="loading-state">{t("Loading catalogue from PostgreSQL…")}</p> :
          filteredProducts.length ? <div className="register-table-wrap"><table className="register-table"><thead><tr><th>{t("Product name")}</th><th>{t("Status")}</th><th>{t("Action")}</th></tr></thead><tbody>
            {filteredProducts.map(product => <tr key={product.id} className={selectedId === product.id ? "catalogue-selected-row" : ""}>
              <td><strong>{product.displayName}</strong></td>
              <td><span className="inventory-state-tag">{t("DRAFT")}</span></td>
              <td><div className="table-actions"><button type="button" className="table-action" onClick={() => setSelectedId(product.id)}>{t("View")}</button>{canManage && <button type="button" className="table-action" onClick={() => editProduct(product)}>{t("Edit")}</button>}</div></td>
            </tr>)}
          </tbody></table></div> : <p className="inventory-empty">{t("No catalogue records yet. Add a generic draft record to begin.")}</p>}
        <button type="button" className="subtle-button catalogue-new-button" onClick={resetProduct} disabled={!canManage}>{t("+ New draft product")}</button>
      </div>

      <div className="inventory-panel">
        <div className="inventory-panel-heading"><div><p className="eyebrow">{t("PRODUCT IDENTITY")}</p><h3>{editing ? "Edit draft product" : "Create draft product"}</h3></div></div>
        {canManage ? <form className="location-form catalogue-form" onSubmit={saveProduct}>
          <div className="form-grid">
            <label className="wide-field">{t("Display name")}<input required maxLength={200} value={displayName} onChange={e => setDisplayName(e.target.value)} /></label>
            <label className="wide-field">{t("Change reason (optional; do not enter patient or health data)")}<input maxLength={500} value={changeReason} onChange={e => setChangeReason(e.target.value)} /></label>
          </div>
          <div className="form-actions"><span className="inventory-state-tag">{t("STATUS IS ALWAYS DRAFT")}</span><div>{editing && <button type="button" className="subtle-button" onClick={resetProduct}>{t("Cancel")}</button>}<button type="submit" className="primary-button" disabled={busy}>{busy ? "Saving…" : editing ? "Save draft" : "Create draft"}</button></div></div>
        </form> : <p className="inventory-empty">{t("Catalogue changes require the Administrator role. Your account currently has read-only access.")}</p>}
        <p className="catalogue-id-note">{selectedId ? `Selected record ID: ${selectedId}` : "A product receives a stable system identifier when created."}</p>
      </div>
    </section>

    <section className="catalogue-layout catalogue-units-layout">
      <div className="inventory-panel">
        <div className="inventory-panel-heading"><div><p className="eyebrow">{t("UNIT REFERENCE")}</p><h3>{t("Units of measure")}</h3></div><span className="inventory-count">{units.length} units</span></div>
        {units.length ? <div className="register-table-wrap"><table className="register-table"><thead><tr><th>{t("Code")}</th><th>{t("Name")}</th><th>{t("Symbol")}</th></tr></thead><tbody>
          {units.map(unit => <tr key={unit.id}><td><code>{unit.code}</code></td><td><strong>{unit.name}</strong></td><td>{unit.symbol || "—"}</td></tr>)}
        </tbody></table></div> : <p className="inventory-empty">{t("No units have been defined.")}</p>}
        {canManage && <form className="location-form catalogue-form" onSubmit={saveUnit}>
          <div className="form-grid">
            <label>{t("Code")}<input required maxLength={24} value={unitCode} onChange={e => setUnitCode(e.target.value)} placeholder={t("Unique unit code")} /></label>
            <label>{t("Name")}<input required maxLength={100} value={unitName} onChange={e => setUnitName(e.target.value)} placeholder={t("Unit name")} /></label>
            <label>{t("Symbol (optional)")}<input maxLength={24} value={unitSymbol} onChange={e => setUnitSymbol(e.target.value)} /></label>
          </div>
          <button type="submit" className="primary-button" disabled={busy}>{t("Add unit")}</button>
        </form>}
      </div>

      <div className="inventory-panel">
        <div className="inventory-panel-heading"><div><p className="eyebrow">{t("EXPLICIT CONVERSION")}</p><h3>{t("Product-unit conversions")}</h3></div><span className="inventory-count">{t("Draft only")}</span></div>
        {selectedId ? <>
          <p className="catalogue-ratio-note">{t("A conversion means: 1 source unit = numerator ÷ denominator target units. Values are stored as exact whole-number ratios; no rounding or stock calculation is performed.")}</p>
          {conversions.length ? <div className="register-table-wrap"><table className="register-table"><thead><tr><th>{t("From")}</th><th>To</th><th>{t("Exact ratio")}</th></tr></thead><tbody>
            {conversions.map(x => <tr key={x.id}><td>{x.fromUnitName}</td><td>{x.toUnitName}</td><td><code>{x.numerator}/{x.denominator}</code></td></tr>)}
          </tbody></table></div> : <p className="inventory-empty">{t("No conversions are recorded for this product.")}</p>}
          {canManage && units.length >= 2 && <form className="location-form catalogue-form" onSubmit={saveConversion}>
            <div className="form-grid">
              <label>{t("Source unit")}<select required value={fromUnitId} onChange={e => setFromUnitId(e.target.value)}><option value="">{t("Choose unit")}</option>{units.map(x => <option key={x.id} value={x.id}>{x.name} ({x.code})</option>)}</select></label>
              <label>{t("Target unit")}<select required value={toUnitId} onChange={e => setToUnitId(e.target.value)}><option value="">{t("Choose unit")}</option>{units.map(x => <option key={x.id} value={x.id}>{x.name} ({x.code})</option>)}</select></label>
              <label>{t("Numerator")}<input type="number" min="1" max="9007199254740991" step="1" required value={numerator} onChange={e => setNumerator(e.target.value)} /></label>
              <label>{t("Denominator")}<input type="number" min="1" max="9007199254740991" step="1" required value={denominator} onChange={e => setDenominator(e.target.value)} /></label>
            </div>
            <button type="submit" className="primary-button" disabled={busy || fromUnitId === toUnitId}>{t("Add draft conversion")}</button>
          </form>}
        </> : <p className="inventory-empty">{t("Select a product to view or add its draft conversions.")}</p>}
      </div>
    </section>
    <ProductGovernanceManager productId={selectedId} canManage={canManage} />
    <p className="catalogue-footer-note">{t("Family, identifier and lifecycle submissions remain unverified review records. No product activation, supplier, purchasing, receiving, stock, lot, transfer, pricing, valuation or financial posting is available.")}</p>
  </div>;
}
