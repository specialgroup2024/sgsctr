"use client";

import { useCallback, useEffect, useState } from "react";
import PharmacistReviewExamples from "./PharmacistReviewExamples";
import { useI18n } from "@/components/locale-provider";

type Approval = {
  id: string;
  approvalCode: string;
  title: string;
  requiredApproverRole: string;
  status: "Pending" | "Approved" | "ApprovedWithConditions" | "Rejected" | "Withdrawn" | "Superseded";
  scopeDescription: string;
  evidenceReference: string;
  createdAtUtc: string;
  updatedAtUtc: string;
  decisionAtUtc: string | null;
  decisionBySubject: string | null;
  decisionReference: string | null;
  decisionNotes: string | null;
  conditions: string | null;
};

function statusLabel(status: Approval["status"]) {
  switch (status) {
    case "Approved": return "Approved";
    case "ApprovedWithConditions": return "Approved with conditions";
    case "Rejected": return "Rejected";
    case "Withdrawn": return "Withdrawn";
    case "Superseded": return "Superseded";
    default: return "Pending";
  }
}

export default function ApprovalRegister() {
  const { t } = useI18n();
  const [items, setItems] = useState<Approval[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  const load = useCallback(async () => {
    setLoading(true);
    setError("");
    try {
      const response = await fetch("/api/pharmacy/approvals", { cache: "no-store" });
      if (response.status === 401) { window.location.assign("/login"); return; }
      const body = await response.json().catch(() => null);
      if (!response.ok) throw new Error(body?.error ?? "The approval register could not be loaded.");
      setItems(body as Approval[]);
    } catch (e) {
      setError(e instanceof Error ? e.message : "The approval register could not be loaded.");
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => { void load(); }, [load]);

  const pendingCount = items.filter(x => x.status === "Pending").length;

  return <section className="inventory-workspace-panel">
    <div className="inventory-section-heading">
      <div>
        <p className="eyebrow">{t("GOVERNANCE · HUMAN SIGN-OFF")}</p>
        <h2>{t("Approval register" )}</h2>
        <p>{t("Approval requirements are persisted in PostgreSQL and read through the ASP.NET Core API." )}</p>
      </div>
      <span className="inventory-status-chip">{loading ? "Loading" : pendingCount + " pending"}</span>
    </div>

    <div className="inventory-gate" role="note">
      <span className="inventory-gate-icon">!</span>
      <div>
        <strong>{t("Pending means no professional approval has been recorded." )}</strong>
        <p>{t("This screen tracks the required sign-offs. It does not grant approval. Decision entry remains disabled until designated reviewer identities, qualifications, delegated authority and server-side role permissions are verified.")}</p>
      </div>
    </div>
    {error && <p className="form-error" role="alert">{t(error)}</p>}
    {loading && <p className="loading-state">{t("Loading approval records from PostgreSQL…" )}</p>}
    {!loading && !error && items.length === 0 && <p className="inventory-empty">{t("No approval records were returned by the API." )}</p>}

    <div className="inventory-approval-list">
      {items.map(item => <article className="inventory-panel" key={item.approvalCode}>
        <div className="inventory-panel-heading">
          <div>
            <p className="eyebrow">{item.approvalCode}</p>
            <h3>{item.title}</h3>
          </div>
          <span className={"inventory-status-chip " + (item.status === "Pending" ? "approval-pending" : "approval-recorded")}>{t(statusLabel(item.status))}</span>
        </div>
        <p><strong>{t("Required approver:")}</strong> {item.requiredApproverRole}</p>
        <p>{item.scopeDescription}</p>
        <p className="catalogue-footer-note"><strong>{t("Evidence:")}</strong> <code>{item.evidenceReference}</code></p>
        {item.status !== "Pending" && <div className="catalogue-id-note">
          <strong>{t("Recorded decision:")}</strong> {t(statusLabel(item.status))}
          {item.decisionAtUtc ? " · " + new Date(item.decisionAtUtc).toLocaleString() : ""}
          {item.decisionBySubject ? " · " + item.decisionBySubject : " · Approver identity not captured in the application"}
          {item.decisionReference ? <p>Reference: {item.decisionReference}</p> : null}
          {item.conditions ? <p>Conditions: {item.conditions}</p> : null}
          {item.decisionNotes ? <p>{item.decisionNotes}</p> : null}
        </div>}
      </article>)}
    </div>
    <PharmacistReviewExamples />
    <div className="inventory-panel">
      <h3>{t("How an approval will be recorded")}</h3>
      <p>The authorized reviewer must be authenticated, hold the designated role, and provide a decision, date, evidence reference and any conditions. The application must retain the decision history. This first increment is deliberately read-only; it cannot mark a pending item as approved.</p>
      <button className="inventory-refresh" type="button" onClick={() => void load()} disabled={loading}>{t("Refresh approvals")}</button>
    </div>
  </section>;
}
