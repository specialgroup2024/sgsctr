import { chromium } from "playwright";
import { mkdir } from "node:fs/promises";
import { join } from "node:path";

const baseUrl = process.env.WEB_BASE_URL ?? "http://127.0.0.1:3000";
const email = process.env.BOOTSTRAP_ADMIN_EMAIL;
const password = process.env.BOOTSTRAP_ADMIN_PASSWORD;
if (!email || !password) throw new Error("Bootstrap administrator credentials are required for authenticated RTL checks.");

const routes = [
  ["/", "dashboard"],
  ["/organization", "organization"],
  ["/pharmacies", "pharmacies"],
  ["/pharmacies/inventory", "inventory"],
  ["/pharmacies/regulatory-intelligence", "regulatory-intelligence"],
  ["/contracting", "contracting"]
];
const output = join(process.cwd(), "artifacts", "rtl-visual");
await mkdir(output, { recursive: true });
const browser = await chromium.launch({ headless: true });
const context = await browser.newContext({ viewport: { width: 1440, height: 1000 }, deviceScaleFactor: 1 });
const page = await context.newPage();

try {
  await page.goto(baseUrl + "/login", { waitUntil: "domcontentloaded" });
  await page.locator("#email").fill(email);
  await page.locator("#password").fill(password);
  await page.locator(".login-button").click();
  await page.waitForURL(url => !url.pathname.startsWith("/login"), { timeout: 15000 });

  for (const viewport of [
    { name: "desktop", width: 1440, height: 1000 },
    { name: "mobile", width: 390, height: 844 }
  ]) {
    await page.setViewportSize({ width: viewport.width, height: viewport.height });
    await page.locator(".language-switcher button[lang='ar']").click();
    await page.waitForFunction(() => document.documentElement.lang === "ar" && document.documentElement.dir === "rtl");
    for (const [route, slug] of routes) {
      await page.goto(baseUrl + route, { waitUntil: "domcontentloaded" });
      await page.waitForFunction(() => document.documentElement.lang === "ar" && document.documentElement.dir === "rtl");
      await page.waitForTimeout(250);
      const layout = await page.evaluate(() => ({
        width: window.innerWidth,
        documentWidth: document.documentElement.scrollWidth,
        direction: getComputedStyle(document.body).direction,
        lang: document.documentElement.lang,
        dir: document.documentElement.dir
      }));
      if (layout.dir !== "rtl" || layout.direction !== "rtl" || layout.lang !== "ar") {
        throw new Error(`Arabic direction failed on ${route} at ${viewport.name}: ${JSON.stringify(layout)}`);
      }
      if (layout.documentWidth > layout.width + 2) {
        throw new Error(`Horizontal overflow on ${route} at ${viewport.name}: ${JSON.stringify(layout)}`);
      }
      await page.screenshot({ path: join(output, `arabic-${viewport.name}-${slug}.png`), fullPage: true });
    }

    await page.locator(".language-switcher button[lang='en']").click();
    await page.waitForFunction(() => document.documentElement.lang === "en" && document.documentElement.dir === "ltr");
    for (const [route, slug] of routes) {
      await page.goto(baseUrl + route, { waitUntil: "domcontentloaded" });
      const layout = await page.evaluate(() => ({
        width: window.innerWidth,
        documentWidth: document.documentElement.scrollWidth,
        direction: getComputedStyle(document.body).direction,
        lang: document.documentElement.lang,
        dir: document.documentElement.dir
      }));
      if (layout.dir !== "ltr" || layout.direction !== "ltr" || layout.lang !== "en") {
        throw new Error(`English direction failed on ${route} at ${viewport.name}: ${JSON.stringify(layout)}`);
      }
      if (layout.documentWidth > layout.width + 2) {
        throw new Error(`Horizontal overflow on ${route} at ${viewport.name}: ${JSON.stringify(layout)}`);
      }
    }
  }
  console.log("Desktop/mobile EN-LTR and AR-RTL route checks passed. Arabic screenshots were saved to artifacts/rtl-visual.");
} finally {
  await browser.close();
}
