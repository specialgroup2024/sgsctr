"use client";

import Link from "next/link";
import { AppShell } from "@/components/app-shell";
import { useI18n } from "@/components/locale-provider";
import CatalogueManager from "../inventory/CatalogueManager";

export default function CatalogueWorkspacePage() {
  const { t } = useI18n();

  return (
    <AppShell>
      <div className="content inventory-content">
        <section className="welcome-row inventory-welcome">
          <div>
            <p className="eyebrow">{t("SECTOR 01 · PHARMACIES")}</p>
            <h1>{t("Product")} <span>{t("catalogue")}</span></h1>
            <p className="welcome-copy">{t("Manage generic product identities, units and exact packaging references.")}</p>
          </div>
          <Link className="subtle-button" href="/pharmacies/inventory">{t("Back to Pharmacy Inventory")}</Link>
        </section>
        <section className="inventory-gate" role="note">
          <span className="inventory-gate-icon">!</span>
          <div>
            <strong>{t("INV-01 · Generic draft reference data")}</strong>
            <p>{t("All product and conversion records remain drafts. Product-family classification and professional review are pending. This workspace does not activate products or post stock, dispensing, valuation or financial transactions.")}</p>
          </div>
        </section>
        <CatalogueManager />
      </div>
    </AppShell>
  );
}
