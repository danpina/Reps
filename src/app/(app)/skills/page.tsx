import { redirect } from "next/navigation";

/**
 * Browsing starts at topics now.
 *
 * The route survives as a redirect rather than as a 404 because it is in the
 * nav of anyone's muscle memory, in old bookmarks, and in the onboarding
 * emails that have already been sent. Individual skills still live under
 * /skills/[slug], so only this index moved.
 */
export default function SkillsIndexPage() {
  redirect("/topics");
}
