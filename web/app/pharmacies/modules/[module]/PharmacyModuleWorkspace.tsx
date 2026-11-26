"use client";

import Link from "next/link";
import { AppShell } from "@/components/app-shell";
import { useI18n } from "@/components/locale-provider";

type ModuleKey = "regular-medications" | "chemotherapy-drugs" | "medical-supplies" | "cosmetics";
type Workflow = [string, string, string, string];
const moduleDetails: Record<ModuleKey, { code: string; title: string; arabicTitle: string; summary: string; arabicSummary: string; workflows: Workflow[] }> = {
  "regular-medications": {
    code: "PHARM-M01", title: "Regular Medications", arabicTitle: "الأدوية العادية",
    summary: "Dedicated operational boundary for regular medicines. The screen structure is reconstructed from the Future 25 static module, UI and workflow evidence; exact legacy runtime behavior was not available.",
    arabicSummary: "حد تشغيلي مستقل للأدوية العادية. تمت إعادة بناء هيكل الشاشة من أدلة الوحدات والواجهة وسير العمل الثابتة في Future 25؛ ولم تتوفر تفاصيل التشغيل الفعلية للنظام القديم.",
    workflows: [
      ["Product catalogue", "Product identity, pack and unit reference", "دليل المنتجات", "هوية المنتج والعبوة والوحدات"],
      ["Suppliers & purchasing", "Supplier records, requisitions, quotations and purchase orders", "الموردون والمشتريات", "سجلات الموردين والطلبات وعروض الأسعار وأوامر الشراء"],
      ["Receiving & inspection", "Delivery evidence, inspection and approved disposition", "الاستلام والفحص", "أدلة التسليم والفحص والتصرف المعتمد"],
      ["Stock & traceability", "Location stock, batches, expiry and movement history", "المخزون والتتبع", "مخزون المواقع والتشغيلات والصلاحية وسجل الحركة"],
      ["Dispensing & sales", "Applicable counter, hospital and customer transactions", "الصرف والمبيعات", "المعاملات المناسبة للمنفذ والمستشفى والعملاء"],
      ["Payers & claims", "Provider agreements, claims and remittance follow-up", "الجهات والمطالبات", "اتفاقيات الجهات والمطالبات ومتابعة التحصيل"],
      ["Management reports", "Module-owned operational and management reporting", "تقارير الإدارة", "التقارير التشغيلية والإدارية الخاصة بالوحدة"]
    ]
  },
  "chemotherapy-drugs": {
    code: "PHARM-M02", title: "Chemotherapy Drugs", arabicTitle: "أدوية العلاج الكيميائي",
    summary: "Separate workspace boundary for chemotherapy products and their specialist supply-chain evidence. No clinical, handling, storage or dispensing procedure is inferred or enabled.",
    arabicSummary: "مساحة مستقلة لمنتجات العلاج الكيميائي وأدلة سلسلة الإمداد المتخصصة. لا يتم افتراض أو تفعيل أي إجراء سريري أو تداول أو تخزين أو صرف.",
    workflows: [
      ["Product catalogue", "Specialist product identity and review evidence", "دليل المنتجات", "هوية المنتجات المتخصصة وأدلة المراجعة"],
      ["Supplier & procurement", "Supplier evidence and module-owned purchasing records", "الموردون والمشتريات", "أدلة الموردين وسجلات الشراء الخاصة بالوحدة"],
      ["Receiving & quality", "Delivery evidence and qualified quality disposition", "الاستلام والجودة", "أدلة التسليم والتصرف النوعي المختص"],
      ["Custody & traceability", "Product-specific traceability and authorized custody", "الحيازة والتتبع", "التتبع الخاص بالمنتج والحيازة المفوضة"],
      ["Dispensing workflow", "Specialist-authorized workflow design only", "سير عمل الصرف", "تصميم سير العمل المعتمد من المختصين فقط"],
      ["Payers & claims", "Applicable payer and claim records", "الجهات والمطالبات", "سجلات الجهات والمطالبات المنطبقة"],
      ["Management reports", "Separate module-level operational reporting", "تقارير الإدارة", "تقارير تشغيلية مستقلة على مستوى الوحدة"]
    ]
  },
  "medical-supplies": {
    code: "PHARM-M03", title: "Medical Supplies", arabicTitle: "المستلزمات الطبية",
    summary: "Dedicated medical-supplies workspace. Device-versus-supply classification, serial/lot applicability and regulatory attributes remain unresolved and require qualified review.",
    arabicSummary: "مساحة مستقلة للمستلزمات الطبية. لا يزال تصنيف الأجهزة مقابل المستلزمات ومدى انطباق الأرقام التسلسلية والتشغيلات والخصائص التنظيمية بحاجة إلى مراجعة مختصة.",
    workflows: [
      ["Product catalogue", "Supply identity and product-specific attributes", "دليل المنتجات", "هوية المستلزم والخصائص الخاصة بالمنتج"],
      ["Suppliers & purchasing", "Supplier, quotation and order workflow", "الموردون والمشتريات", "سير عمل الموردين وعروض الأسعار والطلبات"],
      ["Receiving & inspection", "Delivery, inspection and acceptance evidence", "الاستلام والفحص", "أدلة التسليم والفحص والقبول"],
      ["Stock & traceability", "Lot/serial/UDI applicability and location records", "المخزون والتتبع", "مدى انطباق التشغيلة والرقم التسلسلي وUDI وسجلات المواقع"],
      ["Distribution & sales", "Hospital, branch and customer supply workflows", "التوزيع والمبيعات", "سير عمل توريد المستشفيات والفروع والعملاء"],
      ["Contracts & claims", "Applicable customer and payer references", "العقود والمطالبات", "مراجع العملاء والجهات المنطبقة"],
      ["Management reports", "Module-owned stock and management reporting", "تقارير الإدارة", "تقارير المخزون والإدارة الخاصة بالوحدة"]
    ]
  },
  cosmetics: {
    code: "PHARM-M04", title: "Cosmetics", arabicTitle: "مستحضرات التجميل",
    summary: "Separate cosmetics workspace for catalogue, supplier, receiving, batch, sales and regulatory-evidence tasks. Product notification and regulatory applicability are not decided by this screen.",
    arabicSummary: "مساحة مستقلة لمهام دليل مستحضرات التجميل والموردين والاستلام والتشغيلات والمبيعات والأدلة التنظيمية. لا تحدد هذه الشاشة متطلبات الإخطار أو الانطباق التنظيمي.",
    workflows: [
      ["Product catalogue", "Cosmetic identity, variant and evidence references", "دليل المنتجات", "هوية مستحضر التجميل والأنواع ومراجع الأدلة"],
      ["Suppliers & purchasing", "Supplier and module-specific purchasing records", "الموردون والمشتريات", "الموردون وسجلات الشراء الخاصة بالوحدة"],
      ["Receiving & inspection", "Delivery and quality review evidence", "الاستلام والفحص", "أدلة التسليم ومراجعة الجودة"],
      ["Batch & expiry", "Batch, expiry and traceability requirements", "التشغيلات والصلاحية", "متطلبات التشغيلات والصلاحية والتتبع"],
      ["Sales & pricing", "Sales and pricing workflow requirements", "المبيعات والتسعير", "متطلبات سير عمل المبيعات والتسعير"],
      ["Regulatory evidence", "Product-specific notification and source records", "الأدلة التنظيمية", "الإخطارات وسجلات المصادر الخاصة بالمنتج"],
      ["Management reports", "Separate operational and management reporting", "تقارير الإدارة", "تقارير تشغيلية وإدارية مستقلة"]
    ]
  }
};

