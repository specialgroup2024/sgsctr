"use client";
import { useEffect, useState } from "react";
import Link from "next/link";
import { usePathname } from "next/navigation";
import type { ReactNode } from "react";
const navigation: Array<{ href: string; label: string; icon: string; status?: string }> = [
  { href: "/", label: "Overview", icon: "▦" },
  { href: "/organization", label: "Organization", icon: "⌂" },
  { href: "/pharmacies", label: "Pharmacies", icon: "✚", status: "Foundation" },
  { href: "/pharmacies/inventory", label: "Pharmacy Inventory", icon: "▤", status: "INV-00" },
  { href: "/pharmacies/regulatory-intelligence", label: "Regulatory Intelligence", icon: "◎", status: "EDA" },
  { href: "/contracting", label: "Specialized Contracting", icon: "▤", status: "Foundation" }
];
type Identity = { authenticated: boolean; user?: { subject: string; displayName: string; email: string } };
export function AppShell({ children }: { children: ReactNode }) {
  const pathname = usePathname();
  const current = navigation.find(item => item.href === pathname) ?? navigation.find(item => item.href !== "/" && pathname.startsWith(item.href));
  const [identity, setIdentity] = useState<Identity | null>(null);
  useEffect(() => {
    let active = true;
    fetch("/api/auth/session", { cache: "no-store" })
      .then(response => response.ok ? response.json() : { authenticated: false })
      .then(data => { if (active) setIdentity(data); })
      .catch(() => { if (active) setIdentity({ authenticated: false }); });
    return () => { active = false; };
  }, []);
  return <main className="app-shell">
    <aside className="sidebar">
      <Link className="brand" href="/"><span className="brand-mark">SG</span><span><strong>SPECIAL GROUP</strong><small>OPERATIONS PLATFORM</small></span></Link>
      <div className="nav-label">WORKSPACE</div>
      <nav className="nav-list" aria-label="Main navigation">
        {navigation.map(item => {
          const active = item.href === "/" ? pathname === "/" : item.href === "/pharmacies" ? pathname === item.href : pathname === item.href || pathname.startsWith(item.href + "/");
          return <Link className={"nav-item " + (active ? "active" : "")} href={item.href} key={item.href} aria-current={active ? "page" : undefined}>
            <span className="nav-icon" aria-hidden="true">{item.icon}</span><span>{item.label}</span>
            {item.status && <span className="nav-status">{item.status}</span>}
          </Link>;
        })}
      </nav>
      <div className="sidebar-bottom">
        <div className="environment-card"><span className="environment-indicator" /><div><strong>WORKSPACE ACCESS</strong><small>Local development environment</small></div></div>
        <small className="sidebar-foot">SGSCTR · Local development</small>
      </div>
    </aside>
    <section className="main-panel">
      <header className="topbar"><div className="breadcrumb">Workspace <span>/</span> {current?.label ?? "Workspace"}</div><div className="topbar-right">
        <div className="identity-chip"><strong>{identity?.user?.displayName ?? "Signed-in user"}</strong><small>{identity?.user?.email ?? "Application account"}</small></div>
        <form action="/api/auth/logout" method="post"><button className="logout-link" type="submit">Sign out</button></form>
      </div></header>
      {children}
    </section>
  </main>;
}
