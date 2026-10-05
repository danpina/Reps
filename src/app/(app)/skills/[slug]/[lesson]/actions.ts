"use server";

import { requireUser } from "@/lib/auth/dal";
import { recordLessonRead } from "@/lib/progress/lesson-read";
import { createClient } from "@/lib/supabase/server";

/**
 * Records that a lesson has been read. The rules live in
 * `lib/progress/lesson-read`, shared with the iOS app's API route.
 *
 * Called from the client on mount rather than during render, because a page
 * render must not have side effects.
 */
export async function markLessonRead(lessonId: string): Promise<void> {
  const user = await requireUser();
  const supabase = await createClient();
  await recordLessonRead(supabase, user.id, lessonId);
}
