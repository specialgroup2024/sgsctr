import type { Metadata } from "next";
import "./globals.css";
export const metadata: Metadata = { title: "SGSCTR | Special Group Operations", description: "Special Group Pharmacies and Specialized Contracting operations platform." };
export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return <html lang="en"><body>{children}</body></html>;
}
