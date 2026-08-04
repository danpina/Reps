import { AppNav } from "@/components/app-nav";
import { requireUser } from "@/lib/auth/dal";

export default async function AppLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  // The proxy already redirects signed-out visitors. This is the second lock:
  // every screen in this group is behind it, so a new page cannot forget.
  await requireUser();

  return (
    <div className="min-h-dvh">
      <AppNav />
      {/* Bottom padding clears the phone tab bar. */}
      <div className="pb-24 sm:pb-0">{children}</div>
    </div>
  );
}
