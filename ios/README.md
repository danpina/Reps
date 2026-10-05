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

**Milestone 1 — the pipeline and a first vertical slice (this commit).** Sign in, then browse
topics → skills → lesson titles, in the account's own language (`profiles.locale`, same as the
website; English and Spanish — German is not offered yet). Lessons you haven't unlocked show a lock.
This proves signing, upload and the Supabase connection end to end before the larger screens are built.

**Next, in roughly this order:** reading a lesson (theory, examples, the check questions) → the line
and choice drills (no AI, so no API needed) → logging a rep, progress, XP and ranks → the AI
rehearsal and the coach (needs the JSON API) → settings, language and **account deletion** (App Store
rule 5.1.1(v) as soon as there is sign-up in the app) → in-app sign-up and Sign in with Apple.

Until in-app sign-up exists, accounts are created on the website and the login screen says so.

## No Mac? CI is the compiler

- **`.github/workflows/ios-build.yml`** — runs on every push that touches `ios/`. Generates the
  project, builds for the iOS Simulator, and re-emits compiler errors as annotations on the run page.
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
