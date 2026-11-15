"use client";

const evidence = [
  ["EVD-DEMO-001", "Professional qualification certificate"],
  ["EVD-DEMO-002", "Pharmacist registration/license record"],
  ["EVD-DEMO-003", "Pharmacy workflow review authorization letter"],
  ["EVD-DEMO-004", "Workflow review checklist"],
  ["EVD-DEMO-005", "Medication safety assessment report"],
];

export default function PharmacistReviewExamples() {
  return <section className="inventory-demo-examples" aria-labelledby="pharmacist-demo-examples-title">
    <div className="inventory-demo-heading">
      <div>
        <p className="eyebrow">REFERENCE MATERIAL · NOT APPROVAL</p>
        <h3 id="pharmacist-demo-examples-title">Illustrative pharmacist review examples — demo only</h3>
      </div>
      <span className="inventory-demo-label">NOT REAL APPROVAL</span>
    </div>
    <p className="inventory-demo-warning">These owner-supplied examples are kept separate from the real approval register. They are not verified reviewer identities, qualifications, authorization or evidence. They do not change INV-PRO-001, which remains Pending.</p>
    <article className="inventory-demo-card">
      <h4>Example A — conditional-approval scenario</h4>
      <dl>
        <div><dt>Decision date</dt><dd>15 November 2026</dd></div>
        <div><dt>Review ID</dt><dd>REV-DEMO-2026-015</dd></div>
        <div><dt>Workflow version</dt><dd>WF-V1.4</dd></div>
        <div><dt>Conditions</dt><dd>Staff must complete medication safety refresher training.</dd></div>
        <div><dt>Reviewer confirmation</dt><dd>Digitally acknowledged – Demo only</dd></div>
        <div><dt>Supporting evidence references</dt><dd>EVD-DEMO-001, EVD-DEMO-002, EVD-DEMO-003</dd></div>
      </dl>
      <p className="inventory-demo-subheading">Evidence descriptions supplied with the example (documents not supplied)</p>
      <ul>{evidence.map(([id, description]) => <li key={id}><code>{id}</code> — {description}</li>)}</ul>
    </article>
    <article className="inventory-demo-card">
      <h4>Example B — alternative rejection scenario</h4>
      <dl>
        <div><dt>Reviewer (demo value)</dt><dd>Dr. Sara Mohamed Ali</dd></div>
        <div><dt>Job title</dt><dd>Responsible Pharmacist</dd></div>
        <div><dt>License number</dt><dd>EGY-PH-DEMO-00952</dd></div>
        <div><dt>Pharmacy</dt><dd>Nile Care Pharmacy</dd></div>
        <div><dt>Authorization</dt><dd>AUTH-DEMO-2026-018</dd></div>
        <div><dt>Decision</dt><dd><strong>REJECT</strong></dd></div>
        <div><dt>Decision date</dt><dd>15 November 2026</dd></div>
        <div><dt>Reason</dt><dd>Insufficient evidence of prescription verification controls</dd></div>
        <div><dt>Conditions / required follow-up</dt><dd>Correct identified workflow gaps and submit updated evidence</dd></div>
        <div><dt>Supporting evidence references</dt><dd>REJ-EVD-DEMO-001, REJ-EVD-DEMO-002</dd></div>
      </dl>
    </article>
    <p className="inventory-demo-footnote">Full provenance and limitations: <code>.ai/delivery/pharmacy-inventory-pharmacist-review-examples.md</code>. No example above is stored as a GovernanceApproval or returned by the real approval API.</p>
  </section>;
}
