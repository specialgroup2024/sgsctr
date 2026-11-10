import { redirect } from "next/navigation";
import { readSession } from "@/lib/auth";
import Dashboard from "@/components/dashboard";

export const dynamic = "force-dynamic";

export default async function HomePage() {
  const session = await readSession();
  if (!session) redirect("/login");
  return <Dashboard />;
}
