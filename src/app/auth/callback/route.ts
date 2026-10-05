import { cookies } from "next/headers";
import { NextResponse, type NextRequest } from "next/server";
import type { EmailOtpType } from "@supabase/supabase-js";

import { createClient } from "@/lib/supabase/server";
import { PASSWORD_RECOVERY_COOKIE } from "@/lib/auth/recovery";

export async function GET(request: NextRequest) {
  const { searchParams, origin } = request.nextUrl;

  const rawNext = searchParams.get("next") ?? "/today";
  const next =
    rawNext.startsWith("/") && !rawNext.startsWith("//") ? rawNext : "/today";

  const supabase = await createClient();

  const code = searchParams.get("code");
  const tokenHash = searchParams.get("token_hash");
  const type = searchParams.get("type") as EmailOtpType | null;
  // A reset link comes back in one of two shapes. The token-hash shape carries
  // `type=recovery`; the PKCE shape this app's emails actually use arrives as a
  // bare `?code=` with no type at all, so the only thing that says "this was a
  // password reset" is where the link was told to go. That is safe to trust:
  // the cookie below is only set after the exchange succeeds, and an exchange
  // only succeeds for someone who has just opened a link sent to the account's
  // inbox — the same proof a recovery link gives. A forged `next` with no valid
  // code gets nothing.
  const isRecovery = type === "recovery" || next === "/reset-password";

  let verified = false;
  if (code) {
    const { error } = await supabase.auth.exchangeCodeForSession(code);
    verified = !error;
  } else if (tokenHash && type) {
    const { error } = await supabase.auth.verifyOtp({
      type,
      token_hash: tokenHash,
    });
    verified = !error;
  }

  if (verified) {
    // Marks the session as one proven by clicking a password-recovery email,
    // not merely a session that happens to exist — /reset-password checks for
    // this rather than for being signed in, because "signed in" alone would
    // let a borrowed session (shared laptop, stolen cookie) set a new password
    // without ever proving the old one. Short-lived and cleared on use, so it
    // cannot be replayed after the reset is done.
    if (isRecovery) {
      const jar = await cookies();
      jar.set(PASSWORD_RECOVERY_COOKIE, "1", {
        httpOnly: true,
        sameSite: "lax",
        secure: process.env.NODE_ENV === "production",
        maxAge: 60 * 10,
        path: "/",
      });
    }
    return NextResponse.redirect(`${origin}${next}`);
  }

  return NextResponse.redirect(`${origin}/sign-in?error=link_invalid`);
}
