import type { Metadata, Viewport } from "next";

import { ServiceWorker } from "@/components/service-worker";
import "./globals.css";

export const metadata: Metadata = {
  title: "Reps — learn to talk to anyone",
  description:
    "Talking to people is a skill, not a personality. REPS teaches you one idea at a time, gives you somewhere to practise it, and keeps a record of every real conversation you use it on.",
  applicationName: "Reps",
  icons: {
    icon: [
      { url: "/icon.svg", type: "image/svg+xml" },
      { url: "/icon-192.png", sizes: "192x192", type: "image/png" },
    ],
    apple: "/apple-touch-icon.png",
  },
  appleWebApp: {
    capable: true,
    title: "Reps",
    statusBarStyle: "black-translucent",
  },
  // A private practice log has no business in search results.
  robots: { index: false, follow: false },
};

export const viewport: Viewport = {
  themeColor: [
    { media: "(prefers-color-scheme: light)", color: "#f4f5f3" },
    { media: "(prefers-color-scheme: dark)", color: "#101214" },
  ],
  // Lets the layout reach under the notch and home indicator once installed.
  viewportFit: "cover",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" className="h-full antialiased">
      <body className="flex min-h-full flex-col">
        {/* Visible only once focused, so a keyboard user can jump the nav. */}
        <a
          href="#main"
          className="sr-only rounded bg-[var(--accent)] px-4 py-2 text-sm font-medium text-[var(--accent-ink)] focus:not-sr-only focus:absolute focus:left-3 focus:top-3 focus:z-50"
        >
          Skip to content
        </a>
        {children}
        <ServiceWorker />
      </body>
    </html>
  );
}
