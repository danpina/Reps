import { apiRoute, ApiError } from "@/lib/api/route";
import { getProfile, requireUser } from "@/lib/auth/dal";
import { rehearsalsLeft } from "@/lib/billing/entitlement";
import { getLesson } from "@/lib/curriculum/queries";
import { pickVariant, scenarioFor, type LessonVariant } from "@/lib/curriculum/variants";
import { isRehearsalUnlocked, requiredLevelForLesson } from "@/lib/roleplay/limits";
import { costsMoney, isRehearsalMode } from "@/lib/roleplay/modes";
import { getRehearsalsForLesson } from "@/lib/roleplay/queries";
import { XP_AWARD } from "@/lib/progress/rules";
import { createClient } from "@/lib/supabase/server";

/**
 * The rehearsal box at the foot of a lesson, as data: what kind of exercise this is,
 * whether it is open to this reader yet, what is left of the free allowance, and the
 * rehearsals already done on it. The same facts, from the same functions, the website's
 * lesson page asks for.
 */
export async function GET(request: Request, { params }: { params: Promise<{ id: string }> }) {
  return apiRoute(request, async () => {
    await requireUser();
    const { id } = await params;
    const supabase = await createClient();

    const { data } = await supabase
      .from("lessons")
      .select("id, sort_order, skill_id, rehearsal_mode, variants_json, skills(slug)")
      .eq("id", id)
      .maybeSingle();
    if (!data) throw new ApiError(404, "not_found");

    const lesson = data as unknown as {
      id: string;
      sort_order: number;
      skill_id: string;
      rehearsal_mode: string;
      variants_json: LessonVariant[];
      skills: { slug: string };
    };

    const localized = await getLesson(lesson.skills.slug, lesson.sort_order);
    if (!localized) throw new ApiError(404, "not_found");

    const profile = await getProfile();
    const audience = {
      sex: profile?.sex ?? null,
      ageGroup: profile?.age_group ?? null,
      datingInterest: profile?.dating_interest ?? null,
    };
    const scenario = scenarioFor(
      localized.lesson.scenario_json,
      audience,
      pickVariant(lesson.variants_json, audience),
    );

    const mode = isRehearsalMode(lesson.rehearsal_mode) ? lesson.rehearsal_mode : "scene";
    const paid = costsMoney(mode);
    const left = paid ? await rehearsalsLeft() : null;

    const [{ data: state }, past] = await Promise.all([
      supabase.from("user_skill_state").select("level").eq("skill_id", lesson.skill_id).maybeSingle(),
      getRehearsalsForLesson(lesson.id),
    ]);

    const level = (state as { level?: number } | null)?.level ?? 1;
    const open = past.find((r) => r.status === "open");

    return {
      mode,
      paid,
      partnerName: scenario.partner.name,
      openness: scenario.partner.openness,
      level,
      requiredLevel: requiredLevelForLesson(lesson.sort_order),
      unlocked: isRehearsalUnlocked(lesson.sort_order, level, mode),
      freeLeft: left,
      // Out of free rehearsals and nothing open to carry on with.
      spent: left !== null && left <= 0 && !open,
      openId: open?.id ?? null,
      xp: XP_AWARD.roleplay,
      past,
    };
  });
}
