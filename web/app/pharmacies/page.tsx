import { redirect } from "next/navigation";
import { readSession } from "@/lib/auth";
import { AppShell } from "@/components/app-shell";

export const dynamic = "force-dynamic";

export default async function PharmaciesPage() {
  const session = await readSession();
  if (!session) redirect("/login");
  return <AppShell><div className="content"><section className="welcome-row"><div><p className="eyebrow">SECTOR 01</p><h1>Pharmacies <span>workspace</span></h1><p className="welcome-copy">Authenticated sector workspace.</p></div><span className="read-only-pill">FOUNDATION ONLY</span></section><section className="notice-panel"><strong>Operational features are not enabled.</strong><p>Inventory, purchasing, receiving, dispensing, branch transfers, claims, patient balances and costing remain outside this implementation phase and require separate approval.</p></section><p className="muted">Use Organization to manage approved location reference records. This page does not create pharmacy transactions.</p></div></AppShell>;
}
