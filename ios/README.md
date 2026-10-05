# Reps — iOS app

A native SwiftUI client for Reps. Same recipe as the Doc Scanner and Linguanest apps — an
`ios/` folder in the web repo, an XcodeGen `project.yml`, and GitHub Actions on a macOS runner
as the compiler and the TestFlight uploader — with one difference: those apps sat on an Express
API, and Reps has none. It is a Next.js app whose logic runs as server actions.

So the app talks to **Supabase directly**, the way the website's own server code does:

- **Sign-in** is Supabase Auth over HTTPS (`/auth/v1/token`). The session is kept in the Keychain.
- **Reads** go to PostgREST (`/rest/v1/…`) with the signed-in user's token, so the same row level
  security that governs the website governs the app. A free account sees what a free account sees.
- **Anything that needs a secret** (the AI rehearsal partner, the coach — they use the Anthropic key —
  and the server-side progress and XP rules) will go through a small JSON API added to the Next app.
  The service-role and Anthropic keys never ship in the app.

The `.xcodeproj` is **not** checked in. It is generated from `project.yml` by
[XcodeGen](https://github.com/yonaskolb/XcodeGen).

## Where it is

Five tabs, the same places the website's navigation offers, and a first-run Welcome:

- **Today** — the landing screen: the reason this is worth doing, log-a-rep, reps and streak, your rank and
  what it takes to reach the next, "pick up where you left off", the twelve-week activity grid, where you are
  in each topic, and badges.
- **Learn** — topics → skills → lessons. A lesson is the theory, worked examples, the comprehension questions
  (answer once, see why), **the test** — the lesson's rehearsal — and today's mission with a **Log this rep**
  button.
- **Field log** — every rep logged, by day, with edit and delete. Moving a rep to another skill moves its XP;
  deleting one takes it back and works the streak out again.
- **Rehearsals** — every rehearsal done, in the order the curriculum runs, each one re-openable.
- **Settings** — About you, Language, Appearance (stored on the account, so it follows you), Change password,
  Sign out, and **Delete account**.

**Welcome** appears until the profile says onboarding is done: a name, where to start, three optional answers.

### The rehearsal, in its four forms

The lesson says which one it is. **Line** and **read-and-decide** never call the model, so they are free and
repeatable; **short sequence** and **open scene** use the AI partner and are scored against the lesson's
rubric when ended.

### Where the rules live

Nowhere in this app. Every verdict, every cap, every score, the free allowance, XP and the streak are decided
by the website's own code, behind a JSON API (`src/app/api`) that runs it unchanged. A request carrying the
Supabase access token runs *as that person*: `createClient()` and `getSessionUser()` consult a per-request
`AsyncLocalStorage` (`lib/api/context`) before the cookie, so the website's queries and server actions work as
they are and the app cannot disagree with the web about a rule. Row level security still decides what any of
it may touch.

Reads of the curriculum go straight to Supabase under row level security. The few ports that are pure logic —
forward-only unlocking, the audience-variant matcher, the markdown subset — have unit tests mirroring the
website's.

### Wording

The app bundles the website's translation catalogs (`scripts/sync-messages.sh` copies `src/messages/*.json` in at
build time), so it says everything in exactly the website's words, English and Spanish, with a small ICU
formatter for plurals. A website test (`tests/ios-messages.test.ts`) checks that every catalog key the Swift
code uses exists in both languages.

### Not in the app yet

The weekly review and the coach (both AI reads of the log), the end-of-track recap, topic cheat sheets, and the
admin screens (use the website). **Sign-up and password reset** open the website: they send an email whose link
the website handles, and an account made there signs in here the same.

The API routes deploy with the website, so a new app build that calls a route needs that route to be live first.

## What an account deletion needs

`DELETE /api/account` asks for the current password and then deletes that one user with the privileged client,
which needs `SUPABASE_SECRET_KEY` in the **Vercel** environment. Without it the route answers 503 and the app says
deletion is unavailable. Every table that refers to a user cascades from `auth.users`, so that one delete takes
the profile, reps, rehearsals, progress and badges with it.

## No Mac? CI is the compiler

- **`.github/workflows/ios-build.yml`** — runs on every push that touches `ios/`. Generates the
  project, builds for the iOS Simulator, runs the unit tests (`RepsTests`), and re-emits compiler errors and
  failed assertions as annotations on the run page.
- **`.github/workflows/ios-testflight.yml`** — manual. Archives, signs and uploads to TestFlight.

With a Mac: `brew install xcodegen && cd ios && xcodegen generate`, open `Reps.xcodeproj`, pick a
Simulator, ⌘R.

## Path to TestFlight

These steps are on Apple's side and in the repo's settings, so they are yours to do; the workflow
does the rest. The team (`RW46NLF44W`) is the same as the other apps.

1. **Register the bundle ID** `com.danipina.reps` at developer.apple.com → Certificates, Identifiers &
   Profiles → Identifiers (no capabilities needed yet). Do this *first*: the "New App" form in the next
   step only lists bundle IDs that already exist.
2. **Create the app** in [App Store Connect](https://appstoreconnect.apple.com) → Apps → **+** → New App,
   pick that bundle ID. The name must be unique across the whole store (it can change before a public
   release); the SKU is any unique string.
3. **Add four repository secrets** to this repo (Settings → Secrets and variables → Actions) — secrets
   don't carry over from the other repos: `APPLE_TEAM_ID`, `ASC_KEY_ID`, `ASC_ISSUER_ID`, and
   `ASC_KEY_P8` (the full contents of the `AuthKey_XXXX.p8` file, pasted as text). The key is made in
   App Store Connect → Users and Access → Integrations → App Store Connect API. If the export step
   fails with a cloud-signing permission error, the key's role is too low — recreate it with **Admin**.
   The key from the other apps can be reused: it belongs to the team, not the app.
4. **Actions → iOS TestFlight → Run workflow.** The build number is the run number; the build appears in
   TestFlight a few minutes after Apple finishes processing it. If a run fails, the last lines of the
   failing `xcodebuild` step are copied into the run's annotations.

## Before an App Store submission (not needed for TestFlight)

- **Subscriptions.** Reps has a paid tier. Apple requires In-App Purchase for digital content unlocked
  inside an iOS app, so the app must not link out to a web checkout. Today the paid tier is granted by
  hand (`subscriptions.source = manual`), so the app simply reflects `is_pro`; decide how purchases work
  before submitting for review.
- **Privacy policy and support pages** are needed for the store listing. The other apps' listings
  (`APP_STORE_LISTING.md` in the Linguanest repo) are a good template.
- **Review access.** Put a demo account in the review notes so the reviewer can get past the login screen.
- **App icon** is the website's mark rendered at 1024×1024 with no transparency. Replace
  `Reps/Resources/Assets.xcassets/AppIcon.appiconset/AppIcon.png` if you want something different.

## The backend values

`Reps/Networking/BackendConfig.swift` holds the Supabase URL and the **publishable** key. Both are the
public values the website already ships in its browser bundle; the publishable key is not a secret and
every row is protected by row level security. If the Supabase project ever changes, update that file.
