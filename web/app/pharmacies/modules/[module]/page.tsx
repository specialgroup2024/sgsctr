import { notFound, redirect } from "next/navigation";
import { readSession } from "@/lib/auth";
import PharmacyModuleWorkspace from "./PharmacyModuleWorkspace";

const modules = ["regular-medications", "chemotherapy-drugs", "medical-supplies", "cosmetics"] as const;

export const dynamic = "force-dynamic";

export default async function PharmacyModulePage({ params }: { params: Promise<{ module: string }> }) {
  const session = await readSession();
  if (!session) redirect("/login");
  const { module } = await params;
  if (!modules.includes(module as (typeof modules)[number])) notFound();
  return <PharmacyModuleWorkspace moduleKey={module as (typeof modules)[number]} />;
}
