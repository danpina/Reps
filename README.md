# Reps

A small talk practice log. You learn one idea, rehearse it, then go and have a
real conversation and log the rep. The app is a coach wrapped around real-world
repetitions — not a replacement for them.

## Status

Phase 1 (foundations) is in place: auth, the `profiles` table with RLS, and the
cross-user isolation test. The curriculum, field log, roleplay, and progress
screens are still to come.

## Stack

Next.js 16 (App Router) · Supabase (Postgres, Auth, RLS) · Tailwind v4 ·
TypeScript. Tests run on Node's built-in test runner.

Note that Next.js 16 renames `middleware.ts` to `proxy.ts` — session refresh
lives in [`src/proxy.ts`](src/proxy.ts).

## Setup

1. Create a Supabase project, then copy the template and fill it in:

   ```bash
   cp .env.example .env.local
   ```

   `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_ANON_KEY` come from the
   project's API settings. `SUPABASE_SERVICE_ROLE_KEY` is only read by the test
   suite — it bypasses RLS, so keep it out of any `NEXT_PUBLIC_` variable.

2. Apply the migrations:

   ```bash
   npx supabase link --project-ref <your-project-ref>
   ```

   ```bash
   npx supabase db push
   ```

   To run the whole stack locally instead, install Docker and use
   `npm run db:start` followed by `npm run db:reset`.

3. Start the dev server:

   ```bash
   npm run dev
   ```

## Commands

| Command | What it does |
| --- | --- |
| `npm run dev` | Dev server |
| `npm run build` | Production build |
| `npm test` | RLS and integration tests |
| `npm run typecheck` | `tsc --noEmit` |
| `npm run lint` | ESLint |

## Security model

Every user-owned row carries a `user_id` and is gated by `auth.uid()`. RLS is
enabled on every table with no exceptions, and
[`tests/rls.test.ts`](tests/rls.test.ts) asserts that one user cannot read or
write another user's rows. Add a case to that file whenever you add a table.

The tests need all three Supabase environment variables. Without them the suite
skips rather than passing silently, so check the output says `pass`, not `skip`.

## Design

"Ledger" — the app is a training diary, not a social app. Cool paper and ink,
hairline rules instead of cards, and tabular monospace numerals for every metric
so progress reads like an instrument rather than a scoreboard. Tokens live at the
top of [`src/app/globals.css`](src/app/globals.css).
