import { redirect } from "next/navigation";
import { readSession } from "@/lib/auth";
import RegulatoryIntelligenceClient from "./RegulatoryIntelligenceClient";

export const dynamic = "force-dynamic";

export default async function RegulatoryIntelligencePage() {
  const session = await readSession();
  if (!session) redirect("/login");
  return <RegulatoryIntelligenceClient />;
}
