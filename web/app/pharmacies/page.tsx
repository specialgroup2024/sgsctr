import { AppShell } from "@/components/app-shell";
export default function PharmaciesPage() {
  return <AppShell><div className="content">
    <section className="welcome-row"><div><p className="eyebrow">SECTOR 01</p><h1>Pharmacies <span>workspace</span></h1><p className="welcome-copy">A dedicated workspace for the pharmacy network.</p></div><span className="read-only-pill">FOUNDATION ONLY</span></section>
    <section className="notice-panel"><strong>Operational features are not enabled.</strong><p>This phase provides navigation and context only. Product catalogue, purchasing, receiving, dispensing, stock balances, branch transfers, claims, patient balances and costing are not implemented or authorized for use.</p></section>
    <div className="section-heading"><div><p className="eyebrow">NEXT APPROVAL-DEPENDENT WORK</p><h2>Pharmacy capabilities</h2></div></div>
    <section className="capability-grid"><article className="capability-card"><strong>Location register</strong><span>Owner-identified locations are visible in Organization.</span></article><article className="capability-card"><strong>Inventory and transfers</strong><span>Workflow and acceptance criteria require pharmacy-operations and accountant approval.</span></article><article className="capability-card"><strong>Products and suppliers</strong><span>Catalogue, units, lot/expiry and supplier requirements remain to be defined.</span></article></section>
  </div></AppShell>;
}