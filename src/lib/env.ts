function required(name: string, value: string | undefined): string {
  if (!value) {
    throw new Error(
      `Missing environment variable ${name}. Copy .env.example to .env.local and fill it in.`,
    );
  }
  return value;
}

// Supabase's current key system: a publishable key that is safe in the browser,
// and a secret key that must never leave the server. These replace the older
// anon and service_role keys. The NEXT_PUBLIC_ prefix is what makes Next.js
// inline a value into the client bundle, so the two the browser needs carry it
// and the secret key deliberately does not.

export const SUPABASE_URL = required(
  "NEXT_PUBLIC_SUPABASE_URL",
  process.env.NEXT_PUBLIC_SUPABASE_URL,
);

export const SUPABASE_PUBLISHABLE_KEY = required(
  "NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY",
  process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY,
);

/**
 * Where magic links and confirmation emails come back to.
 *
 * Only ever read on the server, in the auth actions, so the Vercel variables
 * below do not need a NEXT_PUBLIC_ prefix. Do not use this in a client
 * component: it would be undefined there.
 *
 * Vercel's production URL is preferred over VERCEL_URL because VERCEL_URL is
 * unique per deployment, and Supabase only redirects to URLs on its allow
 * list. Sending every preview deployment's links to production is far less
 * confusing than links that silently fail.
 */
function resolveSiteUrl(): string {
  const explicit = process.env.NEXT_PUBLIC_SITE_URL?.trim();
  if (explicit) return explicit.replace(/\/$/, "");

  const production = process.env.VERCEL_PROJECT_PRODUCTION_URL;
  if (production) return `https://${production}`;

  const deployment = process.env.VERCEL_URL;
  if (deployment) return `https://${deployment}`;

  // Matches the port in .claude/launch.json, so magic links work in dev.
  return `http://localhost:${process.env.PORT ?? 3002}`;
}

export const SITE_URL = resolveSiteUrl();