export default function PharmacyModuleWorkspace({ moduleKey }: { moduleKey: ModuleKey }) {
  const { locale } = useI18n();
  const module = moduleDetails[moduleKey];
  const isArabic = locale === "ar";
  return <AppShell><div className="content inventory-content">
    <section className="welcome-row inventory-welcome">
      <div><p className="eyebrow">{module.code} · {isArabic ? "وحدة تشغيل مستقلة" : "INDEPENDENT OPERATIONAL MODULE"}</p><h1>{isArabic ? module.arabicTitle : module.title}</h1><p className="welcome-copy">{isArabic ? module.arabicSummary : module.summary}</p></div>
      <span className="inventory-phase-pill">{isArabic ? "واجهة الوحدة · غير تشغيلية" : "MODULE UI · NON-OPERATIVE"}</span>
    </section>
    <div className="inventory-section-heading"><div><p className="eyebrow">{isArabic ? "خريطة سير العمل المستمدة من Future 25" : "FUTURE 25 WORKFLOW RECONSTRUCTION"}</p><h2>{isArabic ? "أقسام مساحة العمل" : "Workspace sections"}</h2><p>{isArabic ? "تعرض هذه الأقسام الوظائف التي يجب استكمالها ومراجعتها. لا توجد عمليات كتابة أو ترحيل في هذه المرحلة." : "These sections map the functions to be completed and reviewed. No write or posting operations are available in this increment."}</p></div></div>
    <section className="inventory-report-grid">
      {module.workflows.map(([title, detail, arabicTitle, arabicDetail], index) => <article key={title}><span>{String(index + 1).padStart(2, "0")}</span><strong>{isArabic ? arabicTitle : title}</strong><small>{isArabic ? arabicDetail : detail}</small><small className="inventory-status-chip">{isArabic ? "قيد التصميم والمراجعة" : "Design / review pending"}</small></article>)}
    </section>
    <section className="inventory-main-grid">
      <article className="inventory-panel"><div className="inventory-panel-heading"><div><p className="eyebrow">{isArabic ? "الأساس الحالي" : "CURRENT FOUNDATION"}</p><h3>{isArabic ? "ما هو متاح في SGSCTR؟" : "What is available in SGSCTR?"}</h3></div></div>
        <ul className="inventory-check-list">
          <li><span className="check-pending">○</span><div><strong>{isArabic ? "دليل منتجات عام" : "Generic product catalogue"}</strong><small>{isArabic ? "متاح كبيانات مسودة مشتركة؛ غير معزول حسب الوحدة." : "Available as shared Draft reference data; not partitioned by module."}</small></div></li>
          <li><span className="check-pending">○</span><div><strong>{isArabic ? "الموردون والاستلام والمخزون" : "Suppliers, receiving and inventory"}</strong><small>{isArabic ? "توجد أسس ومسودات فقط؛ لا يوجد ترحيل تشغيلي." : "Foundations and draft records only; no operational posting."}</small></div></li>
          <li><span className="check-pending">○</span><div><strong>{isArabic ? "المطالبات والتكلفة والحسابات" : "Claims, costing and accounting"}</strong><small>{isArabic ? "غير متصلة بوحدة مستقلة أو بدفتر مالي تشغيلي." : "Not connected to an independent module or operational financial ledger."}</small></div></li>
        </ul>
      </article>
      <article className="inventory-panel"><div className="inventory-panel-heading"><div><p className="eyebrow">{isArabic ? "بوابات الاعتماد" : "APPROVAL GATES"}</p><h3>{isArabic ? "قبل تفعيل العمليات" : "Before operations are enabled"}</h3></div></div><p>{isArabic ? "تظل مراجعات الصيدلة والجودة والتنظيم والمحاسبة والأمن وصلاحيات المستخدمين مطلوبة حسب الوظيفة." : "Pharmacy, quality, regulatory, accounting, security and user-permission reviews remain required according to each capability."}</p><Link className="inventory-text-link" href="/pharmacies/inventory">{isArabic ? "عرض سجل الموافقات والجاهزية ↗" : "Review approval register and readiness ↗"}</Link></article>
    </section>
    <section className="inventory-gate" role="note"><span className="inventory-gate-icon">!</span><div><strong>{isArabic ? "هذه واجهة عمل وليست تفعيلًا تشغيليًا." : "This is a workspace shell, not operational activation."}</strong><p>{isArabic ? "لا تنشئ هذه الشاشة منتجات أو مخزونًا أو أوامر شراء أو استلامات أو حركات أو مطالبات أو قيودًا مالية. يجب أولاً اعتماد حدود البيانات الخاصة بالوحدة ثم إضافة الترحيلات وواجهات API واختبارات PostgreSQL." : "This screen creates no products, stock, purchase orders, receipts, movements, claims or financial postings. Module data ownership must be approved and implemented before adding persistence, API commands and PostgreSQL tests."}</p></div></section>
    <Link className="inventory-text-link" href="/pharmacies">{isArabic ? "← العودة إلى وحدات الصيدليات" : "← Back to Pharmacy modules"}</Link>
  </div></AppShell>;
}
