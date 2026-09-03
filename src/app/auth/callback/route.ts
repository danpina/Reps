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
  const isRecovery = type === "recovery";

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
