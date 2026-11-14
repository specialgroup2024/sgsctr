import { redirect } from "next/navigation";
import Link from "next/link";
import { readSession } from "@/lib/auth";
import { AppShell } from "@/components/app-shell";

export const dynamic = "force-dynamic";

export default async function PharmaciesPage() {
  const session = await readSession();
  if (!session) redirect("/login");
  return <AppShell><div className="content">
    <section className="welcome-row"><div><p className="eyebrow">SECTOR 01</p><h1>Pharmacies <span>workspace</span></h1><p className="welcome-copy">Pharmacy operations, inventory preparation and Egyptian regulatory intelligence.</p></div><span className="read-only-pill">FOUNDATION + INV-01 DRAFT</span></section>
    <section className="pharmacy-entry-grid">
      <Link className="pharmacy-entry-card pharmacy-entry-primary" href="/pharmacies/inventory"><span className="pharmacy-entry-icon">▦</span><div><p className="eyebrow">INVENTORY · INV-01</p><h2>Inventory workspace</h2><p>Manage generic draft product identities, units and exact conversion references; review the gated screens for receiving, transfers, batches and reports.</p><strong>Open inventory workspace <span>→</span></strong></div></Link>
      <Link className="pharmacy-entry-card" href="/pharmacies/regulatory-intelligence"><span className="pharmacy-entry-icon">◎</span><div><p className="eyebrow">EGYPT · REGULATORY</p><h2>Regulatory intelligence</h2><p>Review configured EDA source monitoring, ingested documents, scan history and human review alerts.</p><strong>Open regulatory intelligence <span>→</span></strong></div></Link>
    </section>
    <section className="notice-panel secondary-notice"><strong>Implementation boundary</strong><p>The inventory workspace reads the existing organization location register and API/database health status. Generic product identity, unit masters and draft conversion references are persisted; all remain draft-only while Q38 professional review is pending. Supplier records, receipts, stock balances, transfers, batch records, valuation and financial postings are not implemented. Business and professional approvals remain required for regulated and transactional workflows.</p></section>
  </div></AppShell>;
}
