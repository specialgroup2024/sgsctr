import { redirect } from "next/navigation";
import { readSession } from "@/lib/auth";
import InventoryWorkspace from "./InventoryWorkspace";

export const dynamic = "force-dynamic";

export default async function PharmacyInventoryPage() {
  const session = await readSession();
  if (!session) redirect("/login");
  return <InventoryWorkspace />;
}
