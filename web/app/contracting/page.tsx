import { AppShell } from "@/components/app-shell";
export default function ContractingPage() {
  return <AppShell><div className="content">
    <section className="welcome-row"><div><p className="eyebrow">SECTOR 02</p><h1>Specialized Contracting <span>workspace</span></h1><p className="welcome-copy">A separate workspace for contracting operations.</p></div><span className="read-only-pill">FOUNDATION ONLY</span></section>
    <section className="notice-panel"><strong>Operational features are not enabled.</strong><p>No projects, contracts, procurement, subcontractors, progress claims, cost allocations, invoices or financial postings can be created in this phase.</p></section>
    <div className="section-heading"><div><p className="eyebrow">NEXT DISCOVERY WORK</p><h2>Contracting capabilities</h2></div></div>
    <section className="capability-grid"><article className="capability-card"><strong>Project and contract lifecycle</strong><span>Stages, variations, approvals and close-out require contracting-owner definition.</span></article><article className="capability-card"><strong>Procurement and execution</strong><span>Supplier, subcontractor, commitment and progress-control processes remain open.</span></article><article className="capability-card"><strong>Cost and commercial control</strong><span>Cost categories, budget authority and reporting require accountant and owner approval.</span></article></section>
  </div></AppShell>;
}