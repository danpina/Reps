import { redirect } from "next/navigation";

import { AppNav } from "@/components/app-nav";
import { getProfile, requireUser } from "@/lib/auth/dal";

export default async function AppLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  // The proxy already redirects signed-out visitors. This is the second lock:
  // every screen in this group is behind it, so a new page cannot forget.
  await requireUser();

  // Onboarding lives outside this group precisely so this redirect cannot loop
  // through its own layout.
  const profile = await getProfile();
  if (!profile?.onboarded_at) redirect("/welcome");

  return (
    <div className="min-h-dvh">
      <AppNav />
      {/* Target for the skip link, and bottom padding clears the phone tabs. */}
      <div id="main" className="pb-24 sm:pb-0">
        {children}
      </div>
    </div>
  );
}
