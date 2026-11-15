"use client";

import { useI18n } from "@/components/locale-provider";

const evidence = [
  ["EVD-DEMO-001", "Professional qualification certificate"],
  ["EVD-DEMO-002", "Pharmacist registration/license record"],
  ["EVD-DEMO-003", "Pharmacy workflow review authorization letter"],
  ["EVD-DEMO-004", "Workflow review checklist"],
  ["EVD-DEMO-005", "Medication safety assessment report"],
];

export default function PharmacistReviewExamples() {
  const { t, formatDate } = useI18n();
  return <section className="inventory-demo-examples" aria-labelledby="pharmacist-demo-examples-title">
    <div className="inventory-demo-heading">
      <div>
        <p className="eyebrow">{t("REFERENCE MATERIAL · NOT APPROVAL")}</p>
        <h3 id="pharmacist-demo-examples-title">{t("Illustrative pharmacist review examples — demo only")}</h3>
      </div>
      <span className="inventory-demo-label">{t("NOT REAL APPROVAL")}</span>
    </div>
    <p className="inventory-demo-warning">{t("These owner-supplied examples are kept separate from the real approval register. They are not verified reviewer identities, qualifications, authorization or evidence. They do not change INV-PRO-001, which remains Pending.")}</p>
    <article className="inventory-demo-card">
      <h4>{t("Example A — conditional-approval scenario")}</h4>
      <dl>
        <div><dt>{t("Decision date")}</dt><dd>{formatDate("2026-11-15T00:00:00Z", { dateStyle: "long", timeZone: "UTC" })}</dd></div>
        <div><dt>{t("Review ID")}</dt><dd>REV-DEMO-2026-015</dd></div>
        <div><dt>{t("Workflow version")}</dt><dd>WF-V1.4</dd></div>
        <div><dt>{t("Conditions")}</dt><dd>{t("Staff must complete medication safety refresher training.")}</dd></div>
        <div><dt>{t("Reviewer confirmation")}</dt><dd>{t("Digitally acknowledged – Demo only")}</dd></div>
        <div><dt>{t("Supporting evidence references")}</dt><dd>EVD-DEMO-001, EVD-DEMO-002, EVD-DEMO-003</dd></div>
      </dl>
      <p className="inventory-demo-subheading">{t("Evidence descriptions supplied with the example (documents not supplied)")}</p>
      <ul>{evidence.map(([id, description]) => <li key={id}><code>{id}</code> — {t(description)}</li>)}</ul>
    </article>
    <article className="inventory-demo-card">
      <h4>{t("Example B — alternative rejection scenario")}</h4>
      <dl>
        <div><dt>{t("Reviewer (demo value)")}</dt><dd>Dr. Sara Mohamed Ali</dd></div>
        <div><dt>{t("Job title")}</dt><dd>{t("Responsible Pharmacist")}</dd></div>
        <div><dt>{t("License number")}</dt><dd>EGY-PH-DEMO-00952</dd></div>
        <div><dt>{t("Pharmacy")}</dt><dd>Nile Care Pharmacy</dd></div>
        <div><dt>{t("Authorization")}</dt><dd>AUTH-DEMO-2026-018</dd></div>
        <div><dt>{t("Decision")}</dt><dd><strong>{t("REJECT")}</strong></dd></div>
        <div><dt>{t("Decision date")}</dt><dd>{formatDate("2026-11-15T00:00:00Z", { dateStyle: "long", timeZone: "UTC" })}</dd></div>
        <div><dt>{t("Reason")}</dt><dd>{t("Insufficient evidence of prescription verification controls")}</dd></div>
        <div><dt>{t("Conditions / required follow-up")}</dt><dd>{t("Correct identified workflow gaps and submit updated evidence")}</dd></div>
        <div><dt>{t("Supporting evidence references")}</dt><dd>REJ-EVD-DEMO-001, REJ-EVD-DEMO-002</dd></div>
      </dl>
    </article>
    <p className="inventory-demo-footnote">{t("Full provenance and limitations:")} <code>.ai/delivery/pharmacy-inventory-pharmacist-review-examples.md</code>. {t("No example above is stored as a GovernanceApproval or returned by the real approval API.")}</p>
  </section>;
}
