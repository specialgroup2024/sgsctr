import { redirect } from "next/navigation";
import { readSession } from "@/lib/auth";
import OrganizationWorkspace from "@/components/organization-workspace";

export const dynamic = "force-dynamic";

export default async function OrganizationPage() {
  const session = await readSession();
  if (!session) redirect("/login");
  return <OrganizationWorkspace />;
}
