import { redirect } from "next/navigation";
import { readSession } from "@/lib/auth";
import { AppShell } from "@/components/app-shell";

export const dynamic = "force-dynamic";

export default async function ContractingPage() {
  const session = await readSession();
  if (!session) redirect("/login");
  return <AppShell><div className="content"><section className="welcome-row"><div><p className="eyebrow">SECTOR 02</p><h1>Specialized Contracting <span>workspace</span></h1><p className="welcome-copy">Authenticated sector workspace.</p></div><span className="read-only-pill">FOUNDATION ONLY</span></section><section className="notice-panel"><strong>Operational features are not enabled.</strong><p>Projects, contracts, procurement, subcontractors, progress claims, cost allocations, invoices and financial postings require a separately approved implementation.</p></section></div></AppShell>;
}
