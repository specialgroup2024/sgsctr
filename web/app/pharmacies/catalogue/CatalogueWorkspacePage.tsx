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
            <h1>{t("Product catalogue")}</h1>
            <p className="welcome-copy">{t("Inventory workspace foundation · reference visibility and workflow preparation.")}</p>
          </div>
          <Link className="subtle-button" href="/pharmacies/inventory">{t("Pharmacy Inventory")}</Link>
        </section>
        <section className="inventory-gate" role="note">
          <span className="inventory-gate-icon">!</span>
          <div>
            <strong>{t("Generic catalogue only · Q38 professional review remains pending")}</strong>
            <p>{t("Records and conversions remain drafts. Family and identifier entries are provisional only; no verified classification, product activation, stock, dispensing or valuation is enabled.")}</p>
          </div>
        </section>
        <CatalogueManager />
      </div>
    </AppShell>
  );
}
