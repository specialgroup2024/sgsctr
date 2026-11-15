import { chromium } from "playwright";
import { mkdir } from "node:fs/promises";

const base = process.env.WEB_BASE_URL ?? "http://localhost:3000";
const email = process.env.BOOTSTRAP_ADMIN_EMAIL;
const password = process.env.BOOTSTRAP_ADMIN_PASSWORD;
if (!email || !password) throw new Error("CI bootstrap administrator credentials are required for authenticated RTL checks.");
await mkdir("artifacts", { recursive: true });
const browser = await chromium.launch({ headless: true });
const viewports = [
  { name: "desktop", width: 1440, height: 1000 },
  { name: "mobile", width: 390, height: 844 }
];
try {
  for (const locale of ["en", "ar"]) {
    for (const viewport of viewports) {
      const context = await browser.newContext({ viewport });
      await context.addCookies([{ name: "sgsctr-locale", value: locale, url: base, sameSite: "Lax" }]);
      const page = await context.newPage();
      page.setDefaultTimeout(15000);
      await page.goto(`${base}/login`, { waitUntil: "networkidle" });
      const expectedDir = locale === "ar" ? "rtl" : "ltr";
      const loginRoot = await page.evaluate(() => ({ lang: document.documentElement.lang, dir: document.documentElement.dir }));
      if (loginRoot.lang !== locale || loginRoot.dir !== expectedDir) throw new Error(`Login root metadata mismatch for ${locale}: ${JSON.stringify(loginRoot)}`);
      await page.getByLabel(locale === "ar" ? "البريد الإلكتروني" : "Email address").fill(email);
      await page.getByLabel(locale === "ar" ? "كلمة المرور" : "Password").fill(password);
      await Promise.all([
        page.waitForURL(url => url.pathname === "/", { timeout: 20000 }),
        page.getByRole("button", { name: locale === "ar" ? "تسجيل الدخول" : "Sign in" }).click()
      ]);
      await page.goto(`${base}/pharmacies/inventory`, { waitUntil: "networkidle" });
      const root = await page.evaluate(() => ({
        lang: document.documentElement.lang,
        dir: document.documentElement.dir,
        width: window.innerWidth,
        documentWidth: document.documentElement.scrollWidth,
        bodyWidth: document.body.scrollWidth,
        sidebar: (() => { const e=document.querySelector(".sidebar"); if(!e)return null; const r=e.getBoundingClientRect(); return {left:r.left,right:r.right,top:r.top,bottom:r.bottom}; })(),
        main: (() => { const e=document.querySelector(".main-panel"); if(!e)return null; const r=e.getBoundingClientRect(); return {left:r.left,right:r.right,top:r.top,bottom:r.bottom}; })()
      }));
      if (root.lang !== locale || root.dir !== expectedDir) throw new Error(`Inventory root metadata mismatch for ${locale}: ${JSON.stringify(root)}`);
      if (root.documentWidth > root.width || root.bodyWidth > root.width) throw new Error(`Horizontal overflow at ${viewport.name} for ${locale}: ${JSON.stringify(root)}`);
      if (!root.sidebar || !root.main) throw new Error("Expected authenticated application shell was not rendered.");
      if (locale === "ar" && viewport.name === "desktop" && root.sidebar.left < root.main.left) throw new Error(`RTL desktop sidebar is not on the right: ${JSON.stringify(root)}`);
      if (viewport.name === "mobile" && root.sidebar.top > root.main.top) throw new Error(`Mobile navigation appears after the content: ${JSON.stringify(root)}`);
      await page.screenshot({ path: `artifacts/rtl-${locale}-${viewport.name}.png`, fullPage: true });
      console.log(`PASS ${locale.toUpperCase()} ${viewport.name}: lang/dir, authenticated inventory shell and no horizontal overflow`);
      await context.close();
    }
  }
} finally {
  await browser.close();
}
