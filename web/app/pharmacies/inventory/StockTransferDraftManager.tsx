"use client";

import { useCallback, useEffect, useState, type FormEvent } from "react";
import { useI18n } from "@/components/locale-provider";

type Location = { id: string; code: string; name: string; sectorCode: string; isActive: boolean };
type Product = { id: string; displayName: string; status: string };
type Unit = { id: string; code: string; name: string; symbol: string | null };
type DraftResult = { id: string; status: string; lineCount: number; stockPosted: boolean; message: string };

async function payload<T>(response: Response): Promise<T> {
  const body = await response.json().catch(() => null);
  if (!response.ok) throw new Error(body?.error ?? body?.title ?? body?.detail ?? `Request failed (${response.status}).`);
  return body as T;
}

export default function StockTransferDraftManager() {
  const { t } = useI18n();
  const [locations, setLocations] = useState<Location[]>([]);
  const [products, setProducts] = useState<Product[]>([]);
  const [units, setUnits] = useState<Unit[]>([]);
  const [sourceLocationId, setSourceLocationId] = useState("");
  const [destinationLocationId, setDestinationLocationId] = useState("");
  const [productId, setProductId] = useState("");
  const [unitId, setUnitId] = useState("");
  const [quantity, setQuantity] = useState("1");
  const [lotNumber, setLotNumber] = useState("");
  const [expiryDate, setExpiryDate] = useState("");
  const [reason, setReason] = useState("");
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState("");
  const [result, setResult] = useState<DraftResult | null>(null);

  const loadReferences = useCallback(async () => {
    setLoading(true);
    setError("");
    try {
      const [organizationResponse, productResponse, unitResponse] = await Promise.all([
        fetch("/api/organization", { cache: "no-store" }),
        fetch("/api/pharmacy/catalogue", { cache: "no-store" }),
        fetch("/api/pharmacy/catalogue/units", { cache: "no-store" })
      ]);
      if ([organizationResponse, productResponse, unitResponse].some(response => response.status === 401)) {
        window.location.assign("/login");
        return;
      }
      const [organization, productRows, unitRows] = await Promise.all([
        payload<{ locations?: Location[] }>(organizationResponse),
        payload<Product[]>(productResponse),
        payload<Unit[]>(unitResponse)
      ]);
      const activeLocations = (organization.locations ?? []).filter(location =>
        location.sectorCode === "PHARMACIES" && location.isActive);
      const draftProducts = productRows.filter(product => product.status === "Draft");
      setLocations(activeLocations);
      setProducts(draftProducts);
      setUnits(unitRows);
      setSourceLocationId(current => current || activeLocations[0]?.id || "");
      setDestinationLocationId(current => current || activeLocations.find(location => location.id !== activeLocations[0]?.id)?.id || "");
      setProductId(current => current || draftProducts[0]?.id || "");
      setUnitId(current => current || unitRows[0]?.id || "");
    } catch (cause) {
      setError(cause instanceof Error ? cause.message : t("Transfer reference data could not be loaded."));
    } finally {
      setLoading(false);
    }
  }, [t]);

  useEffect(() => { void loadReferences(); }, [loadReferences]);

  async function createDraft(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setError("");
    setResult(null);
    if (!sourceLocationId || !destinationLocationId || sourceLocationId === destinationLocationId ||
        !productId || !unitId || !Number.isFinite(Number(quantity)) || Number(quantity) <= 0 ||
        reason.trim().length > 500 || lotNumber.trim().length > 64) {
      setError(t("Choose different active locations, a Draft product and unit, and enter a positive quantity."));
      return;
    }
    setSaving(true);
    try {
      const response = await fetch("/api/pharmacy/inventory/stock-transfers", {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({
          sourceLocationId,
          destinationLocationId,
          reason: reason.trim() || null,
          lines: [{
            productId,
            unitId,
            quantity: Number(quantity),
            lotNumber: lotNumber.trim() || null,
            expiryDate: expiryDate || null
          }]
        })
      });
      if (response.status === 401) {
        window.location.assign("/login");
        return;
      }
      const saved = await payload<DraftResult>(response);
      setResult(saved);
      setReason("");
      setLotNumber("");
      setExpiryDate("");
    } catch (cause) {
      setError(cause instanceof Error ? cause.message : t("Draft transfer request could not be saved."));
    } finally {
      setSaving(false);
    }
  }

  return <section className="inventory-workspace-panel">
    <div className="inventory-section-heading">
      <div><p className="eyebrow">{t("LOCATION MOVEMENT")}</p><h2>{t("Stock transfers")}</h2>
        <p>{t("Create a non-posting draft request for warehouse-to-branch or direct branch-to-branch movement.")}</p></div>
      <span className="inventory-status-chip">{t("Draft request only")}</span>
    </div>
    <div className="inventory-gate" role="note">
      <span className="inventory-gate-icon">!</span>
      <div><strong>{t("No dispatch, receipt or stock posting is available here.")}</strong>
        <p>{t("This screen only creates a Draft request. It does not submit, approve, dispatch, receive, change custody, create a stock balance or calculate transfer valuation. Lifecycle and professional approvals remain pending.")}</p>
      </div>
    </div>
    {error && <p className="form-error" role="alert">{t(error)}</p>}
    {result && <div className="inventory-panel" role="status">
      <strong>{t("Draft transfer request saved")}</strong>
      <p><code>{result.id}</code> · {t(result.status)} · {result.lineCount} {t("line")}</p>
      <p>{t(result.message)} {result.stockPosted ? t("Unexpected stock posting status; stop and report this result.") : ""}</p>
    </div>}
    <form className="receiving-draft-form" onSubmit={createDraft}>
      <div className="receiving-draft-fields">
        <label>{t("Source location")}
          <select required value={sourceLocationId} onChange={event => setSourceLocationId(event.target.value)} disabled={loading || saving}>
            <option value="">{t("Select source")}</option>
            {locations.map(location => <option key={location.id} value={location.id}>{location.name} · {location.code}</option>)}
          </select>
        </label>
        <label>{t("Destination location")}
          <select required value={destinationLocationId} onChange={event => setDestinationLocationId(event.target.value)} disabled={loading || saving}>
            <option value="">{t("Select destination")}</option>
            {locations.filter(location => location.id !== sourceLocationId).map(location =>
              <option key={location.id} value={location.id}>{location.name} · {location.code}</option>)}
          </select>
        </label>
        <label>{t("Draft catalogue product")}
          <select required value={productId} onChange={event => setProductId(event.target.value)} disabled={loading || saving}>
            <option value="">{t("Select product")}</option>
            {products.map(product => <option key={product.id} value={product.id}>{product.displayName}</option>)}
          </select>
        </label>
        <label>{t("Unit of measure")}
          <select required value={unitId} onChange={event => setUnitId(event.target.value)} disabled={loading || saving}>
            <option value="">{t("Select unit")}</option>
            {units.map(unit => <option key={unit.id} value={unit.id}>{unit.code} · {unit.name}</option>)}
          </select>
        </label>
        <label>{t("Requested quantity")}
          <input type="number" min="0.000001" step="any" required value={quantity} onChange={event => setQuantity(event.target.value)} disabled={loading || saving} />
        </label>
        <label>{t("Lot number (optional)" )}
          <input maxLength={64} value={lotNumber} onChange={event => setLotNumber(event.target.value)} disabled={loading || saving} />
        </label>
        <label>{t("Expiry date (optional)" )}
          <input type="date" value={expiryDate} onChange={event => setExpiryDate(event.target.value)} disabled={loading || saving} />
        </label>
        <label>{t("Reason (optional)" )}
          <input maxLength={500} value={reason} onChange={event => setReason(event.target.value)} disabled={loading || saving} />
        </label>
      </div>
      <div className="receiving-draft-actions">
        <small>{t("Only active Pharmacies locations, existing Draft catalogue products and registered units can be selected. The API enforces Administrator permission for draft creation.")}</small>
        <button type="submit" className="primary-button" disabled={loading || saving || locations.length < 2 || !products.length || !units.length}>
          {saving ? t("Saving…") : t("Save draft transfer request")}
        </button>
      </div>
      {!loading && (!locations.length || locations.length < 2 || !products.length || !units.length) &&
        <p className="inventory-empty">{t("Two active pharmacy locations, one Draft catalogue product and one unit are required before a draft request can be created.")}</p>}
      {loading && <p className="loading-state">{t("Loading transfer reference data…")}</p>}
    </form>
    <div className="inventory-empty-state compact-empty">
      <h3>{t("Transfer history and approval actions are not shown in this increment.")}</h3>
      <p>{t("The current list API does not yet enforce the required location-scoped read permissions. This UI therefore does not expose transfer records to a broader audience. A security-reviewed, location-scoped read model is required before history is enabled.")}</p>
    </div>
  </section>;
}
