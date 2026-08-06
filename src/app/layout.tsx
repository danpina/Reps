import type { Metadata, Viewport } from "next";

import { ServiceWorker } from "@/components/service-worker";
import { getProfile } from "@/lib/auth/dal";
import "./globals.css";

export const metadata: Metadata = {
  title: "Reps — learn to talk to anyone",
  description:
    "Talking to people is a skill, not a personality. It decides who you meet, who hires you, and who you end up close to. REPS trains it one idea and one real conversation at a time, and keeps the record that proves it worked.",
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
  // A private record of someone's practice has no business in search results.
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

export default async function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  // Rendered into the initial HTML rather than applied on the client, so the
  // first paint is already the right palette. A theme restored in an effect
  // shows the wrong one for a frame, and on this app that flash lands on every
  // navigation. "system" writes no attribute at all, which is exactly what the
  // stylesheet's prefers-color-scheme block is already there to handle.
  const profile = await getProfile();
  const theme = profile?.theme ?? "system";

  return (
    <html
      lang="en"
      className="h-full antialiased"
      data-theme={theme === "system" ? undefined : theme}
    >
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
