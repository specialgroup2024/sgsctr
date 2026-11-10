import { AppShell } from "@/components/app-shell";
const locations = [
  { code: "WH-01", name: "Mokattam", kind: "Main warehouse" },
  { code: "PH-02", name: "Student Hospital", kind: "Pharmacy branch" },
  { code: "PH-03", name: "Qasr El-Aini Hospital", kind: "Pharmacy branch" },
  { code: "PH-04", name: "Manial Hospital", kind: "Pharmacy branch" },
];
export default function OrganizationPage() {
  return <AppShell><div className="content">
    <section className="welcome-row"><div><p className="eyebrow">ORGANIZATION DIRECTORY</p><h1>Organization <span>register</span></h1><p className="welcome-copy">A read-only view of the organization structure currently supplied by the owner.</p></div><span className="read-only-pill">READ-ONLY FOUNDATION</span></section>
    <section className="notice-panel" role="note"><strong>Legal identity verification is still pending.</strong><p>“Special Group” is the owner-provided organization name. The legal entity model is provisional until registration documents and sector ownership are verified. No legal, tax or licensing status is asserted here.</p></section>
    <div className="section-heading"><div><p className="eyebrow">PROVISIONAL STRUCTURE</p><h2>Business sectors</h2></div><span className="section-note">Owner-identified · Not a legal verification</span></div>
    <section className="sector-grid">
      <article className="sector-card pharmacy-card"><div className="sector-top"><span className="sector-symbol">✚</span><span className="sector-tag">SECTOR 01</span></div><h3>Pharmacies</h3><p>Pharmacy network with one main warehouse and three owner-identified hospital branches.</p><div className="sector-meta"><span>4 locations identified</span><span>Operational design pending</span></div></article>
      <article className="sector-card contracting-card"><div className="sector-top"><span className="sector-symbol">⌂</span><span className="sector-tag">SECTOR 02</span></div><h3>Specialized Contracting</h3><p>Separate business domain. Offices, sites, project structure and operating model have not yet been registered in this workspace.</p><div className="sector-meta"><span>Structure pending</span><span>Owner input required</span></div></article>
    </section>
    <div className="section-heading"><div><p className="eyebrow">PHARMACY LOCATIONS</p><h2>Warehouse and branches</h2></div><span className="section-note">Names are owner-provided</span></div>
    <section className="register-table-wrap"><table className="register-table"><thead><tr><th>Location</th><th>Type</th><th>Reference</th><th>Record status</th></tr></thead><tbody>
      {locations.map((location) => <tr key={location.code}><td><strong>{location.name}</strong></td><td>{location.kind}</td><td><code>{location.code}</code></td><td><span className="record-status">Owner identified</span></td></tr>)}
    </tbody></table></section>
    <section className="notice-panel secondary-notice"><strong>Location transfer capability</strong><p>The owner confirmed direct branch-to-branch transfers as well as warehouse-mediated transfers. This UI does not initiate, approve, dispatch, receive or post any stock movement. Workflow and control design remain subject to pharmacy-operations and accountant approval.</p></section>
    <footer className="footer"><span>SGSCTR · Organization directory</span><span>No operational records created</span></footer>
  </div></AppShell>;
}