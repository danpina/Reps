# Reps

A small talk practice log. You learn one idea, rehearse it, then go and have a
real conversation and log the rep. The app is a coach wrapped around real-world
repetitions — not a replacement for them.

## Status

Built: auth and RLS, the full nine-track curriculum (45 lessons), field
missions and the field log, XP and streaks, badges, the dashboard with a
calendar heatmap, and the weekly review.

Remaining: roleplay and the feedback engine (the only part with a per-call
cost), and polish — PWA manifest, offline shell, onboarding flow, and a
systematic accessibility pass.

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

   `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY` come
   from the project's API settings. `SUPABASE_SECRET_KEY` is only read by the
   test suite — it bypasses RLS, so it must never gain a `NEXT_PUBLIC_` prefix.

   The `NEXT_PUBLIC_` prefix is load-bearing rather than decorative: it is what
   makes Next.js inline a value into the client bundle. Without it the browser
   Supabase client receives `undefined` and sign-in fails at runtime.

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

## Deploying

Vercel, from the GitHub repo. Two things are easy to miss.

**Environment variables.** Set `NEXT_PUBLIC_SUPABASE_URL`,
`NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY` and `SUPABASE_SECRET_KEY` in the Vercel
project. `NEXT_PUBLIC_SITE_URL` is optional: without it,
[`src/lib/env.ts`](src/lib/env.ts) falls back to Vercel's own
`VERCEL_PROJECT_PRODUCTION_URL`, so email links point at the production domain
rather than at `localhost`.

**Supabase redirect allow-list.** Authentication → URL Configuration. Set the
Site URL to the production domain and add `https://<domain>/auth/callback` to
the redirect list. Magic links and email confirmations fail silently without
this, because Supabase will only redirect to URLs it has been told about.

Preview deployments deliberately send their email links to the production
domain. `VERCEL_URL` is unique per deployment, so preview links would never be
on the allow-list and would fail every time.

## Security model

Every user-owned row carries a `user_id` and is gated by `auth.uid()`. RLS is
enabled on every table with no exceptions, and
[`tests/rls.test.ts`](tests/rls.test.ts) asserts that one user cannot read or
write another user's rows. Add a case to that file whenever you add a table.

The RLS tests need all three Supabase environment variables. Without them that
suite skips rather than passing silently, so check the output says `pass`, not
`skip`.

## Curriculum

Three levels: **topics** hold **skills** hold **lessons**. A topic is a
situation — Small talk, Interviews, Work, Dating, Making friends, Hard
conversations, Storytelling — and the skills inside it are written for that
situation only, because an opener at a bar and an opener in an interview are
different crafts.

Lessons live in `supabase/migrations/*_seed_lessons_*.sql`, one migration per
skill. Each lesson carries a theory card, exactly three worked examples, two
comprehension beats, a rubric for the feedback engine, and a roleplay scenario
whose partner has an `openness` of 1 to 5.

## Entitlements

The first two lessons of the first skill in every topic are free, along with one
rehearsal, the field log, streaks and the weekly review. Everything else needs a
subscription.

That rule lives in row level security, not in the pages — see
`supabase/migrations/*_entitlements.sql`. A gate written only in the UI is a gate
on a hyperlink, and the lesson body is the product. Because a gated row is
invisible to a free account, listings read from the `lesson_index` view, which
exposes titles and nothing that teaches anything.

There is no checkout yet. Access is granted by hand from the admin screen, which
writes a `subscriptions` row with the secret key; the table has no insert policy,
so nothing reachable with a user's own session can grant entitlement. Stripe
later writes the same rows and nothing else has to change.

[`tests/entitlements.test.ts`](tests/entitlements.test.ts) proves all of this
against real policies with real sessions. It needs the same three environment
variables as the RLS suite.

[`tests/curriculum.test.ts`](tests/curriculum.test.ts) validates all of that
without a database: it parses every `$j$` block, rejects malformed JSON, and
enforces the rules the content has to follow — three examples per card, exactly
one correct answer per check, openness within range, every skill filed under a
topic that exists, and a scenario that tells the roleplay partner never to coach
mid-scene. Run `npm test` after writing a track.

Avoid currency symbols in seed content. A stray dollar sign inside a
dollar-quoted block breaks the migration and the test's parser at once.

## Design

"Ledger" — the app is a training diary, not a social app. Cool paper and ink,
hairline rules instead of cards, and tabular monospace numerals for every metric
so progress reads like an instrument rather than a scoreboard. Tokens live at the
top of [`src/app/globals.css`](src/app/globals.css).
