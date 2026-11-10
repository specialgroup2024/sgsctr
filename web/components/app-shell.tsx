"use client";
import Link from "next/link";
import { usePathname } from "next/navigation";
import type { ReactNode } from "react";
const navigation: Array<{ href: string; label: string; icon: string; status?: string }> = [
  { href: "/", label: "Overview", icon: "▦" },
  { href: "/organization", label: "Organization", icon: "⌂" },
  { href: "/pharmacies", label: "Pharmacies", icon: "✚", status: "Foundation" },
  { href: "/contracting", label: "Specialized Contracting", icon: "▤", status: "Foundation" },
];
export function AppShell({ children }: { children: ReactNode }) {
  const pathname = usePathname();
  const current = navigation.find((item) => item.href === pathname);
  return <main className="app-shell">
    <aside className="sidebar">
      <Link className="brand" href="/"><span className="brand-mark">SG</span><span><strong>SPECIAL GROUP</strong><small>OPERATIONS PLATFORM</small></span></Link>
      <div className="nav-label">WORKSPACE</div>
      <nav className="nav-list" aria-label="Main navigation">
        {navigation.map((item) => {
          const active = item.href === "/" ? pathname === "/" : pathname.startsWith(item.href);
          return <Link className={`nav-item ${active ? "active" : ""}`} href={item.href} key={item.href} aria-current={active ? "page" : undefined}>
            <span className="nav-icon" aria-hidden="true">{item.icon}</span><span>{item.label}</span>
            {item.status && <span className="nav-status">{item.status}</span>}
          </Link>;
        })}
      </nav>
      <div className="sidebar-bottom"><div className="environment-card"><span className="environment-indicator" /><div><strong>LOCAL ENVIRONMENT</strong><small>Development workspace</small></div></div><small className="sidebar-foot">SGSCTR · Foundation UI</small></div>
    </aside>
    <section className="main-panel">
      <header className="topbar"><div className="breadcrumb">Workspace <span>/</span> {current?.label ?? "Workspace"}</div><div className="topbar-right"><span className="local-pill">LOCAL TEST</span><div className="avatar" aria-label="Special Group workspace">SG</div></div></header>
      {children}
    </section>
  </main>;
}
