import { redirect } from "next/navigation";
import { readSession } from "@/lib/auth";
import CatalogueWorkspacePage from "./CatalogueWorkspacePage";

export const dynamic = "force-dynamic";

export default async function PharmacyCataloguePage() {
  const session = await readSession();
  if (!session) redirect("/login");
  return <CatalogueWorkspacePage />;
}
