"use client";

import Link from "next/link";
import { AppShell } from "@/components/app-shell";
import { useI18n } from "@/components/locale-provider";

const modules = [
  { href: "/pharmacies/modules/regular-medications", code: "PHARM-M01", title: "Regular Medications", arabicTitle: "الأدوية العادية", description: "A dedicated workspace for regular medicine catalogue, procurement, receiving, stock, dispensing and payer workflows.", arabicDescription: "مساحة مستقلة لدليل الأدوية العادية والمشتريات والاستلام والمخزون والصرف وسير عمل الجهات المتعاقدة.", icon: "Rx" },
  { href: "/pharmacies/modules/chemotherapy-drugs", code: "PHARM-M02", title: "Chemotherapy Drugs", arabicTitle: "أدوية العلاج الكيميائي", description: "A separate workspace boundary for chemotherapy product records, controlled supply-chain evidence and specialist review.", arabicDescription: "حد تشغيلي مستقل لسجلات أدوية العلاج الكيميائي وأدلة سلسلة الإمداد والمراجعة المتخصصة.", icon: "CH" },
  { href: "/pharmacies/modules/medical-supplies", code: "PHARM-M03", title: "Medical Supplies", arabicTitle: "المستلزمات الطبية", description: "A dedicated workspace for medical supplies and the product-specific procurement, traceability and distribution capabilities to be approved.", arabicDescription: "مساحة مستقلة للمستلزمات الطبية وقدرات الشراء والتتبع والتوزيع الخاصة بالمنتج بعد اعتمادها.", icon: "MS" },
  { href: "/pharmacies/modules/cosmetics", code: "PHARM-M04", title: "Cosmetics", arabicTitle: "مستحضرات التجميل", description: "A separate workspace for cosmetics catalogue, supplier, batch, sales and regulatory-evidence workflows.", arabicDescription: "مساحة مستقلة لدليل مستحضرات التجميل والموردين والتشغيلات والمبيعات والأدلة التنظيمية.", icon: "CO" }
];

export function PharmacyLanding() {
  const { t, locale } = useI18n();
  const isArabic = locale === "ar";
  return <AppShell><div className="content">
    <section className="welcome-row">
      <div><p className="eyebrow">{t("SECTOR 01")}</p><h1>{t("Pharmacies")} <span>{t("workspace")}</span></h1><p className="welcome-copy">{t("Pharmacy operations, inventory preparation and Egyptian regulatory intelligence.")}</p></div>
      <span className="read-only-pill">{isArabic ? "أربعة مجالات تشغيل مستقلة · قيد التنفيذ" : "FOUR INDEPENDENT MODULES · IN DELIVERY"}</span>
    </section>
    <section className="inventory-section-heading"><div><p className="eyebrow">{isArabic ? "نموذج التشغيل المعتمد" : "SELECTED OPERATING MODEL"}</p><h2>{isArabic ? "وحدات الصيدليات الأربع" : "Four independent pharmacy modules"}</h2><p>{isArabic ? "لكل وحدة مساحة عمل مستقلة. لم يتم بعد اعتماد أو تفعيل قواعد البيانات والمعاملات الخاصة بكل وحدة." : "Each module has its own workspace entry. Module-specific data ownership and transactional workflows are not yet enabled."}</p></div></section>
    <section className="pharmacy-entry-grid" aria-label={isArabic ? "وحدات الصيدليات" : "Pharmacy modules"}>
      {modules.map(module => <Link className="pharmacy-entry-card" href={module.href} key={module.code}>
        <span className="pharmacy-entry-icon" aria-hidden="true">{module.icon}</span>
        <div><p className="eyebrow">{module.code}</p><h2>{isArabic ? module.arabicTitle : module.title}</h2><p>{isArabic ? module.arabicDescription : module.description}</p><strong>{isArabic ? "فتح مساحة الوحدة" : "Open module workspace"} →</strong></div>
      </Link>)}
    </section>
    <section className="inventory-section-heading"><div><p className="eyebrow">{isArabic ? "خدمات مشتركة" : "SHARED FOUNDATION"}</p><h2>{isArabic ? "خدمات مجموعة الصيدليات" : "Pharmacy Group services"}</h2></div></section>
    <section className="pharmacy-entry-grid">
      <Link className="pharmacy-entry-card pharmacy-entry-primary" href="/pharmacies/inventory"><span className="pharmacy-entry-icon" aria-hidden="true">▦</span><div><p className="eyebrow">INV-01</p><h2>{t("Inventory workspace")}</h2><p>{isArabic ? "الأساس الحالي لدليل المنتجات العام ووحدات القياس وسجلات المراجعة. هذه البيانات ليست معزولة حسب الوحدة بعد." : "Current shared foundation for generic product identities, units and review records. These records are not yet partitioned by module."}</p><strong>{t("Open inventory workspace")} →</strong></div></Link>
      <Link className="pharmacy-entry-card" href="/pharmacies/regulatory-intelligence"><span className="pharmacy-entry-icon" aria-hidden="true">◎</span><div><p className="eyebrow">{t("EGYPT · REGULATORY")}</p><h2>{t("Regulatory intelligence")}</h2><p>{t("Review configured EDA source monitoring, ingested documents, scan history and human review alerts.")}</p><strong>{t("Open regulatory intelligence")} →</strong></div></Link>
    </section>
    <section className="notice-panel secondary-notice"><strong>{t("Implementation boundary")}</strong><p>{isArabic ? "تم اختيار الوحدات الأربع على مستوى نموذج الأعمال، لكن الفصل الفعلي لسجلات المنتجات والموردين والمواقع والمخزون والصلاحيات لم يكتمل. تظل عمليات الشراء والاستلام والترحيل والصرف والمطالبات والتكلفة والقيود المالية غير مفعلة إلى حين اعتماد القواعد المطلوبة." : "The four modules are selected at the business-model level, but product, supplier, location, inventory and permission records are not yet technically partitioned. Purchasing, accepted receiving, stock posting, dispensing, claims, costing and financial postings remain disabled pending the required approvals."}</p></section>
  </div></AppShell>;
}
